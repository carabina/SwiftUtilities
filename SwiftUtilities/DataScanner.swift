//
//  DataScanner.swift
//  MavlinkTest
//
//  Created by Jonathan Wight on 3/29/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public class DataScanner {
    public typealias BufferType = UnsafeBufferPointer <UInt8>
    public let buffer: BufferType
    public var current: BufferType.Index

    public var remaining: BufferType {
        return BufferType(start: buffer.baseAddress + current, count: buffer.count - current)
    }

    public init(buffer: BufferType) {
        self.buffer = buffer
        current = self.buffer.startIndex
    }

    public func scan() throws -> UInt8? {
        if atEnd {
            return nil
        }
        let result = buffer[current]
        current = current.advancedBy(1)
        return result
    }

    public func scan() throws -> Int8? {
        if let unsigned: UInt8 = try scan() {
            return Int8(bitPattern: unsigned)
        }
        else {
            return nil
        }
    }

    public func scan() throws -> UInt16? {
        typealias Type = UInt16
        if atEnd {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        // TODO; Endianness
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan() throws -> Int16? {
        if let unsigned: UInt16 = try scan() {
            return Int16(bitPattern: unsigned)
        }
        else {
            return nil
        }
    }

    public func scan() throws -> UInt32? {
        typealias Type = UInt32
        if atEnd {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        // TODO; Endianness
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan() throws -> Int32? {
        if let unsigned: UInt32 = try scan() {
            return Int32(bitPattern: unsigned)
        }
        else {
            return nil
        }
    }

    public func scan() throws -> UInt64? {
        typealias Type = UInt64
        if atEnd {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        // TODO; Endianness
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan() throws -> Int64? {
        if let unsigned: UInt64 = try scan() {
            return Int64(bitPattern: unsigned)
        }
        else {
            return nil
        }
    }

    public func scan() throws -> Float? {
        typealias Type = Float
        if atEnd {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        // TODO; Endianness
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan() throws -> Double? {
        typealias Type = Double
        if atEnd {
            return nil
        }
        let offset = buffer.baseAddress.advancedBy(current)
        let b = UnsafePointer <Type> (offset)
        let result = b.memory
        // TODO; Endianness
        current = current.advancedBy(sizeof(Type))
        return result
    }

    public func scan(value: UInt8) throws -> Bool {
        if let scannedValue: UInt8 = try scan() {
            return scannedValue == value
        }
        else {
            return false
        }
    }

    public func scanBuffer(count: Int) throws -> UnsafeBufferPointer <UInt8>? {
        if atEnd {
            return nil
        }
        let scannedBuffer = UnsafeBufferPointer <UInt8> (start: buffer.baseAddress.advancedBy(current), count: count)
        current = current.advancedBy(count)
        return scannedBuffer
    }

    var currentPointer: UnsafePointer <UInt8> {
        return buffer.baseAddress.advancedBy(current)
    }

    public func scanString(maxCount: Int? = nil, encoding:NSStringEncoding = NSUTF8StringEncoding) throws -> String? {
        guard atEnd == false else {
            return nil
        }

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
}


public extension DataScanner {

    func scanUpTo(byte: UInt8) throws -> UnsafeBufferPointer <UInt8>? {
        let start = current
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
