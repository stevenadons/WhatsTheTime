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
    static let Theme = UIColor.init(hexString: "#1E2460") // Dark Blue          // Colours on Navigation Bar, Button Titles, Progress Indicator etc. "#ffcc00"
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
//    static let Negation = UIColor.init(hexString: "#ff3300")                  // Colour to show error, some danger zones for user.
    
    // Custom colors
    static let MenuCircleBigOutside = UIColor(hexString: "#4C54A6")
    static let MenuCircleBigInside = UIColor(hexString: "#6A74E6")
    static let MenuCircleMediumOutside = UIColor(hexString: "#2D347B")
    static let MenuCircleMediumInside = UIColor(hexString: "#4049AD")
    static let MenuCircleSmallOutside = UIColor(hexString: "#1E2460")
    static let MenuCircleSmallInside = UIColor(hexString: "#2E3694")
    
    static let White = UIColor(hexString: "#FFFFFF")
}


enum FONTNAME {
    
    static let MenuButton = "HelveticaNeue-Bold"
    static let DurationLabel = "HelveticaNeue"
}


