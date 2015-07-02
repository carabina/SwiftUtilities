//
//  DispatchDataTest.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 7/1/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import XCTest

import SwiftUtilities

extension DispatchData: Equatable {
}

public func == <T> (lhs: DispatchData <T>, rhs: DispatchData <T>) -> Bool {

    guard lhs.count == rhs.count else {
        return false
    }

    return lhs.map() {
        (lhsBuffer:UnsafeBufferPointer) -> Bool in

        return rhs.map() {
            (rhsBuffer:UnsafeBufferPointer) -> Bool in

            let result = memcmp(lhsBuffer.baseAddress, rhsBuffer.baseAddress, lhsBuffer.length)
            return result == 0
        }
    }
}

class DispatchDataTest: XCTestCase {

    func testBasic1() {
        let data = DispatchData <Void> (value:UInt32(0xDEADBEEF).bigEndian)
        XCTAssertEqual(data.elementSize, 1)
        XCTAssertEqual(data.count, 4)
        XCTAssertEqual(data.length, 4)
        XCTAssertEqual(data.startIndex, 0)
        XCTAssertEqual(data.endIndex, 4)
    }

    func testDefaulInit() {
        let data = DispatchData <Void> ()
        XCTAssertEqual(data.elementSize, 1)
        XCTAssertEqual(data.count, 0)
        XCTAssertEqual(data.length, 0)
        XCTAssertEqual(data.startIndex, 0)
        XCTAssertEqual(data.endIndex, 0)
    }

    func testConcat() {
        let data1 = DispatchData <Void> (value:UInt16(0xDEAD).bigEndian)
        let data2 = DispatchData <Void> (value:UInt16(0xBEEF).bigEndian)
        let result = data1 + data2
        let expectedResult = DispatchData <Void> (value:UInt32(0xDEADBEEF).bigEndian)
        XCTAssertTrue(result == expectedResult)
    }

    func testSplit() {
        let data = DispatchData <Void> (value:UInt32(0xDEADBEEF).bigEndian)
        let (lhs, rhs) = data.split(2)
        XCTAssertTrue(lhs == DispatchData <Void> (value:UInt16(0xDEAD).bigEndian))
        XCTAssertTrue(rhs == DispatchData <Void> (value:UInt16(0xBEEF).bigEndian))
    }

    func testInset() {
        let data = DispatchData <Void> (value:UInt32(0xDEADBEEF).bigEndian)
        let insettedData = data.inset(startInset: 1, endInset: 1)
        let expectedResult = DispatchData <Void> (value:UInt16(0xADBE).bigEndian)
        XCTAssertEqual(insettedData, expectedResult)
    }

    func testNonByteSized() {
        let data = DispatchData <UInt16> (array:[ 1, 2, 3, 4 ])
        XCTAssertEqual(data.subBuffer(1 ..< 3), DispatchData <UInt16> (array:[ 2, 3 ]))
        XCTAssertEqual(data.subBuffer(startIndex:1, count:2), DispatchData <UInt16> (array:[ 2, 3 ]))
        XCTAssertEqual(data[1 ..< 3], DispatchData <UInt16> (array:[ 2, 3 ]))
//        XCTAssertEqual(data.subBuffer(startIndex:1, length:2 * sizeof(UInt16)), DispatchData <UInt16> (array:[ 2, 3 ]))
    }
}

extension DispatchData {
    init(array:Array <T>) {
        let data:DispatchData = array.withUnsafeBufferPointer() {
            return DispatchData(buffer: $0)
        }
        self = data
    }
}
