//
//  MenuButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MenuButton: UIButton {

    
    // MARK: - Properties
    
    var text: String! {
        didSet {
            setNeedsLayout()
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
    
    
    convenience init(text: String) {
        
        self.init()
        self.text = text
    }
    
  
    
    // MARK: - Public Methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        setTitle(text, for: .normal)

    }
    
    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        backgroundColor = COLOR.White
        translatesAutoresizingMaskIntoConstraints = false
        
        setTitle(text, for: .normal)
        setTitleColor(COLOR.Theme, for: .normal)
        titleLabel?.font = UIFont(name: FONTNAME.MenuButton, size: 12)
    }

}
