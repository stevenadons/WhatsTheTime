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
    
    private var leftSwipe: UISwipeGestureRecognizer!
    private var rightSwipe: UISwipeGestureRecognizer!
    private var centerFrame: CGRect!
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

        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(recognizer:)))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(recognizer:)))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: bounds.width, height: bounds.height)
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    func repositionBall(withDelay delay: Double) {
        
        isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseOut], animations: {
            self.frame = self.centerFrame
        }) { (finished) in
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
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
    
    @objc private func handleLeftSwipe(recognizer: UISwipeGestureRecognizer) {
        
        guard let pitch = superview else { return }
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseIn], animations: {
            self.frame = self.frame.offsetBy(dx: -pitch.bounds.width / 2 - self.bounds.width / 2, dy: 0)
        }, completion: { (finished) in
            self.delegate?.homeScored()
            self.alpha = 0.0
            self.repositionBall(withDelay: 1.0)
        })
        
    }
    
    @objc private func handleRightSwipe(recognizer: UISwipeGestureRecognizer) {
        
        guard let pitch = superview else { return }
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseIn], animations: {
            self.frame = self.frame.offsetBy(dx: pitch.bounds.width / 2 + self.bounds.width / 2, dy: 0)
        }, completion: { (finished) in
            self.delegate?.awayScored()
            self.alpha = 0.0
            self.repositionBall(withDelay: 1.0)
//            self.frame = self.centerFrame
//            self.setNeedsLayout()
        })
        
    }
    
}


