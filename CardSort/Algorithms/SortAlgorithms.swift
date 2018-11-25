//
//  SortingAlgorithms.swift
//  CardGame
//
//  Created by Omer Karayel on 14.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation

class SortAlgorithms {
    
    //MARK: - Variables
    
    var differentCards = [Card]()
    private let allCardIndexes = Array(0..<CARD_COUNT)
    
    //MARK: - Sorting Functions
    
    //MARK: - Serial Sort
    
    func serialSort(cards: [Card]) -> ([Int]?, [[Card]]) {
        differentCards.removeAll()
        let serialSort = SerialSort()
        let serialCardsTupple = serialSort.sort(withCards: getOrderedCardWithSuit(cards: cards))
        let serialCards = serialCardsTupple.0
        
        if serialCards.count == 0 {
            differentCards = cards
            let orderedCardIndexes = detectDifferentCardAndSortWithRank(cardIndexes: [], cards: cards)
            return (orderedCardIndexes, serialCardsTupple.1)
        }
        
        var serialCardIndexes = [Int]()
        
        serialCards.forEach {
            if let index = cards.firstIndex(of: $0) {
                serialCardIndexes.append(index)
            }
        }
        
        let differentCardIndexes = serialCardIndexes.difference(from: allCardIndexes)
        
        differentCardIndexes.forEach {
            differentCards.append(cards[$0])
        }
        
        serialCardIndexes.append(contentsOf: detectDifferentCardAndSortWithRank(cardIndexes: serialCardIndexes, cards: cards))

        return (serialCardIndexes,serialCardsTupple.1)
    }
    
    //MARK: - Suit Sort
    
    func suitSort(cards: [Card]) -> ([Int]?, [[Card]]) {
        differentCards.removeAll()
        let suitSort = SuitSort()
        let suitCardsTupple = suitSort.sort(withCards: cards)
        let suitCards = suitCardsTupple.0
        
        if suitCards.count == 0 {
            differentCards = cards
            let orderedCardIndexes = detectDifferentCardAndSortWithRank(cardIndexes: [], cards: cards)
            return (orderedCardIndexes,suitCardsTupple.1)
        }
        
        var suitCardIndexes = [Int]()
        
        suitCards.forEach {
            if let index = cards.firstIndex(of: $0) {
                suitCardIndexes.append(index)
            }
        }
        
        let differentCardIndexes = suitCardIndexes.difference(from: allCardIndexes)
        
        differentCardIndexes.forEach {
            differentCards.append(cards[$0])
        }
        
        suitCardIndexes.append(contentsOf: detectDifferentCardAndSortWithRank(cardIndexes: suitCardIndexes, cards: cards))

        return (suitCardIndexes, suitCardsTupple.1)
    }
    
    //MARK: - Smart Sort
    
    func smartSort(cards: [Card]) -> [Int]? {
        differentCards.removeAll()
        let smartSort = SmartSort()
        let serialSort = SerialSort()
        let suitSort = SuitSort()
        
        let serialCardsTupple = serialSort.sort(withCards: getOrderedCardWithSuit(cards: cards))
        suitSort.sort(withCards: getOrderedCardWithSuit(cards: cards))
        
        let serialSortSubSet = serialSort.subSets
        let serialSortAllSubSet = serialSort.allSubSets
        let suitSortSubSet = suitSort.subSets
        let suitSortAllSubSet = suitSort.allSubSets
        
        var allSubSets = serialSortAllSubSet
        allSubSets.append(contentsOf: suitSortAllSubSet)
        
        if suitSortSubSet.count == 0 && serialSortSubSet.count == 1 {
            
            //For decreasing the complexity if cards are shuffled like that ace,1,2,3,4,5,6,7,8,9,10
         
            var resultIndexes = [Int]()
            
            serialCardsTupple.0.forEach {
                if let index = cards.firstIndex(of: $0) {
                    resultIndexes.append(index)
                }
            }
           
            resultIndexes.append(contentsOf: detectDifferentCardAndSortWithRank(cardIndexes: resultIndexes, cards: cards))
        
            return resultIndexes
        } else {
            
            //Smart Sort
            
            let smartCards = smartSort.sort(cards: getOrderedCardWithSuit(cards: cards), allSubSet: allSubSets)
            
            if smartCards.count == 0 {
                differentCards = cards
                let orderedCardIndexes = detectDifferentCardAndSortWithRank(cardIndexes: [], cards: cards)
                return orderedCardIndexes
            }
            
            var smartCardIndexes = [Int]()
            
            smartCards.forEach {
                if let index = cards.firstIndex(of: $0) {
                    smartCardIndexes.append(index)
                }
            }
            
            let differentCardIndexes = smartCardIndexes.difference(from: allCardIndexes)
            
            differentCardIndexes.forEach {
                differentCards.append(cards[$0])
            }
            
            smartCardIndexes.append(contentsOf: detectDifferentCardAndSortWithRank(cardIndexes: smartCardIndexes, cards: cards))

            return smartCardIndexes
        }
    }
    
    //MARK: - Private Methods
    
    private func detectDifferentCardAndSortWithRank(cardIndexes: [Int], cards: [Card]) -> [Int] {
      
        var unorderedCardIndexes = cardIndexes.difference(from: allCardIndexes)
        
        var unorderedCards = [Card]()
        
        unorderedCardIndexes.forEach {
            unorderedCards.append(cards[$0])
        }
        
        unorderedCards = getOrderedCardWithRank(cards: unorderedCards)
        
        unorderedCardIndexes = unorderedCards.map { cards.firstIndex(of: $0)! }
        
        return unorderedCardIndexes
    }
    
    private func getOrderedCardWithSuit(cards: [Card]) -> [Card] {
        
        let orderedCards = cards.sorted { (card1, card2) -> Bool in
            
            if card1.suit.rank < card2.suit.rank {
                return true
            } else if card1.suit.rank > card2.suit.rank {
                return false
            } else {
                return card1.type.rank < card2.type.rank
            }
        }
        return orderedCards
    }
    
    private func getOrderedCardWithRank(cards: [Card]) -> [Card] {
        
        let orderedCards = cards.sorted { (card1, card2) -> Bool in
            
           return card1.type.rank <= card2.type.rank
        }
        return orderedCards
    }
}
