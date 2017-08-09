//
//  AnimationPresentationController.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 9/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class AnimationPresentationController: UIPresentationController {
    
    
    // MARK: - Properties
    
    let chrome = UIView()
    
    
    
    // MARK: - Methods
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        return containerView!.bounds.insetBy(dx: 0, dy: 0)
    }
    
    
    override func presentationTransitionWillBegin() {
        
        chrome.frame = containerView!.bounds
//        chrome.alpha = 0.0
        chrome.backgroundColor = COLOR.White
        containerView!.insertSubview(chrome, at: 0)
        
        // animation ofwel transitioncoordinator
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
//            self.chrome.alpha = 1.0
            if let presentingVC = self.presentingViewController as? TimerVC {
                // change UI in TimerVC (alpha, scale,...)
            }
        })
        animator.startAnimation()
    }
    
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
        if !completed { chrome.removeFromSuperview() } // if transition gets interrupted
    }
    
    
    override func dismissalTransitionWillBegin() {
        
        // transitioncoordinator?
        // get things from (to be dismissed) presentedviewcontroller and add to presentingviewcontroller
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
//            self.chrome.alpha = 0.0
            if let presentingVC = self.presentingViewController as? TimerVC {
                // change UI in TimerVC (alpha, scale,...) back
            }
        }, completion: { (context) in
            self.chrome.removeFromSuperview()
        })
    }
    
    
    override func containerViewWillLayoutSubviews() {
        
        chrome.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}

