//
//  RegularExpression.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/31/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

public struct RegularExpression {

    public let expression: NSRegularExpression

    public init(_ pattern:String, options:NSRegularExpressionOptions = NSRegularExpressionOptions()) {
        var error:NSError?
        let expression = NSRegularExpression(pattern:pattern, options:options, error:&error)
        assert(error == nil)
        self.expression = expression!
        
    }

    public func match(string:String, options:NSMatchingOptions = NSMatchingOptions()) -> Match? {
        let length = (string as NSString).length
        if let result = expression.firstMatchInString(string, options:options, range:NSMakeRange(0, length)) {
            return Match(string:string, result:result)
        }
        else {
            return nil
        }
    }

    public struct Match: Printable {
        public let string: String
        public let result: NSTextCheckingResult

        init(string:String, result:NSTextCheckingResult) {
            self.string = string
            self.result = result
        }

        public var description: String {
            get {
                return "Match(\(result.numberOfRanges))"
            }
        }

        public var ranges: BlockBackedCollection <Range <String.Index>> {
            get {
                let count = result.numberOfRanges
                let ranges = BlockBackedCollection <Range <String.Index>> (count:count) {
                    let nsRange = self.result.rangeAtIndex($0)
                    let range = self.string.convert(nsRange)
                    return range!
                    }
                return ranges
            }
        }

        public var strings: BlockBackedCollection <String> {
            get {
                let count = result.numberOfRanges
                let groups = BlockBackedCollection <String> (count:count) {
                    let range = self.result.rangeAtIndex($0)
                    return (self.string as NSString).substringWithRange(range)
                    }
                return groups
            }
        }

    }
}
