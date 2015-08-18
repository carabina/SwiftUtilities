//
//  Buffer.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public struct Buffer <Element> {

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return count }
    public subscript (i: Int) -> Element {
        return baseAddress[i]
    }

//    func generate() -> UnsafeBufferPointerGenerator<Element>

    public var baseAddress: UnsafePointer <Element> {
        return UnsafePointer <Element> (data.bytes)
    }

    public var count: Int {
        return data.length / Buffer <Element>.elementSize
    }

    public static var elementSize: Int {
        return max(sizeof(Element), 1)
    }

    public var length: Int {
        return count * max(sizeof(Element), 1)
    }

    public init(start: UnsafePointer<Element>, count: Int) {
        self.init(NSData(bytes: start, length: count * Buffer <Element>.elementSize))
    }



    // MARK: -

    public init() {
    }

    public init(_ data: NSData) {
        assert(data.length == 0 || data.length >= Buffer <Element>.elementSize)
        self.data = data.copy() as! NSData
    }

    public var data: NSData = NSData()
}

// MARK: -

extension Buffer {

    public init(pointer: UnsafePointer <Element>, length: Int) {
        assert(length >= Buffer <Element>.elementSize)
        self.init(NSData(bytes: pointer, length: length))
    }

    public init(_ bufferPointer: UnsafeBufferPointer <Element>) {
        self.init(NSData(bytes: bufferPointer.baseAddress, length: bufferPointer.length))
    }

    public var bufferPointer: UnsafeBufferPointer <Element> {
        return UnsafeBufferPointer <Element> (start: self.baseAddress, count: count)
    }
}

// MARK: -

extension Buffer: Equatable {
}

public func == <Element>(lhs: Buffer <Element>, rhs: Buffer <Element>) -> Bool {
    if lhs.length != rhs.length {
        return false
    }
    return memcmp(lhs.baseAddress, rhs.baseAddress, lhs.length) == 0
}

// MARK: -

public func + <Element> (lhs: Buffer <Element>, rhs: Buffer <Element>) -> Buffer <Element> {
    let data = NSMutableData(data: lhs.data)
    data.appendData(data)
    return Buffer <Element> (data)
}

public func + <Element> (lhs: Buffer <Element>, rhs: UnsafeBufferPointer <Element>) -> Buffer <Element> {
    let data = NSMutableData(data: lhs.data)
    data.appendBytes(rhs.baseAddress, length: rhs.length)
    return Buffer <Element> (data)
}
