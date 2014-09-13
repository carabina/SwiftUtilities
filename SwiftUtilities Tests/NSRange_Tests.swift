//
//  NSRange_Tests.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 9/13/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftUtilities

class NSRange_Tests: XCTestCase {

    func testRange() {
        XCTAssertEqual(NSRange(), NSMakeRange(0, 0))
        XCTAssertEqual(NSRange(range:5..<15), NSMakeRange(5, 10))
        XCTAssertEqual(NSRange(5, 10), NSMakeRange(5, 10))

        XCTAssertEqual(NSRange(range:1...10).endIndex, Range <Int> (1...10).endIndex)
        XCTAssertEqual(NSRange(range:1..<10).endIndex, Range <Int> (1..<10).endIndex)

        XCTAssertTrue(NSRange(1,0).isEmpty)
        XCTAssertFalse(NSRange(0,1).isEmpty)

        XCTAssertEqual(NSRange(1,10).clamp(5), 5)
        XCTAssertEqual(NSRange(1,10).clamp(0), 1)
        XCTAssertEqual(NSRange(1,10).clamp(10), 10)
        XCTAssertEqual(NSRange(1,10).clamp(100), 10)
        XCTAssertEqual(NSRange(1,10).clamp(-100), 1)

        XCTAssertEqual(NSRange(range:1...10).clamp(NSRange(-100, 200)), NSRange(range:1...10))
        XCTAssertEqual(NSRange(range:1...10).clamp(NSRange(5, 200)), NSRange(range:5...10))
        XCTAssertEqual(NSRange(range:1...10).clamp(NSRange(-100, 105)), NSRange(range:1...5))

    }
}
