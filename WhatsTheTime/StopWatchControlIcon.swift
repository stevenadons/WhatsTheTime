//
//  StopWatchControlIcon.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchControlIcon: UIView {

    
    // MARK: - Helper Classes
    
    enum Icon {
        
        case Play
        case Pause
        case Stop
    }
    
    
    // MARK: - Properties
    
    var icon: Icon = .Play {
        didSet {
            shape.setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.white {
        didSet {
//            shape.setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var container: CALayer!
    private var shape: CAShapeLayer!
    private var path: UIBezierPath!

    
    // MARK: - Initializers
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    convenience init(icon: Icon) {
        
        self.init()
        self.icon = icon
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
            container.frame = bounds
            
        }
        
        if shape.superlayer == container {
            
            // Properties to change when layout occurs - will animate or not
            shape.frame = bounds
            
            //  Custom = add animations to include in CATransaction + set animated properties
            let pathAnimation = CABasicAnimation(keyPath: "path")
            shape.add(pathAnimation, forKey: "path")
            shape.path = path(for: icon).cgPath
        }
        
        CATransaction.commit()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        shape.setNeedsDisplay()
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
        shape.path = path(for: icon).cgPath
        container.addSublayer(shape)
    }
    
    private func path(for icon: Icon) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        switch icon {
        case .Play:
            path.move(to: CGPoint(x: bounds.width * 0.14, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.86, y: bounds.height / 2))
            path.addLine(to: CGPoint(x: bounds.width * 0.14, y: bounds.height))
            path.close()
        case .Pause:
            path.move(to: CGPoint(x: bounds.width * 0.14, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.46, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.46, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width * 0.14, y: bounds.height))
            path.close()
            path.move(to: CGPoint(x: bounds.width * 0.54, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.86, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.86, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width * 0.54, y: bounds.height))
            path.close()
        case .Stop:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
            path.close()
        }
        
        return path
    }

    
    
    
    // MARK: - Math methods
    
    

}
