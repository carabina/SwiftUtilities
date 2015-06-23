//
//  Tests.swift
//  Tests
//
//  Created by Jonathan Wight on 6/24/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftUtilities

class Tests: XCTestCase {

//    func testBase() {
//        XCTAssertEqual(0b10, 10, 10)
//    }


    func testScalarBitRange() {
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 0, length: 2, flipped:false), 0b11)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 2, length: 2, flipped:false), 0b10)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 4, length: 2, flipped:false), 0b01)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 6, length: 2, flipped:false), 0b00)

        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 0, length: 2, flipped:true), 0b00)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 2, length: 2, flipped:true), 0b01)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 4, length: 2, flipped:true), 0b10)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 6, length: 2, flipped:true), 0b11)
    }

    func testBufferBitRange() {
        let data = try! NSData(hexString: "0001020304050607F0F1F2F3F4F5F6F7")

        data.withUnsafeBufferPointer {
            (p:UnsafeBufferPointer<Void>) -> Void in

            for n:Int in stride(from: 0, through: 7, by: 1) {
                XCTAssertEqual(try! bitRange(p, start:bits(n), length: 8), UIntMax(n))
                XCTAssertEqual(try! bitRange(p, start:bits(n + 8), length: 8), 0xF0 + UIntMax(n))
            }

            for n:Int in stride(from: 0, through: 7, by: 1) {
                XCTAssertEqual(try! bitRange(p, start:bits(n) + 1, length: 7), UIntMax(n))
//                XCTAssertEqual(try! bitRange(p, start:bits(n + 8) + 1, length: 7), (0xF0 + UIntMax(n)) & 0b01111111)
            }
        }


    }

}
