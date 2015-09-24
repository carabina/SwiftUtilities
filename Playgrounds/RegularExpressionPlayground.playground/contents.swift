//: Playground - noun: a place where people can play

import Cocoa


import SwiftUtilities

let expression = try! RegularExpression("😀")

let haystack = "xxxxxx😀yyyy"
let match = expression.match(haystack)!
let range = match.ranges[0]
haystack[range]

func ~= (pattern: RegularExpression, value: String) -> Bool {
    let match = pattern.match(value)
    return match != nil
}

switch "hello world" {
    case try! RegularExpression("^hello.+"):
        print("Match!")
    default:
        print("No match")
}