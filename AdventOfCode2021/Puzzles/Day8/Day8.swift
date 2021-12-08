import Foundation
import Algorithms
import Collections

let day8_example = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""

//  0:      1:      2:      3:      4:
//   aaaa    ....    aaaa    aaaa    ....
//  b    c  .    c  .    c  .    c  b    c
//  b    c  .    c  .    c  .    c  b    c
//   ....    ....    dddd    dddd    dddd
//  e    f  .    f  e    .  .    f  .    f
//  e    f  .    f  e    .  .    f  .    f
//   gggg    ....    gggg    gggg    ....
//
//  5:      6:      7:      8:      9:
//   aaaa    aaaa    aaaa    aaaa    aaaa
//  b    .  b    .  .    c  b    c  b    c
//  b    .  b    .  .    c  b    c  b    c
//   dddd    dddd    ....    dddd    dddd
//  .    f  e    f  .    f  e    f  .    f
//  .    f  e    f  .    f  e    f  .    f
//   gggg    gggg    ....    gggg    gggg

// 0: a b c . e f g (6)
// 1: . . c . . f . (2)
// 2: a . c d e . g (5)
// 3: a . c d . f g (5)
// 4: . b c d . f . (4)
// 5: a b . d . f g (5)
// 6: a b . d e f g (6)
// 7: a . c . . f . (3)
// 8: a b c d e f g (7)
// 9: a b c d . f g (6)

// count 2: 1
// count 3: 7
// count 4: 4
// count 5: 2, 3, 5
// count 6: 0, 6, 9
// count 7: 8

class Day8 {
    
    struct Line {
        let signals: [String]
        let values: [String]
    }
    
    let lines: [Line]
    
    init() {
        let strLines = day8_input.components(separatedBy: .newlines)
        
        lines = strLines.map {
            let parts = $0.components(separatedBy: " | ")
            return Line(
                signals: parts[0].components(separatedBy: .whitespaces).map { $0.sorted().map { String($0) }.joined() },
                values: parts[1].components(separatedBy: .whitespaces).map { $0.sorted().map { String($0) }.joined() })
        }
    }
    
    func part1() {
        var result = 0
        
        for line in lines {
            for value in line.values {
                switch value.count {
                case 2, 3, 4, 7:
                    result += 1
                default:
                    break
                }
            }
        }
        
        print("Day 8 - Part 1")
        print(result)
    }
    
    func part2() {
        var result = 0
        
        var mapping = [String](repeating: "", count: 10)
        
        for line in lines {
            print(" *** ")
            for signal in line.signals {
                switch signal.count {
                case 2:
                    mapping[1] = signal
                case 3:
                    mapping[7] = signal
                case 4:
                    mapping[4] = signal
                case 7:
                    mapping[8] = signal
                default:
                    break
                }
            }
            
            for signal in line.signals {
                let set = Set(signal)
                
                switch signal.count {
                case 5:
                    // 2: a . c d e . g (5) -> intersect with 7 (acf): (ac), intersect with 4 (bcdf): (cd)
                    // 3: a . c d . f g (5) -> intersect with 7 (acf): (acf)
                    // 5: a b . d . f g (5) -> intersect with 7 (acf): (af), intersect with 4 (bcdf): (bdf)
                    
                    if set.intersection(mapping[7]).count == 3 {
                        mapping[3] = signal
                    } else {
                        if set.intersection(mapping[4]).count == 2 {
                            mapping[2] = signal
                        } else {
                            mapping[5] = signal
                        }
                    }
                case 6:
                    // 0: a b c . e f g (6) -> intersect with 1 (cf): (cf), intersect with 4 (bcdf): (bcf)
                    // 6: a b . d e f g (6) -> intersect with 1 (cf): (f)
                    // 9: a b c d . f g (6) -> intersect with 1 (cf): (cf), intersect with 4 (bcdf): (bcdf)

                    if set.intersection(mapping[1]).count == 1 {
                        mapping[6] = signal
                    } else {
                        if set.intersection(mapping[4]).count == 3 {
                            mapping[0] = signal
                        } else {
                            mapping[9] = signal
                        }
                    }
                default:
                    break
                }
            }
            
            for (index, signal) in mapping.enumerated() {
                print("\(signal): \(index)")
            }
            
            var numStr = ""
            
            for value in line.values {
                let number = mapping.firstIndex(of: value)!
                numStr += "\(number)"
            }
            
            result += Int(numStr)!
        }
        
        print("Day 8 - Part 2")
        print(result)
    }
}
