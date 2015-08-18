//
//  Pointers+Extensions.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/23/15.
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

public extension UnsafeBufferPointer {
    public init(start: UnsafePointer<Element>, length: Int) {
        precondition(length % UnsafeBufferPointer <Element>.elementSize == 0)
        self.init(start:start, count:length / UnsafeBufferPointer <Element>.elementSize)
    }
}


public extension UnsafeMutableBufferPointer {
    func toUnsafeBufferPointer() -> UnsafeBufferPointer <Element> {
        return UnsafeBufferPointer <Element> (start: baseAddress, count: count)
    }
}

//extension UnsafeBufferPointer {
//    public func dump(cap: Int = 256) -> String {
//        let limit = min(length, cap)
//        var dump: String = " ".join(stride(from: 0, to: limit, by: 4).map() {
//            let region = self[$0..<min($0 + 4, limit)]
//            return region.toHex()
//        })
//        if length > cap {
//            dump = "<\(dump) ...>"
//        }
//        else {
//            dump = "<\(dump)>"
//        }
//
//        return dump
//    }
//}


//extension UnsafeBufferPointer: CustomStringConvertible {
//    public var description: String {
//        return "UnsafeBufferPointer(start: \(self.baseAddress), length: \(length), \(dump())"
//    }
//}

