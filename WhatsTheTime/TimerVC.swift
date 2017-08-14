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

protocol DotMenuDelegate {
    
    func handleDotMenuButtonTapped(buttonNumber: Int)
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
    fileprivate var confirmationButton: ConfirmationButton!
    fileprivate var dotMenu: DotMenu!

    fileprivate var menu: Menu!
    fileprivate var duration: MINUTESINHALF = .TwentyFive
    
    fileprivate var game: HockeyGame!
    var stopWatchCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!
    private var scorePanelCenterYConstraint: NSLayoutConstraint!
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    fileprivate var messageTimer: Timer?
    fileprivate let standardUndoButtonColor: UIColor = COLOR.Negation
    fileprivate var inEditMode: Bool = false
    fileprivate var animationTransitioningDelegate: AnimationTransitioningDelegate = AnimationTransitioningDelegate()
    
    var message: String = "HELLO" {
        didSet {
            confirmationButton.setTitle(message, for: .normal)
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
        
        confirmationButton = ConfirmationButton.redButton()
        confirmationButton.alpha = 0.0
        confirmationButton.setTitle(LS_BACKBUTTON, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(confirmationButton)
        
        menu = Menu()
        menu.delegate = self
        view.addSubview(menu)
        
        dotMenu = DotMenu(inView: self.view, delegate: self)
        
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
            dismissEditMode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            dismissEditMode.widthAnchor.constraint(equalTo: dismissEditMode.heightAnchor, multiplier: 1),
            dismissEditMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationButton.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            confirmationButton.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
            confirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            
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
    }
        
    
    // MARK: - Drawing and laying out
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        animateViewsOnAppear()
        showIcons()
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
    
    fileprivate func showConfirmationButton() {
        
        confirmationButton.grow()
    }
    
    @objc fileprivate func hideConfirmationButton() {
        
        if messageTimer != nil {
            messageTimer!.invalidate()
            messageTimer = nil
        }
        confirmationButton.shrink()
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0.0
        }
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
        hideConfirmationButton()
        menu.show()
    }
    
    @objc private func resetButtonTapped(sender: ResetButtonIconOnly, forEvent event: UIEvent) {
        
        message = LS_WARNINGRESETGAME
        showConfirmationButton()
        UIView.animate(withDuration: 0.2) { 
            self.maskView.alpha = 0.2

        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideConfirmationButton), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissButtonTapped(sender: DismissButton, forEvent event: UIEvent) {
        
        inEditMode = false
        dismissEditMode.hide()
        hideConfirmationButton()
        pitch.moveBack {
            if self.stopWatch.timer.state != .WaitingToStart && self.stopWatch.timer.state != .Ended {
                self.pitch.showBall()
            }
            self.stopWatch.comeFromBackground(completion: {
                self.showIcons()
            })
        }
    }
    
    @objc private func confirmationButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideConfirmationButton()
        if message == LS_UNDOGOAL {
            if messageTimer != nil {
                messageTimer?.invalidate()
                messageTimer = nil
            }
            guard game.lastScored != nil else { return }
            switch (game.lastScored)! {
            case .Home:
                pitch.homeMinusOne()
            case .Away:
                pitch.awayMinusOne()
            }
        } else if message == LS_WARNINGRESETGAME {
            resetWithNewGame()
        }
    }
    
    @objc private func maskViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideConfirmationButton()
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
        if confirmationButton.alpha == 0 {
            showConfirmationButton()
        }
        if messageTimer != nil {
            messageTimer?.invalidate()
        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideConfirmationButton), userInfo: nil, repeats: false)
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
                    self.confirmationButton.isUserInteractionEnabled = false
                    self.showConfirmationButton()
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


extension TimerVC: DotMenuDelegate {
    
    func handleDotMenuButtonTapped(buttonNumber: Int) {
        
        print("number \(buttonNumber) tapped")
    }
}



