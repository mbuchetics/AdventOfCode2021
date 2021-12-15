import Foundation
import Algorithms
import Collections

public struct Grid<T> {
    public let numColumns: Int
    public let numRows: Int
    
    var elements: [T?]
    
    public init(numColumns: Int, numRows: Int, initialValue: T? = nil) {
        self.numColumns = numColumns
        self.numRows = numRows
        elements = .init(repeating: initialValue, count: numColumns*numRows)
    }
    
    private static func stringElements(line: String) -> [String] {
        return line.components(separatedBy: .whitespacesAndNewlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    public subscript(point: Point) -> T? {
        get {
            return self[point.x, point.y]
        }
        set {
            self[point.x, point.y] = newValue
        }
    }
    
    public subscript(column: Int, row: Int) -> T? {
        get {
            precondition(column < numColumns, "Column \(column) Index is out of range. Array<T>(columns: \(numColumns), rows:\(numRows))")
            precondition(row < numRows, "Row \(row) Index is out of range. Array<T>(columns: \(numColumns), rows:\(numRows))")
            return elements[row*numColumns + column]
        }
        set {
            precondition(column < numColumns, "Column \(column) Index is out of range. Array<T>(columns: \(numColumns), rows:\(numRows))")
            precondition(row < numRows, "Row \(row) Index is out of range. Array<T>(columns: \(numColumns), rows:\(numRows))")
            elements[row*numColumns + column] = newValue
        }
    }
}

// MARK: - Convenience Creators

extension Grid {
    // Example:
    // 76 82  2 92 53
    // 74 33  8 89  3
    // 80 27 72 26 91
    // 30 83  7 16  4
    // 20 56 48  5 13
    public static func create(from input: String, value: (String) -> T?) -> Grid<T> {
        let lines = input.components(separatedBy: .newlines)
        return create(lines: lines, value: value)
    }
    
    public static func create(lines: [String], value: (String) -> T?) -> Grid<T> {
        let numRows = lines.count
        let numColumns = Grid.stringElements(line: lines.first ?? "").count
        var grid = Grid<T>(numColumns: numColumns, numRows: numRows, initialValue: nil)
        
        for (r, line) in lines.enumerated() {
            let elements = Grid.stringElements(line: line)
            for (c, stringValue) in elements.enumerated() {
                grid[c, r] = value(stringValue)
            }
        }
        
        return grid
    }
    
    public static func createSingleDigitGrid(from input: String) -> Grid<Int> {
        let lines = input.components(separatedBy: .newlines)
        return createSingleDigitGrid(lines: lines)
    }
    
    // Example:
    // 548314
    // 274585
    // 526455
    // 614133
    public static func createSingleDigitGrid(lines: [String]) -> Grid<Int> {
        var grid = Grid<Int>(numColumns: lines.first?.count ?? 0, numRows: lines.count, initialValue: nil)
        
        for y in 0 ..< grid.numRows {
            let row = lines[y]
            
            for (x, c) in row.enumerated() {
                let h = Int(String(c))!
                grid[x, y] = h
            }
        }
        
        return grid
    }
}

// MARK: - Convenience Methods

extension Grid {
    
    var size: Size {
        return Size(width: numColumns, height: numRows)
    }
    
    func transposed() -> Grid {
        var result = Grid(numColumns: self.numRows, numRows: self.numColumns, initialValue: nil)
        for r in 0..<numRows {
            for c in 0..<numColumns {
                result[r, c] = self[c, r]
            }
        }
        return result
    }
    
    func reversedRows() -> Grid {
        var result = Grid(numColumns: self.numColumns, numRows: self.numRows, initialValue: nil)
        for r in 0..<numRows {
            for c in 0..<numColumns {
                result[c, r] = self[numColumns - c - 1, r]
            }
        }
        return result
    }
    
    func reversedColumns() -> Grid {
        var result = Grid(numColumns: self.numColumns, numRows: self.numRows, initialValue: nil)
        for r in 0..<numRows {
            for c in 0..<numColumns {
                result[c, r] = self[c, numRows - r - 1]
            }
        }
        return result
    }
    
    func rotated(angle: Int) -> Grid {
        switch angle {
        case +90, -270:
            return self.transposed().reversedRows()
        case -90, +270:
            return self.transposed().reversedColumns()
        case -180, +180:
            return self.reversedRows().reversedColumns()
        case -360, +360:
            return self
        default:
            fatalError("unsupported angle")
        }
    }
    
    func row(_ r: Int) -> [T?] {
        return Array(elements[r * numColumns ..< (r + 1) * numColumns])
    }
    
    func column(_ c: Int) -> [T?] {
        return stride(from: c, to: numRows * numColumns, by: numColumns).map { elements[$0] }
    }
    
    var rows: [[T?]] {
        Array(0 ..< numRows).map { row($0) }
    }
    
    var columns: [[T?]] {
        Array(0 ..< numColumns).map { column($0) }
    }
    
    func element(at p: Point, offset: Point = .zero) -> T? {
        let x = p.x + offset.x
        let y = p.y + offset.y
        
        if x >= 0 && x < numColumns && y >= 0 && y < numRows {
            return self[x, y]
        } else {
            return nil
        }
    }
    
    func allElements() -> [(Point, T?)] {
        var result = [(Point, T?)]()
        for y in 0..<numRows {
            for x in 0..<numColumns {
                result.append((Point(x: x, y: y), self[x, y]))
            }
        }
        return result
    }

    func neighbours(at p: Point, includingDiagonals: Bool = false) -> [Point] {
        var points = [
            point(at: p, offset: Point(x: -1, y: 0)),
            point(at: p, offset: Point(x: 1, y: 0)),
            point(at: p, offset: Point(x: 0, y: -1)),
            point(at: p, offset: Point(x: 0, y: 1)),
        ]
        
        if includingDiagonals {
            points.append(contentsOf: [
                point(at: p, offset: Point(x: -1, y: -1)),
                point(at: p, offset: Point(x: 1, y: 1)),
                point(at: p, offset: Point(x: 1, y: -1)),
                point(at: p, offset: Point(x: -1, y: 1)),
            ])
        }
        
        return Array(points.compacted())
    }
    
    private func point(at p: Point, offset: Point = .zero) -> Point? {
        let x = p.x + offset.x
        let y = p.y + offset.y
        
        if x >= 0 && x < numColumns && y >= 0 && y < numRows {
            return Point(x: x, y: y)
        } else {
            return nil
        }
    }
}

// MARK: - Equatable & Hashable

extension Grid: Equatable where T: Equatable {
}

extension Grid: Hashable where T: Hashable {
}

// MARK: - Printing

extension Grid {
    
    func printDebug(valueToString: ((T?) -> String)? = nil) {
        for r in 0..<numRows {
            var str: String = ""
            for c in 0..<numColumns {
                if let valueToString = valueToString {
                    let valueStr = valueToString(self[c, r])
                    str.append(valueStr)
                } else {
                    if let value = self[c, r] {
                        
                        str.append("\(value) ")
                    } else {
                        str.append("- ")
                    }
                }                
            }
            print(str)
        }
    }
}


