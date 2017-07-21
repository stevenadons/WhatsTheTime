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
    private var state: State = .WaitingToStart
    private var delegate: StopWatchTimerDelegate!
    
    private var totalSeconds: Int = 60 * 25
    private var secondsToGo: Int = 60 * 25
    private var seconds: Int {
        return secondsToGo % 60
    }
    private var minutes: Int {
        return secondsToGo / 60
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
        secondsToGo = totalSeconds
        state = .WaitingToStart
    }
    
    
    
    // MARK: - Private Methods

    @objc private func tick() {
        
        secondsToGo -= 1
        if secondsToGo < 1 {
            // Reached zero
            timer.invalidate()
            delegate.handleReachedZero(for: self)
            state = .Ended
        } else {
            // Keep on counting
            delegate.handleTick(for: self)
        }
    }
    
    
    
    
    
    
}
