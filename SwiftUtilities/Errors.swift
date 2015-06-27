//
//  Errors.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/27/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

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

@noreturn public func unimplementedFailure(@autoclosure message: () -> String = "", file: StaticString = __FILE__, line: UWord = __LINE__) {
    preconditionFailure(message, file:file, line:line)
}

