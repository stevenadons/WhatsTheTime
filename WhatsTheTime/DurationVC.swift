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
    
    var onCardTapped: (() -> Void)?
    
    fileprivate var backButton: BackButtonIconOnly!
    fileprivate var titleLabel: UILabel!
    fileprivate var cardOne: DurationCard!
    fileprivate var cardTwo: DurationCard!
    fileprivate var cardThree: DurationCard!
    fileprivate var cardFour: DurationCard!
    fileprivate var cards: [DurationCard] = []
    
    fileprivate let padding: CGFloat = 18
    
    
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
                card.popup(delay: 0.1 * Double(index))
            } else {
                card.popup(delay: 1.0)
            }
        }
    }
    
    private func setupViews() {
        
        backButton = BackButtonIconOnly()
        backButton.alpha = 0.0
        backButton.addTarget(self, action: #selector(backButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(backButton)
        
        titleLabel = titleLabel(text: LS_TITLE_SETGAMETIME)
        view.addSubview(titleLabel)
        
        cardOne = DurationCard(duration: .Twenty)
        cardTwo = DurationCard(duration: .TwentyFive)
        cardThree = DurationCard(duration: .Thirty)
        cardFour = DurationCard(duration: .ThirtyFive)
        cards.append(cardOne)
        cards.append(cardTwo)
        cards.append(cardThree)
        cards.append(cardFour)
        cards.forEach {
            $0.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
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
    
    private func titleLabel(text: String) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.Theme
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    // MARK: - Private Methods
    
    @objc private func backButtonTapped(sender: BackButton, forEvent event: UIEvent) {
        
        dismissVC()
    }
    
    private func showBackButton(delay: Double) {
        
        UIView.animate(withDuration: 0.2, delay: delay, options: [], animations: { 
            self.backButton.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func dismissVC() {
        
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Touch Methods

private extension DurationVC {
    
    @objc func handleCardTapped(sender: DurationCard, forEvent event: UIEvent) {

        UserDefaults.standard.set(sender.duration.rawValue, forKey: USERDEFAULTSKEY.Duration)
        onCardTapped?()
        dismissVC()
    }
    
}
