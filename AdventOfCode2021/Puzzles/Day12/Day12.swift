import Foundation
import Algorithms
import Collections

let day12_example = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

class Node {
    
    let name: String
    let isSmall: Bool
    var connections: [Node] = []
    
    init(name: String) {
        self.name = name
        self.isSmall = name.lowercased() == name
    }
    
    func connect(to: Node) {
        if !connections.contains(to) {
            connections.append(to)
            to.connect(to: self)
        }
    }
    
    var isStart: Bool {
        name == "start"
    }
    
    var isEnd: Bool {
        name == "end"
    }
}

extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

class Graph {
    var nodes = Dictionary<String, Node>()
    
    init(input: String) {
        let connections = input.components(separatedBy: .newlines)
        for c in connections {
            let parts = c.components(separatedBy: "-")
            let from = parts.first!
            let to = parts.last!
            
            let fromNode = nodes[from, default: Node(name: from)]
            let toNode = nodes[to, default: Node(name: to)]
            
            nodes[from] = fromNode
            nodes[to] = toNode
            
            fromNode.connect(to: toNode)
        }
    }
    
    var start: Node {
        nodes["start"]!
    }
}

struct Path: CustomStringConvertible {
    let nodes: [Node]
    
    func canVisit(node: Node, canVisitOneSmallNodeTwice: Bool = false) -> Bool {
        if node.isStart {
            return false
        } else if node.isSmall {
            let containsNode = nodes.contains(where: { $0.name == node.name })
            
            if canVisitOneSmallNodeTwice {
                if containsNode {
                    let groups = Dictionary(grouping: nodes.filter { $0.isSmall}, by: { $0.name })
                    let noSmallNodeVisitedTwice = groups.allSatisfy { $0.value.count < 2 }
                    return noSmallNodeVisitedTwice
                } else {
                    return true
                }
            } else {
                return !containsNode
            }
        } else {
            return true
        }
    }
    
    var description: String {
        nodes.map { $0.name }.joined(separator: ",")
    }
}

class Day12 {
    
    let graph: Graph
    
    init() {
        graph = Graph(input: day12_input)
    }
    
    func part1() {
        let paths = findPath(start: graph.start, path: Path(nodes: [graph.start]))

        print("Day 12 - Part 1")
        print(paths.count)
    }
    
    func part2() {
        let paths = findPath(start: graph.start, path: Path(nodes: [graph.start]), canVisitOneSmallNodeTwice: true)

        print("Day 12 - Part 2")
        print(paths.count)
    }
    
    private func findPath(start: Node, path: Path, canVisitOneSmallNodeTwice: Bool = false) -> [Path] {
        if start.isEnd {
            return [path]
        }
        
        let possibilities = start.connections.filter { path.canVisit(node: $0, canVisitOneSmallNodeTwice: canVisitOneSmallNodeTwice) }
        
        if possibilities.isEmpty {
            // dead end
            return []
        }
        
        let foundPaths = possibilities.flatMap {
            findPath(start: $0, path: Path(nodes: path.nodes + [$0]), canVisitOneSmallNodeTwice: canVisitOneSmallNodeTwice)
        }
        
        return foundPaths
    }
}
