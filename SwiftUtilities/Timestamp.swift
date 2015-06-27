//
//  Utilities.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/24/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

/**
 *  A wrapper around CFAbsoluteTime
 *
 *  CFAbsoluteTime is just typealias for a Double. By wrapping it in a struct we're able to extend it.
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


