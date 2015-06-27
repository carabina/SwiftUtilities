//
//  Random.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics
import Darwin

public protocol Random {
    var seedless: Bool { get }
    var max: UInt64 { get }
    var seed: UInt64 { get }
    init()
    init(seed:UInt64)
    func random() -> UInt64
    func random(uniform:UInt64) -> UInt64
}

// MARK: Random

public let random = DefaultRandom()

// MARK: Random

public extension Random {

    func random() -> Int {
        let value:UInt64 = random()
        return Int(value)
    }

    func random(uniform:Int) -> Int {
        assert(UInt64(uniform) <= max && uniform >= 0)
        let value:UInt64 = random(UInt64(uniform))
        return Int(value)
    }

    func random(range:Range<Int>) -> Int {
        return random(range.endIndex - range.startIndex) + range.startIndex
    }
}

// MARK: Doubles

public extension Random {

    func random() -> Double {
        typealias Type = Double
        let value:UInt64 = random()
        return Type(value) / Type(max)
    }

    func random(uniform:Double) -> Double {
        typealias Type = Double
        let value:UInt64 = random()
        return Type(value) / Type(max - 1) * uniform
    }

    func random(range:ClosedInterval<Double>) -> Double {
        let r = random() * (range.end - range.start) + range.start
        return r
    }
}

// MARK: CG Types

public extension Random {

    func random() -> CGFloat {
        typealias Type = CGFloat
        let value:UInt64 = random()
        return Type(value) / Type(max)
    }

    func random(uniform:CGFloat) -> CGFloat {
        typealias Type = CGFloat
        let value:UInt64 = random()
        return Type(value) / Type(max - 1) * uniform
    }

    func random(range:ClosedInterval<CGFloat>) -> CGFloat {
        let r = random() * (range.end - range.start) + range.start
        return r
    }

    func random(range:CGRect) -> CGPoint {
        let r = CGPoint(
            x:range.origin.x + random() * range.size.width,
            y:range.origin.y + random() * range.size.height
        )
        return r
    }
}

// MARK: Arrays

public extension Random {

    func shuffle <T>(inout a:Array <T>) {
        //To shuffle an array a of n elements (indices 0..n-1):
        //  for i from 0 to n − 1 do
        //       j ← random integer with i ≤ j < n
        //       exchange a[j] and a[i]
        let n = a.count
        for i in 0..<n {
            let j = random(i..<n)
            (a[j], a[i]) = (a[i], a[j])
        }
    }

    func shuffled <T> (source:Array <T>) -> Array <T> {
        if source.count == 0 {
            return []
        }
        return random_array(source.count, initial:source[0]) { source[$0] }
    }

    func random_array <T> (count:Int, initial:T, @noescape block:Int -> T) -> Array <T> {
        //To initialize an array a of n elements to a randomly shuffled copy of source, both 0-based:
        //  for i from 0 to n − 1 do
        //      j ← random integer with 0 ≤ j ≤ i
        //      if j ≠ i
        //          a[i] ← a[j]
        //      a[j] ← source[i]
        if count == 0 {
            return []
        }
        var a = Array <T> (count:count, repeatedValue: initial)
        for i in 0 ..< count {
            let j = i > 0 ? random(0..<i) : 0
            if j != i {
                a[i] = a[j]
            }
            a[j] = block(i)
        }
        return a
    }
}

// MARK: -

public typealias DefaultRandom = MT19937Random

public typealias MersenneTwisterRandom = MT19937Random

public class MT19937Random: Random {

    public let seedless: Bool = false
    public let max: UInt64 = UInt64.max
    public let seed:UInt64

    public var engine: UnsafeMutablePointer<Void>

    public convenience required init() {
        let seed = UInt64(arc4random()) << 32 | UInt64(arc4random())
        self.init(seed:seed)
    }

    public required init(seed:UInt64) {
        self.seed = seed
        engine = NewMT19937Engine(seed)
    }

    deinit {
        DeallocMT19937Engine(engine)
    }

    public func random() -> UInt64 {
        return MT19937EngineGenerate(engine, 0, max)
    }

    public func random(uniform:UInt64) -> UInt64 {
        return MT19937EngineGenerate(engine, 0, uniform)
    }

}
