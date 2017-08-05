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

    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    private func setupViews() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        addSubview(containerView)
        
        menuCircles = MenuCircles(smallRatio: 0.7, mediumRatio: 0.9, bigRatio: 1.0)
        containerView.addSubview(menuCircles)
        
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
        
        bringInHiddenUIState()
    }
    
    private func bringInHiddenUIState() {
        
        menuCircles.scaleDown()
        for button in buttons {
            button.alpha = 0.0
        }
        isUserInteractionEnabled = false
    }
    
    
    
    // MARK: - User Methods
    
    func show() {
        
        menuCircles.animateToOriginalScale(duration: 0.5, delay: 0.0, completion: {
            self.isUserInteractionEnabled = true
            self.enableBeat(interval: 5)
        })
        for index in 0..<self.buttons.count {
            let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(300 + 100 * index)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.buttons[index].alpha = 1.0
                self.animateBeat(button: self.buttons[index], delay: 0.0)
            })
        }
    }
    
    
    
    // MARK: - Private Methods
    
    private func enableBeat(interval: Double) {
        
        menuCircles.enableBeat(interval: interval)
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
                self.flash()
            }
        }
    }
    
    private func disableBeat() {
        
        menuCircles.disableBeat()
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }

    
    @objc private func buttonTapped(sender: MenuButton, forEvent event: UIEvent) {
        
        state = .ButtonTapped
        selectedMenuItem = sender.menuItem
        isUserInteractionEnabled = false
        
        layer.removeAllAnimations()
        disableBeat()
        
        menuCircles.animateToDownsizedScale(duration: 0.4, delay: 0.0, completion: {
            self.delegate?.handleNavigation(for: sender.menuItem)
        })
        for button in buttons {
            let delay: Double = button.isEqual(sender) ? 0.2 : 0.0
            UIView.animate(withDuration: 0.15, delay: delay, options: [.curveEaseIn, .allowUserInteraction], animations: {
                button.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
                button.alpha = 0.0
            }, completion: { (finished) in
                button.alpha = 0.0
            })
        }
    }
    
    private func flash() {
        
        for index in 0..<buttons.count {
            let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(500 + 100 * index)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: { 
                self.animateBeat(button: self.buttons[index], delay: 0.0)
            })
        }
    }

    private func animateBeat(button: MenuButton, delay: Double) {
        
        button.alpha = 1.0
        button.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.05, delay: delay, options: [.curveEaseOut, .allowUserInteraction], animations: {
            button.transform = CGAffineTransform(scaleX: 1.04, y: 1)
        }) { (finished) in
            if self.state == .WaitingForInput {
                UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                    button.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
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
}
