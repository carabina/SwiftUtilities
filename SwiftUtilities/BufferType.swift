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

    func subBuffer(start:Int, count:Int) -> UnsafeBufferPointer <T> {
        return UnsafeBufferPointer <T> (start: baseAddress.advancedBy(start), count: count)
    }

    func inset(startInset:Int, endInset:Int) -> UnsafeBufferPointer <T> {
        assert(startInset >= 0)
        assert(endInset >= 0)
        return UnsafeBufferPointer <T> (start: baseAddress.advancedBy(startInset), count: count - (startInset + endInset))
    }


    subscript (range:Range <Int>) -> UnsafeBufferPointer <T> {
        return UnsafeBufferPointer <T> (start: baseAddress + range.startIndex, count:range.endIndex - range.startIndex)
    }

    func toUnsafeBufferPointer <U> () -> UnsafeBufferPointer <U> {
        let count = length / UnsafeBufferPointer <U>.elementSize
        return UnsafeBufferPointer <U> (start: UnsafePointer <U> (baseAddress), count: count)
    }
}

extension UnsafeBufferPointer: BufferType {
    static var elementSize: Int {
        return max(sizeof(Element), 1)
    }

    var length:Int {
        return count * UnsafeBufferPointer <Element>.elementSize
    }
}

extension Buffer: BufferType {
}

