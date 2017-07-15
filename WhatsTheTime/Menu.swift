//
//  Menu.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Menu: UIView {
    
    
    // MARK: - Properties
    
    var menuCircles: MenuCircles!
    var buttons: [MenuButton] = []
    
    private var containerView: UIView = UIView()
    private let  spacingButtons: CGFloat = 14

    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Set constraints
        
        for button in buttons {
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                button.heightAnchor.constraint(equalToConstant: 35),
                button.widthAnchor.constraint(equalToConstant: 148),
                ])
        }
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            
            menuCircles.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            menuCircles.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            menuCircles.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            menuCircles.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            buttons[1].bottomAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -spacingButtons/2),
            buttons[0].bottomAnchor.constraint(equalTo: buttons[1].topAnchor, constant: -spacingButtons),
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: spacingButtons),
            buttons[3].topAnchor.constraint(equalTo: buttons[2].bottomAnchor, constant: spacingButtons),
            
            ])
        }
    
    
    
    // MARK: - Public UI Methods
    
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        // Add containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        addSubview(containerView)
        
        
        // Add circles
        menuCircles = MenuCircles(smallRatio: 0.7, mediumRatio: 0.9, bigRatio: 1.0)
        containerView.addSubview(menuCircles)
        
        
        // Add buttons
        let button1 = MenuButton(text: "TIMER (2 X 25 MIN)")
        let button2 = MenuButton(text: "SET GAME TIME")
        let button3 = MenuButton(text: "EDIT SCORE")
        let button4 = MenuButton(text: "DOCUMENTS")
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
        for button in buttons {
            containerView.addSubview(button)
        }
    }

    
    

    
    
    
    
}
