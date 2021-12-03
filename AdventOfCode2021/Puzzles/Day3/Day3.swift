import Foundation
import Algorithms
import Collections

let day3_example = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

class Day3 {
    
    func part1() {
        let input = day3_input.components(separatedBy: "\n")
        let digitCount = input.first?.count ?? 0
        
        let lines = input.map { (line) in
            line.map { Int(String($0))! }
        }
        
        var gamma = [Int]()
        var epsilon = [Int]()
        
        for col in 0 ..< digitCount {
            let column = lines.map { $0[col] }
            let counts = column.reduce(into: [:]) { counts, digit in
                counts[digit, default: 0] += 1
            }
            
            gamma.append(counts.max(by: { $0.value < $1.value })!.key)
            epsilon.append(counts.min(by: { $0.value < $1.value })!.key)
        }
        
        let gammaStr = gamma.map { String($0) }.joined()
        let epsilonStr = epsilon.map { String($0) }.joined()
        
        let gammaInt = Int(gammaStr, radix: 2)!
        let epsilonInt = Int(epsilonStr, radix: 2)!
        let result = gammaInt * epsilonInt
        
        print("Day 3 - Part 1")
        print(gammaStr)
        print(epsilonStr)
        print(result)
    }
    
    func part2() {
        let input = day3_input.components(separatedBy: "\n")
        
        var lines = input.map { (line) in
            line.map { Int(String($0))! }
        }

        let oxygenRating = compute(initialLines: lines, comparison: >)
        let co2Rating = compute(initialLines: lines, comparison: <=)
        let result = oxygenRating * co2Rating
        
        print("Day 3 - Part 2")
        print(result)
    }
    
    private func compute(initialLines: [[Int]], comparison: (Int, Int) -> Bool) -> Int {
        let digitCount = initialLines.first!.count
        var lines = initialLines
        
        for col in 0 ..< digitCount {
            let column = lines.map { $0[col] }
            let counts = column.reduce(into: [:]) { counts, digit in
                counts[digit, default: 0] += 1
            }
            
            let num0 = counts[0, default: 0]
            let num1 = counts[1, default: 0]
            let value = comparison(num0, num1) ? 0 : 1
            
            lines = lines.filter { $0[col] == value }
            
            if lines.count == 1 {
                break
            }
        }
        
        let lineStr = lines.first!.map { String($0) }.joined()
        let result = Int(lineStr, radix: 2)!
        return result
    }
}
