import Foundation
import Algorithms
import Collections

let day11_example = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

class Day11 {
    
    let grid: Grid<Int>
    var numFlashes = 0
    
    init() {
        grid = Grid<Int>.createSingleDigitGrid(from: day11_input)
    }
    
    func part1() {
        var nextGrid = grid
        
        for _ in 1...100 {
            nextGrid = step(grid: nextGrid)
        }
        
        print("Day 11 - Part 1")
        print(numFlashes)
    }
    
    func part2() {
        var nextGrid = grid
        var index = 0
        
        while true {
            index += 1
            nextGrid = step(grid: nextGrid)
            
            if nextGrid.elements.allSatisfy({ $0 == 0 }) {
                break
            }
        }
        
        print("Day 11 - Part 2")
        print(index)
    }
    
    private func step(grid: Grid<Int>) -> Grid<Int> {
        var result = grid
        
        for (p, v) in result.allElements() {
            result[p] = min((v ?? 0) + 1, 10)
        }
        
        for (p, v) in result.allElements() {
            if v == 10 {
                result = flash(point: p, grid: result)
            }
        }
        
        for (index, value) in result.elements.enumerated() {
            if value == 10 {
                result.elements[index] = 0
            }
        }
        
        return result
    }
    
    private func flash(point: Point, grid: Grid<Int>) -> Grid<Int> {
        var result = grid
        
        numFlashes += 1
        
        for p in result.neighbours(at: point, includingDiagonals: true) {
            if let v = result[p], v < 10 {
                result[p] = min(v + 1, 10)
                
                if v == 9 {
                    result = flash(point: p, grid: result)
                }
            }
        }
        
        return result
    }
}
