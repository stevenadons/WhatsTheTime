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
    
    var shape: CAShapeLayer!
    
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        backgroundColor = COLOR.White.cgColor
        
        // Set up sublayers
        shape = createShape()
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shape.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // Set bounds if layer has to be fixed size
        bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // Add sublayers
        addSublayer(shape)
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
        self.shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = createPath().cgPath
        shape.lineWidth = 2.5
        shape.strokeColor = COLOR.Theme.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
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
