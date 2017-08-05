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
    
    var normalConstraint: NSLayoutConstraint?
    var stretchedConstraint: NSLayoutConstraint?
    var shrunkenConstraint: NSLayoutConstraint?
    var activeConstraint: NSLayoutConstraint?
    var menuItem: MenuItem!
    
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
    
    
    convenience init(text: String, menuItem: MenuItem) {
        
        self.init()
        self.text = text
        self.menuItem = menuItem
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
    
    
    // MARK: - User Methods
    
    func fade(duration: Double, delay: Double, completion: (() -> Void)?) {
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
            self.alpha = 0.0
        }) { (finished) in
            completion?()
        }
    }
    
    func pop(duration: Double, delay: Double, completion: (() -> Void)?) {

        transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
        }) { (finished) in
            completion?()
        }
    }

    
    
    // MARK: - Private UI Methods
    
    private func setup() {
        
        backgroundColor = COLOR.White
        translatesAutoresizingMaskIntoConstraints = false
        
        setTitle(text, for: .normal)
        setTitleColor(COLOR.Theme, for: .normal)
        titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 12)
    }
    

    

}
