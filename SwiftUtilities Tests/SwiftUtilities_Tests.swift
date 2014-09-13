//
//  SwiftUtilities_Tests.swift
//  SwiftUtilities Tests
//
//  Created by Jonathan Wight on 8/12/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftUtilities

class SwiftUtilities_Tests: XCTestCase {
    
    func testBoolEnum() {
        let b = BoolEnum(false)
        XCTAssertEqual(b, false)
        XCTAssertEqual(b, BoolEnum.False)
    }

}
