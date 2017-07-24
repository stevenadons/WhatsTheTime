//
//  StopWatchPointer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 24/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchPointer: UIView {

    
    // MARK: - Helper Classes
    
    
    
    // MARK: - Properties
    
    var color: UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var container: CALayer!
    private var shape: CAShapeLayer!
    private var path: UIBezierPath!
    private var width: CGFloat = 12
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(color: UIColor, width: CGFloat) {
        
        self.init()
        self.color = color
        self.width = width
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layoutOrAnimateSublayers()
        shape.fillColor = color.cgColor
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
            container.bounds = CGRect(x: 0, y: 0, width: width, height: width)
            container.position = CGPoint(x: bounds.width / 2, y: width / 2)
        }
        if shape.superlayer == container {
            // Properties to change when layout occurs - will animate or not
            shape.frame = container.bounds
//            //  Custom = add animations to include in CATransaction + set animated properties
//            let pathAnimation = CABasicAnimation(keyPath: "path")
//            shape.add(pathAnimation, forKey: "path")
//            shape.path = triangularPath().cgPath
        }
        CATransaction.commit()
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        shape.path = triangularPath().cgPath
        shape.setNeedsDisplay()
    }
    
    //  Sometimes it is necessary for a view to ignore touch events and pass them through to the views below. For example, assume a transparent overlay view placed above all other application views. The overlay has some subviews in the form of controls and buttons which should respond to touches normally. But touching the overlay somewhere else should pass the touch events to the views below the overlay.
    //  http://smnh.me/hit-testing-in-ios/
    //
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var hitTestView = super.hitTest(point, with: event)
        if hitTestView == self {
            hitTestView = nil
        }
        return hitTestView
    }
    
    
    
    // MARK: - UI methods
    
    private func setup() {
        
        // Configure self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        // Add containerView
        container = CALayer()
        container.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(container)
        
        // Add shape
        shape = CAShapeLayer()
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = color.cgColor
        shape.contentsScale = UIScreen.main.scale
        shape.path = triangularPath().cgPath
        container.addSublayer(shape)
    }
    
    private func triangularPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: container.bounds.width * 0.50, y: 0))
        path.addLine(to: CGPoint(x: container.bounds.width, y: container.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: container.bounds.height))
        path.close()
        return path
    }
    
    
    
    // MARK: - Math methods
    

}
