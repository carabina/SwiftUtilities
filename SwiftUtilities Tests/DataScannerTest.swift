//
//  DataScannerTest.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 8/12/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import XCTest

import SwiftUtilities

class DataScannerTest: XCTestCase {

    func testNumbers() {

        let inputData = try! NSData.fromHex("DEADBEEF")
        let buffer: UnsafeBufferPointer <UInt8> = inputData.toUnsafeBufferPointer()
        let scanner = DataScanner(buffer: buffer)

        let B1:UInt8? = try! scanner.scan()
        XCTAssertEqual(B1, 0xDE)
        let B2:UInt16? = try! scanner.scan()
        XCTAssertEqual(UInt16(bigEndian:B2!), 0xADBE)
        let B3:UInt8? = try! scanner.scan()
        XCTAssertEqual(B3, 0xEF)

        XCTAssert(scanner.atEnd)
    }

    func testStrings() {

        let inputData = "Hello world\0".dataUsingEncoding(NSASCIIStringEncoding)!
        print(inputData)

        let buffer:UnsafeBufferPointer <UInt8> = inputData.toUnsafeBufferPointer()

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
