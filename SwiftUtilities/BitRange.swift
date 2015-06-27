//
//  BitRange.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/24/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public func bitRange <T:UnsignedIntegerType> (value:T, range:Range <Int>, flipped:Bool = false) -> T {
    return bitRange(value, start:range.startIndex, length:range.endIndex - range.startIndex, flipped:flipped)
}

public func bitRange <T:UnsignedIntegerType> (value:T, start:Int, length:Int, flipped:Bool = false) -> T {
    assert(sizeof(T) <= sizeof(UIntMax))
    let bitSize = UIntMax(sizeof(T) * 8)
    assert(start + length <= Int(bitSize))
    if flipped {
        let shift = bitSize - UIntMax(start) - UIntMax(length)
        let mask = (1 << UIntMax(length)) - 1
        let intermediate = value.toUIntMax() >> shift & mask
        let result = intermediate
        return T.init(result)
    }
    else {
        let shift = UIntMax(start)
        let mask = (1 << UIntMax(length)) - 1
        let result = value.toUIntMax() >> shift & mask
        return T.init(result)
    }
}

public func bitRange(buffer:UnsafeBufferPointer <Void>, start:Int, length:Int) -> UIntMax {
    let pointer = buffer.baseAddress

    // Fast path; we want whole integers and the range is aligned to integer size.
    if length == 64 && start % 64 == 0 {
        return UnsafePointer <UInt64> (pointer)[start / 64]
    }
    else if length == 32 && start % 32 == 0 {
        return UIntMax(UnsafePointer <UInt32> (pointer)[start / 32])
    }
    else if length == 16 && start % 16 == 0 {
        return UIntMax(UnsafePointer <UInt16> (pointer)[start / 16])
    }
    else if length == 8 && start % 8 == 0 {
        return UIntMax(UnsafePointer <UInt8> (pointer)[start / 8])
    }
    else {
        // Slow(er) path. Range is not aligned.
        let pointer = UnsafePointer <UIntMax> (pointer)
        let wordSize = sizeof(UIntMax) * 8

        let end = start + length

        if start / wordSize == (end - 1) / wordSize {
            // Bit range does not cross two words

            let offset = start / wordSize
            let result = bitRange(pointer[offset].bigEndian, start: start, length: length, flipped:true)
            // TODO: ENDIANNESS: Do we need an endian converter that works on bit ranges instead of 2/4/8 bytes? Can we convert to next highest 2/4/8 bytes?
            return result
        }
        else {
            // Bit range spans two words, get bit ranges for both words and then combine them.
            let offset = start / wordSize
            let msw = bitRange(pointer[offset].bigEndian, range: start ..< wordSize, flipped:true)
            let bits = (end - offset * wordSize) % wordSize
            let lsw = bitRange(pointer[offset + 1].bigEndian, range: 0 ..< bits, flipped:true)
            // TODO: ENDIANNESS
            return msw << UIntMax(bits) | lsw
        }
    }
}

public func bitRange(buffer:UnsafeBufferPointer <Void>, range:Range <Int>) -> UIntMax {
    return bitRange(buffer, start:range.startIndex, length:range.endIndex - range.startIndex)
}
