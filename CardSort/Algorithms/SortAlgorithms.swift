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
    
    private let allCardIndexes = [0,1,2,3,4,5,6,7,8,9,10]
    
    //MARK: - Sorting Functions
    
    //MARK: - Serial Sort
    
    func serialSort(cards: [Card]) -> ([Int]?, [[Card]]) {
        
        let serialSort = SerialSort()
        let serialCardsTupple = serialSort.sort(withCards: getOrderedCard(cards: cards))
        let serialCards = serialCardsTupple.0
        
        if serialCards.count == 0 {
            return (nil, serialCardsTupple.1)
        }
        
        var serialCardIndexes = [Int]()
        
        serialCards.forEach {
            if let index = cards.firstIndex(of: $0) {
                serialCardIndexes.append(index)
            }
        }
        
        let diff = serialCardIndexes.difference(from: allCardIndexes)
        
        serialCardIndexes.append(contentsOf: diff)
        
        return (serialCardIndexes,serialCardsTupple.1)
    }
    
    //MARK: - Suit Sort
    
    func suitSort(cards: [Card]) -> ([Int]?, [[Card]]) {
        let suitSort = SuitSort()
        let suitCardsTupple = suitSort.sort(withCards: cards)
        let suitCards = suitCardsTupple.0
        
        if suitCards.count == 0 {
            return (nil,[])
        }
        
        var suitCardIndexes = [Int]()
        
        suitCards.forEach {
            if let index = cards.firstIndex(of: $0) {
                suitCardIndexes.append(index)
            }
        }
        
        let diff = suitCardIndexes.difference(from: allCardIndexes)
        
        suitCardIndexes.append(contentsOf: diff)
        
        return (suitCardIndexes, suitCardsTupple.1)
    }
    
    //MARK: - Smart Sort
    
    func smartSort(cards: [Card]) -> [Int]? {
        let smartSort = SmartSort()
        let serialSort = SerialSort()
        let suitSort = SuitSort()
        
        let serialCardsTupple = serialSort.sort(withCards: getOrderedCard(cards: cards))
        let _ = suitSort.sort(withCards: getOrderedCard(cards: cards))
        
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
            let diff = resultIndexes.difference(from: allCardIndexes)
            
            resultIndexes.append(contentsOf: diff)
        
            return resultIndexes
        } else {
            
            //Smart Sort
            
            let smartCards = smartSort.sort(cards: getOrderedCard(cards: cards), allSubSet: allSubSets)
            
            if smartCards.count == 0 {
                return nil
            }
            
            var serialCardIndexes = [Int]()
            
            smartCards.forEach {
                if let index = cards.firstIndex(of: $0) {
                    serialCardIndexes.append(index)
                }
            }
            
            let diff = serialCardIndexes.difference(from: allCardIndexes)
            
            serialCardIndexes.append(contentsOf: diff)
            
            return serialCardIndexes
        }
    }
    
    //MARK: - Private Methods
    
    private func getOrderedCard(cards: [Card]) -> [Card] {
        
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
}
