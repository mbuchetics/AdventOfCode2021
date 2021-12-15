//
//  Geometry.swift
//  AdventOfCode2018
//
//  Created by Matthias Buchetics on 03.12.18.
//  Copyright © 2018 Matthias Buchetics. All rights reserved.
//

import Foundation

public struct Point: Equatable, Hashable {
    public let x: Int
    public let y: Int
}

public struct Line: Equatable, Hashable {
    public let from: Point
    public let to: Point
}

public struct Size: Equatable, Hashable {
    public let width: Int
    public let height: Int
}

public struct Rect: Equatable, Hashable {
    public let id: Int
    public let origin: Point
    public let size: Size
    
    init(id: Int, x: Int, y: Int, width: Int, height: Int) {
        self.id = id
        self.origin = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    public var topLeft: Point {
        return origin
    }
    
    public var bottomRight: Point {
        return Point(x: origin.x + size.width - 1, y: origin.y + size.height - 1)
    }
    
    public var points: [Point] {
        var result = [Point]()
        for y in origin.y ... bottomRight.y {
            for x in origin.x ... bottomRight.x {
                result.append(Point(x: x, y: y))
            }
        }
        return result
    }
}

public extension Point {
    
    static var zero: Point {
        Point(x: 0, y: 0)
    }
    
    func manhattanDistance(to other: Point) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
    
    func adjacentPositions(size: Size) -> [Point] {
        var result = [Point]()
        for y in max(0, self.y - 1) ... min(size.height - 1, self.y + 1) {
            for x in max(0, self.x - 1) ... min(size.width - 1, self.x + 1) {
                if self.x != x || self.y != y {
                    result.append(Point(x: x, y: y))
                }
            }
        }
        return result
    }
    
    static func fromString(_ str: String) -> Point {
        let parts = str.components(separatedBy: ",")
        
        return Point(
            x: parts[0].integer,
            y: parts[1].integer)
    }
}

public extension Line {
    
    var points: [Point] {
        [from, to]
    }
    
    static func fromString(_ str: String) -> Line {
        let parts = str.components(separatedBy: " -> ")
        return Line(
            from: Point.fromString(parts[0]),
            to: Point.fromString(parts[1]))
    }
}

extension Point: CustomStringConvertible {
    
    public var description: String {
        return "\(x),\(y)"
    }
}
