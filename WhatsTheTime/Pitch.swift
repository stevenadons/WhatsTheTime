//
//  Pitch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Pitch: UIView {

    
    // MARK: - Properties
    
    private var childView: UIView!
    private var striping: PitchStripingLayer!
    
    private var pitchFrame: CGRect = CGRect.zero
    private var viewRatio: CGFloat {
        return bounds.width / bounds.height
    }
    
    
    
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
        
        backgroundColor = COLOR.Theme
        translatesAutoresizingMaskIntoConstraints = false
        
        striping = PitchStripingLayer()
        striping.frame = bounds
        layer.addSublayer(striping)
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if viewRatio > striping.designRatio {
            let inset = (bounds.width - bounds.height * striping.designRatio) / 2
            pitchFrame = bounds.insetBy(dx: inset, dy: 0).insetBy(dx: 15, dy: 15)
        } else {
            let inset = (bounds.height - bounds.width / striping.designRatio) / 2
            pitchFrame = bounds.insetBy(dx: 0, dy: inset).insetBy(dx: 15, dy: 15)
        }
        
        striping.frame = pitchFrame
        striping.setNeedsLayout()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        striping.setNeedsDisplay()
    }
    

}
