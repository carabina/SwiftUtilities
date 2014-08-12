//
//  Utilities.swift
//  SwiftTag
//
//  Created by Jonathan Wight on 6/12/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import Foundation

// MARK: NSURL extensions

extension NSURL {
    func URLByResolvingURL(inout error: NSError?) -> NSURL! {
        let bookmark : NSData? = self.bookmarkDataWithOptions(NSURLBookmarkCreationOptions.MinimalBookmark, includingResourceValuesForKeys:nil, relativeToURL:nil, error:&error)
        if bookmark == nil {
            return nil
        }
        let bookmarkedURL = NSURL(byResolvingBookmarkData:bookmark, options: .WithoutUI, relativeToURL:nil, bookmarkDataIsStale:nil, error:&error)
        return bookmarkedURL
    }
}

func + (lhs: NSURL, rhs: String) -> NSURL {
    return lhs.URLByAppendingPathComponent(rhs)
}

func += (inout left: NSURL, right: String) {
    left = left + right
}

// MARK: NSValueTransformers

class BlockValueTransformer: NSValueTransformer {

    typealias TransformerBlock = (AnyObject!) -> (AnyObject!)

    let block : TransformerBlock

    /*
    Generally used:
    
    BlockValueTransformer.register(name:"Foo") { return Foo($0) }
    }
    */
    class func register(name:String, block:TransformerBlock) {
        let transformer = BlockValueTransformer(block:block)
        self.setValueTransformer(transformer, forName:name)
    }

    init(block:TransformerBlock) {
        self.block = block
    }
    
    override func transformedValue(value: AnyObject!) -> AnyObject! {
        return self.block(value)
    }
}

