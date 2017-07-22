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



class HockeyGame {
    
    
    // MARK: - Helpers
    
    enum Status {
        
        case WaitingToStart
        case Running
        case Pausing
        case Ended
    }
    
    enum MinutesInHalf: Int {
        
        case Twenty = 20
        case TwentyFive = 25
        case Thirty = 30
        case ThirtyFive = 35
    }
    
    
    // MARK: - Properties
    
    private var scoreHome: Int = 0
    private var scoreAway: Int = 0
    private var half: Half = .First
    var status: Status = .WaitingToStart
    private var duration: MinutesInHalf = .Twenty
    
    
    
    // MARK: - Initializing

    convenience init(duration: MinutesInHalf) {
        
        self.init()
        self.duration = duration
    }
    
    
}
