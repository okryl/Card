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
        //
        for i in 0..<11 {
            cards.append(shuffledCards[i])
        }
        //
        //        cards[2] = Card(suit: .hearts, type: .five)
        //        cards[5] = Card(suit: .hearts, type: .ace)
        //        cards[8] = Card(suit: .hearts, type: .two)
        //        cards[10] = Card(suit: .hearts, type: .two)
        
        cards = [Card(suit: .hearts, type: .ace),
                 Card(suit: .clubs, type: .two),
                 Card(suit: .diamonds, type: .five),
                 Card(suit: .hearts, type: .four),
                 Card(suit: .clubs, type: .ace),
                 Card(suit: .diamonds, type: .three),
                 Card(suit: .spades, type: .four),
                 Card(suit: .clubs, type: .four),
                 Card(suit: .diamonds, type: .ace),
                 Card(suit: .clubs, type: .three),
                 Card(suit: .diamonds, type: .four)]
        
        return cards
    }
}
