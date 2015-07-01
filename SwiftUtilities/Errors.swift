//
//  Errors.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/27/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

// TODO: This is kinda crap.
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

public func tryAndLogError <T> (@autoclosure block:(Void) throws -> T) -> T {
    do {
        let result = try block()
        return result
    }
    catch let error {
        preconditionFailure(String(error))
    }
}

public func makeOSStatusError(status:OSErr, description:String? = nil) -> ErrorType {
    let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
    return error
}


@noreturn public func unimplementedFailure(@autoclosure message: () -> String = "", file: StaticString = __FILE__, line: UWord = __LINE__) {
    preconditionFailure(message, file:file, line:line)
}

public func withNoOutput <R>(@noescape block:() throws -> R) throws -> R {

    fflush(stderr)
    let savedStdOut = dup(fileno(stdout))
    let savedStdErr = dup(fileno(stderr))

    var fd:[Int32] = [ 0, 0 ]
    var err = pipe(&fd)
    guard err >= 0 else {
        throw NSError(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: nil)
    }

    err = dup2(fd[1], fileno(stdout))
    guard err >= 0 else {
        fatalError()
    }

    err = dup2(fd[1], fileno(stderr))
    guard err >= 0 else {
        fatalError()
    }

    defer {
        fflush(stderr)
        var err = dup2(savedStdErr, fileno(stderr))
        guard err >= 0 else {
            fatalError()
        }
        err = dup2(savedStdOut, fileno(stdout))
        guard err >= 0 else {
            fatalError()
        }

        assert(err >= 0)
    }

    let result = try block()

    return result
}
