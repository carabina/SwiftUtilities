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

    public init(absoluteTime:CFAbsoluteTime) {
        self.absoluteTime = absoluteTime
    }
}

// MARK: -

extension Timestamp: Equatable {
}

public func ==(lhs: Timestamp, rhs: Timestamp) -> Bool {
    return lhs.absoluteTime == rhs.absoluteTime
}

// MARK: -

extension Timestamp: Comparable {
}

public func <(lhs: Timestamp, rhs: Timestamp) -> Bool {
    return lhs.absoluteTime < rhs.absoluteTime
}

// MARK: -

extension Timestamp: Hashable {
    public var hashValue: Int {
        return absoluteTime.hashValue
    }
}
// MARK: -

extension Timestamp: CustomStringConvertible {
    public var description: String {
        return String(absoluteTime)
    }
}

extension Timestamp: CustomReflectable {

    public func customMirror() -> Mirror {
        return Mirror(reflecting:absoluteTime)
    }

}