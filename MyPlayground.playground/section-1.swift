// Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities

let R = NSRange(1,10)
R.clamp(NSRange(-100, 200))

NSRange(range:R.clamp(-100)...R.clamp(100))


