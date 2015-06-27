//
//  Buffer.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public struct Buffer <T> {

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return count }
    public subscript (i: Int) -> T {
        return baseAddress[i]
    }

    public init(start: UnsafePointer<T>, count: Int) {
        self.init(data:NSData(bytes: start, length: count * Buffer <T>.elementSize))
    }

//    func generate() -> UnsafeBufferPointerGenerator<T>

    public var baseAddress:UnsafePointer <T> {
        return UnsafePointer <T> (data.bytes)
    }

    public var count:Int {
        return data.length / Buffer <T>.elementSize
    }

    // MARK: -

    public init() {
    }

    public init(data:NSData) {
        assert(data.length == 0 || data.length >= Buffer <T>.elementSize)
        self.data = data.copy() as! NSData
    }

    public var data:NSData = NSData()

    public static var elementSize:Int {
        return max(sizeof(T), 1)
    }
}

// MARK: -

extension Buffer {

    public init(pointer:UnsafePointer <T>, length:Int) {
        assert(length >= Buffer <T>.elementSize)
        self.init(data: NSData(bytes: pointer, length: length))
    }

    public var bufferPointer:UnsafeBufferPointer <T> {
        return UnsafeBufferPointer <T> (start:self.baseAddress, count:count)
    }
}

// MARK: -

public func + <T> (lhs:Buffer <T>, rhs:Buffer <T>) -> Buffer <T> {
    let data = NSMutableData(data: lhs.data)
    data.appendData(data)
    return Buffer <T> (data:data)
}

public func + <T> (lhs:Buffer <T>, rhs:UnsafeBufferPointer <T>) -> Buffer <T> {
    let data = NSMutableData(data: lhs.data)
    data.appendBytes(rhs.baseAddress, length: rhs.length)
    return Buffer <T> (data:data)
}
