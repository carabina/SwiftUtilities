//: Playground - noun: a place where people can play

import Foundation

import SwiftUtilities

extension DispatchData: SequenceType {

    public typealias Generator = DispatchDataGenerator <Element>

    @warn_unused_result
    public func generate() -> Generator {
        return DispatchDataGenerator <Element> (self)
    }

}

public struct DispatchDataGenerator <Element>: GeneratorType {

    var remaining:DispatchData <Element>

    @warn_unused_result
    public init(_ dispatchData:DispatchData <Element>) {
        remaining = dispatchData
    }

    public mutating func next() -> Element? {
        if remaining.length == 0 {
            return nil
        }
        let (current, newRemaining) = remaining.split(1)
        remaining = newRemaining
        return current.createMap() {
            (data, buffer)  in
            return buffer[0]
        }
    }
}

let array = [1,2,3,4,5,6]

// Copy array into a DispatchData
let data = array.withUnsafeBufferPointer() {
    (buffer) in
    return DispatchData <Int> (buffer: buffer)
}

for value in data {
    print(value)
}


extension DispatchData {

    public func map(transform: (Element) throws -> Element) rethrows -> [Element] {
        var result:[Element] = []
        apply() {
            (range, buffer) in
            for value in buffer {
                let value = try! transform(value)
                result.append(value)
            }
            return true
        }
        return result
    }

}
//
//
let result = data.map() { return $0 }
print(result)

