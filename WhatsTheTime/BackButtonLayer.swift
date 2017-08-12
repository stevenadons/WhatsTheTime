//
//  BackButtonLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class BackButtonLayer: CALayer {

    
    
    // MARK: - Properties
    
    private var shape: CAShapeLayer!
    
    private let designWidth: CGFloat = 44
    private let designHeight: CGFloat = 44
    
    var color: UIColor = COLOR.Theme {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        backgroundColor = UIColor.clear.cgColor
        shape = createShape()
        addSublayer(shape)
        bounds = CGRect(x: 0, y: 0, width: designWidth, height: designHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
//        cornerRadius = min(bounds.width, bounds.height) / 2
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.strokeColor = color.cgColor
        shape.path = createPath().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = createPath().cgPath
        shape.lineWidth = 1
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 25 * widthScale, y: 13 * heightScale))
        path.addLine(to: CGPoint(x: 16 * widthScale, y: 22 * heightScale))
        path.addLine(to: CGPoint(x: 25 * widthScale, y: 31 * heightScale))
        return path
    }
}
