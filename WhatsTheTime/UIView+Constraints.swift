//
//  UIView+Constraints.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func changeSizeConstraint(attribute: NSLayoutAttribute, constant: CGFloat, updateNow: Bool = false) {
        
        if attribute == .width || attribute == .height {
            for constraint in constraints {
                if constraint.firstAttribute == attribute {
                    constraint.constant = constant
                    
                    if updateNow {
                        self.needsUpdateConstraints()
                    } else {
                        self.setNeedsUpdateConstraints()
                    }
                }
            }
        }
    }
    
    
    
    // Checks only at superview's level, not higher
    // Beware if other object's constraints refer to these attributes
    func replaceConstraint(attribute: NSLayoutAttribute, with newConstraint: NSLayoutConstraint, updateNow: Bool = false) {
        
        for constraint in constraints {
                if constraint.firstAttribute == attribute {
                removeConstraint(constraint)
                addConstraint(newConstraint)
                
                if updateNow {
                    self.needsUpdateConstraints()
                } else {
                    self.setNeedsUpdateConstraints()
                }
            }
        }
        
        guard superview != nil else { return }
        
        for constraint in superview!.constraints {
            if constraint.firstItem.isEqual(self) && constraint.firstAttribute == attribute {
                superview!.removeConstraint(constraint)
                superview!.addConstraint(newConstraint)
                
                if updateNow {
                    superview!.needsUpdateConstraints()
                } else {
                    superview!.setNeedsUpdateConstraints()
                }
            }
        }
    }
}
