import Foundation
import Algorithms
import Collections

let day7_example = """
16,1,2,0,4,2,7,1,2,14
"""

class Day7 {
    
    let positions: [Int]
    
    init() {
        positions = day7_input.components(separatedBy: ",").map { Int($0)! }
    }
    
    func part1() {
        let result = computeFuel()
        print("Day 7 - Part 1")
        print(result)
    }
    
    func part2() {
        let result = computeFuel(constantFuel: false)
        print("Day 7 - Part 2")
        print(result)
    }
    
    private func computeFuel(constantFuel: Bool = true) -> Int {
        let minPos = positions.min()!
        let maxPos = positions.max()!
        
        print("min: \(minPos), max: \(maxPos)")
        
        var minFuelSum = Int.max
        
        for p in minPos...maxPos {
            let fuel = positions.map { fuelRequired(from: $0, to: p, constantFuel: constantFuel) }
            let sum = fuel.reduce(0, +)
            minFuelSum = min(sum, minFuelSum)
            print("\(p): \(minFuelSum)")
        }
        
        return minFuelSum
    }
    
    private func fuelRequired(from: Int, to: Int, constantFuel: Bool) -> Int {
        let d = Int(abs(from - to))
        
        if constantFuel || d <= 1 {
            return d
        }
        
        return d * (d + 1) / 2
    }
}
