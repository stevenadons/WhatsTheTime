//
//  ResetButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ResetButton: UIButton {

    // MARK: - Properties
    
    private var shapeLayer: ResetButtonLayer!
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        // Configuring self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        
        // Add (passive) shapes
        shapeLayer = ResetButtonLayer()
        layer.addSublayer(shapeLayer)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Cornerradius for round views
        layer.cornerRadius = bounds.height / 2
        
        // Adjusting sublayers dimensions to change in UIView dimensions
        shapeLayer.frame = bounds
        
    }

}
