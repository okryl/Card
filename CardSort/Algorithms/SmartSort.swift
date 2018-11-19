//
//  SmartSort.swift
//  Order
//
//  Created by Omer Karayel on 15.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation

class SmartSort {
    
    private var resultIndexSet = [[Int]]()
    
    //MARK: - Sort Process
    
    func sort(cards: [Card], allSubSet: [[Int]]) -> [Card] {
        
        var cardCombinationSets = Set<[Int]>()
        
        for i in 0..<allSubSet.count {
            
            for j in i..<allSubSet.count{
                
                if i == j {
                    cardCombinationSets.insert(allSubSet[i])
                } else {
                    let count = cardCombinationSets.count - 1
                    for index in 0...count {
                        if !isIntersection(arr1: Array(cardCombinationSets)[index], arr2: allSubSet[j]) {
                            var arr1 = Array(cardCombinationSets)[index]
                            let arr2 = allSubSet[j]
                            arr1.append(contentsOf: arr2)
                            cardCombinationSets.insert(arr1)
                        }
                    }
                }
            }
        }
        
        resultIndexSet = Array(cardCombinationSets)
        
        var max = 0
        var maxIndex = 0
        
        //Selection Sort
        for i in 0..<resultIndexSet.count {
            var value = 0
            resultIndexSet[i].forEach {
                let card = cards[$0]
                value = card.type.point + value
            }
            
            if max < value {
                max = value
                maxIndex = i
            }
        }
        
        var smartSortedCards = [Card]()
        if resultIndexSet.count > 0 {
            resultIndexSet[maxIndex].forEach {
                let card = cards[$0]
                smartSortedCards.append(card)
            }
        }
        return smartSortedCards
    }
    
    //MARK: - Helper Methods
    
    private func isIntersection(arr1: [Int], arr2: [Int]) -> Bool {
        
        for i in arr1 {
            for j in arr2 {
                if i == j {
                    return true
                }
            }
        }
        
        return false
    }
}
