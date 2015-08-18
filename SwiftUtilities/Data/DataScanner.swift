//
//  DataScanner.swift
//  MavlinkTest
//
//  Created by Jonathan Wight on 3/29/15.
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

public class DataScanner {
    public typealias BufferType = UnsafeBufferPointer <Void>

    public init(buffer: BufferType) {
        self.buffer = buffer
        current = self.buffer.startIndex
    }

    public let buffer: BufferType

    public var current: BufferType.Index

    public var remainingSize: Int {
        return buffer.count - current
    }

    public var remaining: BufferType {
        return BufferType(start: buffer.baseAddress + current, count: buffer.count - current)
    }

    public var atEnd: Bool {
        return current == buffer.endIndex
    }

    private var currentPointer: UnsafePointer <Void> {
        return buffer.baseAddress.advancedBy(current)
    }
}

// MARK: Integers

public extension DataScanner {

    func scan <Type:IntegerType>() throws -> Type? {
        guard remainingSize >= sizeof(Type) else {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        current = current.advancedBy(sizeof(Type))
        return result
    }

    func scan <Type:IntegerType>() throws -> Type {
        guard let value:Type = try scan() else {
            throw Error.generic("Unable to scan element.")
        }
        return value
    }
}

// MARK: Floats

public extension DataScanner {

    func scan <Type:FloatingPointType> () throws -> Type? {
        guard remainingSize >= sizeof(Type) else {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        // TODO; Endianness
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan <Type:FloatingPointType> () throws -> Type {
        guard let value:Type = try scan() else {
            throw Error.generic("Unable to scan element.")
        }
        return value
    }

}

// MARK: Misc.

public extension DataScanner {

    func scan(count: Int) throws -> UnsafeBufferPointer <Void>? {
        if remainingSize < count {
            return nil
        }
        let scannedBuffer = UnsafeBufferPointer <Void> (start: buffer.baseAddress.advancedBy(current), count: count)
        current = current.advancedBy(count)
        return scannedBuffer
    }

    func scan(count: Int) throws -> UnsafeBufferPointer <Void> {
        guard let value:UnsafeBufferPointer <Void> = try scan(count) else {
            throw Error.generic("Not enough data in buffer")
        }
        return value
    }

}

public extension DataScanner {

    func scan(value: UInt8) throws -> Bool {
        if let scannedValue: UInt8 = try scan() {
            return scannedValue == value
        }
        else {
            return false
        }
    }

    func scan(value: UInt8) throws {
        if try scan(value) == false {
            throw Error.generic("Cannot scan value")
        }
    }

    func scanString(maxCount: Int? = nil, encoding:NSStringEncoding = NSUTF8StringEncoding) throws -> String? {
        guard atEnd == false else {
            return nil
        }

        let buffer:UnsafeBufferPointer <UInt8> = self.buffer.toUnsafeBufferPointer()

        var count = 0
        var index = current
        var nilByteFound = false
        while index != buffer.endIndex {
            if buffer[index++] == 0x00 {
                nilByteFound = true
                break
            }
            if let maxCount = maxCount where count >= maxCount {
                break
            }
            count++
        }

        if count == 0 {
            if nilByteFound {
                current = current.advancedBy(1)
                return ""
            }
            return nil
        }

        let bytes = UnsafeMutablePointer <Void> (currentPointer)
        current = current.advancedBy(count)
        if nilByteFound {
            current = current.advancedBy(1)
        }

        let data = NSData(bytesNoCopy: bytes, length: count, freeWhenDone: false)
        guard let string = NSString(data: data, encoding: encoding) else {
            throw Error.generic("Unable to create string from data.")
        }

        return string as String
    }

    func scanUpTo(byte: UInt8) throws -> UnsafeBufferPointer <UInt8>? {
        let start = current
        let buffer:UnsafeBufferPointer <UInt8> = self.buffer.toUnsafeBufferPointer()
        for ; current != buffer.endIndex; ++current {
            if buffer[current] == byte {
                break
            }
        }
        if start == current {
            return nil
        }
        return buffer[start..<current]
    }
}
