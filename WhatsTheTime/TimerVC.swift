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

protocol PitchDelegate: class {
    
    func scoreHome()
    func scoreAway()
    func scoreLabelChanged()
    func scoreHomeMinusOne()
    func scoreAwayMinusOne()
}

protocol MenuDelegate: class {
    
    func handleNavigation(for menuItem: MenuItem)
}


class TimerVC: UIViewController, Sliding {

    
    // MARK: - Properties
    
    fileprivate var hamburger: HamburgerButtonIconOnly!
    fileprivate var resetButton: ResetButtonIconOnly!
    fileprivate var stopWatchContainer: ContainerView!
    fileprivate var stopWatch: StopWatch!
    fileprivate var pitchContainer: PitchContainerView!
    fileprivate var pitch: Pitch!
    fileprivate var dismissEditMode: DismissButton!
    fileprivate var maskView: UIButton!
    private var undoButtonContainer: ContainerView!
    fileprivate var undoButton: UIButton!
    fileprivate var messageLabel: UILabel!
    fileprivate var menu: Menu!
    fileprivate var duration: MINUTESINHALF = .TwentyFive
    
    fileprivate var game: HockeyGame!
    var stopWatchCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!
    private var scorePanelCenterYConstraint: NSLayoutConstraint!
    private var undoButtonTopConstraint: NSLayoutConstraint!
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    fileprivate var messageTimer: Timer?
    fileprivate let standardUndoButtonColor: UIColor = COLOR.Negation
    fileprivate var inEditMode: Bool = false
    fileprivate var animationTransitioningDelegate: AnimationTransitioningDelegate = AnimationTransitioningDelegate()
    
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
        view.backgroundColor = COLOR.White
        view.clipsToBounds = true
        if let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = MINUTESINHALF(rawValue: minutes) {
                duration = enumCase
            }
        }
        game = HockeyGame(duration: duration)
        setupViews()
    }
    
    private func setupViews() {
        
        hamburger = HamburgerButtonIconOnly()
        hamburger.addTarget(self, action: #selector(menuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(hamburger)
        
        resetButton = ResetButtonIconOnly()
        resetButton.addTarget(self, action: #selector(resetButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(resetButton)
        
        pitchContainer = PitchContainerView()
        view.addSubview(pitchContainer)
        pitch = Pitch(delegate: self)
        pitch.isUserInteractionEnabled = true
        pitch.hideBall()
        pitchContainer.addSubview(pitch)
        
        stopWatchContainer = ContainerView()
        view.addSubview(stopWatchContainer)
        stopWatch = StopWatch(delegate: self, game: game)
        stopWatch.translatesAutoresizingMaskIntoConstraints = false
        stopWatchContainer.addSubview(stopWatch)

        dismissEditMode = DismissButton()
        dismissEditMode.addTarget(self, action: #selector(dismissButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        dismissEditMode.alpha = 0
        view.addSubview(dismissEditMode)
        
        maskView = UIButton()
        maskView.addTarget(self, action: #selector(maskViewTapped(sender:forEvent:)), for: [.touchUpInside])
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        view.addSubview(maskView)
        
        undoButtonContainer = ContainerView()
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
        
        menu = Menu()
        menu.delegate = self
        view.addSubview(menu)
        
        // Add constraints
        setInitialLayoutConstraints()
        
        NSLayoutConstraint.activate([
            
            hamburger.widthAnchor.constraint(equalToConstant: 44),
            hamburger.heightAnchor.constraint(equalToConstant: 44),
            hamburger.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            hamburger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),
            
            resetButton.widthAnchor.constraint(equalToConstant: 44),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CoordinateScalor.convert(y: -13)),

            pitchContainer.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 380)),
            pitchContainer.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 202)),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75),
            pitch.leadingAnchor.constraint(equalTo: pitchContainer.leadingAnchor),
            pitch.trailingAnchor.constraint(equalTo: pitchContainer.trailingAnchor),
            pitch.heightAnchor.constraint(equalTo: pitchContainer.heightAnchor),
            pitchCenterYConstraint,
            
            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 210/375),
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 207)),
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatchCenterYConstraint,
            
            dismissEditMode.heightAnchor.constraint(equalToConstant: 50),
            dismissEditMode.bottomAnchor.constraint(equalTo: undoButtonContainer.topAnchor, constant: -30),
            dismissEditMode.widthAnchor.constraint(equalTo: dismissEditMode.heightAnchor, multiplier: 1),
            dismissEditMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            
            menu.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            menu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            menu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menu.widthAnchor.constraint(equalTo: menu.heightAnchor, multiplier: 1),
            
            ])
        
        hideIcons()
    }
    
    func setInitialLayoutConstraints() {
        
        stopWatchCenterYConstraint = NSLayoutConstraint(item: stopWatch, attribute: .centerY, relatedBy: .equal, toItem: stopWatchContainer, attribute: .centerY, multiplier: 1, constant: UIScreen.main.bounds.height)
        pitchCenterYConstraint = NSLayoutConstraint(item: pitch, attribute: .centerY, relatedBy: .equal, toItem: pitchContainer, attribute: .centerY, multiplier: 1, constant: UIScreen.main.bounds.height)
        undoButtonTopConstraint = NSLayoutConstraint(item: undoButton, attribute: .top, relatedBy: .equal, toItem: undoButtonContainer, attribute: .top, multiplier: 1, constant: 130)
    }
        
    
    // MARK: - Drawing and laying out
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("appearing")
        super.viewDidAppear(animated)
        animateViewsOnAppear()
        showIcons()
    }
    
    override func viewDidLayoutSubviews() {
        
        undoButton.layer.cornerRadius = undoButton.bounds.width / 2
    }
    
    
    // MARK: - Private Methods
    
    func animateViewsOnAppear() {
        
        stopWatchCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.stopWatchContainer.layoutIfNeeded()
        })
        pitchCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.pitchContainer.layoutIfNeeded()
        }, completion: { (finished) in
            self.showIcons()
        })
    }
    
    private func resetViews() {
        
        stopWatch.transform = CGAffineTransform.identity
        pitch.transform = CGAffineTransform.identity
        setInitialLayoutConstraints()
    }
    
    fileprivate func showUndoButton(withSpecificColor color: UIColor?) {
        
        if let color = color {
            undoButton.backgroundColor = color
        } else {
            undoButton.backgroundColor = standardUndoButtonColor
        }
        guard undoButtonTopConstraint.constant != 0 else { return }
        undoButtonTopConstraint.constant = 0
        undoButton.setNeedsDisplay()
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
            self.undoButtonContainer.layoutIfNeeded()
        }, completion: { (finished) in
            self.messageLabel.layer.opacity = 1.0
        })
    }
    
    @objc fileprivate func hideUndoButton() {
        
        if messageTimer != nil {
            messageTimer!.invalidate()
            messageTimer = nil
        }
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
    
    fileprivate func hideIcons() {
        
        UIView.animate(withDuration: 0.2) {
            self.hamburger.alpha = 0.0
            self.resetButton.alpha = 0.0
        }
    }
    
    fileprivate func showIcons() {
        
        UIView.animate(withDuration: 0.2) {
            self.hamburger.alpha = 1.0
            self.resetButton.alpha = 1.0
        }
    }
    
    @objc private func menuButtonTapped(sender: HamburgerButton, forEvent event: UIEvent) {
        
        hideIcons()
        hideUndoButton()
        menu.show()
    }
    
    @objc private func resetButtonTapped(sender: ResetButtonIconOnly, forEvent event: UIEvent) {
        
        message = LS_WARNINGRESETGAME
        showUndoButton(withSpecificColor: nil)
        UIView.animate(withDuration: 0.2) { 
            self.maskView.alpha = 0.7

        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideUndoButton), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissButtonTapped(sender: DismissButton, forEvent event: UIEvent) {
        
        inEditMode = false
        dismissEditMode.hide()
        hideUndoButton()
        undoButton.isUserInteractionEnabled = true
        pitch.moveBack {
            if self.stopWatch.timer.state != .WaitingToStart && self.stopWatch.timer.state != .Ended {
                self.pitch.showBall()
            }
            self.stopWatch.comeFromBackground(completion: {
                self.showIcons()
            })
        }
    }
    
    @objc private func undoButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideUndoButton()
        if message == LS_UNDOGOAL {
            if messageTimer != nil {
                messageTimer?.invalidate()
                messageTimer = nil
            }
            // to implement score countdown
        } else if message == LS_WARNINGRESETGAME {
            resetWithNewGame()
        }
    }
    
    @objc private func maskViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideUndoButton()
    }
    
    fileprivate func resetWithNewGame() {
        
        pitch.resetScores()
        handleNewGame()
    }
}



extension TimerVC: StopWatchDelegate {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?) {
        switch stopWatchTimer.state {
        case .WaitingToStart:
            pitch.hideBall()
            completionHandler?()
        case .RunningCountDown:
            if !inEditMode {
                pitch.showBall()
            }
            completionHandler?()
        case .RunningCountUp:
            completionHandler?()
        case .Paused:
            completionHandler?()
        case .Overdue:
            completionHandler?()
        case .Ended:
            pitch.hideBall()
            completionHandler?()
        }
    }
    
    func handleNewGame() {
        
        if let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = MINUTESINHALF(rawValue: minutes) {
                duration = enumCase
            }
        }
        game = HockeyGame(duration: duration)
        stopWatch.reset(withGame: game)
        pitch.hideBall()
        pitch.resetScores()
    }
}


extension TimerVC: PitchDelegate {
    
    func scoreHome() {
        
        game.homeScored()
    }
    
    func scoreAway() {
        
        game.awayScored()
    }
    
    func scoreHomeMinusOne() {
        
        game.homeScoreMinusOne()
    }
    
    func scoreAwayMinusOne() {
        
        game.awayScoreMinusOne()
    }
    
    func scoreLabelChanged() {
        
        message = LS_UNDOGOAL
        showUndoButton(withSpecificColor: nil)
        if messageTimer != nil {
            messageTimer?.invalidate()
        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideUndoButton), userInfo: nil, repeats: false)
    }
}


extension TimerVC: MenuDelegate {
    
    func handleNavigation(for menuItem: MenuItem) {
        
        switch menuItem {
        case .Timer:
            showIcons()
            
        case .SetGameTime:
            hideIcons()
            let newVC = DurationVC()
            newVC.modalTransitionStyle = .crossDissolve
            newVC.onCardTapped = { self.resetWithNewGame() }
            present(newVC, animated: true, completion: nil)
            
        case .EditScore:
            inEditMode = true
            hideIcons()
            stopWatch.goToBackground(completion: {
                self.pitch.hideBall()
                self.pitch.moveUp(completion: {
                    self.message = LS_MESSAGEEDITSCORES
                    self.undoButton.isUserInteractionEnabled = false
                    self.showUndoButton(withSpecificColor: COLOR.DarkBackground)
                    self.dismissEditMode.show()
                })
            })
            
        case .Documents:
            hideIcons()
            let newVC = DocumentMenuVC()
            newVC.modalTransitionStyle = .crossDissolve
            present(newVC, animated: true, completion: nil)
        }
    }
}



