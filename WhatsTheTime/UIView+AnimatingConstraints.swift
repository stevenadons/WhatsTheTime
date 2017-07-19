//
//  UIView+AnimatingConstraints.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

extension UIView {
    
    
    // MARK: - Public Methods

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
    
    
    func animateSizeConstraintConstantChange(attribute selfAttribute: NSLayoutAttribute, newConstant: CGFloat, duration: Double, delay: Double, options: UIViewAnimationOptions = [], completion: (() -> Void)?) {
        
        if selfAttribute == .width || selfAttribute == .height {
            for constraint in self.constraints {
                if constraint.firstAttribute == selfAttribute {
                    constraint.constant = newConstant
                    self.setNeedsUpdateConstraints()
                }
            }
        }
        
        print("animating beat for button \(self) at \(Date()) with delay \(delay)")
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.layoutIfNeeded()
            
        }) { (finished) in
            if finished {
                completion?()
            }
        }
        
    }
    
    
    func animateConstraintChange(attribute selfAttribute: NSLayoutAttribute, withNewConstraintRelatedBy relation: NSLayoutRelation, toItem: Any?, attribute otherAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, duration: Double, delay: Double, springDamping: CGFloat = 5, options: UIViewAnimationOptions = [], completion: (() -> Void)?) {
        
        guard let constraintHoldingView = viewHolding(constraintWithAttribute: selfAttribute, forView: self) else {
            print("ERROR - No viewHolding")
            return
        }
        
        let newConstraint = NSLayoutConstraint(item: self, attribute: selfAttribute, relatedBy: relation, toItem: toItem, attribute: otherAttribute, multiplier: multiplier, constant: constant)
        
        guard let successView = constraintHoldingView.viewWithReplacedConstraint(attribute: selfAttribute, with: newConstraint) else {
            print("ERROR - No successView")
            return
        }
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: 0.0, options: options, animations: {
            successView.layoutIfNeeded()
            
        }) { (finished) in
            
            if finished {
                completion?()
            }
        }
    }
    
    
    
    // MARK: - Private Methods
    
    private func viewHolding(constraintWithAttribute attribute: NSLayoutAttribute, forView: UIView) -> UIView? {
        
        for constraint in forView.constraints {
            if constraint.firstAttribute == attribute {
                return forView
            }
        }
        if let supView = forView.superview {
            if let constraintHoldingView = viewHolding(constraintWithAttribute: attribute, forView: supView) {
                return constraintHoldingView
            }
        }
        return nil
    }
    
    
    // How to use:
    //      object.replaceConstraint(attribute: .top, with newConstraint: NSLayoutConstraint)
    //      UIView.animate(... animations: {
    //          objectsSuperView.layoutIfNeeded()
    //
    // Checks only at superview's level, not higher
    // Beware if other object's constraints refer to these attributes
    //
    private func viewWithReplacedConstraint(attribute: NSLayoutAttribute, with newConstraint: NSLayoutConstraint, updateNow: Bool = false) -> UIView? {
        
        for constraint in constraints {
            if constraint.firstAttribute == attribute {
                removeConstraint(constraint)
                addConstraint(newConstraint)
                
                if updateNow {
                    self.needsUpdateConstraints()
                } else {
                    self.setNeedsUpdateConstraints()
                }
                
                return self
            }
        }
        
        // This could very well be redundant as the method is a recursive method
        guard superview != nil else {
            return nil
        }
        
        for constraint in superview!.constraints {
            if constraint.firstItem.isEqual(self) && constraint.firstAttribute == attribute {
                superview!.removeConstraint(constraint)
                superview!.addConstraint(newConstraint)
                
                if updateNow {
                    superview!.needsUpdateConstraints()
                } else {
                    superview!.setNeedsUpdateConstraints()
                }
                
                return superview!
            }
        }
        
        return nil
    }
}







