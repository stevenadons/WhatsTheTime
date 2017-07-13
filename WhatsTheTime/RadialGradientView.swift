//
//  RadialGradientView.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 13/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class RadialGradientView: UIView {
    

    // MARK: - Properties

    private let gradientLayer = RadialGradientLayer()
    
    var colors: [UIColor] {
        get {
            return gradientLayer.colors
        }
        set {
            gradientLayer.colors = newValue
        }
    }
    
    var locations: [CGFloat] {
        get {
            return gradientLayer.locations
        }
        set {
            gradientLayer.locations = newValue
        }
    }
    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = bounds
    }

}




