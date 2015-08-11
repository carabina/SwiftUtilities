//
//  TestBase.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/25/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftUtilities

class TestBase: XCTestCase {

    func testFromString() {
        XCTAssertEqual(try! UIntMax(fromString: "0b1111"), 0b1111)
        XCTAssertEqual(try! UIntMax(fromString: "0o1234"), 0o1234)
        XCTAssertEqual(try! UIntMax(fromString: "0x1234abcd"), 0x1234abcd)
    }

    func testToString() {
        XCTAssertEqual(String(value: 0b1111, base: 2, prefix: true), "0b1111")
        XCTAssertEqual(String(value: 0o1234, base: 8, prefix: true), "0o1234")
        XCTAssertEqual(String(value: 0x1234abcd, base: 16, prefix: true), "0x1234abcd")
    }

    func testToString_Lengths() {
        XCTAssertEqual(String(value: 0b1111, base: 2, prefix: true, width: 8), "0b00001111")
    }
}
