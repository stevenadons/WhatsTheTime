//
//  StopWatchView.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 20/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchView: UIView {

    
    
    // MARK: - Properties
    
    var stopWatch: StopWatch!
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        stopWatch.frame = self.bounds
    }
    
    
    
    // MARK: - Private methods
    
    private func setUp() {
        
        self.backgroundColor = UIColor.clear
        stopWatch = StopWatch()
        self.addSubview(stopWatch)
        
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }

}
