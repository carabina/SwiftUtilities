//
//  String+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/27/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public extension String {
    func substringFromPrefix(prefix:String) throws -> String {
        if let range = rangeOfString(prefix) where range.startIndex == startIndex {
            return substringFromIndex(range.endIndex)
        }
        throw Error.generic("String does not begin with prefix.")
    }
}

// MARK: -

public extension String {
    func withCString<Result>(@noescape f: UnsafeBufferPointer<Int8> -> Result) -> Result {
        return withCString() {
            (ptr: UnsafePointer<Int8>) -> Result in
            let buffer = UnsafeBufferPointer <Int8> (start:ptr, count:Int(strlen(ptr)))
            return f(buffer)
        }
    }
}

