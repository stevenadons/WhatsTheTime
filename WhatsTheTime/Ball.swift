//
//  Ball.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 1/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Ball: UIView {
    

    // MARK: - Properties
    
    private var pan: UIPanGestureRecognizer!
    private var animator: UIViewPropertyAnimator!
    var centerFrame: CGRect!
    private var xOffset: CGFloat!

    fileprivate var delegate: BallDelegate?
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: BallDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    private func setup() {
        
        layer.backgroundColor = COLOR.Affirmation.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        clipsToBounds = true
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
        addGestureRecognizer(pan)
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerFrame = CGRect(x: (superview!.bounds.width - bounds.width) / 2, y: (superview!.bounds.height - bounds.height) / 2, width: bounds.width, height: bounds.height)
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    
    func repositionBall(withDelay delay: Double) {
        
        isUserInteractionEnabled = true
        frame = self.centerFrame

        UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    
    
    // MARK: - Touch methods
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let distance = sqrt(pow(point.x - bounds.midX, 2) + pow(point.y - bounds.midY, 2))
        if distance <= min(bounds.width, bounds.height) {
            return true
        }
        return false
    }
    
    @objc private func handlePan(pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: superview!)
        
        switch pan.state {
            
        case .began:
            xOffset = (UIScreen.main.bounds.width / 2 + bounds.width / 2) * copysign(1.0, translation.x)
            animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5, animations: {
                self.frame = self.centerFrame.offsetBy(dx: self.xOffset, dy: 0)
            })
            animator.pauseAnimation()
            
        case .changed:
            
            if copysign(1.0, translation.x) != copysign(1.0, xOffset) {
                xOffset = (UIScreen.main.bounds.width / 2 + bounds.width / 2) * copysign(1.0, translation.x)
                animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5, animations: {
                    self.frame = self.centerFrame.offsetBy(dx: self.xOffset, dy: 0)
                })
                animator.pauseAnimation()
            }
            animator.fractionComplete = translation.x / xOffset
            _ = checkBallPositionAndHandleScore(homeSide: (translation.x < 0))
            
        case .ended:
            guard checkBallPositionAndHandleScore(homeSide: (translation.x < 0)) == false else { return }
            xOffset = 0
            animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5, animations: {
                self.frame = self.centerFrame
            })
            animator.startAnimation()
            
        default:
            print("other pan state")
        }
        
    }
    
    private func checkBallPositionAndHandleScore(homeSide: Bool) -> Bool {
        
        if animator.fractionComplete > 0.70 {
            if homeSide {
                delegate?.homeScored()
            } else {
                delegate?.awayScored()
            }
            animator.stopAnimation(true)
            alpha = 0
            repositionBall(withDelay: 1.0)
            return true
        }
        return false
    }
    
}


