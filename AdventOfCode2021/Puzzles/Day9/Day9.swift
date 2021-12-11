import Foundation
import Algorithms
import Collections

let day9_example = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

class Day9 {
    
    var heightmap: Grid<Int>

    init() {
        heightmap = Grid<Int>.createSingleDigitGrid(from: day9_input)
    }
    
    func part1() {
        var result = 0
        
        for x in 0 ..< heightmap.numColumns {
            for y in 0 ..< heightmap.numRows {
                let p = Point(x: x, y: y)
                let center = heightmap[x, y] ?? Int.max
                let neighbours = [
                    heightmap.element(at: p, offset: Point(x: -1, y: 0)),
                    heightmap.element(at: p, offset: Point(x: 1, y: 0)),
                    heightmap.element(at: p, offset: Point(x: 0, y: -1)),
                    heightmap.element(at: p, offset: Point(x: 0, y: 1))
                ].compacted()
                
                if neighbours.allSatisfy({ $0 > center }) {
                    result += (1 + center)
                }
            }
        }
        
        print("Day 9 - Part 1")
        print(result)
    }
    
    func part2() {
        var basins = [Set<Point>]()
        
        for x in 0 ..< heightmap.numColumns {
            for y in 0 ..< heightmap.numRows {
                let p = Point(x: x, y: y)
                
                if basins.first(where: { $0.contains(p)}) != nil {
                    continue
                }
                
                let points = findBasin(p: p, current: Set<Point>())
                if points.count > 0 {
                    basins.append(points)
                }
            }
        }
        
        let sorted = basins.sorted(by: { $0.count > $1.count })
        let result = sorted[0].count * sorted[1].count * sorted[2].count

        print("Day 9 - Part 2")
        print(result)
    }
    
    private func findBasin(p: Point, current: Set<Point>) -> Set<Point> {
        if heightmap[p.x, p.y] == 9 || current.contains(p) {
            return current
        }
        
        var result = current
        result.insert(p)
        
        // left
        if p.x > 0 {
            result = findBasin(p: Point(x: p.x - 1, y: p.y), current: result)
        }
        // right
        if p.x < heightmap.numColumns  - 1 {
            result = findBasin(p: Point(x: p.x + 1, y: p.y), current: result)
        }
        // top
        if p.y > 0 {
            result = findBasin(p: Point(x: p.x, y: p.y - 1), current: result)
        }
        // bottom
        if p.y < heightmap.numRows - 1 {
            result = findBasin(p: Point(x: p.x, y: p.y + 1), current: result)
        }
        
        return result
    }
}
