//
//  ViewController.swift
//  Order
//
//  Created by Omer Karayel on 14.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import UIKit

let CARD_COUNT = 5

final class DeckViewController: UIViewController {
    
    //MARK: - UI
    
    @IBOutlet private weak var cardsContainerView: UIView!
    @IBOutlet private weak var groupInfoLabel: UILabel!
    
    //MARK: - Variables
    
    private var targetViews = [UIView]()
    private var cardViews = [CardView]()
    private var cards: [Card]!
    private let sortingAlgorithm = SortAlgorithms()
    private let cardRadians: [CGFloat] = {
        let cardCount = CARD_COUNT % 2 == 0 ? CARD_COUNT : CARD_COUNT + 1
        var radians: [CGFloat] = [0, 0.07, 0.11, 0.17, 0.22, 0.24, 0.28, 0.31, 0.38, 0.48, 0.60, 0.64, 0.72,0.72,0.72,0.72,0.72,0.72]
        var reversedRadias = radians[0..<Int(ceil(Double(cardCount/2)))].reversed().map { CGFloat(0 - $0)}
        reversedRadias.append(contentsOf: radians[0..<Int(ceil(Double(cardCount/2)))])
        
        if CARD_COUNT % 2 == 1 && CARD_COUNT > 1 {
            reversedRadias.remove(at: CARD_COUNT / 2)
        }
        return reversedRadias
    }()
    private let  cardsYPositions: [CGFloat] = {
        let cardCount = CARD_COUNT % 2 == 0 ? CARD_COUNT : CARD_COUNT + 1
        var yPositions: [CGFloat] =  [8, 12, 17, 24, 35, 47, 60, 75, 90, 110, 110, 130,140,150,160,170,180]
        var reversedYPositions = yPositions[0..<Int(ceil(Double(cardCount/2)))].reversed().map { CGFloat($0)}
        reversedYPositions.append(contentsOf: yPositions[0..<Int(ceil(Double(cardCount/2)))])
        
        if CARD_COUNT % 2 == 1 && CARD_COUNT > 1 {
            reversedYPositions.remove(at: CARD_COUNT / 2)
        }
        return reversedYPositions
    }()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards = Dealor.getPlayersDeck()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        generateCardViews()
        generateTargetViews()
        addCardViews()
    }
    
    //MARK: - Generate Card Views
    
    private func generateCardViews() {
        
        for _ in 0..<CARD_COUNT {
            let cardView = CardView()
            cardView.dragDelegate = self
            cardViews.append(cardView)
        }
    }
    
    private func generateTargetViews() {
        
        for _ in 0..<CARD_COUNT {
            let targetView = UIView()
            targetView.backgroundColor = .clear
            targetViews.append(targetView)
            cardsContainerView.addSubview(targetView)
        }
    }
    
    //MARK: - Add Card In Container
    
    func addCardViews() {
        
        var divider = CARD_COUNT * 7 / 11
        if divider < 7 {
            divider = 7
        }
        let width = cardsContainerView.frame.width /  CGFloat(divider)
        var xPosition: CGFloat =  cardsContainerView.center.x - (CGFloat((CARD_COUNT+1) / 2) * width/2)
        let height = cardsContainerView.frame.height - 100
        var delay = 0.0
        
        for i in 0..<CARD_COUNT {
            
            let cardView = cardViews[i]
            cardView.index = i
            cardView.card = cards[i]
            
            let targetView = targetViews[i]
            targetView.transform = .identity
            
            targetView.frame = CGRect(x: xPosition, y: 0, width: width, height: height)
            cardView.frame = CGRect(x: xPosition, y: 0, width: width, height: height)
            
            xPosition = xPosition + width/2
            
            targetView.transform = CGAffineTransform(rotationAngle: CGFloat(cardRadians[i])).translatedBy(x: 0, y: CGFloat(cardsYPositions[i]))
            targetView.backgroundColor = .clear
            targetView.layer.zPosition = CGFloat(i/100)
            
            cardsContainerView.addSubview(cardView)
            cardView.transform = CGAffineTransform(translationX: 0, y: -500)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                
                UIView.animate(withDuration: 0.30, delay: 0.0, options: .curveEaseIn, animations: {
                    cardView.transform = CGAffineTransform(rotationAngle: CGFloat(self.cardRadians[i])).translatedBy(x: 0, y: CGFloat(self.cardsYPositions[i]))
                    print(self.cardsYPositions[i])
                }, completion: { _ in
                })
            })
            
            delay = delay + 0.15
        }
    }
    
    //MARK: - Card Change Position
    
    func placeCard( cardView: CardView, targetView: UIView) {
        
        UIView.animate(withDuration: 0.35, delay: 0.00, options: .curveEaseOut, animations: {
            cardView.center = targetView.center
            self.cardsContainerView.bringSubviewToFront(cardView)
            cardView.transform = targetView.transform
            
        }, completion: nil)
        
    }
    
    //MARK: - Find Near By TargetView
    
    func findNearByView(_ cardView: CardView) -> UIView? {
        let distances = targetViews.map { $0.frame.origin.distance(to: cardView.frame.origin) }
        
        // we zip both sequences into one, that way we don't have to worry about sorting two arrays
        let viewDistances = zip(targetViews, distances)
        // we don't need sorting just to get the minimum
        let closesViews = viewDistances.min { $0.1 < $1.1 }
        
        return closesViews?.0
    }
    
    //MARK: - IBActions
    
    @IBAction func serialSortButtonTapped() {
        groupInfoLabel.text = ""
        
        let sortedCardsTupple = sortingAlgorithm.serialSort(cards: cards)
        let sortedCards = sortedCardsTupple.0
        
        let differentCards = sortingAlgorithm.differentCards
        
        var value = 0
        
        differentCards.forEach {
            value = value + $0.type.point
        }
        groupInfoLabel.text = "Kalan KArtların Değeri = \(value)"

        sortedCards.map {
            
            var newCards = [Card]()
            
            $0.forEach {
                newCards.append(cards[$0])
            }
            
            cards = newCards
            
            var index = 0
            
            for i in $0 {
                cardViews[i].index = index
                index = index + 1
            }
            
            cardViews.sort { (cardView1, cardView2) -> Bool in
                return cardView1.index < cardView2.index
            }
            
            
            for i in 0..<cardViews.count {
                placeCard(cardView: cardViews[i], targetView: targetViews[cardViews[i].index])
                cardViews[i].layer.zPosition = CGFloat(i)
            }
        }
    }
    
    @IBAction func smartSortButtonTapped() {
        groupInfoLabel.text = ""
        
        
        let sortedCards = sortingAlgorithm.smartSort(cards: cards)
        
        let differentCards = sortingAlgorithm.differentCards
        
        var value = 0
        
        differentCards.forEach {
            value = value + $0.type.point
        }
        
        groupInfoLabel.text = "Kalan KArtların Değeri = \(value)"

        sortedCards.map {
            var newCards = [Card]()
            
            $0.forEach {
                newCards.append(cards[$0])
            }
            
            cards = newCards
            
            var index = 0
            
            for i in $0 {
                cardViews[i].index = index
                index = index + 1
            }
            
            cardViews.sort { (cardView1, cardView2) -> Bool in
                return cardView1.index < cardView2.index
            }
            
            for i in 0..<cardViews.count {
                placeCard(cardView: cardViews[i], targetView: targetViews[cardViews[i].index])
                cardViews[i].layer.zPosition = CGFloat(i)
            }
        }
    }
    
    @IBAction func suitSortButtonTapped() {
        groupInfoLabel.text = ""
        
        let sortedCardsTupple = sortingAlgorithm.suitSort(cards: cards)
        let sortedCards = sortedCardsTupple.0
        
        let differentCards = sortingAlgorithm.differentCards
        
        var value = 0
        
        differentCards.forEach {
            value = value + $0.type.point
        }
        groupInfoLabel.text = "Kalan KArtların Değeri = \(value)"

        sortedCards.map {
            
            var newCards = [Card]()
            
            $0.forEach {
                newCards.append(cards[$0])
            }
            
            cards = newCards
            
            var index = 0
            
            for i in $0 {
                cardViews[i].index = index
                index = index + 1
            }
            
            cardViews.sort { (cardView1, cardView2) -> Bool in
                return cardView1.index < cardView2.index
            }
            
            for i in 0..<cardViews.count {
                placeCard(cardView: cardViews[i], targetView: targetViews[cardViews[i].index])
                cardViews[i].layer.zPosition = CGFloat(i)
            }
        }
    }
    
    @IBAction func resetButtonTapped() {
        
        cardViews.forEach {
            $0.removeFromSuperview()
        }
        
        cardViews.removeAll()
        
        cards = Dealor.getPlayersDeck()
        generateCardViews()
        addCardViews()
    }
}

//MARK: - CardDragDelegateProtocol

extension DeckViewController: CardDragDelegateProtocol {
    func cardViewDidDrag(cardView: CardView, point: CGPoint) {
        
        var targetView: UIView?
        var targetViewIndex = 0
        
        for i in 0..<targetViews.count {
            if targetViews[i].frame.contains(point)  {
                targetView = targetViews[i]
                targetViewIndex = i
                if let  view = findNearByView(cardView) {
                    let index = targetViews.firstIndex(of: view)
                    targetView = view
                    targetViewIndex = index!
                }
            }
        }
        
        if targetView != nil {
            
            if cardView.index != targetViewIndex {
                if cardView.index < targetViewIndex {
                    for i in cardView.index+1...targetViewIndex {
                        cardViews[i].index = cardViews[i].index - 1
                    }
                } else {
                    for i in targetViewIndex...cardView.index-1 {
                        cardViews[i].index = cardViews[i].index + 1
                    }
                }
                
                cardView.index = targetViewIndex
            }
            
            cardViews.sort { (cardView1, cardView2) -> Bool in
                return cardView1.index < cardView2.index
            }
            
            
            var newCards = [Card]()
            
            cardViews.forEach {
                newCards.append($0.card)
            }
            
            cards = newCards
            
            for i in 0..<cardViews.count {
                placeCard(cardView: cardViews[i], targetView: targetViews[cardViews[i].index])
                cardViews[i].layer.zPosition = CGFloat(i)
            }
        } else {
            placeCard(cardView: cardView, targetView: targetViews[cardView.index])
            cardView.layer.zPosition = CGFloat(cardView.index)
        }
    }    
}


extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
