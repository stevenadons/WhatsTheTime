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
    func handleTickOverdue()
    func handleNewGame()
}


class TimerVC: UIViewController, Sliding {

    
    // MARK: - Properties
    
    var message: String = "" {
        didSet {
            if let label = messageLabel {
                label.text = message
                label.setNeedsDisplay()
            }
        }
    }
    
    private var logo: Logo!
    private var hamburger: Hamburger!
    private var ellipseContainer: ContainerView!
    private var ellipse: EllipseView!
    fileprivate var stopWatchContainer: ContainerView!
    fileprivate var stopWatch: StopWatch!
    private var pitchContainer: ContainerView!
    private var pitch: UIView!
    private var messageContainer: ContainerView!
    fileprivate var messageLabel: UILabel!
    
    fileprivate var game: HockeyGame!
    
    fileprivate var stopWatchCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!
    private var ellipseTopConstraint: NSLayoutConstraint!
    private var ellipseBottomConstraint: NSLayoutConstraint!
    
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    
    fileprivate var ellipseUp: Bool = true
    
    
    
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
        
        hamburger = Bundle.main.loadNibNamed(NIBNAME.Hamburger, owner: self, options: nil)?.last as! Hamburger
        hamburger.addTarget(self, action: #selector(showMenu(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(hamburger)

        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
        view.addSubview(logo)
        
        messageContainer = ContainerView()
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.backgroundColor = COLOR.DarkBackground
        view.addSubview(messageContainer)
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isUserInteractionEnabled = false
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = COLOR.White
        message = LS_NEWGAME
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 14)
        messageContainer.addSubview(messageLabel)
        
        ellipseContainer = ContainerView()
        ellipseContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ellipseContainer)
        
        ellipse = EllipseView()
        ellipse.translatesAutoresizingMaskIntoConstraints = false
        ellipse.isUserInteractionEnabled = false
        ellipse.color = COLOR.White
        ellipseContainer.addSubview(ellipse)
        
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
        
        stopWatchCenterYConstraint = NSLayoutConstraint(item: stopWatch, attribute: .centerY, relatedBy: .equal, toItem: stopWatchContainer, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 207) + initialObjectYOffset)
        pitchCenterYConstraint = NSLayoutConstraint(item: pitch, attribute: .centerY, relatedBy: .equal, toItem: pitchContainer, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 429) + initialObjectYOffset)
        ellipseTopConstraint = NSLayoutConstraint(item: ellipse, attribute: .top, relatedBy: .equal, toItem: ellipseContainer, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 60) - CoordinateScalor.convert(y: 120))
        ellipseBottomConstraint = NSLayoutConstraint(item: ellipse, attribute: .bottom, relatedBy: .equal, toItem: ellipseContainer, attribute: .bottom, multiplier: 1, constant: CoordinateScalor.convert(y: -100) + CoordinateScalor.convert(y: 150))
        
        NSLayoutConstraint.activate([
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 200)),
            logo.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 40)),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 23)),
            
            hamburger.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 20)),
            hamburger.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 20)),
            hamburger.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 30)),
            hamburger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 27)),
            
            messageContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            messageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            messageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            messageLabel.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 24)),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -50 - CoordinateScalor.convert(height: 30)),
            
            ellipseContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            ellipseContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            ellipseContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ellipseTopConstraint,
            ellipseBottomConstraint,
            ellipse.leadingAnchor.constraint(equalTo: ellipseContainer.leadingAnchor, constant: CoordinateScalor.convert(x: -250)),
            ellipse.trailingAnchor.constraint(equalTo: ellipseContainer.trailingAnchor, constant: CoordinateScalor.convert(x: 250)),
            
            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            stopWatchContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stopWatch.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 210/375),
            stopWatch.heightAnchor.constraint(equalTo: stopWatch.widthAnchor, multiplier: 1),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatchCenterYConstraint,
            
            pitchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            pitchContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            pitch.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 185)),
            pitch.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 111)),
            pitch.centerXAnchor.constraint(equalTo: pitchContainer.centerXAnchor),
            pitchCenterYConstraint,
            
            ])
    }
    
    
    private func animateViewsOnAppear() {
        
        slideViewController(to: .In, offScreenPosition: .Bottom, completion: nil)
        
        stopWatchCenterYConstraint.constant = CoordinateScalor.convert(y: 207)
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.stopWatchContainer.layoutIfNeeded()
        })
        
        pitchCenterYConstraint.constant = CoordinateScalor.convert(y: 429)
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.pitchContainer.layoutIfNeeded()
        })
        
        ellipseTopConstraint.constant = CoordinateScalor.convert(y: 60)
        ellipseBottomConstraint.constant = CoordinateScalor.convert(y: -100 - 24)
        UIView.animate(withDuration: 4, delay: 1, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.ellipseContainer.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func animateEllipse(up: Bool, color: UIColor?, completion: (() -> Void)?) {
        
        ellipseBottomConstraint.constant = up ? CoordinateScalor.convert(y: -100 - 24) : CoordinateScalor.convert(y: -100)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.ellipseContainer.layoutIfNeeded()
            self.messageContainer.backgroundColor = (up && color != nil) ? color : UIColor.clear
        }) { (finished) in
            self.ellipseUp = up
            completion?()
        }
    }
    
    
    
    // MARK: - Private Methods
    
    @objc private func showMenu(sender: Hamburger, forEvent event: UIEvent) {
        
        print("menu")
    }
}



extension TimerVC: StopWatchDelegate {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?) {
        
        switch stopWatchTimer.state {
        case .WaitingToStart:
            message = ""
            animateEllipse(up: false, color: nil, completion: {
                completionHandler?()
            })
        case .RunningCountDown:
            if ellipseUp {
                message = ""
                animateEllipse(up: false, color: nil, completion: nil)
            }
            completionHandler?()
        case .RunningCountUp:
            message = LS_HALFTIME
            completionHandler?()
        case .Paused:
            completionHandler?()
        case .Overdue:
            animateEllipse(up: true, color: COLOR.DarkBackground, completion: {
                self.message = LS_OVERTIME
                completionHandler?()
            })
        case .Ended:
            message = LS_FULLTIME
            completionHandler?()
        }
    }
    
    func handleTickOverdue() {
        
        var updatedMessage = LS_OVERDUE_MESSAGE_BEGINS
        updatedMessage.append(stopWatch.messageLabelTimeString())
        message = updatedMessage
    }
    
    func handleNewGame() {
        
        game = HockeyGame(duration: .Fifteen)
        stopWatch.game = game
        stopWatch.reset()
        stopWatch.setNeedsLayout()
        animateEllipse(up: false, color: nil, completion: nil)
        message = ""
    }

}



