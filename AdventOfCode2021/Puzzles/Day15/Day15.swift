import Foundation
import Algorithms
import Collections

let day15_example = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""

class PathItem {
    let point: Point
    var path = [Point]()
    var cost = Int.max
    var visited = false
    
    public init(_ point: Point) {
        self.point = point
    }
}
  
class Day15 {
    
    let inputGrid: Grid<Int>
    var queue = PriorityQueue<PathItem>(sort: { $0.cost < $1.cost })

    init() {
        inputGrid = Grid<Int>.createSingleDigitGrid(from: day15_input)
    }
    
    func part1() {
        var pathGrid = Grid<PathItem>(numColumns: inputGrid.numColumns, numRows: inputGrid.numRows, initialValue: nil)

        for y in 0 ..< pathGrid.numRows {
            for x in 0 ..< pathGrid.numColumns {
                pathGrid[x, y] = PathItem(Point(x: x, y: y))
            }
        }
        
        let (_, cost) = findPath(grid: pathGrid, localCost: { inputGrid[$0]! })

        print("Day 15 - Part 1")
        print(cost)
    }
    
    func part2() {
        var pathGrid = Grid<PathItem>(numColumns: inputGrid.numColumns * 5, numRows: inputGrid.numRows * 5, initialValue: nil)

        for y in 0 ..< pathGrid.numRows {
            for x in 0 ..< pathGrid.numColumns {
                pathGrid[x, y] = PathItem(Point(x: x, y: y))
            }
        }
        
        let numColumns = inputGrid.numColumns
        let numRows = inputGrid.numRows
        
        let localCost: (Point) -> Int = { (pos) -> Int in
            let baseCost = self.inputGrid[pos.x % numColumns, pos.y % numRows]!
            let dx = pos.x / numColumns
            let dy = pos.y / numRows
            var adjustedCost = (baseCost + dx + dy) % 9
            if adjustedCost == 0 {
                adjustedCost = 9
            }
            return adjustedCost
        }

        let (_, cost) = findPath(grid: pathGrid, localCost: localCost)
        
        print("Day 15 - Part 2")
        print(cost)
    }
    
    private func findPath(grid: Grid<PathItem>, localCost: (Point) -> Int) -> ([Point], Int) {
        let start = Point(x: 0, y: 0)
        let destination = Point(x: grid.numColumns - 1, y: grid.numRows - 1)
        
        let startItem = grid[start]!
        startItem.path = [start]
        startItem.cost = 0
        
        queue.enqueue(startItem)
        
        return findPath(grid: grid, destination: destination, localCost: localCost)
    }
    
    private func findPath(grid: Grid<PathItem>, destination: Point, localCost: (Point) -> Int) -> ([Point], Int) {
        while let item = queue.dequeue() {
            item.visited = true
            
            //print("visited \(item.point), cost: \(item.cost)")
            
            if item.point == destination {
                //print("reached end \(item.path)")
                return (item.path, item.cost)
            }
            
            for pos in grid.neighbours(at: item.point) {
                let neighbourItem = grid.element(at: pos)!
                if neighbourItem.visited {
                    continue
                }
                
                let cost = item.cost + localCost(pos)
                
                if neighbourItem.cost > cost {
                    neighbourItem.cost = cost
                    neighbourItem.path = item.path + [pos]
                    queue.enqueue(neighbourItem)
                }
            }
        }
        
        return ([], 0)
    }
}
