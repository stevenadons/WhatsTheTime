//
//  DurationVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationVC: UIViewController {

    
    // MARK: - Properties
    
    var onDismiss: (() -> Void)?
    
    private var backButton: BackButton!
    
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
        showBackButton(delay: 0.8)
        for card in self.cards {
            if let index = self.cards.index(of: card) {
                card.popup(delay: 0.2 * Double(index))
            } else {
                card.popup(delay: 1.0)
            }
        }
    }
    
    private func setupViews() {
        
        backButton = BackButton()
        backButton.alpha = 0.0
        backButton.addTarget(self, action: #selector(backButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(backButton)
        
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
            
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),
            
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
    
    
    // MARK: - Private Methods
    
    @objc private func backButtonTapped(sender: BackButton, forEvent event: UIEvent) {
        
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        onDismiss?()
    }
    
    private func showBackButton(delay: Double) {
        
        UIView.animate(withDuration: 0.2, delay: delay, options: [], animations: { 
            self.backButton.alpha = 1.0
        }, completion: nil)
    }



}