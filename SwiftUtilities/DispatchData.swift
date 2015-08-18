//
//  DispatchData.swift
//  RTP Test
//
//  Created by Jonathan Wight on 6/30/15.
//  Copyright © 2015 schwa. All rights reserved.
//

import Foundation

public struct DispatchData <Element> {

    public let data: dispatch_data_t

    public var count: Int {
        return length / elementSize
    }

    public static var elementSize: Int {
        return max(sizeof(Element), 1)
    }

    public var elementSize: Int {
        return DispatchData <Element>.elementSize
    }

    public var length: Int {
        return dispatch_data_get_size(data)
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    // MARK: -

    public init(data: dispatch_data_t) {
        self.data = data
        assert(count * elementSize == length)
    }

    public init() {
        self.init(data: dispatch_data_create(nil, 0, nil, nil))
    }

    public init(buffer: UnsafeBufferPointer <Element>) {
        self.init(data: dispatch_data_create(buffer.baseAddress, buffer.length, nil, nil))
    }

    public init(start: UnsafePointer <Element>, count:Int) {
        self.init(data: dispatch_data_create(start, count * DispatchData <Element>.elementSize, nil, nil))
    }

    // MARK: -

    public func subBuffer(range: Range <Int>) -> DispatchData <Element> {
        assert(range.startIndex >= startIndex && range.startIndex <= endIndex)
        assert(range.endIndex >= startIndex && range.endIndex <= endIndex)
        assert(range.startIndex <= range.endIndex)
        return DispatchData <Element> (data: dispatch_data_create_subrange(data, range.startIndex * elementSize, (range.endIndex - range.startIndex) * elementSize))
    }

    // MARK: Mapping data.

    /// IMPORTANT: If you need to keep the buffer beyond the scope of block uyou must retain data too.
    public func map <R> (@noescape block: (DispatchData <Element>, UnsafeBufferPointer <Void>) -> R) -> R {
        var pointer: UnsafePointer <Void> = nil
        var size: Int = 0
        let mappedData = dispatch_data_create_map(data, &pointer, &size)
        let buffer = UnsafeBufferPointer <Void> (start: pointer, count: size)
        return block(DispatchData <Element> (data: mappedData), buffer)
    }

    /// IMPORTANT: If you need to keep the buffer beyond the scope of block uyou must retain data too.
    public func map <R> (@noescape block: (DispatchData <Element>, UnsafeBufferPointer <Void>) throws -> R) rethrows -> R {
        var pointer: UnsafePointer <Void> = nil
        var size: Int = 0
        let mappedData = dispatch_data_create_map(data, &pointer, &size)
        let buffer = UnsafeBufferPointer <Void> (start: pointer, count: size)
        return try block(DispatchData <Element> (data: mappedData), buffer)
    }

    // MARK: -

    public func apply(applier: (Range<Int>, UnsafeBufferPointer <Element>) -> Void) {
        dispatch_data_apply(data) {
            (region: dispatch_data_t!, offset: Int, buffer: UnsafePointer <Void>, size: Int) -> Bool in
            let buffer = UnsafeBufferPointer <Element> (start: UnsafePointer <Element> (buffer), count: size / self.elementSize)
            applier(offset..<offset + size, buffer)
            return true
        }
    }

    public func convert <U> () -> DispatchData <U> {
        return DispatchData <U> (data: data)
    }
}

// MARK: -

public func + <Element> (lhs: DispatchData <Element>, rhs: DispatchData <Element>) -> DispatchData <Element> {
    let data = dispatch_data_create_concat(lhs.data, rhs.data)
    return DispatchData <Element> (data: data)
}

// MARK: -

public extension DispatchData {
    public subscript (range: Range <Int>) -> DispatchData <Element> {
        return subBuffer(range)
    }
}

// MARK: -

public extension DispatchData {

    public func subBuffer(startIndex startIndex: Int, count: Int) -> DispatchData <Element> {
        return subBuffer(Range <Int> (start: startIndex, end: startIndex + count))
    }

    public func inset(startInset startInset: Int = 0, endInset: Int = 0) -> DispatchData <Element> {
        assert(startInset >= 0)
        assert(endInset >= 0)
        return subBuffer(startIndex: startInset, count: count - (startInset + endInset))
    }

    public func split(count: Int) -> (DispatchData <Element>, DispatchData <Element>) {
        let lhs = subBuffer(startIndex: 0, count: count)
        let rhs = subBuffer(startIndex: count, count: self.count - count)
        return (lhs, rhs)
    }
}

// MARK: -

extension DispatchData: Equatable {
}

public func == <Element> (lhs: DispatchData <Element>, rhs: DispatchData <Element>) -> Bool {

    guard lhs.count == rhs.count else {
        return false
    }

    return lhs.map() {
        (lhsData, lhsBuffer) -> Bool in

        return rhs.map() {
            (rhsData, rhsBuffer) -> Bool in

            let result = memcmp(lhsBuffer.baseAddress, rhsBuffer.baseAddress, lhsBuffer.length)
            return result == 0
        }
    }
}

// MARK: -

extension DispatchData: CustomStringConvertible {
    public var description: String {
        var chunkCount = 0
        apply() {
            (range, pointer) in
            chunkCount++
        }
        return "DispatchData(count: \(count), length: \(length), chunk count: \(chunkCount), data: \(data))"
    }
}

// MARK: -

public extension DispatchData {
    init <U: IntegerType> (value: U) {
        var copy = value
        self = withUnsafePointer(&copy) {
            let buffer = UnsafeBufferPointer <U> (start: $0, count: 1)
            return DispatchData <U> (buffer: buffer).convert()
        }
    }
}

// MARK: -

public extension DispatchData {
    func toBuffer() -> Buffer <Void> {
        return map() {
            (data, ptr) in
            return Buffer <Void> (buffer: ptr)
        }
    }
}

// MARK: -

public extension DispatchData {

    init <U> (value:U) {
        var copy = value
        let data:dispatch_data_t = withUnsafePointer(&copy) {
            let buffer = UnsafeBufferPointer <U> (start:$0, count:1)
            return dispatch_data_create(buffer.baseAddress, buffer.length, nil, nil)
        }
        self.init(data:data)
    }
}
