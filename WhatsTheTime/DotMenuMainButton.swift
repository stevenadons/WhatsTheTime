//
//  DotMenuMainButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DotMenuMainButton: UIButton {

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
    
    private var buttonLayer: DotMenuMainButtonLayer!
    
    
    
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
        buttonLayer = DotMenuMainButtonLayer()
        layer.addSublayer(buttonLayer)
    }
    
    convenience init(shapeColor: UIColor, bgColor: UIColor) {
        self.init()
        convenienceSet(shapeColor: shapeColor, bgColor: bgColor)
    }
    
    private func convenienceSet(shapeColor: UIColor, bgColor: UIColor) {
        self.shapeColor = shapeColor
        self.bgColor = bgColor
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        buttonLayer.frame = bounds
    }
    
    
    // MARK: - User Methods
    
    func invertColors() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        buttonLayer.shapeColor = bgColor
        buttonLayer.bgColor = COLOR.Blue
        CATransaction.commit()
//        buttonLayer.setNeedsDisplay()
    }
    
    func resetColors() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        buttonLayer.shapeColor = shapeColor
        buttonLayer.bgColor = bgColor
        CATransaction.commit()
//        buttonLayer.setNeedsDisplay()
    }
    


}
