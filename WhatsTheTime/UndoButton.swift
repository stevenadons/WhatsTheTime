//
//  UndoButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class UndoButton: UIButton {

    
    // MARK: - Properties
    
    var color: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(color: UIColor) {
        self.init()
        self.color = color
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Drawing and layout Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = color
    }
    
    
  

}
