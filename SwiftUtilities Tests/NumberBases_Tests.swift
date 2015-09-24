//
//  NumberBases_Tests.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/25/15.
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

class NumberBases_Tests: XCTestCase {

    func testFromString() {
        XCTAssertEqual(try! UIntMax(fromString: "0b1111"), 0b1111)
        XCTAssertEqual(try! UIntMax(fromString: "0o1234"), 0o1234)
        XCTAssertEqual(try! UIntMax(fromString: "0x1234abcd"), 0x1234abcd)
        XCTAssertEqual(try! UIntMax(fromString: "123456"), 123456)
    }

    func testFromStringWithBase() {
        XCTAssertEqual(try! UIntMax(fromString: "0b1111", base: 2), 0b1111)
        XCTAssertEqual(try! UIntMax(fromString: "0o1234", base: 8), 0o1234)
        XCTAssertEqual(try! UIntMax(fromString: "0x1234abcd", base: 16), 0x1234abcd)
        XCTAssertEqual(try! UIntMax(fromString: "123456", base: 10), 123456)
    }

    func testBadFromString() {
        XCTAssertThrows() {
            let _ = try UIntMax(fromString: "0b1112")
            return
        }
        XCTAssertThrows() {
            let _ = try UIntMax(fromString: "0o8111")
            return
        }
        XCTAssertThrows() {
            let _ = try UIntMax(fromString: "0xGGGGG")
            return
        }
//        XCTAssertEqual(try! UIntMax(fromString: "0o1234"), 0o1234)
//        XCTAssertEqual(try! UIntMax(fromString: "0x1234abcd"), 0x1234abcd)
//        XCTAssertEqual(try! UIntMax(fromString: "123456"), 123456)
    }

    func testToString() {
        XCTAssertEqual(try! UInt32(0b1111).encodeToString(base: 2, prefix: true), "0b1111")
        XCTAssertEqual(try! UInt32(0o1234).encodeToString(base: 8, prefix: true), "0o1234")
        XCTAssertEqual(try! UInt32(0x1234abcd).encodeToString(base: 16, prefix: true), "0x1234abcd")
    }

    func testToString_Lengths() {
        XCTAssertEqual(try! UInt32(0b1111).encodeToString(base: 2, prefix: true, width: 8), "0b00001111")
    }
}
