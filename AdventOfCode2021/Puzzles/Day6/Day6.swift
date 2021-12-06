import Foundation
import Algorithms
import Collections

let day6_example = """
3,4,3,1,2
"""

class Day6 {
    
    let initialState: [Int]
    
    init() {
        initialState = day6_input.components(separatedBy: ",").map { Int($0)! }
    }
    
    func part1() {
        let result = run(numDays: 80)
        print("Day 6 - Part 1")
        print(result)
    }
    
    func part2() {
        let result = run(numDays: 256)
        print("Day 6 - Part 2")
        print(result)
    }
    
    private func run(numDays: Int) -> Int {
        var counts = [Int](repeating: 0, count: 9)
        
        for value in initialState {
            counts[value] += 1
        }
        
        let numDays = 256
        
        for day in 0..<numDays {
            counts = iterate(counts: counts)
            print(day)
            print(counts)
        }
        
        return counts.reduce(0, +)
    }
    
    private func iterate(counts: [Int]) -> [Int] {
        var next = [Int](repeating: 0, count: 9)
        
        for (timer, count) in counts.enumerated() {
            if timer == 0 {
                next[6] += count
                next[8] += count
            } else {
                next[timer - 1] += count
            }
        }
        
        return next
    }
    
}
