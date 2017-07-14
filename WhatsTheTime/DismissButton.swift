//
//  DismissButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 14/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DismissButton: UIButton {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
   
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: - Public UI Methods
    
    override func awakeFromNib() {
        
        line1.backgroundColor = COLOR.Theme
        line2.backgroundColor = COLOR.Theme
        
        line1.isUserInteractionEnabled = false
        line2.isUserInteractionEnabled = false
        
        transform = CGAffineTransform(rotationAngle: .pi/4)
    }
    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    
    
}
