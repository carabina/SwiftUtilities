//
//  Pointers+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public extension UnsafeBufferPointer {
    static var elementSize: Int {
        return max(sizeof(T), 1)
    }

    var length:Int {
        return count * UnsafeBufferPointer <T>.elementSize
    }

}

public extension UnsafeBufferPointer {
    func toUnsafeBufferPointer <U> () -> UnsafeBufferPointer <U> {
        let count = length / UnsafeBufferPointer <U>.elementSize
        return UnsafeBufferPointer <U> (start: UnsafePointer <U> (baseAddress), count: count)
    }

    subscript (range:Range <Int>) -> UnsafeBufferPointer <T> {
        get {
            return UnsafeBufferPointer <T> (start: baseAddress + range.startIndex, count:range.endIndex - range.startIndex)
        }
    }
}

public func convert <T, U>(pointer:UnsafeMutablePointer <T>) -> UnsafeMutablePointer <U> {
    return UnsafeMutablePointer <U> (pointer)
}

public extension NSData {
    var buffer:UnsafeBufferPointer <Void> {
        get {
            return UnsafeBufferPointer <Void> (start: bytes, count: length)
        }
    }
}

public extension NSData {

    func withUnsafeBufferPointer<T, R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R {
        let voidBuffer = UnsafeBufferPointer<Void> (start: bytes, count: length)
        let buffer:UnsafeBufferPointer<T> = voidBuffer.toUnsafeBufferPointer()
        return body(buffer)
    }

}

