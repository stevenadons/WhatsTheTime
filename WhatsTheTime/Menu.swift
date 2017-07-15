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
//    var buttonsWidthConstraints: [NSLayoutConstraint] = []
    
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
                button.activeConstraint!,
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
            button.normalConstraint = button.widthAnchor.constraint(equalToConstant: normalWidth(button: button))
            button.stretchedConstraint = button.widthAnchor.constraint(equalToConstant: stretchedWidth(button: button))
            button.shrunkenConstraint = button.widthAnchor.constraint(equalToConstant: 0)
            button.activeConstraint = button.normalConstraint
            button.addTarget(self, action: #selector(buttonTapped(sender:forEvent:)), for: [.touchUpInside])
            containerView.addSubview(button)
        }
    }
    
    
    @objc private func buttonTapped(sender: MenuButton, forEvent event: UIEvent) {
        
        animateButtons(tappedButton: sender)
        menuCircles.expandToFullScreen(duration: 0.8)
        // notice viewcontroller
    }
    
    
    private func animateButtons(tappedButton: MenuButton) {
        
        for index in 0..<buttons.count {
            var tappedHit = false
            if buttons[index].isEqual(tappedButton) {
                animateHighlight(button: tappedButton)
                tappedHit = true
            } else {
                let delay = tappedHit ? 0.1 * Double(index) : 0.1 * Double(index + 1)
                animateShrink(button: buttons[index], delay: delay)
            }
        }
    }
    
    
    private func animateHighlight(button: MenuButton) {
        
        button.activeConstraint?.isActive = false
        button.activeConstraint = button.stretchedConstraint
        button.activeConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.layoutIfNeeded()
        })
    }
    
    
    private func animateShrink(button: MenuButton, delay: Double) {
        
        button.activeConstraint?.isActive = false
        button.activeConstraint = button.shrunkenConstraint
        button.activeConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.25, delay: delay, options: [.curveEaseIn], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    // MARK: - Private Helper Methods
    
    private func normalWidth(button: MenuButton) -> CGFloat {
        
        var normalWidth: CGFloat
        let index = buttons.index(of: button)
        if index == 0 || index == 3 {
            normalWidth = 148
        } else {
            normalWidth = 198
        }
        return normalWidth
    }
    
    
    private func stretchedWidth(button: MenuButton) -> CGFloat {
        
        var stretchedWidth: CGFloat
        let index = buttons.index(of: button)
        if index == 0 || index == 3 {
            stretchedWidth = UIScreen.main.bounds.width - 125
        } else {
            stretchedWidth = UIScreen.main.bounds.width - 75
        }
        return stretchedWidth
    }

    
}
