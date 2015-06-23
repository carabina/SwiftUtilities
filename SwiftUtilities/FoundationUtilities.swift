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
        var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let bookmark = try self.bookmarkDataWithOptions(NSURLBookmarkCreationOptions.MinimalBookmark, includingResourceValuesForKeys:nil, relativeToURL:nil)
        let bookmarkedURL: NSURL?
        do {
            bookmarkedURL = try NSURL(byResolvingBookmarkData:bookmark, options: .WithoutUI, relativeToURL:nil, bookmarkDataIsStale:nil)
        } catch let error1 as NSError {
            error = error1
            bookmarkedURL = nil
        }
        if let value = bookmarkedURL {
            return value
        }
        throw error
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

    typealias TransformerBlock = (AnyObject!) -> (AnyObject!)

    let block : TransformerBlock

    /*
    Generally used:
    
    BlockValueTransformer.register(name:"Foo") { return Foo($0) }
    }
    */
    class func register(name:String, block:TransformerBlock) -> BlockValueTransformer {
        let transformer = BlockValueTransformer(block:block)
        self.setValueTransformer(transformer, forName:name)
        return transformer
    }

    init(block:TransformerBlock) {
        self.block = block
    }
    
    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        return self.block(value)
    }
}

