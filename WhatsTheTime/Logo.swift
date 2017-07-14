//
//  Logo.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 14/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Logo: UIView {

    
    // MARK: - Properties
    
    @IBOutlet weak var whatsTheTime: UILabel!
    @IBOutlet weak var hockey: UILabel!
    @IBOutlet weak var ref: UILabel!
    @IBOutlet weak var questionMark: UILabel!
    
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
        
        whatsTheTime.textColor = COLOR.Theme
        hockey.textColor = COLOR.Theme
        ref.textColor = COLOR.Theme
        questionMark.textColor = COLOR.Theme
    }
    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}
