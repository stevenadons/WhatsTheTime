//
//  DismissButtonLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DismissButtonLayer: CALayer {

    
    // MARK: - Properties
    
    var shape: CAShapeLayer!
    
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        backgroundColor = COLOR.White.cgColor
        
        // Set up and add sublayers
        shape = createShape()
        addSublayer(shape)

        // Set bounds if layer has to be fixed size
        bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
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
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = createPath().cgPath
        shape.lineWidth = 1
        shape.strokeColor = COLOR.Theme.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 15, y: 15))
        path.addLine(to: CGPoint(x: 29, y: 29))
        path.move(to: CGPoint(x: 29, y: 15))
        path.addLine(to: CGPoint(x: 15, y: 29))
        return path
    }

}
