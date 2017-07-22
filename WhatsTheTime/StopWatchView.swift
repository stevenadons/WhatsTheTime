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
    
    func handleTick(for: StopWatchTimer, timeString: String)
    func handlePause(for: StopWatchTimer)
    func handleReset(for: StopWatchTimer)
    func handleReachedZero(for: StopWatchTimer, timeString: String)

}


class StopWatchView: UIView {

    
    // MARK: - Properties
    
    private var stopWatchUI: StopWatchUI!
    
    fileprivate var delegate: StopWatchViewDelegate!
    fileprivate var timer: StopWatchTimer!
    fileprivate var icon: StopWatchControlIcon!
    fileprivate var timeLabel: StopWatchLabel!

    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    convenience init(delegate: StopWatchViewDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        stopWatchUI.frame = bounds
        icon.frame = bounds.insetBy(dx: (130 * bounds.width / 230) / 2, dy: (130 * bounds.height / 230) / 2)
        timeLabel.frame = bounds.insetBy(dx: bounds.width * 0.15, dy: bounds.height * 0.35)
    }
    
    
    
    // MARK: - Private methods
    
    private func setUp() {
        
        self.backgroundColor = UIColor.clear
        
        stopWatchUI = StopWatchUI(delegate: self)
        addSubview(stopWatchUI)
        
        icon = StopWatchControlIcon(icon: .PlayIcon)
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
        
        print("tapped")

        switch icon.icon {
        case .PlayIcon:
            timer.start()
            delegate.handleTimerStateChanged(stopWatchTimer: timer)
        case .PauseIcon:
            timer.pause()
            delegate.handleTimerStateChanged(stopWatchTimer: timer)
        case .StopIcon:
            timer.pause()
            delegate.handleTimerStateChanged(stopWatchTimer: timer)
        }
    }
}


extension StopWatchView: StopWatchTimerDelegate {
    
    func handleTick(for: StopWatchTimer, timeString: String) {
        
        timeLabel.text = timeString
    }
    
    func handlePause(for: StopWatchTimer) {
    }
    
    func handleReset(for: StopWatchTimer) {
    }
    
    func handleReachedZero(for: StopWatchTimer, timeString: String) {
        
        timeLabel.text = timeString
    }
}



