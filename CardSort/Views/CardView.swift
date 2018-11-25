
//
//  CardView.swift
//  Order
//
//  Created by Omer Karayel on 14.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import UIKit

protocol CardDragDelegateProtocol: class {
    func cardViewDidDrag(cardView: CardView, point: CGPoint)
}

final class CardView: UIView {

    //MARK: - UI
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var smallSuitLabel: UILabel!
    @IBOutlet private weak var bigSuitLabel: UILabel!
    
    //MARK: - Variables
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    var card: Card! {
        didSet {
            setupUI()
        }
    }

    var index: Int!
    weak var dragDelegate: CardDragDelegateProtocol?
    
    //MARK: - Init
    
    convenience init(card: Card) {
        self.init(frame: .zero)
        
        self.card = card
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
     
        Bundle(for: type(of: self)).loadNibNamed("CardView", owner: self, options: nil)
    
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        layer.cornerRadius = 10.0
        
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: -15, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }

    //MARK: - Setup UI
    
    private func setupUI() {
        if card.type.rank == 0 {
            rankLabel.text = "A"
        } else if card.type.rank == 10 {
            rankLabel.text = "J"
        } else if card.type.rank == 11 {
            rankLabel.text = "Q"
        } else if card.type.rank == 12 {
            rankLabel.text = "K"
        } else {
            rankLabel.text = "\(card.type.rank+1)"
        }
        
        switch card.suit {
        case .clubs:
            smallSuitLabel.text = "♠️"
            bigSuitLabel.text = "♠️"
        case .diamonds:
            smallSuitLabel.text = "♦️"
            bigSuitLabel.text = "♦️"
        case .hearts:
            smallSuitLabel.text = "♥️"
            bigSuitLabel.text = "♥️"
        case .spades:
            smallSuitLabel.text = "♣️"
            bigSuitLabel.text = "♣️"
        }
    }
    
    //MARK: - Touch Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: superview)
            xOffset = point.x - center.x
            yOffset = point.y - center.y
            transform = CGAffineTransform(rotationAngle: 0).translatedBy(x: 0, y: transform.ty)
            layer.zPosition = CGFloat(CARD_COUNT)
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: superview)
            center = CGPoint(x: point.x - xOffset, y: point.y - yOffset)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
        dragDelegate?.cardViewDidDrag(cardView: self, point: center)
    }
}
