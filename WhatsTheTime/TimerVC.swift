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
//    func handleTickOverdue()
    func handleNewGame()
}


class TimerVC: UIViewController, Sliding {

    
    // MARK: - Properties
    
    private var hamburger: HamburgerButtonIconOnly!
    private var circleContainer: ContainerView!
    private var circle: BackgroundCircle!
    fileprivate var stopWatchContainer: ContainerView!
    fileprivate var stopWatch: StopWatch!
    private var pitchContainer: ContainerView!
    private var pitch: UIView!
    fileprivate var messageLabel: UILabel!
    
    fileprivate var game: HockeyGame!

    fileprivate var stopWatchCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!

    
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    
    fileprivate var circleUp: Bool = true
    
    
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = COLOR.LightBackground
        game = HockeyGame(duration: .Fifteen)

        setupViews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        animateViewsOnAppear()
    }
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        // Add UI elements
        
        hamburger = HamburgerButtonIconOnly()
        hamburger.addTarget(self, action: #selector(showMenu(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(hamburger)
        
        circleContainer = ContainerView()
        circleContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleContainer)
        
        circle = BackgroundCircle()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.isUserInteractionEnabled = false
        circle.color = COLOR.White
        circleContainer.addSubview(circle)
        
        stopWatchContainer = ContainerView()
        stopWatchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopWatchContainer)
        
        stopWatch = StopWatch(delegate: self, game: game)
        stopWatch.translatesAutoresizingMaskIntoConstraints = false
        stopWatchContainer.addSubview(stopWatch)
        
        pitchContainer = ContainerView()
        pitchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pitchContainer)
        
        pitch = UIView()
        pitch.translatesAutoresizingMaskIntoConstraints = false
        pitch.isUserInteractionEnabled = true
        pitch.backgroundColor = COLOR.Theme
        pitchContainer.addSubview(pitch)
        
        
        // Add constraints

        stopWatchCenterYConstraint = NSLayoutConstraint(item: stopWatch, attribute: .centerY, relatedBy: .equal, toItem: stopWatchContainer, attribute: .centerY, multiplier: 1, constant: UIScreen.main.bounds.height)
        pitchCenterYConstraint = NSLayoutConstraint(item: pitch, attribute: .centerY, relatedBy: .equal, toItem: pitchContainer, attribute: .centerY, multiplier: 1, constant: UIScreen.main.bounds.height)
        
        NSLayoutConstraint.activate([
            
            hamburger.widthAnchor.constraint(equalToConstant: 44),
            hamburger.heightAnchor.constraint(equalToConstant: 44),
            hamburger.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 30)),
            hamburger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),

            circleContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 45)),
            circleContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CoordinateScalor.convert(y: -100)),
            circleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(x: -73)),
            circleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CoordinateScalor.convert(x: 73)),
            
            circle.centerXAnchor.constraint(equalTo: circleContainer.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: circleContainer.centerYAnchor),
            circle.widthAnchor.constraint(equalTo: circleContainer.widthAnchor),
            circle.heightAnchor.constraint(equalTo: circleContainer.heightAnchor),
            
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
            
            ])
        
        // Inflate circle
        circle.transform = CGAffineTransform(scaleX: 2, y: 2)
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
        
        UIView.animate(withDuration: 4, delay: 1, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.circle.transform = .identity
        }, completion: nil)
    }
    
    
    
    // MARK: - Private Methods
    
    @objc private func showMenu(sender: HamburgerButton, forEvent event: UIEvent) {
        
        print("menu")
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
    
//    func handleTickOverdue() {
//        
//        var updatedMessage = LS_OVERDUE_MESSAGE_BEGINS
//        updatedMessage.append(stopWatch.messageLabelTimeString())
//        message = updatedMessage
//    }
    
    func handleNewGame() {
        
        game = HockeyGame(duration: .Fifteen)
        stopWatch.game = game
        stopWatch.reset()
        stopWatch.setNeedsLayout()
    }

}



