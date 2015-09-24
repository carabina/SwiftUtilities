//
//  NSRange_Tests.swift
//  SwiftUtilities
//
//  Created by Jonathan Wight on 9/13/14.
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

class NSRange_Tests: XCTestCase {

    func testRange() {

//        XCTAssertEqual(NSRange(5..<15), NSMakeRange(5, 10))
//        XCTAssertEqual(NSRange(location: 5, length: 10), NSMakeRange(5, 10))

        XCTAssertEqual(NSRange(range: 1...10).endIndex, Range <Int> (1...10).endIndex)
        XCTAssertEqual(NSRange(range: 1..<10).endIndex, Range <Int> (1..<10).endIndex)

        XCTAssertTrue(NSRange(location: 1, length: 0).isEmpty)
        XCTAssertFalse(NSRange(location: 0, length: 1).isEmpty)

        XCTAssertEqual(NSRange(location: 1, length: 10).clamp(5), 5)
        XCTAssertEqual(NSRange(location: 1, length: 10).clamp(0), 1)
        XCTAssertEqual(NSRange(location: 1, length: 10).clamp(10), 10)
        XCTAssertEqual(NSRange(location: 1, length: 10).clamp(100), 10)
        XCTAssertEqual(NSRange(location: 1, length: 10).clamp(-100), 1)

        XCTAssertEqual(NSRange(range: 1...10).clamp(NSRange(location: -100, length: 200)), NSRange(range: 1...10))
        XCTAssertEqual(NSRange(range: 1...10).clamp(NSRange(location: 5, length: 200)), NSRange(range: 5...10))
        XCTAssertEqual(NSRange(range: 1...10).clamp(NSRange(location: -100, length: 105)), NSRange(range: 1...5))

    }
}
