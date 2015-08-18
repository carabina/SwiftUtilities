//
//  Utilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
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


import CoreGraphics

// MARK: Math

infix operator ** { associativity none precedence 160 }

public func ** (lhs: Float, rhs: Float) -> Float {
    if rhs == 2 {
        return lhs * lhs
    }    
    return pow(lhs, rhs)
}

public func ** (lhs: Double, rhs: Double) -> Double {
    if rhs == 2 {
        return lhs * lhs
    }    
    return pow(lhs, rhs)
}

public func ** (lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    if rhs == 2 {
        return lhs * lhs
    }    
    return pow(lhs, rhs)
}

public func log(x: Double, base: Double) -> Double {
    return log(x) / log(base)
}

// MARK: Basics

public func clamp <T: Comparable> (value: T, lower: T, upper: T) -> T {
    return max(min(value, upper), lower)
}

public func round(value: CGFloat, decimal: Int) -> CGFloat {
    let e10n = pow(10.0, CGFloat(clamp(decimal, lower: -6, upper: 7)))
    let fl = floor(e10n * value + 0.5)
    return fl / e10n
}

// MARK: Degrees/Radians

// In the spirit of UInt(bigEndian: ) etc

extension Float {
    init(radians: Float) {
        self = radians
    }

    init(degrees: Float) {
        self = degrees * Float(M_PI) / 180
    }

    var radians: Float {
        return self
    }

    var degrees: Float {
        return self * 180 / Float(M_PI)
    }
}

extension Double {
    init(radians: Double) {
        self = radians
    }

    init(degrees: Double) {
        self = degrees * M_PI / 180
    }

    var radians: Double {
        return self
    }

    var degrees: Double {
        return self * 180 / M_PI
    }
}

extension CGFloat {
    init(radians: CGFloat) {
        self = radians
    }

    init(degrees: CGFloat) {
        self = degrees * CGFloat(M_PI) / 180
    }

    var radians: CGFloat {
        return self
    }

    var degrees: CGFloat {
        return self * 180 / CGFloat(M_PI)
    }
}

// Basic functions

public func DegreesToRadians(v: Float) -> Float {
    return v * Float(M_PI) / 180
}

public func RadiansToDegrees(v: Float) -> Float {
    return v * 180 / Float(M_PI)
}

public func DegreesToRadians(v: Double) -> Double {
    return v * M_PI / 180
}

public func RadiansToDegrees(v: Double) -> Double {
    return v * 180 / M_PI
}

public func DegreesToRadians(v: CGFloat) -> CGFloat {
    return v * CGFloat(M_PI) / 180
}

public func RadiansToDegrees(v: CGFloat) -> CGFloat {
    return v * 180 / CGFloat(M_PI)
}


