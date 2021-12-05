import Foundation
import Algorithms
import Collections

let day4_example = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

class Item: CustomStringConvertible {
    let number: Int
    var drawn: Bool = false
    
    init(_ number: Int) {
        self.number = number
    }
    
    var description: String {
        if drawn {
            return "[\(number)]"
        } else {
            return "\(number)"
        }
    }
}

class Day4 {
    
    let numbers: [Int]
    let grids: [Grid<Item>]
    
    init() {
        let input = day4_input.components(separatedBy: "\n")
        
        numbers = input.first!.components(separatedBy: ",").map { $0.integer }
        grids = Day4.createGrids(input: input.dropFirst(2))
    }
    
    func part1() {
        var winningGrid: Grid<Item>?
        var winningNumber: Int  = 0
        
        for number in numbers {
            for grid in grids {
                markDrawn(grid: grid, number: number)
                
                if hasBingo(grid: grid) {
                    winningGrid = grid
                    break
                }
            }
            
            if winningGrid != nil {
                winningNumber = number
                break
            }
        }
        
        let result = finalScore(grid: winningGrid!, winningNumber: winningNumber)
    
        print("Day 4 - Part 1")
        print(result)
    }
    
    func part2() {
        var results = [(Int, Int)]()
        
        for grid in grids {
            for (index, number) in numbers.enumerated() {
                markDrawn(grid: grid, number: number)
                
                if hasBingo(grid: grid) {
                    let result = finalScore(grid: grid, winningNumber: number)
                    results.append((index, result))
                    break
                }
            }
        }
        
        let losingResult = results.sorted(by: { a, b in a.0 > b.0 }).first!
        
        print("Day 4 - Part 2")
        print(losingResult.1)
    }
    
    private func markDrawn(grid: Grid<Item>, number: Int) {
        for x in 0..<grid.numColumns {
            for y in 0..<grid.numRows {
                if let item = grid[x, y], item.number == number {
                    item.drawn = true
                }
            }
        }
    }
    
    private func finalScore(grid: Grid<Item>, winningNumber: Int) -> Int {
        let sum = grid.elements.compactMap { $0?.drawn == true ? nil : $0?.number }.reduce(0, +)
        return sum * winningNumber
    }
    
    private func hasBingo(grid: Grid<Item>) -> Bool {
        for row in grid.rows {
            if row.allSatisfy({ $0?.drawn == true }) {
                return true
            }
        }
        
        for col in grid.columns {
            if col.allSatisfy({ $0?.drawn == true }) {
                return true
            }
        }
        
        return false
    }
    
    private static func createGrids<S: Sequence>(input: S) -> [Grid<Item>] where S.Element == String  {
        var grids = [Grid<Item>]()
        var gridLines = [String]()
        
        for line in input {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let grid = Grid(lines: gridLines, value: { Item($0.integer) })
                grids.append(grid)
                gridLines.removeAll()
            } else {
                gridLines.append(line)
            }
        }
        
        if gridLines.count > 0 {
            let grid = Grid(lines: gridLines, value: { Item($0.integer) })
            grids.append(grid)
        }
        
        return grids
    }
}
