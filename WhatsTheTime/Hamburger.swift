//
//  Hamburger.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 20/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Hamburger: UIButton {

    
    // MARK: - Properties
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    
    
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
        line3.backgroundColor = COLOR.Theme
        
        line1.isUserInteractionEnabled = false
        line2.isUserInteractionEnabled = false
        line3.isUserInteractionEnabled = false
    }
    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
}
