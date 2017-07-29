//
//  TimerVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit



protocol StopWatchDelegate: class {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?)
    func handleNewGame()
}


class TimerVC: UIViewController, Sliding {

    
    // MARK: - Properties
    
    private var hamburger: HamburgerButtonIconOnly!
    private var resetButton: ResetButtonIconOnly!
    private var circle: BackgroundCircle!
    fileprivate var stopWatchContainer: ContainerView!
    fileprivate var stopWatch: StopWatch!
    private var pitchContainer: ContainerView!
    private var pitch: Pitch!
    private var maskView: UIButton!
    private var undoButtonContainer: ContainerView!
    private var undoButton: UIButton!
    fileprivate var messageLabel: UILabel!
    fileprivate var game: HockeyGame!
    fileprivate var stopWatchCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!
    private var undoButtonTopConstraint: NSLayoutConstraint!
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    fileprivate var circleUp: Bool = true
    private var messageTimer: Timer?
    
    var message: String = "HELLO" {
        didSet {
            if let label = messageLabel {
                label.text = message
                label.setNeedsDisplay()
            }
        }
    }
    
    
    
    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = COLOR.LightBackground
        game = HockeyGame(duration: .Fifteen)
        setupViews()
    }
    
    private func setupViews() {
        
        // Add UI elements
        
        hamburger = HamburgerButtonIconOnly()
        hamburger.addTarget(self, action: #selector(showMenu(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(hamburger)
        
        resetButton = ResetButtonIconOnly()
        resetButton.addTarget(self, action: #selector(resetButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(resetButton)
        
        circle = BackgroundCircle()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.isUserInteractionEnabled = false
        circle.color = COLOR.White
        view.addSubview(circle)
        
        stopWatchContainer = ContainerView()
        stopWatchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopWatchContainer)
        
        stopWatch = StopWatch(delegate: self, game: game)
        stopWatch.translatesAutoresizingMaskIntoConstraints = false
        stopWatchContainer.addSubview(stopWatch)
        
        pitchContainer = ContainerView()
        pitchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pitchContainer)
        
        pitch = Pitch()
        pitch.isUserInteractionEnabled = true
        pitchContainer.addSubview(pitch)
        
        maskView = UIButton()
        maskView.addTarget(self, action: #selector(maskViewTapped(sender:forEvent:)), for: [.touchUpInside])
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        view.addSubview(maskView)
        
        undoButtonContainer = ContainerView()
        undoButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(undoButtonContainer)
        
        undoButton = UIButton()
        undoButton.addTarget(self, action: #selector(undoButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.backgroundColor = COLOR.Negation
        undoButtonContainer.addSubview(undoButton)
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isUserInteractionEnabled = false
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = COLOR.White
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 14)
        messageLabel.layer.opacity = 0.0
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionFade
        messageLabel.layer.add(transition, forKey: "transition")
        view.addSubview(messageLabel)
        
        
        // Add constraints

        stopWatchCenterYConstraint = NSLayoutConstraint(item: stopWatch, attribute: .centerY, relatedBy: .equal, toItem: stopWatchContainer, attribute: .centerY, multiplier: 1, constant: UIScreen.main.bounds.height)
        pitchCenterYConstraint = NSLayoutConstraint(item: pitch, attribute: .centerY, relatedBy: .equal, toItem: pitchContainer, attribute: .centerY, multiplier: 1, constant: UIScreen.main.bounds.height)
        undoButtonTopConstraint = NSLayoutConstraint(item: undoButton, attribute: .top, relatedBy: .equal, toItem: undoButtonContainer, attribute: .top, multiplier: 1, constant: 130)
        
        NSLayoutConstraint.activate([
            
            hamburger.widthAnchor.constraint(equalToConstant: 44),
            hamburger.heightAnchor.constraint(equalToConstant: 44),
            hamburger.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            hamburger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),
            
            resetButton.widthAnchor.constraint(equalToConstant: 44),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CoordinateScalor.convert(y: -13)),

            circle.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 45)),
            circle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CoordinateScalor.convert(y: -100)),
            circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(x: -73)),
            circle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CoordinateScalor.convert(x: 73)),
            
            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 210/375),
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 207)),
            
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatchCenterYConstraint,
            
            pitchContainer.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 185)),
            pitchContainer.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 111)),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 429)),
            
            pitch.leadingAnchor.constraint(equalTo: pitchContainer.leadingAnchor),
            pitch.trailingAnchor.constraint(equalTo: pitchContainer.trailingAnchor),
            pitch.heightAnchor.constraint(equalTo: pitchContainer.heightAnchor),
            pitchCenterYConstraint,
            
            maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            undoButtonContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2),
            undoButtonContainer.heightAnchor.constraint(equalTo: undoButton.widthAnchor, multiplier: 1),
            undoButtonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            undoButtonContainer.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -130),
            
            undoButton.leadingAnchor.constraint(equalTo: undoButtonContainer.leadingAnchor),
            undoButton.trailingAnchor.constraint(equalTo: undoButtonContainer.trailingAnchor),
            undoButton.bottomAnchor.constraint(equalTo: undoButtonContainer.bottomAnchor),
            undoButtonTopConstraint,
            
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            messageLabel.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 24)),
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50 - CoordinateScalor.convert(height: 30)),
            
            ])
        
        // Inflate circle
        circle.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidLayoutSubviews() {
        undoButton.layer.cornerRadius = undoButton.bounds.width / 2
    }
    
    
    // MARK: - Animating
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateViewsOnAppear()
    }
    
    private func animateViewsOnAppear() {
        slideViewController(to: .In, offScreenPosition: .Bottom, completion: nil)
        stopWatchCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.stopWatchContainer.layoutIfNeeded()
        })
        pitchCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.pitchContainer.layoutIfNeeded()
        })
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.circle.transform = .identity
        }, completion: nil)
    }
    
    private func showUndoButton() {
        guard undoButtonTopConstraint.constant != 0 else { return }
        undoButtonTopConstraint.constant = 0
        undoButton.setNeedsDisplay()
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
            self.undoButtonContainer.layoutIfNeeded()
        }, completion: { (finished) in
            self.messageLabel.layer.opacity = 1.0
        })
    }
    
    @objc private func hideUndoButton() {
        print("\(undoButtonTopConstraint.constant)")
        if messageTimer != nil {
            messageTimer!.invalidate()
            messageTimer = nil
        }
        resetButton.alpha = 1.0
        resetButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0.0
        }
        guard undoButtonTopConstraint.constant == 0 else { return }
        undoButtonTopConstraint.constant = 130
        undoButton.setNeedsDisplay()
        messageLabel.layer.opacity = 0.0
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
            self.undoButtonContainer.layoutIfNeeded()
        })
    }
   
    
    
    // MARK: - Private Methods
    
    @objc private func showMenu(sender: HamburgerButton, forEvent event: UIEvent) {
        // test
//        UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
//            self.pitch.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//        })
        print("menu")
        print("pitch frame is \(pitch.frame)")
    }
    
    @objc private func resetButtonTapped(sender: ResetButtonIconOnly, forEvent event: UIEvent) {
        resetButton.alpha = 0.3
        resetButton.isUserInteractionEnabled = false
        message = LS_WARNINGRESETGAME
        showUndoButton()
        UIView.animate(withDuration: 0.2) { 
            self.maskView.alpha = 0.4

        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideUndoButton), userInfo: nil, repeats: false)
        print("reset?")
    }
    
    @objc private func undoButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        print("undo tapped")
        hideUndoButton()
        stopWatch.reset()
        handleNewGame()
        print("undo")
    }
    
    @objc private func maskViewTapped(sender: UIButton, forEvent event: UIEvent) {
        print("maskk tapped")
        hideUndoButton()
    }
}



extension TimerVC: StopWatchDelegate {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?) {
        switch stopWatchTimer.state {
        case .WaitingToStart:
            completionHandler?()
        case .RunningCountDown:
            completionHandler?()
        case .RunningCountUp:
            completionHandler?()
        case .Paused:
            completionHandler?()
        case .Overdue:
            completionHandler?()
        case .Ended:
            completionHandler?()
        }
    }
    
    func handleNewGame() {
        game = HockeyGame(duration: .Fifteen)
        stopWatch.game = game
        stopWatch.reset()
        stopWatch.setNeedsLayout()
    }

}



