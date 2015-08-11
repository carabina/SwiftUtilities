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
        XCTAssertEqual(binary(UInt32(0b0)), "0b0")
//        XCTAssertEqual(binary(0b1), "0b1")
//        XCTAssertEqual(binary(0b1000), "0b1000")
//        XCTAssertEqual(binary(0b11111111), "0b11111111")
//
//        XCTAssertEqual(binary(0b0), "0")
//        XCTAssertEqual(binary(0b1), "1")
//        XCTAssertEqual(binary(0b1000), "1000")
//        XCTAssertEqual(binary(0b11111111), "11111111")
//
//        XCTAssertEqual(binary(0b0, padding: 8), "00000000")
//        XCTAssertEqual(binary(0b1, padding: 8), "00000001")
//        XCTAssertEqual(binary(0b1000, padding: 8), "00001000")
//        XCTAssertEqual(binary(0b11111111, padding: 8), "11111111")
    }


//    func testBitRange() {
//        XCTAssertEqual(bitRange(0b00000101, 0..<3),    0b101)
//        XCTAssertNotEqual(bitRange(0b00000101, 0..<3), 0b010)
//
//    }

//    func testBitRange2() {
//
//        let inputBuffer: Array <UInt64> = [
//            0b1001000000000000000000000000000000000000000000000000000000000000,
//            0b0000000000000000000000000000000000000000000000000000000000000101,
//            ]
//
//        inputBuffer.withUnsafeBufferPointer {
//            (p: UnsafeBufferPointer<UInt64>) -> Void in
//            let value = bitRange(p.baseAddress, range: 60..<68)
//            XCTAssertEqual(value, 0b1001101)
//        }
//    }

}
