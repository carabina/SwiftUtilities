//
//  Endianness.swift
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

public enum Endianess {
    case big
    case little
    public static var native: Endianess {
        // TODO: This is a lie!!!
        return .little
    }
    public static var network: Endianess = .big
}

extension UInt16 {
    init(endianess: Endianess, value: UInt16) {
        switch endianess {
            case .big:
                self = UInt16(bigEndian: value)
            case .little:
                self = UInt16(littleEndian: value)
        }
    }
}

extension UInt32 {
    init(endianess: Endianess, value: UInt32) {
        switch endianess {
            case .big:
                self = UInt32(bigEndian: value)
            case .little:
                self = UInt32(littleEndian: value)
        }
    }
}

extension UInt64 {
    init(endianess: Endianess, value: UInt64) {
        switch endianess {
            case .big:
                self = UInt64(bigEndian: value)
            case .little:
                self = UInt64(littleEndian: value)
        }
    }
}