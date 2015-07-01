//
//  DispatchData.swift
//  RTP Test
//
//  Created by Jonathan Wight on 6/30/15.
//  Copyright © 2015 schwa. All rights reserved.
//

import Foundation

public struct DispatchData <T> {

    public let data:dispatch_data_t

    public var count:Int {
        return length / DispatchData <T>.elementSize
    }

    public static var elementSize:Int {
        return max(sizeof(T), 1)
    }

    public var length:Int {
        return dispatch_data_get_size(data)
    }

    // MARK: -

    public init(data:dispatch_data_t) {
        self.data = data
    }

    public init() {
        self.init(data:dispatch_data_create(nil, 0, nil, nil))
    }

    public init(buffer:UnsafeBufferPointer <T>) {
        self.init(data:dispatch_data_create(buffer.baseAddress, buffer.length, nil, nil))
    }

    // MARK: -

    public func subBuffer(range:Range <Int>) -> DispatchData <T> {
        return DispatchData <T> (data:dispatch_data_create_subrange(data, range.startIndex, range.endIndex - range.startIndex))
    }

    // MARK: -

    public func map() -> DispatchData <T> {
        let mappedData = dispatch_data_create_map(data, nil, nil)
        return DispatchData <T> (data:mappedData)
    }

    public func map(@noescape block:UnsafeBufferPointer <Void> -> Void) -> DispatchData <T> {

        var pointer:UnsafePointer <Void> = nil
        var size:Int = 0

        let mappedData = dispatch_data_create_map(data, &pointer, &size)

        let buffer = UnsafeBufferPointer <Void> (start:pointer, count:size)
        block(buffer)

        return DispatchData <T> (data:mappedData)
    }

    public func map <R>(@noescape block:UnsafeBufferPointer <Void> throws -> R) rethrows -> R {

        var pointer:UnsafePointer <Void> = nil
        var size:Int = 0

        let _ = dispatch_data_create_map(data, &pointer, &size)
        let buffer = UnsafeBufferPointer <Void> (start:pointer, count:size)
        let result = try block(buffer)

        return result
    }

    // MARK: -

    public func apply(applier:(Range<Int>, UnsafeBufferPointer <T>) -> Void) {
        dispatch_data_apply(data) {
            (region:dispatch_data_t!, offset:Int, buffer:UnsafePointer <Void>, size:Int) -> Bool in
            let buffer = UnsafeBufferPointer <T> (start: UnsafePointer <T> (buffer), count: size / DispatchData <T>.elementSize)
            applier(offset..<offset + size, buffer)
            return true
        }
    }
}

// MARK: -

public func + <T> (lhs:DispatchData <T>, rhs:DispatchData <T>) -> DispatchData <T> {
    let data = dispatch_data_create_concat(lhs.data, rhs.data)
    return DispatchData <T> (data:data)
}

// MARK: -

public extension DispatchData {

    public func subBuffer(startIndex startIndex:Int, length:Int) -> DispatchData <T> {
        return subBuffer(Range <Int> (start: startIndex, end: startIndex + length))
    }

    public func subBuffer(startIndex startIndex:Int, count:Int) -> DispatchData <T> {
        return subBuffer(startIndex:startIndex, length:count * DispatchData <T>.elementSize)
    }

    public func inset(startInset startInset:Int = 0, endInset:Int = 0) -> DispatchData <T> {
        assert(startInset >= 0)
        assert(endInset >= 0)
        return subBuffer(startIndex:startInset, count: count - (startInset + endInset))
    }

    public subscript (range:Range <Int>) -> DispatchData <T> {
        return subBuffer(range)
    }
}

// MARK: -

public extension DispatchData {
    func toBuffer() -> Buffer <Void> {
        return try! map() {
            return Buffer <Void> (buffer:$0)
        }
    }
}

// MARK: -

extension DispatchData: CustomStringConvertible {

    public var description: String {
        var chunks:[String] = []
        apply() {
            chunks.append("\($0.startIndex)..+\($0.endIndex - $0.startIndex) \($1.dump(16))")

        }
        let chunksString = ", ".join(chunks)
        return "DispatchData(count:\(count), length:\(length), chunk count:\(chunks.count), chunks:\(chunksString))"
    }
}


extension DispatchData: CustomReflectable {
    public func customMirror() -> Mirror {

        var chunks:[(Range <Int>,String)] = []
        apply() {
            (range:Range<Int>, buffer:UnsafeBufferPointer <T>) -> Void in
            chunks.append((range, buffer.dump(16)))
        }

        return Mirror(self, children: [
            "count":count,
            "length":length,
            "data":chunks,
        ])
    }
}
