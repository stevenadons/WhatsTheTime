//
//  HamburgerButtonLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class HamburgerButtonLayer: CALayer {

    
    // MARK: - Properties
    
    // Shapes (passive or animating)
    var hamburger: CAShapeLayer!
    
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
        backgroundColor = COLOR.White.cgColor
        
        // Set up sublayers
        hamburger = createHamburger()
        hamburger.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hamburger.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // Set bounds if layer has to be fixed size
        bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // Add sublayers
        addSublayer(hamburger)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        cornerRadius = min(bounds.width, bounds.height) / 2
        self.hamburger.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createHamburger() -> CAShapeLayer {
        let hamburger = CAShapeLayer()
        hamburger.path = createPath().cgPath
        hamburger.strokeColor = COLOR.Theme.cgColor
        hamburger.fillColor = UIColor.clear.cgColor
        return hamburger
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 12, y: 17))
        path.addLine(to: CGPoint(x: 32, y: 17))
        path.move(to: CGPoint(x: 12, y: 22))
        path.addLine(to: CGPoint(x: 32, y: 22))
        path.move(to: CGPoint(x: 12, y: 27))
        path.addLine(to: CGPoint(x: 32, y: 27))
        return path
    }

}
