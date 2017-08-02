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
    
    private var ball: Ball!
    private var background: PitchBackgroundLayer!
    fileprivate var delegate: PitchDelegate?
    
    
    
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
        
        ball = Ball(delegate: self)
        addSubview(ball)
        
        // Childviews - constraints (or in layoutSubviews ?)
        NSLayoutConstraint.activate([
            ball.centerXAnchor.constraint(equalTo: centerXAnchor),
            ball.centerYAnchor.constraint(equalTo: centerYAnchor),
            ball.heightAnchor.constraint(equalToConstant: 40),
            ball.widthAnchor.constraint(equalToConstant: 40),
            ])
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        background.frame = bounds
        background.layoutIfNeeded()
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
        
        delegate?.scoreHome()
    }
    
    func awayScored() {
        
        delegate?.scoreAway()
    }
}
