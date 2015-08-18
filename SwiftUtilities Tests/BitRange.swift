//
//  BitRange.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 6/23/15.
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
