//
//  StopWatchArrowLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 27/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchArrowLayer: CALayer {
    
    
    // MARK: - Properties
    
    var arrow: CAShapeLayer!
    var dimension: CGFloat = 2
    
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
        
        // Set up sublayers
        arrow = createArrow()
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        arrow.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        arrow.position = CGPoint(x: 75, y: 150)

        // Add sublayers
        addSublayer(arrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.arrow.position = CGPoint(x: bounds.size.width / 2, y: dimension / 2)
    }
    
    
    
    // MARK: - Methods to create shapes
    
    private func createArrow() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = createCirclePath().cgPath
        shape.fillColor = COLOR.Theme.cgColor
        return shape
    }
    
    private func createCirclePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: dimension / 2, y: 0))
        path.addArc(withCenter: CGPoint(x: dimension / 2, y: dimension / 2), radius: dimension, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        return path
    }


}
