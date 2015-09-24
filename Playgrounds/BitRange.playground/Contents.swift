//: Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities

func test(length: Int, @noescape closure: (UnsafeMutableBufferPointer <UInt8>) -> Void) -> [UInt8] {
    var data = [UInt8](count: Int(ceil(Double(length) / 8)), repeatedValue: 0)
    data.withUnsafeMutableBufferPointer() {
        (inout buffer: UnsafeMutableBufferPointer <UInt8>) -> Void in
        closure(buffer)
    }
    return data
}

struct BitString {
    var string: String

    init(count: Int) {
        string = String(count: count, repeatedValue: Character("0"))
    }

    mutating func bitSet(start: Int, length: Int, newValue: UIntMax) {

        let newValue = try! binary(newValue, width: length, prefix: false)

        let start = string.startIndex.advancedBy(start)
        let end = start.advancedBy(length)
        string.replaceRange(Range(start: start, end: end), with: newValue)
    }
}


let result = test(128) {
    (buffer) in
    bitSet(buffer, start: 0, length: 1, newValue: 0x01)
}
print(result.map({ try! binary($0, width: 8, prefix: false) }).joinWithSeparator(""))


var bitString = BitString(count: 128)
bitString.bitSet(0, length: 1, newValue: 0x01)
print(bitString.string)


