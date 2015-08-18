//
//  BoolEnum.swift
//  GalaxyTest
//
//  Created by Jonathan Wight on 8/9/14.
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

// Swift's Bool type is a struct and not an enum. This is a workaround until they fix that.

public enum BoolEnum {
    case True
    case False
}

public extension BoolEnum {
    init() { self = .False }
}

public extension BoolEnum {
    init(_ bool: BooleanType) { self = bool.boolValue ? .True: .False }
}

extension BoolEnum: BooleanLiteralConvertible {

    public init(booleanLiteral value: BooleanLiteralType) {
        self = value ? .True: .False
    }
}

extension BoolEnum: BooleanType {
    public var boolValue: Bool {
        switch self {
        case .True: return true
        case .False: return false
        }
    }
}

extension BoolEnum: Equatable {
}

public func ==(lhs: BoolEnum, rhs: BoolEnum) -> Bool {
    switch (lhs, rhs) {
    case (.True,.True), (.False,.False):
        return true
    default:
        return false
    }
}

public func &(lhs: BoolEnum, rhs: BoolEnum) -> BoolEnum {
    if lhs {
        return rhs
    }
    return false
}

public func |(lhs: BoolEnum, rhs: BoolEnum) -> BoolEnum {
    if lhs {
        return true
    }
    return rhs
}

public func ^(lhs: BoolEnum, rhs: BoolEnum) -> BoolEnum {
    return BoolEnum(lhs != rhs)
}

public prefix func !(a: BoolEnum) -> BoolEnum {
    return a ^ true
}

// Compound assignment (with bitwise and)
public func &=(inout lhs: BoolEnum, rhs: BoolEnum) {
    lhs = lhs & rhs
}
