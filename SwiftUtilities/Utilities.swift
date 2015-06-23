//
//  Utilities.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/24/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public extension NSData {

    func withUnsafeBufferPointer<T, R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R {
        let voidBuffer = UnsafeBufferPointer<Void> (start: bytes, count: length)
        let buffer:UnsafeBufferPointer<T> = voidBuffer.toUnsafeBufferPointer()
        return body(buffer)
    }

}

@noreturn public func unimplementedFailure(@autoclosure message: () -> String = "", file: StaticString = __FILE__, line: UWord = __LINE__) {
    preconditionFailure(message, file:file, line:line)
}

public extension String {
    func substringFromPrefix(prefix:String) throws -> String {
        if let range = rangeOfString(prefix) where range.startIndex == startIndex {
            return substringFromIndex(range.endIndex)
        }
        throw Error.generic(message: "String does not begin with prefix.")
    }
}

public enum Error: ErrorType {
    case noError
    case generic(message:String)
}

public func log(x:UIntMax, base:Int) -> Double {
    return log(Double(x)) / log(Double(base))
}


