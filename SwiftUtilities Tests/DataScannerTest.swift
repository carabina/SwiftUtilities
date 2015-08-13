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

    func testExample() {

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
