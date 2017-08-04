//
//  Sliding.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 17/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol Sliding: class {
    
}

enum To {
    
    case In
    case Out
}

enum OffScreenPosition {
    
    case Top
    case Bottom
    case Left
    case Right
}

extension Sliding where Self: UIViewController {
    
    func slideViewController(to: To, offScreenPosition: OffScreenPosition, duration: Double = 0.8, delay: Double = 0.0, completion: (() -> Void)?) {
        
        var frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        switch to {
        case .In:
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.frame = frame
                
            }) { (finished) in
                if finished {
                    print("let's ccmplete")
                    completion?()
                }
            }
            break
        
        case .Out:
            switch offScreenPosition {
            case .Top:
                frame.origin.y = -UIScreen.main.bounds.height
            case .Bottom:
                frame.origin.y = UIScreen.main.bounds.height
            case .Left:
                frame.origin.x = -UIScreen.main.bounds.width
            case .Right:
                frame.origin.x = UIScreen.main.bounds.width
            }
            UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
                self.view.frame = frame
            }) { (finished) in
                if finished {
                    print("let's ccmplete")
                    completion?()
                }
            }
        }
    }
}

