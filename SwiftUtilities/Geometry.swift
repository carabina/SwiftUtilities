//
//  Geometry.swift
//  QuadTree
//
//  Created by Jonathan Wight on 8/6/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import QuartzCore

// MARK: Basics

func clamp <T:Comparable> (value:T, lower:T, upper:T) -> T {
    return max(min(value, upper), lower)
}

// MARK: CGPoint

public extension CGPoint {
    public init(x:CGFloat) {
        self.x = x
        self.y = 0
    }
    public init(y:CGFloat) {
        self.x = 0
        self.y = y
    }
}

public func + (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
}

public func - (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs.x - rhs.x, y:lhs.y - rhs.y)
}

public func * (lhs:CGPoint, rhs:CGFloat) -> CGPoint {
    return CGPoint(x:lhs.x * rhs, y:lhs.y * rhs)
}

public func * (lhs:CGFloat, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs * rhs.x, y:lhs * rhs.y)
}

public func / (lhs:CGPoint, rhs:CGFloat) -> CGPoint {
    return CGPoint(x:lhs.x / rhs, y:lhs.y / rhs)
}

public func / (lhs:CGFloat, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs / rhs.x, y:lhs / rhs.y)
}

public func += (inout lhs:CGPoint, rhs:CGPoint) {
    lhs = lhs + rhs
}

public func -= (inout lhs:CGPoint, rhs:CGPoint) {
    lhs = lhs - rhs
}

public func *= (inout lhs:CGPoint, rhs:CGFloat) {
    lhs = lhs * rhs
}

public func /= (inout lhs:CGPoint, rhs:CGFloat) {
    lhs = lhs / rhs
}

public extension CGPoint {
    func clamped(rect:CGRect) -> CGPoint {
    
        var point : CGPoint = CGPointZero
        point.x = min(self.x, rect.minX)
    
        return self
    }
}

// MARK: CGSize

public extension CGSize {
    init(width:CGFloat) {
        self.width = width
        self.height = 0
    }

    init(height:CGFloat) {
        self.width = 0
        self.height = height
    }
}

public func + (lhs:CGSize, rhs:CGSize) -> CGSize {
    return CGSize(width:lhs.width + rhs.width, height:lhs.height + rhs.height)
}

public func - (lhs:CGSize, rhs:CGSize) -> CGSize {
    return CGSize(width:lhs.width - rhs.width, height:lhs.height - rhs.height)
}

public func * (lhs:CGSize, rhs:CGFloat) -> CGSize {
    return CGSize(width:lhs.width * rhs, height:lhs.height * rhs)
}

public func * (lhs:CGFloat, rhs:CGSize) -> CGSize {
    return CGSize(width:lhs * rhs.width, height:lhs * rhs.height)
}

public func / (lhs:CGSize, rhs:CGFloat) -> CGSize {
    return CGSize(width:lhs.width / rhs, height:lhs.height / rhs)
}

public func / (lhs:CGFloat, rhs:CGSize) -> CGSize {
    return CGSize(width:lhs / rhs.width, height:lhs / rhs.height)
}

public func += (inout lhs:CGSize, rhs:CGSize) {
    lhs = lhs + rhs
}

public func -= (inout lhs:CGSize, rhs:CGSize) {
    lhs = lhs - rhs
}

public func *= (inout lhs:CGSize, rhs:CGFloat) {
    lhs = lhs * rhs
}

public func /= (inout lhs:CGSize, rhs:CGFloat) {
    lhs = lhs / rhs
}

public extension CGSize {
    var aspectRatio : CGFloat { get { return width / height } }
    var isSquare : Bool { get { return width == height } }
    var isPortrait : Bool { get { return height > width } }
    var isLandscape : Bool { get { return width > height } }
}

// MARK: CGRect

public extension CGRect {
    init(size:CGSize) {
        self.origin = CGPointZero
        self.size = size
    }
    
    init(width:CGFloat, height:CGFloat) {
        self.origin = CGPointZero
        self.size = CGSize(width:width, height:height)
    }

    init(P1:CGPoint, P2:CGPoint) {
        self.origin = CGPoint(x:min(P1.x, P2.x), y:min(P1.y, P2.y))
        self.size = CGSize(width:abs(P2.x - P1.x), height:abs(P2.y - P1.y))
    }
}

public func * (lhs:CGRect, rhs:CGFloat) -> CGRect {
    return CGRect(origin:lhs.origin * rhs, size:lhs.size * rhs)
}

public func * (lhs:CGFloat, rhs:CGRect) -> CGRect {
    return CGRect(origin:lhs * rhs.origin, size:lhs * rhs.size)
}

public extension CGRect {    
    var isFinite : Bool { get { return CGRectIsNull(self) == false && CGRectIsInfinite(self) == false } }
    var mid : CGPoint { get { return CGPoint(x:self.midX, y:self.midY) } }
    
    static func UnionOfRects(rects:[CGRect]) -> CGRect {
        var result = CGRectZero
        for rect in rects {
            result = CGRectUnion(result, rect)
        }
        return result
    }
}

// MARK: lerp

func lerp(lower:Double, upper:Double, factor:Double) -> Double {
    return (1.0 - factor) * lower + factor * upper
}

func lerp(lower:CGPoint, upper:CGPoint, factor:CGFloat) -> CGPoint {
    return (1.0 - factor) * lower + factor * upper
}

func lerp(lower:CGSize, upper:CGSize, factor:CGFloat) -> CGSize {
    return (1.0 - factor) * lower + factor * upper
}

func lerp(lower:CGRect, upper:CGRect, factor:CGFloat) -> CGRect {
    return CGRect(
        origin:lerp(lower.origin, upper.origin, factor),
        size:lerp(lower.size, upper.size, factor)
        )
}

// MARK: Quadrants

public enum Quadrant {
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}

public extension Quadrant {
    static func fromPoint(point:CGPoint) -> Quadrant {
        if (point.y >= 0) {
            if (point.x >= 0) {
                return(.TopRight)
            }
            else {
                return(.TopLeft)
            }
        }
        else {
            if (point.x >= 0) {
                return(.BottomRight)
            }
            else {
                return(.BottomLeft)
            }
        }
    }

    static func fromPoint(point:CGPoint, origin:CGPoint) -> Quadrant {
        return Quadrant.fromPoint(point - origin)
    }

    static func fromPoint(point:CGPoint, rect:CGRect) -> Quadrant {
        return Quadrant.fromPoint(point - rect.mid)
    }

    func quadrantRectOfRect(rect:CGRect) -> CGRect {
        let size = CGSize(width:rect.size.width * 0.5, height:rect.size.height * 0.5)
        switch self {
        case .TopLeft:
            return CGRect(origin:CGPoint(x:rect.minX, y:rect.midY), size:size)
        case .TopRight:
            return CGRect(origin:CGPoint(x:rect.midX, y:rect.midY), size:size)
        case .BottomLeft:
            return CGRect(origin:CGPoint(x:rect.minX, y:rect.minY), size:size)
        case .BottomRight:
            return CGRect(origin:CGPoint(x:rect.midX, y:rect.minY), size:size)
        }
    }
}

// MARK: Degrees/Radians

func DegreesToRadians(degrees:Double) -> Double {
    return degrees * 180 / M_PI
}

func RadiansToDegrees(radians:Double) -> Double {
    return radians * M_PI / 180
}

// MARK: Scaling and alignment.

enum Scaling {
    case None
    case Proportionally
    case ToFit
}

enum Alignment {
   case Center
   case Top
   case TopLeft
   case TopRight
   case Left
   case Bottom
   case BottomLeft
   case BottomRight
   case Right
}

func ScaleAndAlignRectToRect(inner:CGRect, outer:CGRect, scaling:Scaling, align:Alignment) -> CGRect {
    var resultRect = CGRectZero

    switch scaling {
    case .ToFit:
        resultRect = outer
    case .Proportionally:
        var theScaleFactor = CGFloat(1.0)
        if (outer.size.width / inner.size.width < outer.size.height / inner.size.height) {
            theScaleFactor = outer.size.width / inner.size.width
        }
        else {
            theScaleFactor = outer.size.height / inner.size.height
        }
        resultRect.size = inner.size * theScaleFactor
    case .None:
        switch align {
            //
        case .Center:
            resultRect.origin.x = outer.origin.x + (outer.size.width - inner.size.width) * 0.5
            resultRect.origin.y = outer.origin.y + (outer.size.height - inner.size.height) * 0.5
        case .Top:
            resultRect.origin.x = outer.origin.x + (outer.size.width - inner.size.width) * 0.5
            resultRect.origin.y = outer.origin.y + outer.size.height - inner.size.height
        case .TopLeft:
            resultRect.origin.x = outer.origin.x
            resultRect.origin.y = outer.origin.y + outer.size.height - inner.size.height
        case .TopRight:
            resultRect.origin.x = outer.origin.x + outer.size.width - inner.size.width
            resultRect.origin.y = outer.origin.y + outer.size.height - inner.size.height
        case .Left:
            resultRect.origin.x = outer.origin.x
            resultRect.origin.y = outer.origin.y + (outer.size.height - inner.size.height) * 0.5
        case .Bottom:
            resultRect.origin.x = outer.origin.x + (outer.size.width - inner.size.width) * 0.5
            resultRect.origin.y = outer.origin.y
        case .BottomLeft:
            resultRect.origin.x = outer.origin.x
            resultRect.origin.y = outer.origin.y
        case .BottomRight:
            resultRect.origin.x = outer.origin.x + outer.size.width - inner.size.width
            resultRect.origin.y = outer.origin.y
        case .Right:
            resultRect.origin.x = outer.origin.x + outer.size.width - inner.size.width
            resultRect.origin.y = outer.origin.y + (outer.size.height - inner.size.height) * 0.5
        }
    }
    
    return resultRect
}
