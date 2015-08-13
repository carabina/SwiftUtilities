//
//  DataScanner.swift
//  MavlinkTest
//
//  Created by Jonathan Wight on 3/29/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

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

    private var currentPointer: UnsafePointer <Void> {
        return buffer.baseAddress.advancedBy(current)
    }
}

// MARK: Integers

public extension DataScanner {

    public func scan <Type:IntegerType>() throws -> Type? {
        guard remainingSize >= sizeof(Type) else {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan <Type:IntegerType>() throws -> Type {
        guard let value:Type = try scan() else {
            throw Error.generic("Unable to scan element.")
        }
        return value
    }
}

// MARK: Floats

extension DataScanner {

    public func scan <Type:FloatingPointType> () throws -> Type? {
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

extension DataScanner {

    public func scan(value: UInt8) throws -> Bool {
        if let scannedValue: UInt8 = try scan() {
            return scannedValue == value
        }
        else {
            return false
        }
    }

    public func scanBuffer(count: Int) throws -> UnsafeBufferPointer <Void>? {
        if atEnd {
            return nil
        }
        let scannedBuffer = UnsafeBufferPointer <Void> (start: buffer.baseAddress.advancedBy(current), count: count)
        current = current.advancedBy(count)
        return scannedBuffer
    }

    public func scanString(maxCount: Int? = nil, encoding:NSStringEncoding = NSUTF8StringEncoding) throws -> String? {
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

    public var atEnd: Bool {
        return current == buffer.endIndex
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
