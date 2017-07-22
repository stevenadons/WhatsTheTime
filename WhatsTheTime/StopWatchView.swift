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
    
    private var stopWatchUI: StopWatchUI!
    private var timeLabel: StopWatchLabel!
    private var icon: StopWatchControlIcon!
    private var timer: StopWatchTimer!
    
    
    
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
        
        stopWatchUI.frame = bounds
        icon.frame = bounds.insetBy(dx: (130 * bounds.width / 230) / 2, dy: (130 * bounds.width / 230) / 2)
        timeLabel.frame = bounds.insetBy(dx: stopWatchUI.coreSide * 0.25, dy: stopWatchUI.coreSide * 0.35)
    }
    
    
    
    // MARK: - Private methods
    
    private func setUp() {
        
        self.backgroundColor = UIColor.clear
        
        stopWatchUI = StopWatchUI(delegate: self)
        addSubview(stopWatchUI)
        
        icon = StopWatchControlIcon(icon: .Pause)
        icon.color = COLOR.Affirmation
        addSubview(icon)
        
        timer = StopWatchTimer(delegate: self)
        
        timeLabel = StopWatchLabel(timer: timer)
        addSubview(timeLabel)
        
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



