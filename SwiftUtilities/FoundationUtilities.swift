//
//  Utilities.swift
//  SwiftTag
//
//  Created by Jonathan Wight on 6/12/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import Foundation

// MARK: NSURL extensions

public extension NSURL {
    func URLByResolvingURL() throws -> NSURL {
        let bookmarkData = try self.bookmarkDataWithOptions(NSURLBookmarkCreationOptions.MinimalBookmark, includingResourceValuesForKeys: nil, relativeToURL: nil)
        return try NSURL(byResolvingBookmarkData: bookmarkData, options: .WithoutUI, relativeToURL: nil, bookmarkDataIsStale: nil)
    }
}

public func + (lhs: NSURL, rhs: String) -> NSURL {
    return lhs.URLByAppendingPathComponent(rhs)
}

public func += (inout left: NSURL, right: String) {
    left = left + right
}

// MARK: NSValueTransformers

public class BlockValueTransformer: NSValueTransformer {

    public typealias TransformerBlock = (AnyObject!) -> (AnyObject!)

    public let block: TransformerBlock

    /*
    Generally used:
    
    BlockValueTransformer.register(name: "Foo") { return Foo($0) }
    }
    */
    public static func register(name: String, block: TransformerBlock) -> BlockValueTransformer {
        let transformer = BlockValueTransformer(block: block)
        self.setValueTransformer(transformer, forName: name)
        return transformer
    }

    public init(block: TransformerBlock) {
        self.block = block
    }
    
    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        return self.block(value)
    }
}

