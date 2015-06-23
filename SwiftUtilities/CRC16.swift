//
//  MAVLink.swift
//  MavlinkTest
//
//  Created by Jonathan Wight on 3/29/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

// CRC-16-CCITT	X.25

public struct CRC16 {
    public typealias CRCType = UInt16
    public internal(set) var crc:CRCType!

    public static func accumulate(buffer:UnsafeBufferPointer <UInt8>, crc:CRCType = 0xFFFF) -> CRCType {
        var accum = crc
        for b in buffer {
            var tmp = CRCType(b) ^ (accum & 0xFF)
            tmp = (tmp ^ (tmp << 4)) & 0xFF
            accum = (accum >> 8) ^ (tmp << 8) ^ (tmp << 3) ^ (tmp >> 4)
        }
        return accum
    }

    public mutating func accumulate(buffer:UnsafeBufferPointer <UInt8>) -> CRCType {
        if crc == nil {
            crc = 0xFFFF
        }
        crc = CRC16.accumulate(buffer, crc: crc)
        return crc
    }
}

public extension CRC16 {

    mutating func accumulate(bytes:[UInt8]) -> CRCType {
        bytes.withUnsafeBufferPointer() {
            (body:UnsafeBufferPointer <UInt8>) -> Void in
            accumulate(body)
        }
        return crc
    }


    mutating func accumulate(string:String) -> CRCType {
        string.withCString() {
            (ptr:UnsafePointer<Int8>) -> Void in
            let buffer = UnsafeBufferPointer <UInt8> (start: UnsafePointer <UInt8> (ptr), count: Int(strlen(ptr)))
            accumulate(buffer)
        }
        return crc
    }
}
