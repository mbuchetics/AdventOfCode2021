import Foundation

public struct Grid<T> {
    public let numColumns: Int
    public let numRows: Int
    
    var elements: [T?]
    
    public init(numColumns: Int, numRows: Int, initialValue: T? = nil) {
        self.numColumns = numColumns
        self.numRows = numRows
        elements = .init(repeating: initialValue, count: numColumns*numRows)
    }
    
    public init(lines: [String], value: (String) -> T?) {
        self.numRows = lines.count
        self.numColumns = Grid.stringElements(line: lines.first ?? "").count
        elements = .init(repeating: nil, count: numRows * numColumns)
        
        for (r, line) in lines.enumerated() {
            let elements = Grid.stringElements(line: line)
            for (c, stringValue) in elements.enumerated() {
                self[c, r] = value(stringValue)
            }
        }
    }
    
    private static func stringElements(line: String) -> [String] {
        return line.components(separatedBy: .whitespacesAndNewlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
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
    
    func printDebug() {
        for r in 0..<numRows {
            var str: String = ""
            for c in 0..<numColumns {
                if let value = self[c, r] {
                    str.append("\(value) ")
                } else {
                    str.append("- ")
                }
            }
            print(str)
        }
    }
}

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
}

extension Grid: Equatable where T: Equatable {
}

extension Grid: Hashable where T: Hashable {
}
