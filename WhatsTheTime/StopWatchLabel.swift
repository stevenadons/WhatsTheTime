//
//  StopWatchLabel.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


class StopWatchLabel: UIView {
    
    
    // MARK: - Helper Classes
    
    
    
    
    // MARK: - Properties
    
    var text: String = "25:00" {
        didSet {
            label.setNeedsDisplay()
        }
    }
    
    private var label: UILabel!
    private var timer: StopWatchTimer?
    
    
    
    // MARK: - Initializers
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    convenience init(timer: StopWatchTimer) {
        
        self.init()
        self.timer = timer
    }
    
    
    
    // MARK: - Public methods
    
    
    
    
    
    // MARK: - UI methods
    
    private func setup() {
        
        // Configure self
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        
        // Add label
        label = label(text: text, alignment: .center)
        addSubview(label)
        
        // Set constraints
        NSLayoutConstraint.activate([
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            
            ])
    }
    
    
    private func label(text: String, alignment: NSTextAlignment) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.textColor = COLOR.Theme
        label.text = text
        label.textAlignment = alignment
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.font = UIFont(name: FONTNAME.MenuButton, size: 54)
        return label
    }
    
    
    
    
    // MARK: - Math methods
    
   

    
}
