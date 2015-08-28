//: Playground - noun: a place where people can play

import Cocoa

import SwiftUtilities


struct BloomFilter <Element: Hashable> {

    let data:MutableBuffer <UInt8>

    let count:Int

    init(count:Int) {
        self.count = count
        self.data = MutableBuffer <UInt8> (count: Int(ceil(Double(count) / 8)), repeatedValue: 0)
    }

    func add(value:Element) {

        let hash = value.hashValue
        let position = hash % count

//        bitSet(<#T##buffer: UnsafeMutableBufferPointer<Void>##UnsafeMutableBufferPointer<Void>#>, range: <#T##Range<Int>#>, newValue: <#T##UIntMax#>)


    }

}

let filter = BloomFilter <String>(count:100)
