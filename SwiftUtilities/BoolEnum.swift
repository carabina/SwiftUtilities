//
//  BoolEnum.swift
//  GalaxyTest
//
//  Created by Jonathan Wight on 8/9/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

// Swift's Bool type is a struct and not an enum. This is a workaround until they fix that.

public enum BoolEnum {
    case True
    case False
}

public extension BoolEnum {
    init() { self = .False }
}

public extension BoolEnum {
    init(_ bool:BooleanType) { self = bool.boolValue ? .True : .False }
}

extension BoolEnum : BooleanLiteralConvertible {

    public init(booleanLiteral value: BooleanLiteralType) {
        self = value ? .True : .False
    }
}

extension BoolEnum : BooleanType {
    public var boolValue: Bool {
        switch self {
        case .True: return true
        case .False: return false
        }
    }
}

extension BoolEnum : Equatable {
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