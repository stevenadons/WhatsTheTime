//
//  StopWatchTimer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


class StopWatchTimer {
    
    
    // MARK: - Helper classes
    
    enum State {
        
        case WaitingToStart
        case Running
        case Paused
        case Ended
    }
    
    
    // MARK: - Properties
    
    private var timer: Timer!
    var state: State = .WaitingToStart
    private var delegate: StopWatchTimerDelegate!
    
    private var totalSecondsInHalf: Int = 60 * 25
    private var totalSecondsToGo: Int = 60 * 25
    private var secondsToGo: Int {
        return totalSecondsToGo % 60
    }
    private var minutesToGo: Int {
        return totalSecondsToGo / 60
    }
    
    
    
    // MARK: - Initializing
    
    required init(delegate: StopWatchTimerDelegate) {
        
        self.delegate = delegate
    }
    
    
    
    // MARK: - Public Methods
    
    func start() {
        
        guard state == .WaitingToStart else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        state = .Running
        
    }
    
    func pause() {
        
        guard state == .Running else { return }
        timer.invalidate()
        delegate.handlePause(for: self)
        state = .Paused
    }
    
    func reset() {
        
        guard state != .WaitingToStart else { return }
        timer.invalidate()
        delegate.handleReset(for: self)
        totalSecondsToGo = totalSecondsInHalf
        state = .WaitingToStart
    }
    
    func timeString() -> String {
        
        var timeString: String = ""
        if minutesToGo < 10 {
            timeString.append("0")
        }
        timeString.append("\(minutesToGo):\(secondsToGo)")
        return timeString
    }
    
    
    // MARK: - Private Methods

    @objc private func tick() {
        
        totalSecondsToGo -= 1
        if secondsToGo < 1 {
            // Reached zero
            timer.invalidate()
            delegate.handleReachedZero(for: self, timeString: timeString())
            state = .Ended
        } else {
            // Keep on counting
            delegate.handleTick(for: self, timeString: timeString())
        }
    }
    
    
    
    
    
    
}
