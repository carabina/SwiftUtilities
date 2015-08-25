//
//  BlockBackedCollection.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 3/23/15.
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


/**
 *  A struct that acts like an array but returns results from a block
 */
public struct BlockBackedCollection <T>: CollectionType, SequenceType {
    public typealias Element = T
    public typealias Index = Int
    public typealias Block = (index: Index) -> T
    public typealias Generator = BlockBackedCollectionGenerator <T>

    public var startIndex: Index { return 0 }
    public var endIndex: Index { return count }
    public let count: Int
    public let block: Block

    public init(count: Index, block: Block) {
        self.count = count
        self.block = block
    }

    public subscript (index: Index) -> T {
        assert(index >= 0 && index < self.count)
        return block(index: index)
    }

    public func generate() -> Generator {
        return Generator(sequence: self)
    }
}

extension BlockBackedCollection: CustomStringConvertible {
    public var description: String {
        let strings: [String] = self.map {
            return String($0)
        }
        let content = strings.joinWithSeparator(", ")
        return "[\(content)]"
    }
}


public struct BlockBackedCollectionGenerator <T>: GeneratorType {
    public typealias Sequence = BlockBackedCollection <T>
    public typealias Element = Sequence.Element
    public typealias Index = Sequence.Index
    public typealias Block = Sequence.Block

    public let startIndex: Index = 0
    public var endIndex: Index { return count }
    public let count: Int
    public let block: Block
    public var nextIndex: Index = 0

    public init(sequence: Sequence) {
        self.count = sequence.count
        self.block = sequence.block
    }

    public mutating func next() -> Element? {
        if nextIndex >= endIndex {
            return nil
        }
        else if nextIndex < endIndex {
            let element = block(index: nextIndex++)
            return element
        }
        else {
            return nil
        }
    }
}
