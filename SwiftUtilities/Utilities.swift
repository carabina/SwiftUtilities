//
//  Utilities.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/24/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

@noreturn public func unimplementedFailure(@autoclosure message: () -> String = "", file: StaticString = __FILE__, line: UWord = __LINE__) {
    preconditionFailure(message, file:file, line:line)
}

public extension String {
    func substringFromPrefix(prefix:String) throws -> String {
        if let range = rangeOfString(prefix) where range.startIndex == startIndex {
            return substringFromIndex(range.endIndex)
        }
        throw Error.generic("String does not begin with prefix.")
    }
}

public func log(x:UIntMax, base:Int) -> Double {
    return log(Double(x)) / log(Double(base))
}




public enum Error:ErrorType {
    case none
    case generic(String)
    case dispatchIO(Int32, String)
    case posix(Int32, String)
}

extension Error: CustomStringConvertible {
    public var description: String {
        switch self {
            case .none:
                return "None"
            case .generic(let string):
                return string
            case .dispatchIO(let code, let string):
                return "\(code) \(string)"
                
            case .posix(let code, let string):
                return "\(code) \(string)"
        }
    }
}


/**
 *  A wrapper around CFAbsoluteTime
 *
 *  CFAbsoluteTime is just a (indirect) wrapper around a Double. By wrapping it ourselves in a struct we're able to extend it.
 */
public struct Timestamp {
    public let absoluteTime:CFAbsoluteTime

    public init() {
        absoluteTime = CFAbsoluteTimeGetCurrent()
    }
}

extension Timestamp: CustomStringConvertible {
    public var description: String {
        return "\(absoluteTime)"
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

