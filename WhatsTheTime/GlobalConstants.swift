//
//  GlobalConstants.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 14/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


enum NIBNAME {
    
    static let Logo = "Logo"
    static let DismissButton = "DismissButton"
    static let Hamburger = "Hamburger"
}


enum COLOR {
    
    // Standard colors
    static let Theme = UIColor.init(hexString: "#394560") // Dark Blue 1E2460         // Colours on Navigation Bar, Button Titles, Progress Indicator etc. "#ffcc00"
//    static let Border = UIColor.init(hexString: "#333333")                    // Hair line separators in between views.
//    static let Shadow = UIColor.init(hexString: "#ccccc")                     // Shadow colours for card like design.
//    
    static let DarkBackground = UIColor.init(hexString: "#989CB5") // Dark Grey // Dark background colour to group UI components with light colour. "#999966"
    static let LightBackground = UIColor.init(hexString: "#EAEBF0") // Light Grey // Light background colour to group UI components with dark colour.
//    static let IntermediateBackground = UIColor.init(hexString: "#cccc99")    // Used for grouping UI elements with some other colour scheme.
//
//    static let DarkText = UIColor.init(hexString: "#333333")
//    static let LightText = UIColor.init(hexString: "#cccccc")
//    static let IntermediateText = UIColor.init(hexString: "#999999")
//    
    static let Affirmation = UIColor.init(hexString: "#F4AB23") // Orange yellow // Colour to show success, something right for user. "#00ff66""
    static let Negation = UIColor.init(hexString: "#980822")                  // Colour to show error, some danger zones for user. ff3300
    
    // Custom colors
    static let MenuCircleBigOutside = UIColor(hexString: "#4C54A6")
    static let MenuCircleBigInside = UIColor(hexString: "#6A74E6")
    static let MenuCircleMediumOutside = UIColor(hexString: "#2D347B")
    static let MenuCircleMediumInside = UIColor(hexString: "#4049AD")
    static let MenuCircleSmallOutside = UIColor(hexString: "#1E2460")
    static let MenuCircleSmallInside = UIColor(hexString: "#2E3694")
    
    static let White = UIColor(hexString: "#FFFFFF")
    static let PitchBlue = UIColor(hexString: "#4784C9") // 2C6DB8
    static let PitchEdge = UIColor(hexString: "#8DBFF7")
    static let Striping = UIColor(hexString: "#FFFFFF") //6F7498
}


enum FONTNAME {
    
    static let ThemeBold = "HelveticaNeue-Bold"
    static let ThemeRegular = "HelveticaNeue"
}



// Localized strings

let LS_NEWGAME = NSLocalizedString("New Game", comment: "Overdue message")
let LS_GAMEPAUSED = NSLocalizedString("Game Paused", comment: "Message when game is pausing")
let LS_OVERTIME = NSLocalizedString("Time Over", comment: "Time over message")
let LS_HALFTIME = NSLocalizedString("Half Time", comment: "Half time message")
let LS_READYFORH2 = NSLocalizedString("Ready for H2", comment: "H2 to begin message")
let LS_FULLTIME = NSLocalizedString("Full Time", comment: "Full time message")
let LS_FIRSTHALFLABEL = NSLocalizedString("H1", comment: "Half time indication label")
let LS_SECONDHALFLABEL = NSLocalizedString("H2", comment: "Half time indication label")
let LS_WARNINGRESETGAME = NSLocalizedString("RESET GAME?", comment: "When reset button tapped")






