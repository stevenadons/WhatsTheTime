//
//  UIView+Constraints.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

extension UIView {
    
    
    // How to use:
    //      object.changeSizeConstraint(attribute: .width, constant: 200)
    //      UIView.animate(... animations: {
    //          objectsSuperView.layoutIfNeeded()
    //
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
    
    
    // How to use:
    //      object.replaceConstraint(attribute: .top, with newConstraint: NSLayoutConstraint)
    //      UIView.animate(... animations: {
    //          objectsSuperView.layoutIfNeeded()
    //
    // Checks only at superview's level, not higher
    // Beware if other object's constraints refer to these attributes
    //
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
    
    
    
    
    func replaceConstraintAnimating(attribute selfAttribute: NSLayoutAttribute, withNewRelatedBy: NSLayoutRelation, toItem: Any?, attribute otherAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, duration: Double, delay: Double, springDamping: CGFloat = 5, options: UIViewAnimationOptions = [], completion: (() -> Void)?) {
        
        let newConstraint = NSLayoutConstraint(item: self, attribute: selfAttribute, relatedBy: withNewRelatedBy, toItem: toItem, attribute: otherAttribute, multiplier: multiplier, constant: constant)
        
        self.replaceConstraint(attribute: selfAttribute, with: newConstraint)
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: 0.0, options: options, animations: {
            self.superview?.layoutIfNeeded()
        }) { (finished) in
            completion?()
        }
    }
    
}





