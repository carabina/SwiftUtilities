//
//  Utilities.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 8/10/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

public func bitwiseEquality <T> (lhs: T, _ rhs: T) -> Bool {
    var lhs = lhs
    var rhs = rhs
    return withUnsafePointers(&lhs, &rhs) {
        return memcmp($0, $1, sizeof(T))  == 0
    }
}
