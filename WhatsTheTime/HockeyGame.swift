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

enum Status {
    
    case WaitingToStart
    case Running
    case Pausing
    case Ended
}


struct HockeyGame {
    
    var scoreHome: Int = 0
    var scoreAway: Int = 0
    var half: Half = .First
    var status: Status = .WaitingToStart
    
}
