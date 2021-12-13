import Foundation
import Algorithms
import Collections

let day13_example = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""

enum Fold: CustomStringConvertible {
    case horizontal(y: Int)
    case vertical(x: Int)
    
    var description: String {
        switch self {
        case .horizontal(let y):
            return "fold along y=\(y)"
        case .vertical(let x):
            return "fold along x=\(x)"
        }
    }
}

class Day13 {
    
    let grid: Grid<Int>
    let folds: [Fold]
    
    init() {
        let input = day13_input.components(separatedBy: "\n")
        var points = [Point]()
        var folds = [Fold]()
        
        for line in input {
            if line.isEmpty {
                continue
            } else if line.contains(",") {
                points.append(Point.fromString(line))
            } else {
                let parts = line.components(separatedBy: "=")
                if parts[0].contains("x") {
                    folds.append(.vertical(x: parts[1].integer))
                } else {
                    folds.append(.horizontal(y: parts[1].integer))
                }
            }
        }
        
        let maxX = points.map(\.x).max() ?? 0
        let maxY = points.map(\.y).max() ?? 0
        var grid = Grid<Int>(numColumns: maxX + 1, numRows: maxY + 1, initialValue: nil)
        
        for p in points {
            grid[p] = 1
        }
        
        self.grid = grid
        self.folds = folds
    }
    
    func part1() {
        let folded = foldGrid(grid, with: folds.first!)
        let result = folded.elements.compacted().count
        
        print("Day 13 - Part 1")
        print(result)
    }
    
    func part2() {
        var grid = grid

        for fold in folds {
            print("")
            grid = foldGrid(grid, with: fold)
            grid.printDebug(valueToString: { $0 != nil ? "#" : " " })
            print(grid.elements.compacted().count)
        }
        
        print("Day 13 - Part 2")
        print(0)
    }
    
    private func foldGrid(_ grid: Grid<Int>, with fold: Fold) -> Grid<Int> {
        var result: Grid<Int>
        
        switch fold {
        case .vertical(let x):
            result = Grid(numColumns: x, numRows: grid.numRows, initialValue: nil)
        case .horizontal(let y):
            result = Grid(numColumns: grid.numColumns, numRows: y, initialValue: nil)
        }
        
        let points = grid.allElements().compactMap { $0.1 != nil ? $0.0 : nil }
        
        for p in points {
            switch fold {
            case .vertical(let x) where p.x > x:
                let newX = result.numColumns - (p.x - x)
                result[newX, p.y] = 1
            case .horizontal(let y) where p.y > y:
                let newY = result.numRows - (p.y - y)
                result[p.x, newY] = 1
            default:
                result[p] = 1
            }
        }
        
        return result
    }
}
