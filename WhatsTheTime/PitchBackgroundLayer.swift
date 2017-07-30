//
//  PitchBackgroundLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 30/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PitchBackgroundLayer: CALayer {
    
    
    // MARK: - Properties
    
    // Shapes (passive or animating)
    private var edge: CAShapeLayer!
    private var center: CAShapeLayer!
    private var striping: CAShapeLayer!
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
        
        // Set up sublayers
        edge = createEdge(path: edgePath())
        edge.bounds = CGRect(x: 0, y: 0, width: 375, height: 138)
        edge.position = position
        
        // Set bounds if layer has to be fixed size
        bounds = CGRect(x: 0, y: 0, width: 375, height: 138)
        
        // Add sublayers
        addSublayer(edge)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    // Optional: set shape position relating to embedding view's bounds
    override func layoutSublayers() {
        super.layoutSublayers()
        edge.bounds = bounds
        edge.position = position
        edge.path = edgePath().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createEdge(path: UIBezierPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = COLOR.PitchEdge.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func edgePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: 375/2, y: 36), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 375/4, y: 36))
        path.addCurve(to: CGPoint(x: 375, y: 0), controlPoint1: CGPoint(x: 375 * 3/4, y: 36), controlPoint2: CGPoint(x: 375, y: 0))
        path.addLine(to: CGPoint(x: 375, y: 138))
        path.addCurve(to: CGPoint(x: 375/2, y: 102), controlPoint1: CGPoint(x: 375, y: 138), controlPoint2: CGPoint(x: 375 * 3/4, y: 102))
        path.addCurve(to: CGPoint(x: 0, y: 138), controlPoint1: CGPoint(x: 375/4, y: 102), controlPoint2: CGPoint(x: 0, y: 138))
        path.close()
        return path
    }


}
