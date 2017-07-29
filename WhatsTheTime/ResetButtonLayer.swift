//
//  ResetButtonLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ResetButtonLayer: CALayer {

    
    // MARK: - Properties
    
    var shape: CAShapeLayer!
    var arrow: CAShapeLayer!
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        backgroundColor = COLOR.White.cgColor
        
        // Set up and add sublayers
        shape = createShape(path: createPath())
        addSublayer(shape)
        arrow = createShape(path: createArrow())
        arrow.fillColor = COLOR.Theme.lighter(by: 30).cgColor
        addSublayer(arrow)
        
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
        arrow.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        arrow.bounds = bounds
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape(path: UIBezierPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 1
        shape.strokeColor = COLOR.Theme.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 7, y: 18))
        path.addLine(to: CGPoint(x: 10, y: 22))
        path.addLine(to: CGPoint(x: 15, y: 18))
        path.move(to: CGPoint(x: 10, y: 22))
        path.addArc(withCenter: CGPoint(x: 22, y: 22), radius: 12, startAngle: -.pi, endAngle: .pi * 3 / 4, clockwise: true)
        return path
    }
    
    private func createArrow() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: 18))
        path.addLine(to: CGPoint(x: 20, y: 26))
        path.addLine(to: CGPoint(x: 27, y: 22))
        path.close()
        return path
    }
    

}
