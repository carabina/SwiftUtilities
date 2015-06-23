//
//  main.swift
//  bit_range
//
//  Created by Jonathan Wight on 12/23/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation


/**
 Returns "length" bits of "value" starting from "startIndex".
 
 >>> binary(bitRange(0b010100, 2, 3), "0b")
 0b101
 */
public func bitRange(value:UInt64, startIndex:Int, length:Int) -> UInt64 {
    return bitRange(value, startIndex ..< startIndex + length)
}

public func bitRange(value:UInt64, range:Range <Int>) -> UInt64 {
    let length = range.endIndex - range.startIndex
    if length > 64 || range.startIndex < 0 || range.startIndex > range.endIndex {
        abort()
    }
    let mask = (1 << UInt64(length)) - 1
    let shifted = value >> UInt64(range.startIndex)
    return shifted & mask
}

public func bitRange(pointer:UnsafePointer <Void>, startIndex:Int, length:Int) -> UInt64 {
    return bitRange(pointer, startIndex ..< startIndex + length)
}

public func bitRange(pointer:UnsafePointer <Void>, range:Range <Int>) -> UInt64 {
    var startIndex = range.startIndex
    var endIndex = range.endIndex
    let length = range.endIndex - startIndex
    if length > 64 || startIndex < 0 || startIndex > endIndex {
        abort()
    }
    // Fast path; we want whole integers and the range is aligned to integer size.
    if length == 64 && startIndex % 64 == 0 {
        return UnsafePointer <UInt64> (pointer)[startIndex / 64]
    }
    else if length == 32 && startIndex % 32 == 0 {
        return UInt64(UnsafePointer <UInt32> (pointer)[startIndex / 32])
    }
    else if length == 16 && startIndex % 16 == 0 {
        return UInt64(UnsafePointer <UInt16> (pointer)[startIndex / 16])
    }
    else if length == 8 && startIndex % 8 == 0 {
        return UInt64(UnsafePointer <UInt8> (pointer)[startIndex / 8])
    }
    else {
        // Slow(er) path. Range is not aligned.
        let pointer = UnsafePointer <UInt64> (pointer)

        if startIndex / 64 == (endIndex - 1) / 64 {
            // Bit range does not cross two words
            let index = startIndex / 64
            let range = startIndex - index * 64 ..< endIndex - index * 64
            return bitRange(pointer[index], range)
        }
        else {
            // Bit range spans two words, get bit ranges for both words and then combine them.
            let index = startIndex / 64
            let msw = bitRange(pointer[index], startIndex - index * 64 ..< 64)
            let bits = (endIndex - index * 64) % 64
            let lsw = bitRange(pointer[index + 1], 0 ..< bits)
            return msw << UInt64(bits - 1) | lsw
        }
    }
}

public func bitRange <T> (pointer:UnsafeBufferPointer <T>, range:Range <Int>) -> UInt64 {
    assert(range.endIndex < pointer.endIndex * max(sizeof(T), 1) * 8)
    return bitRange(pointer.baseAddress, range)
}

//let input:UInt64 = 0b001100
//
//let inputBuffer:Array <UInt64> = [
//    0b1001000000000000000000000000000000000000000000000000000000000000,
//    0b0000000000000000000000000000000000000000000000000000000000000101,
//    ]
//
//inputBuffer.withUnsafeBufferPointer {
//    (p:UnsafeBufferPointer<UInt64>) -> Void in
//    let value = bitRange(p.baseAddress, 60..<68)
//    println(binary(value))
//}

//println(binary(input))
//
//println(binary(bitRange(input, 0..<4)))
