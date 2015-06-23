//
//  Bases.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

/**
 Return the binary representation of "value" as a string.
 */
public func binary(value:UInt64, padding:Int = 0, prefix:String = "") -> String {
    var s = ""
    var bits = 0
    if value == 0 {
        s = "0"
        bits = 1
    } else {
        var n:UInt64 = value
        bits = Int(floor(log2(Double(n)))) + 1
        for var index = bits - 1; index >= 0; --index {
            let mask = UInt64(1) << UInt64(index)
            let bit = n & mask != 0
            s += bit ? "1" : "0"
        }
    }
    if padding != 0 {
        let pad = "".stringByPaddingToLength(max(padding - bits, 0), withString:"0", startingAtIndex:0)
        s = pad + s
    }
    return prefix + s
}

public func hex(value:UInt32) -> String {
    return value.asHex()
}

public extension UInt32 {
    func asHex() -> String {
        var s = ""
        let characters:[Character] = [
            "0","1","2","3","4","5","6","7","8","9",
            "A","B","C","D","E","F",
            ]
        s.append(characters[Int(self >> 28 & 0x0F)])
        s.append(characters[Int(self >> 24 & 0x0F)])
        s.append(characters[Int(self >> 20 & 0x0F)])
        s.append(characters[Int(self >> 16 & 0x0F)])
        s.append(characters[Int(self >> 12 & 0x0F)])
        s.append(characters[Int(self >> 8 & 0x0F)])
        s.append(characters[Int(self >> 4 & 0x0F)])
        s.append(characters[Int(self & 0x0F)])
        
        return s
    }

}

