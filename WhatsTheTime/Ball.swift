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
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
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
        }, completion: nil)
        
    }
    
    @objc private func handleRightSwipe(recognizer: UISwipeGestureRecognizer) {
        
        guard let pitch = superview else { return }
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseIn], animations: {
            self.frame = self.frame.offsetBy(dx: pitch.bounds.width / 2 + self.bounds.width / 2, dy: 0)
        }, completion: nil)
        
    }
    
}


