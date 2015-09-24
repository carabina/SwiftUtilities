//
//  BufferType.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/26/15.
//
//  Copyright (c) 2014, Jonathan Wight
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


import Foundation

// MARK: BufferType

public protocol BufferType {
    typealias Element
    var count: Int { get }
    init(start: UnsafePointer<Element>, count: Int)
}

// MARK: IndexedBufferType

public protocol IndexedBufferType: BufferType {
    var baseAddress: UnsafePointer <Element> { get }
    var startIndex: Int { get }
    var endIndex: Int { get }
    subscript (i: Int) -> Element { get }
}

// MARK: BufferType Protocol Extensions

extension BufferType {

//    public init <Other: BufferType where Other.T == T> (buffer: Other) {
//        self.init(start: buffer.baseAddress, count: buffer.count)
//    }

    public static var elementSize: Int {
        return max(sizeof(Element), 1)
    }

    public var length: Int {
        return count * max(sizeof(Element), 1)
    }

}

// MARK: Protocol Extensions

public extension IndexedBufferType {

    public init <Other: IndexedBufferType where Other.Element == Element> (_ buffer: Other) {
        self.init(start: buffer.baseAddress, count: buffer.count)
    }

    func subBuffer(start: Int, count: Int) -> UnsafeBufferPointer <Element> {
        return UnsafeBufferPointer <Element> (start: baseAddress.advancedBy(start), count: count)
    }

    func inset(startInset: Int, endInset: Int) -> UnsafeBufferPointer <Element> {
        assert(startInset >= 0)
        assert(endInset >= 0)
        return UnsafeBufferPointer <Element> (start: baseAddress.advancedBy(startInset), count: count - (startInset + endInset))
    }


    subscript (range: Range <Int>) -> UnsafeBufferPointer <Element> {
        return UnsafeBufferPointer <Element> (start: baseAddress + range.startIndex, count: range.endIndex - range.startIndex)
    }

    func toUnsafeBufferPointer <U> () -> UnsafeBufferPointer <U> {
        let count = length / UnsafeBufferPointer <U>.elementSize
        return UnsafeBufferPointer <U> (start: UnsafePointer <U> (baseAddress), count: count)
    }
}

// MARK: UnsafeBufferPointer conformance

extension UnsafeBufferPointer: IndexedBufferType {

    // TODO: This shouldn't be necessary. But removing these two elements causes swiftc to crash.
    static var elementSize: Int {
        return max(sizeof(Element), 1)
    }

    var length: Int {
        return count * UnsafeBufferPointer <Element>.elementSize
    }
}

// MARK: -

//extension NSData: BufferType {
//
//    public typealias Element = Void
//
//    public var count: Int { return length }
//
//    public convenience init(start: UnsafePointer<Element>, count: Int) {
//        self.init(bytes: start, length: count)
//    }
//}

// MARK: -

extension DispatchData: BufferType {
}




