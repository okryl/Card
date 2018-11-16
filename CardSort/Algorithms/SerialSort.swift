//
//  SerialSort.swift
//  Order
//
//  Created by Omer Karayel on 15.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation


class SerialSort: SortProtocol {
    
    enum CardCompare: Int {
        case same = 0
        case consecutive = 1
        case nonConsecutive = -1
    }
    
    //MARK: - Variables
    
    private(set) var cards: [Card]!
    private(set) var allCards: [Card]!
    private(set) var groups: [[Card]] = []
    private(set) var subSets = [[Int]]()
    private(set) var allSubSets = [[Int]]()
    
    //MARK: - Sort Process
    
    func sort(withCards cards: [Card]) -> ([Card], [[Card]]) {
        self.cards = cards
        self.allCards = cards
        
        return detectSerials()
    }
    
    private func detectSerials()  -> ([Card], [[Card]]) {
        
        var index = 0
        var serialCards = [Card]()
        
        while let serial = detectSerial() {
            let resultCards = playSerial(range: serial)
            serialCards.append(contentsOf: resultCards)
            
            let realIndexes = serial.map{$0+index}
            subSets.append(realIndexes)
            index = index + (serial[1] - serial[0] + 1)
            
            groups.append(resultCards)
        }
        
        allSubSets = getAllSubSets(parentSub: subSets)
        
        return (serialCards,groups)
    }
    
    private func detectSerial() -> [Int]? {
        if cards.count < 3 {
            return nil
        }
        
        var beginIndex = 0
        var endIndex = -1
        
        for i in 1..<cards.count+1 {
            
            let result = chackConsecutive(i: i)
            
            if result == CardCompare.consecutive && i - beginIndex > 1 {
                endIndex = i
            } else if result == CardCompare.nonConsecutive {
                
                if endIndex != -1 {
                    var unique = Set<Card>()
                    
                    for j in beginIndex..<(endIndex+1) {
                        unique.insert(cards[j])
                    }
                    
                    if unique.count >= 3 {
                        return [beginIndex,endIndex]
                    } else {
                        beginIndex = i
                    }
                } else {
                    beginIndex = i
                }
            } else {
                continue
            }
        }
        
        return nil
    }
    
    //MARK: - Helper Functions
    
    private func chackConsecutive(i: Int) -> CardCompare {
        if i == cards.count {
            return CardCompare.nonConsecutive
        }
        
        let beforeCard = cards[i - 1]
        let currentCard = cards[i]
        if beforeCard.type.rank == currentCard.type.rank && beforeCard.suit == currentCard.suit {
            return CardCompare.same
        } else if (beforeCard.suit == currentCard.suit) && (currentCard.type.rank - beforeCard.type.rank == 1) {
            return CardCompare.consecutive
        } else {
            return CardCompare.nonConsecutive
        }
    }
    
    private func playSerial(range: [Int]) -> [Card] {
        var range = range
        let removals = range[1] - range[0] + 1
        var serialCards = [Card]()
        var last: Card?
        
        for i in 0..<removals {
            if i != 0 {
                let card = cards[range[0]]
                
                if !(card.type.rank == last?.type.rank && card.suit == last?.suit) {
                    last = cards.remove(at: range[0])
                    serialCards.append(last!)
                } else {
                    range[0] = range[0] + 1
                }
            } else {
                last = cards.remove(at: range[0])
                serialCards.append(last!)
            }
        }
        
        return serialCards
    }
    
    private func getAllSubSets(parentSub: [[Int]]) -> [[Int]] {
        
        var subSets = [[Int]]()
        
        for sub in parentSub {
            
            var subArray = [Int]()
            
            for i in sub[0]..<sub[1]+1 {
                subArray.append(i)
            }
            
            for i in 3..<subArray.count+1 {
                
                for j in 0..<(subArray.count)+1 {
                    if i+j <= subArray.count {
                        let newNumbers = Array(subArray[j..<i+j])
                        
                        subSets.append(newNumbers)
                    }
                }
            }
        }
        return subSets
    }
}

