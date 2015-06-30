//
//  NSData+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/30/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public extension NSData {
    var buffer:UnsafeBufferPointer <Void> {
        return UnsafeBufferPointer <Void> (start: bytes, count: length)
    }

    func withUnsafeBufferPointer<T, R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R {
        let voidBuffer = UnsafeBufferPointer<Void> (start: bytes, count: length)
        let buffer:UnsafeBufferPointer<T> = voidBuffer.toUnsafeBufferPointer()
        return body(buffer)
    }
}
