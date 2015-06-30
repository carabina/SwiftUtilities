//
//  MutableBuffer.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public struct MutableBuffer <T> {

    var startIndex: Int { return 0 }
    var endIndex: Int { return count }
    subscript (i: Int) -> T {
        return baseAddress[i]
    }

    init(start: UnsafePointer<T>, count: Int) {
        self.init(mutableData:NSMutableData(bytes: start, length: count * MutableBuffer <T>.elementSize))
    }

//    func generate() -> UnsafeBufferPointerGenerator<T>

    public var baseAddress:UnsafeMutablePointer <T> {
        return UnsafeMutablePointer <T> (mutableData.mutableBytes)
    }

    public var count:Int {
        return mutableData.length / MutableBuffer <T>.elementSize
    }

    // MARK: -

    internal init(mutableData:NSMutableData) {
        self.mutableData = mutableData
    }

    internal var mutableData:NSMutableData = NSMutableData()
}

// MARK: -

extension MutableBuffer {

    public init() {
    }

    public init(data:NSData) {
        assert(data.length == 0 || data.length >= MutableBuffer <T>.elementSize)
        self.init(mutableData:NSMutableData(data:data))
    }

    public init(pointer:UnsafePointer <T>, length:Int) {
        assert(length >= MutableBuffer <T>.elementSize)
        self.init(mutableData: NSMutableData(bytes: pointer, length: length))
    }

    public init(bufferPointer:UnsafeBufferPointer <T>) {
        self.init(mutableData: NSMutableData(bytes: bufferPointer.baseAddress, length: bufferPointer.count * MutableBuffer <T>.elementSize))
    }


    public var bufferPointer:UnsafeBufferPointer <T> {
        let count = mutableData.length / MutableBuffer <T>.elementSize
        return UnsafeBufferPointer <T> (start:self.baseAddress, count:count)
    }
}

// MARK: -

public extension MutableBuffer {

    var length:Int {
        return mutableData.length
    }

    static var elementSize:Int {
        return max(sizeof(T), 1)
    }

}

// MARK: -

public extension MutableBuffer {

    func append <Buffer:BufferType> (buffer:Buffer) {
        mutableData.appendBytes(buffer.baseAddress, length: buffer.length)
    }

    func append <T>(value:T) {
        var copy = value
        withUnsafePointer(&copy) {
            (pointer:UnsafePointer <T>) -> Void in
            let buffer = UnsafeBufferPointer <T> (start:pointer, count:1)
            append(buffer)
        }
    }

}


public extension MutableBuffer {

    init(buffer:Buffer <T>) {
        self.init(mutableData:buffer.data.mutableCopy() as! NSMutableData)
    }

}
