//
//  StopWatchView.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 20/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol StopWatchUIDelegate: class {
    
    func handleTap(stopWatchUI: StopWatchUI)
}


protocol StopWatchTimerDelegate: class {
    
    func handleTick(for: StopWatchTimer)
    func handlePause(for: StopWatchTimer)
    func handleReset(for: StopWatchTimer)
    func handleReachedZero(for: StopWatchTimer)

}


class StopWatchView: UIView {

    
    // MARK: - Properties
    
    var stopWatchUI: StopWatchUI!
    var timer: StopWatchTimer!
    
    
    
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
        
        stopWatchUI.frame = self.bounds
    }
    
    
    
    // MARK: - Private methods
    
    private func setUp() {
        
        self.backgroundColor = UIColor.clear
        
        stopWatchUI = StopWatchUI(delegate: self)
        self.addSubview(stopWatchUI)
        
        timer = StopWatchTimer(delegate: self)
        
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }

}



extension StopWatchView: StopWatchUIDelegate {
    
    func handleTap(stopWatchUI: StopWatchUI) {
        
        //        if UserDefaults.standard.bool(forKey: SETTINGS_KEY.Sound) {
        //            JukeBox.instance.playSound(SOUND.ButtonTap)
        //        }
        
        // do something
        
        print("tapped")
    }
}


extension StopWatchView: StopWatchTimerDelegate {
    
    func handleTick(for: StopWatchTimer) {
    }
    
    func handlePause(for: StopWatchTimer) {
    }
    
    func handleReset(for: StopWatchTimer) {
    }
    
    func handleReachedZero(for: StopWatchTimer) {
    }
}



