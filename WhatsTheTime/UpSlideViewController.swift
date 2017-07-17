//
//  UpSlideViewController.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 17/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class UpSlideViewController: UIViewController {

    
    // MARK: - Public Methods
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            print("finished")
        }
    }

}
