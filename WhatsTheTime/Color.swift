//
//  Color.swift
//  EcoWERFAfvalkalenders
//
//  Created by Steven Adons on 4/03/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//


import Foundation
import UIKit

//// Usage Examples
//let shadowColor = Color.shadow.value
//let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
//let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value
//
//
//enum Color {
//    
//    case theme      // Colours on Navigation Bar, Button Titles, Progress Indicator etc.
//    case border     // Hair line separators in between views.
//    case shadow     // Shadow colours for card like design.
//    
//    case darkBackground         // Dark background colour to group UI components with light colour.
//    case lightBackground        // Light background colour to group UI components with dark colour.
//    case intermediateBackground // Used for grouping UI elements with some other colour scheme.
//    
//    case darkText
//    case lightText
//    case intermediateText
//    
//    case affirmation    // Colour to show success, something right for user.
//    case negation       // Colour to show error, some danger zones for user.
//    
//    
//    // Other custom colors
//    case menuCircleBigOutside
//    case menuCircleBigInside
//    case menuCircleMediumOutside
//    case menuCircleMediumInside
//    case menuCircleSmallOutside
//    case menuCircleSmallInside
//    
//    case custom(hexString: String, alpha: Double)
//    
//    func withAlpha(_ alpha: Double) -> UIColor {
//        return self.value.withAlphaComponent(CGFloat(alpha))
//    }
//}
//
//
//extension Color {
//    
//    var value: UIColor {
//        var instanceColor = UIColor.clear
//        
//        switch self {
//        case .border:
//            instanceColor = UIColor(hexString: "#333333")
//        case .theme:
//            instanceColor = UIColor(hexString: "#ffcc00")
//        case .shadow:
//            instanceColor = UIColor(hexString: "#ccccc")
//        case .darkBackground:
//            instanceColor = UIColor(hexString: "#999966")
//        case .lightBackground:
//            instanceColor = UIColor(hexString: "#EAEBF0") // LightGrey
//        case .intermediateBackground:
//            instanceColor = UIColor(hexString: "#cccc99")
//        case .darkText:
//            instanceColor = UIColor(hexString: "#333333")
//        case .intermediateText:
//            instanceColor = UIColor(hexString: "#999999")
//        case .lightText:
//            instanceColor = UIColor(hexString: "#cccccc")
//        case .affirmation:
//            instanceColor = UIColor(hexString: "#00ff66")
//        case .negation:
//            instanceColor = UIColor(hexString: "#ff3300")
//            
//            
//        // Other custom colors
//        case .menuCircleBigOutside:
//            instanceColor = UIColor(hexString: "#4C54A6") // Blue
//        case .menuCircleBigInside:
//            instanceColor = UIColor(hexString: "#6A74E6") // Blue 2D347B
//        case .menuCircleMediumOutside:
//            instanceColor = UIColor(hexString: "#2D347B") // Blue
//        case .menuCircleMediumInside:
//            instanceColor = UIColor(hexString: "#4049AD") // Blue
//        case .menuCircleSmallOutside:
//            instanceColor = UIColor(hexString: "#1E2562") // Blue
//        case .menuCircleSmallInside:
//            instanceColor = UIColor(hexString: "#2E3694") // Blue
//            
//            
//        case .custom(let hexValue, let opacity):
//            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
//        }
//        return instanceColor
//    }
//}


extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}



// Source:  http://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
extension UIColor {
    /**
     Create a ligher color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0,0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}

