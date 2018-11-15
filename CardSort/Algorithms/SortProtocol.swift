//
//  SortProtocol.swift
//  CardSort
//
//  Created by Omer Karayel on 15.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import Foundation

protocol SortProtocol {
    var groups: [[Card]] {get}
    var cards: [Card]! {get}
    var allCards: [Card]! {get}
}
