//: Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities

enum Contains {
    case False
    case Maybe
}

struct BloomFilter <Element: Hashable> {

    var data:Array <UInt8>

    let count:Int

    init(count:Int) {
        self.count = count
        self.data = Array <UInt8> (count: Int(ceil(Double(count) / 8)), repeatedValue: 0)
    }

    mutating func add(value:Element) {
        let hash = value.hashValue
        let position = Int(unsafeBitCast(hash, UInt.self) % UInt(count))
        data.withUnsafeMutableBufferPointer() {
            (buffer) in

            

            bitSet(buffer, start: position, length: 1, newValue: 1)
            return
        }
    }

    func contains(value:Element) -> Contains {
        let hash = value.hashValue
        let position = Int(unsafeBitCast(hash, UInt.self) % UInt(count))
        return data.withUnsafeBufferPointer() {
            (buffer) in
            return bitRange(buffer, start: position, length: 1) == 0 ? Contains.False : Contains.Maybe
        }
    }

}

var filter = BloomFilter <String>(count:100)
filter.data
filter.add("hello world")
filter.data
filter.add("girafe")
filter.data
filter.contains("hello world")
filter.contains("donkey")

