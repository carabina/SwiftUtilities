//
//  BlockBackedCollection.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 3/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

/**
 *  A struct that acts like an array but returns results from a block
 */
public struct BlockBackedCollection <T>: CollectionType, SequenceType {
    public typealias Element = T
    public typealias Index = Int
    public typealias Block = (index:Index) -> T
    public typealias Generator = BlockBackedCollectionGenerator <T>

    public var startIndex: Index { get { return 0 } }
    public var endIndex: Index { get { return count } }
    public let count: Int
    public let block: Block

    public init(count:Index, block:Block) {
        self.count = count
        self.block = block
    }

    public subscript (index:Index) -> T {
        assert(index >= 0 && index < self.count)
        return block(index: index)
    }

    public func generate() -> Generator {
        return Generator(sequence:self)
    }
}

extension BlockBackedCollection: CustomStringConvertible {
    public var description: String {
        get {
            let strings:[String] = self.map {
                return String($0)
            }
            let content = ", ".join(strings)
            return "[\(content)]"
        }
    }
}


public struct BlockBackedCollectionGenerator <T>: GeneratorType {
    public typealias Sequence = BlockBackedCollection <T>
    public typealias Element = Sequence.Element
    public typealias Index = Sequence.Index
    public typealias Block = Sequence.Block

    public let startIndex: Index = 0
    public var endIndex: Index { get { return count } }
    public let count: Int
    public let block: Block
    public var nextIndex: Index = 0

    public init(sequence:Sequence) {
        self.count = sequence.count
        self.block = sequence.block
    }
        
    public mutating func next() -> Element? {
        if nextIndex >= endIndex {
            return nil
        }
        else if nextIndex < endIndex {
            let element = block(index:nextIndex++)
            return element
        }
        else {
            return nil
        }
    }
}
