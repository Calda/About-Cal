//
//  CGPointExtension.swift
//  Gravity
//
//  Created by Cal on 11/12/14.
//  Copyright (c) 2014 Cal. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint{
    
    func distanceSquaredTo(_ other: CGPoint) -> CGFloat{
        return abs(pow(self.x - other.x, 2) + pow(self.y - other.y, 2))
    }
    
    func distanceTo(_ other: CGPoint) -> CGFloat{
        return sqrt(distanceSquaredTo(other))
    }
    
    func asVector() -> CGVector{
        return CGVector(dx: x, dy: y)
    }
    
}

extension CGVector : CustomStringConvertible {

    public var description: String {
        return "(\(dx), \(dy))"
    }
}

func + (left: CGVector, right: CGVector) -> CGVector{
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

func - (left: CGVector, right: CGVector) -> CGVector{
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

func * (left: CGVector, right: CGVector) -> CGVector{
    return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}

func / (left: CGVector, right: CGVector) -> CGVector{
    return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

func * (left: CGVector, right: CGFloat) -> CGVector{
    return CGVector(dx: left.dx * right, dy: left.dy * right)
}

func / (left: CGVector, right: CGFloat) -> CGVector{
    return CGVector(dx: left.dx / right, dy: left.dy / right)
}
