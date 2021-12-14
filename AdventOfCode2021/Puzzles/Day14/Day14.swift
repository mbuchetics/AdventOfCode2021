import Foundation
import Algorithms
import Collections

let day14_example = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

struct Rule {
    struct Pair: Hashable {
        let a: Character
        let b: Character
        
        init(_ a: Character, _ b: Character) {
            self.a = a
            self.b = b
        }
    }
    
    let pair: Pair
    let result: Character
    
    func resultPairs() -> [Pair] {
        [Pair(pair.a, result), Pair(result, pair.b)]
    }
}

class Day14 {
    
    let input: [Character]
    let rules: [Rule.Pair: Rule]
    
    init() {
        let lines = day14_input.components(separatedBy: "\n")

        var rules = [Rule.Pair: Rule]()

        for line in lines.dropFirst(2) {
            let parts = line.components(separatedBy: " -> ")
            let key = Array(parts.first!)
            let value = parts.last!.first!
            let rule = Rule(pair: Rule.Pair(key[0], key[1]), result: value)
            rules[rule.pair] = rule
        }
        
        self.input = Array(lines.first!)
        self.rules = rules
    }
    
    func part1() {
        let result = run(steps: 10)

        print("Day 14 - Part 1")
        print(result)
    }
    
    func part2() {
        let result = run(steps: 40)
        
        print("Day 14 - Part 2")
        print(result)
    }
    
    private func run(steps: Int) -> Int {
        var pairCounts = initialPairCounts(input)
        
        for _ in 0..<steps {
            pairCounts = iterate(pairs: pairCounts)
        }
        
        var counts = [Character: Int]()
        
        counts[input.first!, default: 0] += 1
        counts[input.last!, default: 0] += 1
        
        for (p, count) in pairCounts {
            counts[p.a, default: 0] += count
            counts[p.b, default: 0] += count
        }
        
        counts = counts.mapValues { $0 / 2 }
        
        print(counts)
        
        return counts.values.max()! - counts.values.min()!
    }
    
    private func initialPairCounts(_ input: [Character]) -> [Rule.Pair: Int] {
        var result = [Rule.Pair: Int]()
        
        for index in stride(from: 1, to: input.count, by: 1) {
            let pair = Rule.Pair(input[index - 1], input[index])
            result[pair, default: 0] += 1
        }
        
        return result
    }
    
    private func iterate(pairs: [Rule.Pair: Int]) -> [Rule.Pair: Int] {
        var result = [Rule.Pair: Int]()
        
        for (pair, count) in pairs {
            let rule = rules[pair]!
            
            for resultPair in rule.resultPairs() {
                result[resultPair, default: 0] += count
            }
        }
        
        return result
    }
}
