//
//  DotMenuItemLabel.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DotMenuItemLabel: UILabel {

    // MARK: - Properties
    
    var title: String = "" {
        didSet {
            text = title
            setNeedsDisplay()
        }
    }
    var color: UIColor = UIColor.white {
        didSet {
            textColor = color
            setNeedsDisplay()
        }
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
        backgroundColor = UIColor.clear
        text = title
        font = UIFont.boldSystemFont(ofSize: 13)
        adjustsFontSizeToFitWidth = true
        isUserInteractionEnabled = false
        textAlignment = .left
        textColor = color
    }
    
    
    // MARK: - User Methods
    
    func grow(text: String, duration: Double) {
        let charCount = text.characters.count
        var index: Int = 0
        let _ = Timer.scheduledTimer(withTimeInterval: duration / Double(charCount), repeats: true) { (timer) in
            self.title = "\(String(text.characters.prefix(index)))"
            index += 1
            if index > charCount {
                timer.invalidate()
            }
        }
    }


}
