import Foundation
import Algorithms
import Collections

let day10_example = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]_{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

class Day10 {
    
    struct LineError: Error {
        let character: Character
        
        init(_ character: Character) {
            self.character = character
        }
    }
    
    let lines: [[Character]]
    
    init() {
        lines = day10_input.components(separatedBy: .newlines).map { Array($0) }
    }
    
    func part1() {
        var result = 0
        
        for line in lines {
            let stack = buildStack(line: line)
            switch stack {
            case .failure(let error):
                result += error.character.corruptedScore
            case .success:
                break
            }
        }
        
        print("Day 10 - Part 1")
        print(result)
    }
    
    func part2() {
        var lineResults = [Int]()
        
        for line in lines {
            let stack = buildStack(line: line)
            var lineResult = 0
            
            switch stack {
            case .success(var stack):
                while let c = stack.pop() {
                    lineResult = lineResult * 5 + c.autocompleteScore
                }
                lineResults.append(lineResult)
            case .failure:
                break
            }
        }
        
        let index = Int(lineResults.count / 2)
        let result = lineResults.sorted()[index]
        
        print("Day 10 - Part 2")
        print(result)
    }
    
    private func buildStack(line: [Character]) -> Result<Stack<Character>, LineError> {
        var stack = Stack<Character>()
        
        for c in line {
            if stack.isEmpty || c.isOpening {
                stack.push(c)
            } else if stack.top?.matches(c) == true {
                _ = stack.pop()
            } else {
                return .failure(LineError(c))
            }
        }
        
        return .success(stack)
    }
}


extension Character {
    
    var isOpening: Bool {
        switch self {
        case "(": return true
        case "[": return true
        case "{": return true
        case "<": return true
        default: return false
        }
    }
    
    var isClosing: Bool {
        switch self {
        case ")": return true
        case "]": return true
        case "}": return true
        case ">": return true
        default: return false
        }
    }

    func matches(_ closing: Character) -> Bool {
        switch self {
        case "(": return closing == ")"
        case "[": return closing == "]"
        case "{": return closing == "}"
        case "<": return closing == ">"
        default: return false
        }
    }
    
    var corruptedScore: Int {
        switch self {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: return 0
        }
    }
    
    var autocompleteScore: Int {
        switch self {
        case "(": return 1
        case "[": return 2
        case "{": return 3
        case "<": return 4
        default: return 0
        }
    }
}
