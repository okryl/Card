//
//  SuitSort.swift
//  Order
//
//  Created by Omer Karayel on 15.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation

class SuitSort: SortProtocol {
    
    //MARK: - Variables
    
    private(set) var cards: [Card]!
    private(set) var allCards: [Card]!
    private(set) var groups: [[Card]] = []
    private(set) var subSets = [[Int]]()
    private(set) var allSubSets = [[Int]]()
    
    //MARK: - Sort Process
    
    @discardableResult
    func sort(withCards cards: [Card]) -> ([Card], [[Card]]) {
        self.cards = cards
        self.allCards = cards
        
        return detectSuits()
    }
    
    private func detectSuits() -> ([Card], [[Card]]) {
        var suitCards = [Card]()
        
        while let detectSuit = detectSuit() {
            
            var cardIndexes = [Int]()
            
            for i in detectSuit {
                let card = cards[i]
                if let index = allCards.firstIndex(of: card) {
                    cardIndexes.append(index)
                }
            }
            let resultCards = playSuit(detectSuit)
            suitCards.append(contentsOf: resultCards)
            
            subSets.append(cardIndexes)
            groups.append(resultCards)
        }
        
        for subSet in subSets {
            subSet.powerset.forEach {
                if $0.count >= 3 {
                    allSubSets.append($0.sorted())
                }
            }
        }

        return (suitCards,groups)
    }
    
    private func detectSuit() -> [Int]? {
        if cards.count < 3 {
            return nil
        }
        
        var indices = [Int]()
        var occ = Array<Int>.init(repeating: 0, count: 13)
        
        for i in 0..<cards.count {
            let card = cards[i]
            let val = card.type.rank + 1
            occ[val-1] = occ[val-1] + 1
        }
        
        let max = getMax(occ)
        
        if max < 3 {
            return nil
        } else {
            var n = 0
            
            for i in 0..<occ.count {
                if occ[i] == max {
                    n = i
                }
            }
            for i in 0..<cards.count {
                let card = cards[i]
                if card.type.rank == n {
                    indices.append(i)
                }
            }
        }
        
        var unique = Set<Card>()
        
        for i in indices {
            unique.insert(cards[i])
        }
        
        if unique.count >= 3 {
            return indices
        } else {
            return nil
        }
    }
    
    //MARK: - Helper Functions
    
    private func playSuit(_ indices: [Int]) -> [Card] {
        var suitCards = [Card]()
        
        for i in indices {
            suitCards.append(cards[i])
        }
        for i in indices.reversed() {
            cards.remove(at: i)
        }
        
        return suitCards
    }
    
    private func getMax(_ arr: [Int]) -> Int {
        var max = 0
        
        for i in 0..<arr.count {
            if max < arr[i] {
                max = arr[i]
            }
        }
        
        return max
    }
}
