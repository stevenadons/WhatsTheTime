//
//  StopWatchArrow.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 27/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchArrow: UIView {

    
    // MARK: - Properties
    
    private var animationLayer: StopWatchArrowLayer!
    
    
    
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
        
        // Configuring self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
        
        // ANIMATION - Add animationlayer with sublayers to animate
        animationLayer = StopWatchArrowLayer()
        animationLayer.frame = bounds
        layer.addSublayer(animationLayer)
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        animationLayer.frame = bounds
        animationLayer.setNeedsLayout()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        animationLayer.setNeedsDisplay()
    }
    
    
    // MARK: - ANIMATION Methods
    
    func startAnimation() {
        
        alpha = 1.0
        let groupedAnimation = CAAnimationGroup()
        groupedAnimation.animations = [spinAnimation(), rotateAnimation()]
        groupedAnimation.duration = 1
        groupedAnimation.repeatCount = .infinity
        animationLayer.arrow.add(groupedAnimation, forKey: "spinAndRotate")
    }
    
    func pauseAnimation() {
        
        let pausedTime = animationLayer.arrow.convertTime(CACurrentMediaTime(), from: nil)
        animationLayer.arrow.speed = 0.0
        animationLayer.arrow.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        
        let pausedTime = animationLayer.arrow.timeOffset
        animationLayer.arrow.speed = 1.0
        animationLayer.arrow.timeOffset = 0.0
        animationLayer.arrow.beginTime = 0.0
        let timeSincePause = animationLayer.arrow.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animationLayer.arrow.beginTime = timeSincePause
    }
    
    func stopAnimationAndReset() {
        
        alpha = 0.0
        animationLayer.arrow.removeAllAnimations()
        animationLayer.arrow.setNeedsLayout()
    }
    
    
    private func spinAnimation() -> CAAnimation {
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: min(bounds.width, bounds.height) / 2 - 6, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = circlePath.cgPath
        return animation
    }
    
    private func rotateAnimation() -> CAAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = M_PI * 2
        return animation
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
