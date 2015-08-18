//
//  NSRange.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 9/13/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

public extension NSRange {

    init(location: Int, length: Int) {
        self.location = location
        self.length = length
    }

    init(_ location: Int, _ length: Int) {
        self.location = location
        self.length = length
    }

    init(range: Range <Int>) {
        self.location = range.startIndex
        self.length = range.endIndex - range.startIndex
    }

    init(_ range: Range <Int>) {
        self.location = range.startIndex
        self.length = range.endIndex - range.startIndex
    }

    var startIndex: Int { return location }
    var endIndex: Int { return location + length }
    var asRange: Range<Int> { return location..<location + length }
    var isEmpty: Bool { return length == 0 }

    func contains(index: Int) -> Bool {
        return index >= location && index < endIndex
    }
    
    func clamp(index: Int) -> Int {
        return max(self.startIndex, min(self.endIndex - 1, index))
    }

    func clamp(range: NSRange) -> NSRange {
        let startIndex = self.clamp(range.startIndex)
        let endIndex = self.clamp(range.endIndex)
        return NSRange(range: startIndex...endIndex)
    }
    
    func intersects(range: NSRange) -> Bool {
        return NSIntersectionRange(self, range).isEmpty == false
    }

    func intersection(range: NSRange) -> NSRange? {
        let intersection = NSIntersectionRange(self, range)        
        if intersection.isEmpty {
            return nil
        }
        else {
            return intersection
        }
    }

    func contiguous(range: NSRange) -> Bool {
        let (lhs, rhs) = ordered((self, range))
        return lhs.endIndex == rhs.startIndex 
    }
    
    func union(range: NSRange) -> NSRange {
        return NSUnionRange(self, range)
    }
}

extension NSRange: Equatable {
}

public func == (lhs: NSRange, rhs: NSRange) -> Bool {
    return NSEqualRanges(lhs, rhs)
}

extension NSRange: Comparable {
}

public func < (lhs: NSRange, rhs: NSRange) -> Bool {
    if lhs.location < rhs.location {
        return true
    }
    else if lhs.location == rhs.location {
        return lhs.length < rhs.length
    }
    else {
        return false
    }
}

