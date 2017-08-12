//
//  HockeyGame.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation


class HockeyGame {
    
    
    // MARK: - Helpers
    
    enum Status {
        
        case WaitingToStart
        case Running
        case Pausing
        case HalfTime
        case Finished
    }
    
    
    // MARK: - Properties
    
    private(set) var homeScore: Int = 0
    private(set) var awayScore: Int = 0
    var half: HALF = .First
    var status: Status = .WaitingToStart
    var duration: MINUTESINHALF = .Twenty
    
    
    
    // MARK: - Initializing

    convenience init(duration: MINUTESINHALF) {
        
        self.init()
        self.duration = duration
    }
    
    
    // MARK: - User Methods

    func homeScored() {
        
        homeScore += 1
    }
    
    func awayScored() {
        
        awayScore += 1
    }
    
    func homeScoreMinusOne() {
        
        homeScore -= 1
    }
    
    func awayScoreMinusOne() {
        
        awayScore -= 1
    }
    
}
