import Foundation
import Algorithms
import Collections

let day1_example = """
199
200
208
210
200
207
240
269
260
263
"""

class Day1 {
    
    func part1() {
        let input = day1_input.components(separatedBy: "\n")
        
        var increases = 0
        let values = input.map { Int($0)! }
        
        for index in stride(from: 1, to: values.count, by: 1) {
            let a = values[index]
            let b = values[index - 1]
            
            if a > b {
                increases += 1
                print("\(a) (increased)")
            } else if a < b {
                print("\(a) (decreased)")
            } else {
                print("\(a) (no change)")
            }
        }
        
        print(increases)
    }
    
    func part2() {
        let input = day1_input.components(separatedBy: "\n")
        
        var increases = 0
        let values = input.map { Int($0)! }
        
        for index in stride(from: 1, to: values.count - 2, by: 1) {
            let sum1 = values[index ... index + 2].reduce(0, +)
            let sum2 = values[index - 1 ... index + 1].reduce(0, +)
            
            if sum1 > sum2 {
                increases += 1
                print("\(sum1) (increased)")
            } else if sum1 < sum2 {
                print("\(sum1) (decreased)")
            } else {
                print("\(sum1) (no change)")
            }
        }
        
        print(increases)
    }
}
