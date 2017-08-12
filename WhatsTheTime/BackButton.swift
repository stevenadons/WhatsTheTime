//
//  BackButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    
    
    // MARK: - Properties
    
    private var shape: BackButtonLayer!
    
    
    
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
        
        backgroundColor = COLOR.Affirmation
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        
        shape = BackButtonLayer()
        layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        shape.frame = bounds
    }

}
