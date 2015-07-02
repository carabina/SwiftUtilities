//: Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities

let data1 = DispatchData <Void> (value:UInt16(0xDEAD).bigEndian)
let data2 = DispatchData <Void> (value:UInt16(0xBEEF).bigEndian)
let result = data1 + data2
let expectedResult = DispatchData <Void> (value:UInt32(0xDEADBEEF).bigEndian)
