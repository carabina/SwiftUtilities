//
//  String+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 3/23/15.
//
//  Copyright (c) 2014, Jonathan Wight
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


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
        return utf16.startIndex.distanceTo(utf16Index)
    }

    func convert(range: Range <String.Index>) -> NSRange {
        let startIndex = convert(range.startIndex)
        let endIndex = convert(range.endIndex)
        return NSMakeRange(startIndex, endIndex - startIndex)
    }

}