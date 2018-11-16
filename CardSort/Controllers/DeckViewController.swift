//
//  ViewController.swift
//  Order
//
//  Created by Omer Karayel on 14.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import UIKit

final class DeckViewController: UIViewController {
    
    //MARK: - UI
    
    @IBOutlet private weak var cardsContainerView: UIView!
    @IBOutlet private weak var groupInfoLabel: UILabel!
    
    //MARK: - Variables
    
    private var targetViews = [UIView]()
    private var cardViews = [CardView]()
    private var cards: [Card]!

    private let sortingAlgorithm = SortAlgorithms()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards = Dealor.getPlayersDeck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCardViews()
    }
    
    //MARK: - Add Card In Container
    
    func addCardViews() {
        var radians = [-0.2, -0.17, -0.13, -0.10, -0.02, 0, 0.02, 0.1, 0.13, 0.17, 0.2]
        var yPosition = [40, 30, 24, 19, 16, 14, 16, 19, 24, 30, 40]
        
        var xPosition: CGFloat = 20
        let width = cardsContainerView.frame.width / 7
        let height = cardsContainerView.frame.height - 100
        var delay = 0.0
        
        for i in 0...10 {
            
            let cardView = CardView(card: cards[i])
            cardView.dragDelegate = self
            cardView.backgroundColor = .yellow
            cardView.index = i
            cardViews.append(cardView)
            
            
            let backView = UIView()
            backView.backgroundColor = .clear
            targetViews.append(backView)
            
            backView.frame = CGRect(x: xPosition, y: 0, width: width, height: height)
            cardView.frame = CGRect(x: xPosition, y: 0, width: width, height: height)
            
            xPosition = xPosition + width/2
            
            backView.transform = CGAffineTransform(rotationAngle: CGFloat(radians[i])).translatedBy(x: 0, y: CGFloat(yPosition[i]))
            backView.backgroundColor = .clear
            backView.layer.zPosition = CGFloat(i/100)
            
            
            cardsContainerView.addSubview(backView)
            cardsContainerView.addSubview(cardView)
            cardView.transform = CGAffineTransform(translationX: 0, y: -500)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                
                UIView.animate(withDuration: 0.30, delay: 0.0, options: .curveEaseIn, animations: {
                    cardView.transform = CGAffineTransform(rotationAngle: CGFloat(radians[i])).translatedBy(x: 0, y: CGFloat(yPosition[i]))
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
    
    //MARK: - Handle Card Group
    
    private func handleGroup(groups: [[Card]]) {
        
        var groupInfoText: String = ""
        
        for i in 0..<groups.count {
            groupInfoText = groupInfoText + "\(i+1). grup = "
            
            for j in stride(from:groups[i].count - 1,to:-1,by:-1) {
                let card = groups[i].reversed()[j]
                groupInfoText = groupInfoText + "\(card.suit) \(card.type), "
            }
        }
        
        groupInfoLabel.text = groupInfoText
    }
    
    //MARK: - IBActions
    
    @IBAction func serialSortButtonTapped() {
        groupInfoLabel.text = ""

        let sortedCardsTupple = sortingAlgorithm.serialSort(cards: cards)
        let sortedCards = sortedCardsTupple.0
        let cardGroups = sortedCardsTupple.1

        sortedCards.map {
            
            handleGroup(groups: cardGroups)
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
        let cardGroups = sortedCardsTupple.1
        
        sortedCards.map {
    
            handleGroup(groups: cardGroups)
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
        
        targetViews.forEach {
            $0.removeFromSuperview()
        }
        
        targetViews.removeAll()
        cardViews.forEach {
            $0.removeFromSuperview()
        }
        
        cardViews.removeAll()
        
        
        cards = Dealor.getPlayersDeck()
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

