import Foundation
import Algorithms
import Collections

let day2_example = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

class Day2 {
    
    func part1() {
        let input = day2_input.components(separatedBy: "\n")
        
        var h = 0
        var d = 0
        
        for line in input {
            let parts = line.components(separatedBy: " ")
            let command = parts[0]
            let value = Int(parts[1])!
            
            switch command {
            case "forward":
                h += value
            case "down":
                d += value
            case "up":
                d -= value
            default:
                break
            }
        }
        
        let result = h * d
        
        print("Day 2 - Part 1")
        print(result)
    }
    
    func part2() {
        let input = day2_input.components(separatedBy: "\n")
        
        var h = 0
        var d = 0
        var aim = 0
        
        for line in input {
            let parts = line.components(separatedBy: " ")
            let command = parts[0]
            let value = Int(parts[1])!
            
            switch command {
            case "forward":
                h += value
                d += (aim * value)
            case "down":
                aim += value
            case "up":
                aim -= value
            default:
                break
            }
        }
        
        let result = h * d
        
        print("Day 2 - Part 2")
        print(result)
    }
}
