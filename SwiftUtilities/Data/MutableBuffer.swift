//
//  MutableBuffer.swift
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

public struct MutableBuffer <T> {

    var startIndex: Int { return 0 }
    var endIndex: Int { return count }
    subscript (i: Int) -> T {
        return baseAddress[i]
    }

    init(start: UnsafePointer<T>, count: Int) {
        self.init(mutableData: NSMutableData(bytes: start, length: count * MutableBuffer <T>.elementSize))
    }

//    func generate() -> UnsafeBufferPointerGenerator<T>

    public var baseAddress: UnsafeMutablePointer <T> {
        return UnsafeMutablePointer <T> (mutableData.mutableBytes)
    }

    public var count: Int {
        return mutableData.length / MutableBuffer <T>.elementSize
    }

    // MARK: -

    internal init(mutableData: NSMutableData) {
        self.mutableData = mutableData
    }

    internal var mutableData: NSMutableData = NSMutableData()
}

// MARK: -

extension MutableBuffer {

    public init() {
    }

    public init(data: NSData) {
        assert(data.length == 0 || data.length >= MutableBuffer <T>.elementSize)
        self.init(mutableData: NSMutableData(data: data))
    }

    public init(pointer: UnsafePointer <T>, length: Int) {
        assert(length >= MutableBuffer <T>.elementSize)
        self.init(mutableData: NSMutableData(bytes: pointer, length: length))
    }

    public init(bufferPointer: UnsafeBufferPointer <T>) {
        self.init(mutableData: NSMutableData(bytes: bufferPointer.baseAddress, length: bufferPointer.count * MutableBuffer <T>.elementSize))
    }


    public var bufferPointer: UnsafeBufferPointer <T> {
        let count = mutableData.length / MutableBuffer <T>.elementSize
        return UnsafeBufferPointer <T> (start: self.baseAddress, count: count)
    }
}

// MARK: -

public extension MutableBuffer {

    var length: Int {
        return mutableData.length
    }

    static var elementSize: Int {
        return max(sizeof(T), 1)
    }

}

// MARK: -

public extension MutableBuffer {

    func append <Buffer: IndexedBufferType> (buffer: Buffer) {
        mutableData.appendBytes(buffer.baseAddress, length: buffer.length)
    }

    func append <T>(value: T) {
        var copy = value
        withUnsafePointer(&copy) {
            (pointer: UnsafePointer <T>) -> Void in
            let buffer = UnsafeBufferPointer <T> (start: pointer, count: 1)
            append(buffer)
        }
    }

}


public extension MutableBuffer {

    init(buffer: Buffer <T>) {
        self.init(mutableData: buffer.data.mutableCopy() as! NSMutableData)
    }

}
