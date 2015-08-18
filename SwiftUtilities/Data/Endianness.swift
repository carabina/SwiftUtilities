//
//  Endianness.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

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