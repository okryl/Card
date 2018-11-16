//
//  Dealor.swift
//  Order
//
//  Created by Omer Karayel on 14.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation

class Dealor {
    
    class func generateCards() -> [Card] {
        
        var cards = [Card]()
        
        for suit in CardSuit.allCases {
            for value in CardType.allCases {
                let card = Card(suit: suit, type: value)
                cards.append(card)
            }
        }
        
        return cards
    }
    
    class func getPlayersDeck() -> [Card] {
        
        var cards = [Card]()
        let shuffledCards = generateCards().shuffled()
       
        for i in 0..<11 {
            cards.append(shuffledCards[i])
        }
        
        return cards
    }
}
