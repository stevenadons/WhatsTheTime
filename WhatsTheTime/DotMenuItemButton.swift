//
//  DotMenuItemButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DotMenuItemButton: UIButton {

    // MARK: - Properties
    
    var shapeColor: UIColor = UIColor.black {
        didSet {
            buttonLayer.shapeColor = shapeColor
            buttonLayer.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = UIColor.cyan {
        didSet {
            buttonLayer.bgColor = bgColor
            buttonLayer.setNeedsDisplay()
        }
    }
    var path: UIBezierPath = UIBezierPath() {
        didSet {
            buttonLayer.path = path
            buttonLayer.setNeedsDisplay()
        }
    }
    private var buttonLayer: DotMenuItemButtonLayer!
    
    
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
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = true
        buttonLayer = DotMenuItemButtonLayer()
        layer.addSublayer(buttonLayer)
    }
    
    convenience init(shapeColor: UIColor, bgColor: UIColor, path: UIBezierPath) {
        self.init()
        convenienceSet(shapeColor: shapeColor, bgColor: bgColor, path: path)
    }
    
    private func convenienceSet(shapeColor: UIColor, bgColor: UIColor, path: UIBezierPath) {
        self.shapeColor = shapeColor
        self.bgColor = bgColor
        self.path = path
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        buttonLayer.frame = bounds
    }


}
