//
//  DurationVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationVC: UIViewController, Sliding {

    
    // MARK: - Properties
    
    private var cardOne: DurationCard!
    private var cardTwo: DurationCard!
    private var cardThree: DurationCard!
    private var cardFour: DurationCard!
    private var cards: [DurationCard] = []
    
    private let padding: CGFloat = 8
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        slideViewController(to: .In, offScreenPosition: .Bottom, completion: nil)
        cards.forEach { $0.setNeedsDisplay() }
    }
    
    private func setupViews() {
        
        cardOne = DurationCard(duration: .Twenty)
        cardTwo = DurationCard(duration: .TwentyFive)
        cardThree = DurationCard(duration: .Thirty)
        cardFour = DurationCard(duration: .ThirtyFive)
        cards.append(cardOne)
        cards.append(cardTwo)
        cards.append(cardThree)
        cards.append(cardFour)
        view.addSubview(cardOne)
        view.addSubview(cardTwo)
        view.addSubview(cardThree)
        view.addSubview(cardFour)

        NSLayoutConstraint.activate([
            
            cardOne.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding / 2),
            cardOne.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 140 / 375),
            cardOne.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardOne.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -25 - padding / 2),
            
            cardTwo.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding / 2),
            cardTwo.widthAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardTwo.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardTwo.bottomAnchor.constraint(equalTo: cardOne.bottomAnchor),
            
            cardThree.trailingAnchor.constraint(equalTo: cardOne.trailingAnchor),
            cardThree.widthAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardThree.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardThree.topAnchor.constraint(equalTo: cardOne.bottomAnchor, constant: padding),
            
            cardFour.leadingAnchor.constraint(equalTo: cardTwo.leadingAnchor),
            cardFour.widthAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardFour.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardFour.topAnchor.constraint(equalTo: cardThree.topAnchor),
            
            ])
    }

    


}
