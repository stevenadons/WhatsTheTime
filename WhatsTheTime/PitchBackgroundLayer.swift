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
        masksToBounds = true
        
        // Set up sublayers
        edge = createEdge(path: edgePath())
        edge.bounds = CGRect(x: 0, y: 0, width: 375, height: 138)
        edge.position = position
        center = createCenter(path: centerPath())
        center.bounds = CGRect(x: 0, y: 0, width: 375, height: 138)
        center.position = position
        
        // Set bounds if layer has to be fixed size
        bounds = CGRect(x: 0, y: 0, width: 375, height: 138)
        
        // Add sublayers
        addSublayer(edge)
        addSublayer(center)
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
        center.bounds = bounds
        center.position = position
        center.path = centerPath().cgPath
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
        let width = bounds.width
        let height = bounds.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: width/2, y: height * 36/138), controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: width/4, y: height * 36/138))
        path.addCurve(to: CGPoint(x: width, y: 0), controlPoint1: CGPoint(x: width * 3/4, y: height * 36/138), controlPoint2: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addCurve(to: CGPoint(x: width/2, y: height - height * 36/138), controlPoint1: CGPoint(x: width, y: height), controlPoint2: CGPoint(x: width * 3/4, y: height - height * 36/138))
        path.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: width/4, y: height - height * 36/138), controlPoint2: CGPoint(x: 0, y: height))
        path.close()
        return path
    }
    
    private func createCenter(path: UIBezierPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = COLOR.White.cgColor
        shape.fillColor = COLOR.PitchBlue.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func centerPath() -> UIBezierPath {
        let width = bounds.width
        let height = bounds.height
        let outerInset: CGFloat = 17
        let innerInset: CGFloat = 8
        let offScreen: CGFloat = 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -offScreen, y: 0 + outerInset))
        path.addCurve(to: CGPoint(x: width/2, y: height * 36/138 + innerInset), controlPoint1: CGPoint(x: -offScreen, y: outerInset), controlPoint2: CGPoint(x: width/4, y: height * 36/138 + innerInset))
        path.addCurve(to: CGPoint(x: width + offScreen, y: outerInset), controlPoint1: CGPoint(x: width * 3/4, y: height * 36/138 + innerInset), controlPoint2: CGPoint(x: width + offScreen, y: outerInset))
        path.addLine(to: CGPoint(x: width + offScreen, y: height - outerInset))
        path.addCurve(to: CGPoint(x: width/2, y: height - height * 36/138 - innerInset), controlPoint1: CGPoint(x: width + offScreen, y: height - outerInset), controlPoint2: CGPoint(x: width * 3/4, y: height - height * 36/138 - innerInset))
        path.addCurve(to: CGPoint(x: -offScreen, y: height - outerInset), controlPoint1: CGPoint(x: width/4, y: height - height * 36/138 - innerInset), controlPoint2: CGPoint(x: -offScreen, y: height - outerInset))
        path.close()
        return path
    }


}
