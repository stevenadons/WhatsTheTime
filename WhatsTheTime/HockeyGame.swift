//
//  HockeyGame.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation


enum Half {
    
    case First
    case Second
}

enum MinutesInHalf: Int {
    
    case Fifteen = 15
    case Twenty = 20
    case TwentyFive = 25
    case Thirty = 30
    case ThirtyFive = 35
}



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
    var half: Half = .First
    var status: Status = .WaitingToStart
    var duration: MinutesInHalf = .Twenty
    
    
    
    // MARK: - Initializing

    convenience init(duration: MinutesInHalf) {
        
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
