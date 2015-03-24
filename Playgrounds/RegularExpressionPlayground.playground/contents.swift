//: Playground - noun: a place where people can play

import Cocoa


import SwiftUtilities

let expression = RegularExpression("😀")

let haystack = "xxxxxx😀yyyy"
let match = expression.match(haystack)!
let range = match.ranges[0]
haystack[range]

