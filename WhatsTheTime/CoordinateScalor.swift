//
//  CoordinateScalor.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 19/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class CoordinateScalor {
    
    // How to use
    //
    // CoordinateScalor.convert(x: 100)
    
    
    
    // MARK: - Properties
    
//    private static let _instance = CoordinateScalor()
//    static var instance: CoordinateScalor {
//        return _instance
//    }
    
    static var baseScreenWidth: CGFloat = 375
    static var baseScreenHeight: CGFloat = 667
    
    
    
    // MARK: - Public Methods
    
    
    class func convert(x: CGFloat) -> CGFloat {
        return x * UIScreen.main.bounds.width / CoordinateScalor.baseScreenWidth
    }
    
    
    class func convert(y: CGFloat) -> CGFloat {
        return y * UIScreen.main.bounds.height / CoordinateScalor.baseScreenHeight
    }
    
    
    class func convert(width: CGFloat) -> CGFloat {
        return width * UIScreen.main.bounds.width / CoordinateScalor.baseScreenWidth
    }
    
    
    class func convert(height: CGFloat) -> CGFloat {
        return height * UIScreen.main.bounds.height / CoordinateScalor.baseScreenHeight
    }
}
