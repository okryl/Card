//
//  CardType.swift
//  CardGame
//
//  Created by Omer Karayel on 10.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation


enum CardSuit: CaseIterable {
    case spades
    case diamonds
    case hearts
    case clubs
    
    var rank: Int {
        switch self {
        case .spades:
            return 1
        case .diamonds:
            return 2
        case .hearts:
            return 3
        case .clubs:
            return 4
        }
    }
}

enum CardType: Int, CaseIterable {
    case ace
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    
    var point: Int {
        switch self {
        case .ace:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        case .nine:
            return 9
        case .ten, .jack, .queen, .king:
            return 10
        }
    }
    
    var rank: Int {
      return rawValue
    }
}
