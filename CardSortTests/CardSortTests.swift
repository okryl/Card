//
//  CardSortTests.swift
//  CardSortTests
//
//  Created by Omer Karayel on 15.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import XCTest
@testable import CardSort

class CardSortTests: XCTestCase {
    
    //MARK: - Mock Data
    
    let mockCards = [Card(suit: .hearts, type: .ace),
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
    
    //MARK: - Test Case
    
    func testCheckCardsAreUnique() {
        //Cards are
        let cardsCount = 11
        let cards = Dealor.getPlayersDeck()
        
        let cardSet = Set(cards)
        
        XCTAssertEqual(cardsCount, cardSet.count)
    }
    
    //MARK: -
    func testSerialSort() {
        
        let sortingAlgorithms = SortAlgorithms()
        
        let serialCardIndexes = sortingAlgorithms.serialSort(cards: mockCards).0 ?? []
        
        if serialCardIndexes.count == 11 {
            
            var firstSevenIndex = [Int]()
            
            for i in 0...6 {
                firstSevenIndex.append( serialCardIndexes[i])
            }
            
            if firstSevenIndex[0] == 5 {
                XCTAssertEqual(firstSevenIndex, [5,10,2,4,1,9,7])
            } else if firstSevenIndex[0] == 4 {
                XCTAssertEqual(firstSevenIndex, [4,1,9,7,5,10,2])
            } else {
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
    
    func testSuitSort() {
        
        let sortingAlgorithms = SortAlgorithms()
        
        let suitCardIndexes = sortingAlgorithms.suitSort(cards: mockCards).0 ?? []
        
        if suitCardIndexes.count == 11 {
            
            var firstSevenIndex = [Int]()
            
            for i in 0...6 {
                firstSevenIndex.append(suitCardIndexes[i])
            }
            
            if mockCards[firstSevenIndex[0]].type.rank+1 == 4 {
                let difference = [3,6,7,10].difference(from:  Array(firstSevenIndex[..<4]))
                XCTAssertEqual(0, difference.count)
            } else if mockCards[firstSevenIndex[0]].type.rank == 0 {
                let difference = [4,8,0].difference(from:  Array(firstSevenIndex[..<3]))
                XCTAssertEqual(0, difference.count)
            } else {
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
    
    func testSmartSort() {
        let sortingAlgorithms = SortAlgorithms()
        
        let cardIndexes = sortingAlgorithms.smartSort(cards: mockCards)
        
        
        if cardIndexes != nil {
            let result = [[6,3,7,4,1,9,5,10,2,8,0],
                          [6,3,7,5,10,2,4,1,9,8,0],
                          [4,1,9,6,3,7,5,10,2,8,0],
                          [4,1,9,5,10,2,6,3,7,8,0],
                          [5,10,2,4,1,9,6,3,7,8,0],
                          [5,10,2,6,3,7,4,1,9,8,0],
                          [6,3,7,4,1,9,5,10,2,0,8],
                          [6,3,7,5,10,2,4,1,9,0,8],
                          [4,1,9,6,3,7,5,10,2,0,8],
                          [4,1,9,5,10,2,6,3,7,0,8],
                          [5,10,2,4,1,9,6,3,7,0,8],
                          [5,10,2,6,3,7,4,1,9,0,8]]
            
            if result.contains(cardIndexes!) {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
    
    //MARK: -
    
    func testSerialAndSameSuitCards() {
        let sortingAlgorithms = SortAlgorithms()
        var cards = [Card]()
        let allCards = Dealor.generateCards()
        
        for i in 0...10 {
            cards.append(allCards[i])
        }
        
        let serialSortCardIndexes = sortingAlgorithms.serialSort(cards: cards).0 ?? []
        let suitSortCardIndexes = sortingAlgorithms.suitSort(cards: cards).0 ?? []
        let smartSortIndexes = sortingAlgorithms.smartSort(cards: cards) ?? []
        
        let expectedIndexes =  [0,1,2,3,4,5,6,7,8,9,10]
        if serialSortCardIndexes == expectedIndexes,
            suitSortCardIndexes == expectedIndexes,
            smartSortIndexes == expectedIndexes{
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
}

