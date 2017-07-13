//
//  RadialGradientLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 13/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {

    
    // MARK: - Properties
    
    var center: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    var radius: CGFloat {
        return ((bounds.width + bounds.height) / 2) / 2
    }
    
    var colors: [UIColor] = [UIColor.blue, UIColor.red] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cgColors: [CGColor] {
        return colors.map({ (color) -> CGColor in
            return color.cgColor
        })
    }
    
    var locations: [CGFloat] = [0.0, 1.0] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
    }
   
    
    override init(layer: Any) {
        
        super.init()
    }
    
    
    
    // MARK: - Public Methods

    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            return
        }
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
}
