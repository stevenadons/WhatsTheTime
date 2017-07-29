//
//  BackgroundCircle.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class BackgroundCircle: UIView {

    
    // MARK: - Properties
    
    var circle: CAShapeLayer!
    var path: UIBezierPath!
    var color: UIColor = UIColor.white {
        didSet {
            circle.setNeedsLayout()
        }
    }
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutOrAnimateSublayers()
        circle.fillColor = color.cgColor
    }
    
    func layoutOrAnimateSublayers() {
        
        CATransaction.begin()
        
        // Check whether animation is going on (bounds.size, bounds.origin or position)
        if let animation = layer.animation(forKey: "bounds.size") {
            // Self is animating
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
        } else {
            // Self is not animating
            CATransaction.disableActions()
        }
        if circle.superlayer == layer {
            // Properties to change when layout occurs - will animate or not
            circle.bounds = bounds.insetBy(dx: (bounds.width - bounds.height) / 2, dy: 0)
            circle.frame.origin = CGPoint(x: (bounds.width - bounds.height) / 2, y: 0)
            //  Custom = add animations to include in CATransaction + set animated properties
            let pathAnimation = CABasicAnimation(keyPath: "path")
            circle.add(pathAnimation, forKey: "path")
            circle.path = UIBezierPath(ovalIn: circle.bounds).cgPath
        }
        CATransaction.commit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        circle.setNeedsDisplay()
    }
    
    
    
    // MARK: - Public UI Methods
    
    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        // Configure self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add circle
        circle = CAShapeLayer()
        circle.strokeColor = UIColor.clear.cgColor
        circle.fillColor = color.cgColor
        layer.addSublayer(circle)
    }

}
