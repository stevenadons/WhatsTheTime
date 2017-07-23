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
        case RunningCountDown
        case RunningCountUp
        case Paused
        case Overdue
        case Ended
    }
    
    
    // MARK: - Properties
    
    var state: State = .WaitingToStart
    var progress: CGFloat {
        return CGFloat(totalSecondsInHalf - totalSecondsToGo) / CGFloat(totalSecondsInHalf)
    }
    
    private var timer: Timer!
    private var delegate: StopWatchTimerDelegate!
    
    private var totalSecondsInHalf: Int = MinutesInHalf.Twenty.rawValue
    var totalSecondsToGo: Int = MinutesInHalf.Twenty.rawValue
    var totalSecondsOverdue: Int = 0
    var totalSecondsCountingUp: Int = 0
    
    
    
    // MARK: - Initializing
    
    required init(delegate: StopWatchTimerDelegate, duration: MinutesInHalf) {
        
        self.delegate = delegate
        self.totalSecondsInHalf = duration.rawValue * 60
        self.totalSecondsToGo = duration.rawValue * 60
    }
    
    
    
    // MARK: - Public Methods
    
    func set(duration: MinutesInHalf) {
        
//        totalSecondsInHalf = duration.rawValue * 60
//        totalSecondsToGo = duration.rawValue * 60
        
        totalSecondsInHalf = 5
        totalSecondsToGo = 5

    }
    
    func startCountDown() {
        
        guard state == .WaitingToStart || state == .Paused else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tickCountDown), userInfo: nil, repeats: true)
        state = .RunningCountDown
    }
    
    func startCountUp() {
        
        guard state == .Ended else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tickCountUp), userInfo: nil, repeats: true)
        state = .RunningCountUp
    }
    
    func pause() {
        
        guard state == .RunningCountDown || state == .RunningCountUp else { return }
        timer.invalidate()
        state = .Paused
    }
    
    func stopCountDown() {
        
        guard state == .Overdue || state == .RunningCountDown else { return }
        timer.invalidate()
        totalSecondsOverdue = 0
        state = .Ended
    }
    
    func stopCountUp() {
        
        guard state == .RunningCountUp else { return }
        timer.invalidate()
        totalSecondsCountingUp = 0
        state = .Ended
    }
    
    func reset() {
        
        guard state != .WaitingToStart else { return }
        timer.invalidate()
        totalSecondsToGo = totalSecondsInHalf
        delegate.handleTimerReset()
        state = .WaitingToStart
    }
    
    
    
    // MARK: - Private Methods

    @objc private func tickCountDown() {
        
        if totalSecondsToGo >= 1 {
            // Count down
            totalSecondsToGo -= 1
            if totalSecondsToGo < 1 {
                // Reached zero
                state = .Overdue
                delegate.handleReachedZero()
            } else {
                // Keep on counting down
                delegate.handleTickCountDown(overdue: false)
            }
        } else {
            // Overdue - count up
            totalSecondsOverdue += 1
            delegate.handleTickCountDown(overdue: true)
        }
    }
    
    @objc private func tickCountUp() {
        
        totalSecondsCountingUp += 1
        delegate.handleTickCountUp()
    }


    
}
