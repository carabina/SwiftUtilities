//
//  Utilities.swift
//  SwiftTag
//
//  Created by Jonathan Wight on 6/12/14.
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

