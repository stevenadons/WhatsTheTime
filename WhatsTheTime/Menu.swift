//
//  Menu.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


enum MenuItem {
    
    case Timer
    case SetGameTime
    case EditScore
    case Documents
}


class Menu: UIView {
    
    
    // MARK: - Helper Classes
    
    enum State {
        
        case WaitingForInput
        case ButtonTapped
    }
    
    
    // MARK: - Properties
    
    var menuCircles: MenuCircles!
    var buttons: [MenuButton] = []
    var delegate: MenuDelegate?
    var selectedMenuItem: MenuItem?
    
    private var containerView: UIView = UIView()
    private var timer: Timer?
    private var state: State = .WaitingForInput

    private let buttonHeight: CGFloat = 35
    private let spacingButtons: CGFloat = 14

    
    
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
    
    
    
    // MARK: - Public UI Methods
    
    func enableBeat(interval: Double) {
        
        menuCircles.enableBeat(interval: interval)
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
                self.flash()
            }
        }
    }
    
    
    func disableBeat() {
        
        menuCircles.disableBeat()
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    
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
        let button1 = MenuButton(text: "TIMER (2 X 25 MIN)", menuItem: .Timer)
        let button2 = MenuButton(text: "SET GAME TIME", menuItem: .SetGameTime)
        let button3 = MenuButton(text: "EDIT SCORE", menuItem: .EditScore)
        let button4 = MenuButton(text: "DOCUMENTS", menuItem: .Documents)
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
        for button in buttons {
            button.addTarget(self, action: #selector(buttonTapped(sender:forEvent:)), for: [.touchUpInside])
            containerView.addSubview(button)
        }
        
        // Set constraints
        for button in buttons {
            
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                button.heightAnchor.constraint(equalToConstant: buttonHeight),
                button.widthAnchor.constraint(equalToConstant: normalWidth(button: button)),
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
            
            buttons[0].centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -(buttonHeight * 1.5 + spacingButtons * 1.5)),
            buttons[1].centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -(buttonHeight * 0.5 + spacingButtons * 0.5)),
            buttons[2].centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: buttonHeight * 0.5 + spacingButtons * 0.5),
            buttons[3].centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: buttonHeight * 1.5 + spacingButtons * 1.5),
            
            ])
    }
    
    
    @objc private func buttonTapped(sender: MenuButton, forEvent event: UIEvent) {
        
        state = .ButtonTapped
        selectedMenuItem = sender.menuItem
        
        layer.removeAllAnimations()
        disableBeat()
        
        menuCircles.expandToFullScreen(duration: 0.8)
        animateButtons(tappedButton: sender)
        
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(800)
        DispatchQueue.main.asyncAfter(deadline: deadline) { 
            self.callVCToNavigate(from: sender.menuItem)
        }
    }
    
    
    // Total duration = 0.55
    private func animateButtons(tappedButton: MenuButton) {
        
        for button in buttons {
            if button.isEqual(tappedButton) {
                button.fade(duration: 0.2, delay: 0.6, completion: nil)
            } else {
                button.fade(duration: 0.2, delay: 0.0, completion: nil)
            }
        }
    }
    
    
    private func animateBeat(button: MenuButton, delay: Double) {
        
        button.changeSizeConstraint(attribute: .width, constant: beatingWidth(button: button))
        
        UIView.animate(withDuration: 0.05, delay: delay, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            if self.state == .WaitingForInput {
                button.changeSizeConstraint(attribute: .width, constant: self.normalWidth(button: button))
                UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    
    private func flash() {
        
        for index in 0..<buttons.count {
            self.animateBeat(button: self.buttons[index], delay: 0.5 + 0.1 * Double(index))
        }
    }
    
    
    private func callVCToNavigate(from menuItem: MenuItem) {
        
        delegate?.handleNavigation(for: menuItem)
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
    
    
    private func beatingWidth(button: MenuButton) -> CGFloat {
        
        return normalWidth(button: button) + 5
    }

    
}
