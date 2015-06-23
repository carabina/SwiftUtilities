//
//  Pointers+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

extension UnsafeBufferPointer {
    func toUnsafeBufferPointer <U>() -> UnsafeBufferPointer <U> {
        let start = UnsafePointer <U> (baseAddress)
        let count = (self.count * max(sizeof(T), 1)) / max(sizeof(U), 1)
        return UnsafeBufferPointer <U> (start:start, count:count)
    }
}
