//
//  String+Helpers.swift
//  AdventOfCode2018
//
//  Created by Matthias Buchetics on 03.12.18.
//  Copyright © 2018 Matthias Buchetics. All rights reserved.
//

import Foundation

extension String {
    
    func without(_ strings: [String]) -> String {
        var result = self
        for string in strings {
            result = result.replacingOccurrences(of: string, with: "")
        }
        return result
    }
    
    var integer: Int {
        return Int(self.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
    
    func integerArray(separator: String = " ") -> [Int] {
        return self.components(separatedBy: separator).map { Int($0)! }
    }
}
