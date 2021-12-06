import Foundation
import Algorithms
import Collections

let day5_example = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

class Day5 {
    
    let lines: [Line]
    var grid: Grid<Int>
    
    init() {
        let input = day5_input.components(separatedBy: "\n")
        lines = input.map { Line.fromString($0) }
        grid = Grid(numColumns: 0, numRows: 0, initialValue: 0)
    }
    
    private func setupGrid() {
        let maxX = lines.flatMap { $0.points.map { $0.x } }.max() ?? 0
        let maxY = lines.flatMap { $0.points.map { $0.y } }.max() ?? 0
        grid = Grid(numColumns: maxX + 1, numRows: maxY + 1, initialValue: 0)
    }
    
    func part1() {
        setupGrid()
        
        for line in lines {
            markLine(line, diagonal: false)
        }
        
        let result = grid.elements.filter { ($0 ?? 0) > 1 }.count
        
        print("Day 5 - Part 1")
        print(result)
    }
    
    func part2() {
        setupGrid()
        
        for line in lines {
            markLine(line, diagonal: true)
        }
        
        let result = grid.elements.filter { ($0 ?? 0) > 1 }.count
        
        print("Day 5 - Part 2")
        print(result)
    }
    
    private func markLine(_ line: Line, diagonal: Bool = false) {
        if line.from.x == line.to.x {
            let x = line.from.x
            let minY = min(line.from.y, line.to.y)
            let maxY = max(line.from.y, line.to.y)
            
            for y in minY ... maxY {
                markPoint(x, y)
            }
        } else if line.from.y == line.to.y {
            let y = line.from.y
            let minX = min(line.from.x, line.to.x)
            let maxX = max(line.from.x, line.to.x)
            
            for x in minX ... maxX {
                markPoint(x, y)
            }
        } else if diagonal && abs(line.from.x - line.to.x) == abs(line.from.y - line.to.y) {
            let dx = line.to.x > line.from.x ? 1 : -1
            let dy = line.to.y > line.from.y ? 1 : -1
            let length = abs(line.from.x - line.to.x)
            
            var x = line.from.x
            var y = line.from.y
            
            for _ in 0 ... length {
                markPoint(x, y)
                x += dx
                y += dy
            }
        }
    }
    
    private func markPoint(_ x: Int, _ y: Int) {
        let value = grid[x, y] ?? 0
        grid[x, y] = value + 1
    }
}
