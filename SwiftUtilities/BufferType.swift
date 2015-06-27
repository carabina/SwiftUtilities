//
//  BufferType.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public protocol BufferType {

    typealias T

    var startIndex: Int { get }
    var endIndex: Int { get }
    subscript (i: Int) -> T { get }

    init(start: UnsafePointer<T>, count: Int)

//    func generate() -> UnsafeBufferPointerGenerator<T>

    var baseAddress:UnsafePointer <T> { get }
    var count:Int { get }
}

extension BufferType {

    public init <Other:BufferType where Other.T == T> (buffer:Other) {
        self.init(start:buffer.baseAddress, count:buffer.count)
    }

    public static var elementSize:Int {
        return max(sizeof(T), 1)
    }

    public var length:Int {
        return count * max(sizeof(T), 1)
    }

}

public extension BufferType {
    subscript (range:Range <Int>) -> UnsafeBufferPointer <T> {
        return UnsafeBufferPointer <T> (start: baseAddress + range.startIndex, count:range.endIndex - range.startIndex)
    }
}

extension UnsafeBufferPointer: BufferType {
}

extension Buffer: BufferType {
}

