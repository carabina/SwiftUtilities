//
//  String+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 3/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

/**
 *  Set of helper methods to convert String ranges to/from NSString ranges
 *
 *  NSString indices are UTF16 based
 *  String indices are Grapheme Cluster based
 *  This allows you convert between the two
 *  Converting is useful when using Cocoa APIs that use NSRanges (for example
 *  text view selection ranges or regular expression result ranges).
 */
public extension String {

    func convert(index: NSInteger) -> String.Index? {
        let utf16Index = utf16.startIndex.advancedBy(index)
        return utf16Index.samePositionIn(self)
    }

    func convert(range: NSRange) -> Range <String.Index>? {
        let swiftRange = range.asRange
        if let startIndex = convert(swiftRange.startIndex), let endIndex = convert(swiftRange.endIndex) {
            return startIndex..<endIndex
        }
        else {
            return nil
        }
    }

    func convert(index: String.Index) -> NSInteger {
        let utf16Index = index.samePositionIn(utf16)
        return distance(utf16.startIndex, utf16Index)
    }

    func convert(range: Range <String.Index>) -> NSRange {
        let startIndex = convert(range.startIndex)
        let endIndex = convert(range.endIndex)
        return NSMakeRange(startIndex, endIndex - startIndex)
    }

}