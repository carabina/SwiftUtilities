//
//  BitRange.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation
import XCTest
import SwiftUtilities

class BitRange_Tests: XCTestCase {

    func testBinary() {
        XCTAssertEqual(binary(0b0, prefix:"0b"), "0b0")
        XCTAssertEqual(binary(0b1, prefix:"0b"), "0b1")
        XCTAssertEqual(binary(0b1000, prefix:"0b"), "0b1000")
        XCTAssertEqual(binary(0b11111111, prefix:"0b"), "0b11111111")

        XCTAssertEqual(binary(0b0), "0")
        XCTAssertEqual(binary(0b1), "1")
        XCTAssertEqual(binary(0b1000), "1000")
        XCTAssertEqual(binary(0b11111111), "11111111")

        XCTAssertEqual(binary(0b0, padding:8), "00000000")
        XCTAssertEqual(binary(0b1, padding:8), "00000001")
        XCTAssertEqual(binary(0b1000, padding:8), "00001000")
        XCTAssertEqual(binary(0b11111111, padding:8), "11111111")
    }


    func testBitRange() {

        XCTAssertEqual(bitRange(0b00000101, 0..<3),    0b101)
        XCTAssertNotEqual(bitRange(0b00000101, 0..<3), 0b010)

    }
}
