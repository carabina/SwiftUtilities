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


// MARK: Base Protocols

public protocol BaseDecodable {
    static func decodeFromString(string: String, base: Int?) throws -> Self
}

public protocol BaseEncodable {
    func encodeToString(base base: Int, prefix: Bool, width: Int?) throws -> String
}

public extension BaseDecodable {
    init(fromString string: String, base: Int? = nil) throws {
        self = try Self.decodeFromString(string, base: base)
    }
}

// MARK: UInt types + BaseDecodable

extension UIntMax: BaseDecodable {
}

extension UInt: BaseDecodable {
}

extension UInt32: BaseDecodable {
}

extension UInt16: BaseDecodable {
}

extension UInt8: BaseDecodable {
}

extension UnsignedIntegerType {
    public static func decodeFromString(string: String, base: Int?) throws -> Self {
        var string = string

        // TODO: Base guessing/expectation is broken

        var finalRadix: NamedRadix
        if let base = base {
            guard let radix = NamedRadix(rawValue: base) else {
                throw Error.generic("No standard prefix for base \(base).")
            }
            finalRadix = radix
        }
        else {
            finalRadix = NamedRadix.fromString(string)
        }

        let prefix = finalRadix.constantPrefix
        string = try string.substringFromPrefix(prefix)

        var result: Self = 0

        let base = finalRadix.rawValue

        for c in string.utf8 {
            if let value = try decodeCodeUnit(c, base: base) {
                result *= Self.init(UIntMax(base))
                result += Self.init(UIntMax(value))
            }
        }

        return result
    }
}

// MARK: UInt types + BaseEncodable

extension UIntMax: BaseEncodable {
}

extension UInt: BaseEncodable {
}

extension UInt32: BaseEncodable {
}

extension UInt16: BaseEncodable {
}

extension UInt8: BaseEncodable {
}

extension UnsignedIntegerType {

    public func encodeToString(base base: Int, prefix: Bool = false, width: Int? = nil) throws -> String {
        let value = toUIntMax()

        var s: String = "0"
        if value != 0 {
            let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
            s = ""
            let count = UIntMax(log(Double(value), base: Double(base)))
            var value = value

            for _ in UIntMax(0).stride(through: count, by: 1) {
                let digit = value % UIntMax(base)
                let char = digits[Int(digit)]
                s = String(char) + s
                value /= UIntMax(base)
            }
        }

       if let width = width {
            let count = s.utf8.count
            let pad = "".stringByPaddingToLength(max(width - count, 0), withString: "0", startingAtIndex: 0)
            s = pad + s
        }


        if let radix = NamedRadix(rawValue: base) {
            s = radix.constantPrefix + s
        }

        return s
    }
}

// MARK: DispatchData + BaseDecodable

extension DispatchData: BaseDecodable {
    public static func decodeFromString(string: String, base: Int?) throws -> DispatchData {
        let data = try NSData.decodeFromString(string, base: base!)
        return DispatchData(data)
    }
}

// MARK: DispatchData + BaseDecodable(ish)

extension NSData: BaseDecodable {

    static public func decodeFromString(string: String, base: Int?) throws -> Self {
        precondition(base == 16)

        var octets: [UInt8] = []
        var hiNibble = true
        var octet: UInt8 = 0
        for hexNibble in string.utf8 {
            if hexNibble == 0x20 {
                continue
            }

            if let nibble = try decodeCodeUnit(hexNibble, base: base!) {
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
        let data = octets.withUnsafeBufferPointer() {
            return self.init(bytes: $0.baseAddress, length: $0.count)
        }

        return self.init(data: data)
    }
}

// MARK: UnsafeBufferPointer + BaseEncodable

extension UnsafeBufferPointer: BaseEncodable {
    public func encodeToString(base base: Int, prefix: Bool = false, width: Int? = nil) throws -> String {
        precondition(base == 16)
        precondition(prefix == false)
        precondition(width == nil)

        let buffer: UnsafeBufferPointer <UInt8> = toUnsafeBufferPointer()
        let hex = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        return buffer.map({
            let hiNibble = Int($0) >> 4
            let loNibble = Int($0) & 0b1111
            return hex[hiNibble] + hex[loNibble]
        }).joinWithSeparator("")
    }
}

// MARK: Internal helpers.

enum NamedRadix: Int {
    case Binary = 2
    case Octal = 8
    case Decimal = 10
    case Hexadecimal = 16
}

extension NamedRadix {
    var constantPrefix: String {
        switch self {
            case .Binary:
                return "0b"
            case .Octal:
                return "0o"
            case .Decimal:
                return ""
            case .Hexadecimal:
                return "0x"
        }
    }

    static func fromString(string: String) -> NamedRadix {
        if string.hasPrefix(self.Binary.constantPrefix) {
            return .Binary
        }
        else if string.hasPrefix(self.Octal.constantPrefix) {
            return .Octal
        }
        else if string.hasPrefix(self.Hexadecimal.constantPrefix) {
            return .Hexadecimal
        }
        else {
            return .Decimal
        }
    }
}

func decodeCodeUnit(codeUnit: UTF8.CodeUnit, base: Int) throws -> UInt8? {
    let value: UInt8
    switch codeUnit {
        // "0" ... "9"
        case 0x30 ... 0x39:
            value = codeUnit - 0x30
        // "A" ... "F"
        case 0x41 ... 0x46 where base >= 16:
            value = codeUnit - 0x41 + 0x0A
        // "a" ... "f"
        case 0x61 ... 0x66 where base >= 16:
            value = codeUnit - 0x61 + 0x0A
        default:
            throw Error.generic("Not a digit of base \(base)")
    }

    if value >= UInt8(base) {
        throw Error.generic("Not a digit of base \(base)")
    }

    return value
}

// MARK: Convenience methods that will probably be deprecated or at least renamed in future

public func binary <T: BaseEncodable> (value: T, prefix: Bool = false, width: Int? = nil) throws -> String {
    return try value.encodeToString(base: 2, prefix: prefix, width: width)
}

public extension BaseDecodable {
    static func fromHex(hex: String) throws -> Self {
        return try Self.decodeFromString(hex, base: 16)
    }
}

public extension BaseEncodable {
    func toHex() throws -> String {
        return try encodeToString(base: 16, prefix: false, width: nil)
    }
}
