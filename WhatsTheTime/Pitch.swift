//
//  Pitch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 30/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol BallDelegate: class {
    
    func homeScored()
    func awayScored()
}


class Pitch: UIView {

    
    // MARK: - Properties
    
    private var background: PitchBackgroundLayer!
    private var ball: Ball!
    private var homeNameLabel: UILabel!
    private var awayNameLabel: UILabel!
    fileprivate var homeScoreLabel: UILabel!
    fileprivate var awayScoreLabel: UILabel!
    
    fileprivate var delegate: PitchDelegate?
    fileprivate var homeScore: Int = 0
    fileprivate var awayScore: Int = 0
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: PitchDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        background = PitchBackgroundLayer()
        background.frame = bounds
        layer.addSublayer(background)
        
        homeNameLabel = nameLabel(title: LS_HOME)
        addSubview(homeNameLabel)
        awayNameLabel = nameLabel(title: LS_AWAY)
        addSubview(awayNameLabel)
        
        homeScoreLabel = scoreLabel()
        addSubview(homeScoreLabel)
        awayScoreLabel = scoreLabel()
        addSubview(awayScoreLabel)
        
        ball = Ball(delegate: self)
        addSubview(ball)
    }
    
    private func nameLabel(title: String) -> UILabel {
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.Theme
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func scoreLabel() -> UILabel {
        
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 56)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.White
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        background.frame = bounds
        background.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            
            homeNameLabel.heightAnchor.constraint(equalToConstant: 25),
            homeNameLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -38 * bounds.height / 202),
            homeNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            homeNameLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            awayNameLabel.heightAnchor.constraint(equalTo: homeNameLabel.heightAnchor),
            awayNameLabel.topAnchor.constraint(equalTo: homeNameLabel.topAnchor),
            awayNameLabel.widthAnchor.constraint(equalTo: homeNameLabel.widthAnchor),
            awayNameLabel.leadingAnchor.constraint(equalTo: homeNameLabel.trailingAnchor),
            
            homeScoreLabel.heightAnchor.constraint(equalToConstant: 75),
            homeScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            homeScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.5 * bounds.width / 375),
            homeScoreLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 102.5 * bounds.width / 375),

            awayScoreLabel.heightAnchor.constraint(equalTo: homeScoreLabel.heightAnchor),
            awayScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            awayScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width - 102.5 * bounds.width / 375),
            awayScoreLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width - 18.5 * bounds.width / 375),
            
            ball.centerXAnchor.constraint(equalTo: centerXAnchor),
            ball.centerYAnchor.constraint(equalTo: centerYAnchor),
            ball.heightAnchor.constraint(equalToConstant: 40),
            ball.widthAnchor.constraint(equalToConstant: 40),
            
            ])
    }
    
    func showBall() {
        
        ball.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) { 
            self.ball.alpha = 1
        }
    }
    
    func hideBall() {
        
        ball.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.ball.alpha = 0
        }
    }
    
    
    // MARK: - User Methods
    
    func resetScores() {
        
        homeScore = 0
        homeScoreLabel.text = "\(homeScore)"
        awayScore = 0
        awayScoreLabel.text = "\(awayScore)"
    }
    
    fileprivate func updateScore(for game: HockeyGame) {
        
        if homeScoreLabel.text != "\(game.homeScore)" {
            update(label: homeScoreLabel, withText: "\(game.homeScore)")
        } else if awayScoreLabel.text != "\(game.awayScore)" {
            update(label: awayScoreLabel, withText: "\(game.awayScore)")
        }
        
    }
    
    fileprivate func update(label: UILabel, withText text: String) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            label.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (finished) in
            label.text = text
            label.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
            label.textColor = COLOR.Affirmation
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
                label.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.delegate?.scoreLabelChanged()
                UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
                    label.textColor = COLOR.White
                }, completion: nil)
            })
        }
    }
    
    
    // MARK: - Hit testing
    
    //  Sometimes it is necessary for a view to ignore touch events and pass them through to the views below.
    //  For example, assume a transparent overlay view placed above all other application views.
    //  The overlay has some subviews in the form of controls and buttons which should respond to touches normally.
    //  But touching the overlay somewhere else should pass the touch events to the views below the overlay.
    //  http://smnh.me/hit-testing-in-ios/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var hitTestView = super.hitTest(point, with: event)
        if hitTestView == self {
            hitTestView = nil
        }
        return hitTestView
    }
}


extension Pitch: BallDelegate {
    
    func homeScored() {
        
        homeScore += 1
        update(label: homeScoreLabel, withText: "\(homeScore)")
        delegate?.scoreHome()
    }
    
    func awayScored() {
        
        awayScore += 1
        update(label: awayScoreLabel, withText: "\(awayScore)")
        delegate?.scoreAway()
    }
}
