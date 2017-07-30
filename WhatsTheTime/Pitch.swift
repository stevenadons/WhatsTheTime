//
//  Pitch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 30/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Pitch: UIView {

    
    // MARK: - Properties
    
    private var ball: UIView!
    private var background: PitchBackgroundLayer!
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        ball = UIView()
        ball.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ball)
        
//        // Childviews - constraints (or in layoutSubviews ?)
//        NSLayoutConstraint.activate([
//            childView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            childView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            childView.heightAnchor.constraint(equalTo: heightAnchor),
//            childView.widthAnchor.constraint(equalTo: widthAnchor),
//            ])
        
        background = PitchBackgroundLayer()
        background.frame = bounds
        layer.addSublayer(background)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        background.frame = bounds
        background.layoutIfNeeded()
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
