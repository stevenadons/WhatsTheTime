//
//  EllipseView.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 20/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class EllipseView: UIView {

    
    // MARK: - Properties
    
    var container: CALayer!
    var ellipse: CAShapeLayer!
    var path: UIBezierPath!
    var color: UIColor = UIColor.white {
        didSet {
            ellipse.setNeedsDisplay()
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
        
//        container.frame = bounds
//        ellipse.frame = container.bounds
//        ellipse.path = UIBezierPath(ovalIn: bounds).cgPath
        layoutOrAnimateSublayers()
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
        
        if container.superlayer == layer {
            
            // Properties to change when layout occurs - will animate or not
            container.frame = bounds
            
        }
        
        if ellipse.superlayer == container {
            
            // Properties to change when layout occurs - will animate or not
            ellipse.frame = bounds
            
            //  Custom = add animations to include in CATransaction + set animated properties
            let pathAnimation = CABasicAnimation(keyPath: "path")
            ellipse.add(pathAnimation, forKey: "path")
            ellipse.path = UIBezierPath(ovalIn: ellipse.bounds).cgPath
        }
        
        CATransaction.commit()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        ellipse.setNeedsDisplay()
    }

    
    
    // MARK: - Public UI Methods
    
    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        // Configure self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add containerView
        container = CALayer()
        container.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(container)
        
        // Add ellipse
        ellipse = CAShapeLayer()
        ellipse.strokeColor = UIColor.clear.cgColor
        ellipse.fillColor = self.color.cgColor
        container.addSublayer(ellipse)
    }
}
