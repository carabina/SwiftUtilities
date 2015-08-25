//
//  Base.swift
//  BinaryTest
//
//  Created by Jonathan Wight on 6/24/15.
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


// MARK: -

public extension NSData {

    static func fromHex(string: String) throws -> NSData {
        var octets: [UInt8] = []

        var hiNibble = true
        var octet: UInt8 = 0
        for hexNibble in string.utf8 {
            if hexNibble == 0x20 {
                continue
            }

            if let nibble = try hexNibbleToInt(hexNibble) {
                if hiNibble {
                    octet = nibble << 4
                    hiNibble = false
                }
                else {
                    hiNibble = true
                    octets.append(octet | nibble)
                    octet = 0
                }
            }
        }
        if hiNibble == false {
            octets.append(octet)
        }
        return octets.withUnsafeBufferPointer() {
            return NSData(bytes: $0.baseAddress, length: $0.count)
        }
    }

    convenience init(hexString string: String) throws {
        let data = try NSData.fromHex(string)
        self.init(data: data)
    }
}

// MARK: -

public extension UIntMax {

    static func fromString(var string: String, base: Int, expectPrefix: Bool = false) throws -> UIntMax {

        if expectPrefix == true {
            let prefix: String
            switch base {
                case 2:
                    prefix = "0b"
                case 8:
                    prefix = "0o"
                case 16:
                    prefix = "0x"
                default:
                    throw Error.generic("No standard prefix for base \(base).")
            }
            string = try string.substringFromPrefix(prefix)
        }

        var result: UIntMax = 0

        let conversion: (UInt8) throws -> UInt8?
        if base == 16 {
            conversion = hexNibbleToInt
        }
        else {
            conversion = {
                (c: UInt8) throws -> UInt8? in
                if  (0x30 ... 0x39).contains(c) {
                    return c - 0x30
                }
                else {
                    throw Error.generic("Character not a digit.")
                }
            }
        }

        for c in string.utf8 {
            if let value = try conversion(c) {
                result *= UIntMax(base)
                result += UIntMax(value)
            }
        }

        return result
    }

}

public extension UnsignedIntegerType {
    init(fromString string: String, base: Int, expectPrefix: Bool = true) throws {
        self.init(try UIntMax.fromString(string, base: base, expectPrefix: expectPrefix))
    }

    init(fromString string: String) throws {
        let base: Int
        let expectPrefix: Bool
        if string.hasPrefix("0b") {
            base = 2
            expectPrefix = true
        }
        else if string.hasPrefix("0o") {
            base = 8
            expectPrefix = true
        }
        else if string.hasPrefix("0x") {
            base = 16
            expectPrefix = true
        }
        else {
            base = 10
            expectPrefix = false
        }

        try self.init(fromString: string, base: base, expectPrefix: expectPrefix)
    }
}

public extension String {

    init(value: UIntMax, base: Int, prefix: Bool = false, uppercase: Bool = false, width: Int? = nil) {

        var s: String = "0"
        if value != 0 {
            let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
            s = ""
            let count = UIntMax(log(Double(value), base: Double(base)))
            var value = value

            for _ in UIntMax(0).stride(through: count, by: 1) {
                let digit = value % UIntMax(base)

                let char = digits[Int(digit)]
                s = (uppercase ? char.uppercaseString: char) + s
                value /= UIntMax(base)
            }
        }

       if let width = width {
            let count = s.utf8.count
            let pad = "".stringByPaddingToLength(max(width - count, 0), withString: "0", startingAtIndex: 0)
            s = pad + s
        }

        switch (prefix, base) {
            case (true, 2):
                s = "0b" + s
            case (true, 8):
                s = "0o" + s
            case (true, 16):
                s = "0x" + s
            default:
                break
        }

        self = s
    }

    init <T: UnsignedIntegerType> (value: T, base: Int, prefix: Bool = false, uppercase: Bool = false, width: Int? = nil) {
        let value = value.toUIntMax()
        self.init(value: value, base: base, prefix: prefix, uppercase: uppercase, width: width)
    }

    func toInt() -> Int {
        return (self as NSString).integerValue
    }

}

// TODO; Deprecate
public func binary <T: UnsignedIntegerType> (value: T, width: Int? = nil) -> String {
    return String(value: value, base: 2, prefix: true, width: width)
}

public extension UInt8 {
    var asHex: String {
        return intToHex(Int(self))
    }
}

public extension UInt16 {
    var asHex: String {
        return intToHex(Int(self))
    }
}

public func intToHex(value: Int, skipLeadingZeros: Bool = true, addPrefix: Bool = false, lowercase: Bool = false) -> String {
    var s = ""
    var skipZeros = skipLeadingZeros
    let digits = log2(Int.max) / 8
    for var n: Int = digits; n >= 0; --n {
        let shift = n * 4
        let nibble = (value >> shift) & 0xF
        if !(skipZeros == true && nibble == 0) {
            s += nibbleAsHex(nibble, lowercase: lowercase)
            skipZeros = false
        }
    }
    return addPrefix ? "0x" + s: s
}

// MARK: -

public extension UnsafeBufferPointer {
    var asHex: String {
        let buffer: UnsafeBufferPointer <UInt8> = toUnsafeBufferPointer()
        let hex = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        return buffer.map({
            let hiNibble = Int($0) >> 4
            let loNibble = Int($0) & 0b1111
            return hex[hiNibble] + hex[loNibble]
        }).joinWithSeparator("")
    }
}

// MARK: -

func log2(v: Int) -> Int {
    return Int(log2(Float(v)))
}

func nibbleAsHex(nibble: Int, lowercase: Bool = false) -> String {
    let uppercaseDigits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
    let lowercaseDigits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
    return lowercase ? lowercaseDigits[nibble]: uppercaseDigits[nibble]
}

func hexNibbleToInt(nibble: UInt8) throws -> UInt8? {
    switch nibble {
        case 0x30 ... 0x39:
            return UInt8(nibble) - 0x30
        case 0x41 ... 0x46:
            return UInt8(nibble) - 0x41 + 0x0A
        case 0x61 ... 0x66:
            return UInt8(nibble) - 0x61 + 0x0A
        default:
            return nil
    }
}
