//
//  DataScannerTest.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 8/12/15.
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

class DataScannerTest: XCTestCase {

    func testTooLittleData() {

        let inputData = try! NSData.fromHex("FF")
        let buffer: UnsafeBufferPointer <Void> = inputData.toUnsafeBufferPointer()
        let scanner = DataScanner(buffer: buffer)
        let B1: UInt64? = try! scanner.scan()
        XCTAssert(B1 == nil)
    }

    func testNumbers() {

        let inputData = try! NSData.fromHex("DEADBEEF")
        let buffer: UnsafeBufferPointer <Void> = inputData.toUnsafeBufferPointer()
        let scanner = DataScanner(buffer: buffer)

        let B1: UInt8? = try! scanner.scan()
        XCTAssertEqual(B1, 0xDE)
        let B2: UInt16? = try! scanner.scan()
        XCTAssertEqual(UInt16(bigEndian: B2!), 0xADBE)
        let B3: UInt8? = try! scanner.scan()
        XCTAssertEqual(B3, 0xEF)

        XCTAssert(scanner.atEnd)
    }

    func testStrings() {

        let inputData = "Hello world\0".dataUsingEncoding(NSASCIIStringEncoding)!
        print(inputData)

        let buffer: UnsafeBufferPointer <Void> = inputData.toUnsafeBufferPointer()

        let scanner = DataScanner(buffer: buffer)

        let S1 = try! scanner.scanString(5)
        XCTAssertEqual(S1, "Hello")

        let S2 = try! scanner.scanString()
        XCTAssertEqual(S2, " world")

        print(scanner.atEnd)

        let S3 = try! scanner.scanString()
        XCTAssertEqual(S3, nil)
    }
}
