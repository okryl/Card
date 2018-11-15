//
//  Array.swift
//  Order
//
//  Created by Omer Karayel on 15.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var powerset: [[Element]] {
        guard count > 0 else {
            return [[]]
        }
        
        // tail contains the whole array BUT the first element
        let tail = Array(self[1..<endIndex])
        
        // head contains only the first element
        let head = self[0]
        
        // computing the tail's powerset
        let withoutHead = tail.powerset
        
        // mergin the head with the tail's powerset
        let withHead = withoutHead.map { $0 + [head] }
        
        // returning the tail's powerset and the just computed withHead array
        return withHead + withoutHead
    }
    
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }

}
