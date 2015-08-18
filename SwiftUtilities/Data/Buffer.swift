//
//  Buffer.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//
//  Copyright (c) 2014, Jonathan Wight
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


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
