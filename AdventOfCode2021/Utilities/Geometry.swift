//
//  Geometry.swift
//  AdventOfCode2018
//
//  Created by Matthias Buchetics on 03.12.18.
//  Copyright © 2018 Matthias Buchetics. All rights reserved.
//

import Foundation

struct Point: Equatable, Hashable {
    let x: Int
    let y: Int
}

struct Line: Equatable, Hashable {
    let from: Point
    let to: Point
}

struct Size: Equatable, Hashable {
    let width: Int
    let height: Int
}

struct Rect: Equatable, Hashable {
    let id: Int
    let origin: Point
    let size: Size
    
    init(id: Int, x: Int, y: Int, width: Int, height: Int) {
        self.id = id
        self.origin = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    var topLeft: Point {
        return origin
    }
    
    var bottomRight: Point {
        return Point(x: origin.x + size.width - 1, y: origin.y + size.height - 1)
    }
    
    var points: [Point] {
        var result = [Point]()
        for y in origin.y ... bottomRight.y {
            for x in origin.x ... bottomRight.x {
                result.append(Point(x: x, y: y))
            }
        }
        return result
    }
}

extension Point {
    
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

extension Line {
    
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
