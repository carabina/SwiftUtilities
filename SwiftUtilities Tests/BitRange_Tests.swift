//
//  BitRange_Tests.swift
//  Tests
//
//  Created by Jonathan Wight on 6/24/15.
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


import XCTest
import SwiftUtilities

class BitRange_Tests: XCTestCase {

    func testScalarBitRange() {
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 0, length: 2, flipped: false), 0b11)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 2, length: 2, flipped: false), 0b10)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 4, length: 2, flipped: false), 0b01)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 6, length: 2, flipped: false), 0b00)

        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 0, length: 2, flipped: true), 0b00)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 2, length: 2, flipped: true), 0b01)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 4, length: 2, flipped: true), 0b10)
        XCTAssertEqual(bitRange(UInt8(0b00011011), start: 6, length: 2, flipped: true), 0b11)
    }

    func testScalarBitSet() {
        XCTAssertEqual(bitSet(UInt8(0b00011011), start: 0, length: 3, flipped: false, newValue: UInt8(0b100)), UInt8(0b00011100))
        XCTAssertEqual(bitSet(UInt8(0b00011011), start: 2, length: 1, flipped: false, newValue: UInt8(0b1)), UInt8(0b00011111))
        XCTAssertEqual(bitSet(UInt8(0b00011111), start: 0, length: 3, flipped: true, newValue: UInt8(0b111)), UInt8(0b11111111))
        XCTAssertEqual(bitSet(UInt8(0b00000000), range: 5..<8, flipped: true, newValue: UInt8(5)), UInt8(5))
    }

/// TODO
//    func testBufferRange1() {
//
//        let tests: [(Int,Int,UIntMax)] = [
////            (0, 1, 0x1),
//            (0, 4, 0x1111),
//        ]
//
//        let length = 32
//
//        for test in tests {
//            let result = buildBinary(length) {
//                (buffer) in
//                bitSet(buffer, start: test.0, length: test.1, newValue: test.2)
//                print(test.0, test.1)
//            }
//
//            var bitString = BitString(count: length)
//            try! bitString.bitSet(test.0, length: test.1, newValue: test.2)
//
//            XCTAssertEqual(bitString.string, try! byteArrayToBinary(result))
//        }
//    }

}
