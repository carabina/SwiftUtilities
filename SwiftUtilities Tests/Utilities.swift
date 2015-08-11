//
//  Utilities.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/25/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import XCTest

//func XCTAssertEqual<T: Equatable>(@autoclosure expression1: () -> T, @autoclosure _ expression2: () -> T, @autoclosure _ expression3: () -> T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
//    XCTAssertEqual(expression1, expression2, message, file: file, line: line)
//    XCTAssertEqual(expression2, expression3, message, file: file, line: line)
//    XCTAssertEqual(expression3, expression1, message, file: file, line: line)
//}

func bits(bits: Int) -> Int {
    return bits * 8
}
