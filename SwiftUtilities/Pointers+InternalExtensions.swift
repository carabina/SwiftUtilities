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

    func toUnsafeBufferPointer <U> () -> UnsafeBufferPointer <U> {
        let count = length / UnsafeBufferPointer <U>.elementSize
        return UnsafeBufferPointer <U> (start: UnsafePointer <U> (baseAddress), count: count)
    }
}
