//: Playground - noun: a place where people can play

import Cocoa


import SwiftUtilities

let expression = RegularExpression("(Hel)(lo)")

let match = expression.match("Hello World")!
println(match.strings)



//let group = match!.groups[0]





