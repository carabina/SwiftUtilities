//
//  PureUtilities.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 9/13/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//


/**
 :example:
    let (a,b) = ordered(("B", "A"))
 */
public func ordered <T:Comparable> (tuple:(T, T)) -> (T, T) {
    let (lhs, rhs) = tuple
    if lhs <= rhs {
        return (lhs, rhs)
    }
    else {
        return (rhs, lhs)
    }
}

