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
    private var totalSecondsOverdue: Int = 0
    
    
    
    // MARK: - Initializing
    
    required init(delegate: StopWatchTimerDelegate, duration: MinutesInHalf) {
        
        self.delegate = delegate
        self.totalSecondsInHalf = duration.rawValue * 60
        self.totalSecondsToGo = duration.rawValue * 60
    }
    
    
    
    // MARK: - Public Methods
    
    func set(duration: MinutesInHalf) {
        
        totalSecondsInHalf = duration.rawValue * 60
        
        
        
//        totalSecondsToGo = duration.rawValue * 60
        totalSecondsToGo = 5

    }
    
    func start() {
        
        guard state == .WaitingToStart || state == .Paused else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        state = .Running
    }
    
    func pause() {
        
        guard state == .Running else { return }
        timer.invalidate()
        delegate.handlePause(for: self)
        state = .Paused
    }
    
    func stop() {
        
        guard state == .Overdue else { return }
        timer.invalidate()
        totalSecondsOverdue = 0
        delegate.handleStop(for: self, timeString: timeString(totalSeconds: 0))
        state = .WaitingToStart
    }
    
    func reset() {
        
        guard state != .WaitingToStart else { return }
        timer.invalidate()
        delegate.handleReset(for: self)
        totalSecondsToGo = totalSecondsInHalf
        state = .WaitingToStart
    }
    
    func timeString(totalSeconds: Int) -> String {
        
        var timeString: String = ""
        if minutes(totalSeconds: totalSeconds) < 10 {
            timeString.append("0")
        }
        timeString.append("\(minutes(totalSeconds: totalSeconds)):")
        if seconds(totalSeconds: totalSeconds) < 10 {
            timeString.append("0")
        }
        timeString.append("\(seconds(totalSeconds: totalSeconds))")
        return timeString
    }
    
    
    // MARK: - Private Methods

    @objc private func tick() {
        
        if totalSecondsToGo >= 1 {
            // Count down
            print("ticking with timestring \(timeString(totalSeconds: totalSecondsToGo))")
            totalSecondsToGo -= 1
            if totalSecondsToGo < 1 {
                // Reached zero
                delegate.handleReachedZero(for: self, timeString: timeString(totalSeconds: totalSecondsToGo))
                state = .Overdue
            } else {
                // Keep on counting
                delegate.handleTick(for: self, timeString: timeString(totalSeconds: totalSecondsToGo))
            }
        } else {
            // Count up
            print("ticking overude with timestring \(timeString(totalSeconds: totalSecondsOverdue))")
            totalSecondsOverdue += 1
            delegate.handleTick(for: self, timeString: timeString(totalSeconds: totalSecondsOverdue))
        }
        
    }
    
    private func seconds(totalSeconds: Int) -> Int {
        
        return totalSeconds % 60
    }
    
    private func minutes(totalSeconds: Int) -> Int {
        
        return totalSeconds / 60
    }

    
}
