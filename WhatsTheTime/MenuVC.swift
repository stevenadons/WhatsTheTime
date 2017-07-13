//
//  MenuVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 13/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    
    // MARK: - Properties
    
    var menuCircles: MenuCircles = MenuCircles()
    
    var topCirclesInset: CGFloat = 70
    var bottomCirclesInset: CGFloat = 100
    

    
    
    // MARK: - Public Methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Color.lightBackground.value
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        animateHeartBeat()
    }
    
    
    
    // MARK: - UI Methods
    
    private func setupViews() {
        
        view.addSubview(menuCircles)
        
        NSLayoutConstraint.activate([
            
            menuCircles.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuCircles.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (topCirclesInset - bottomCirclesInset) / 2),
            menuCircles.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -topCirclesInset - bottomCirclesInset),
            menuCircles.widthAnchor.constraint(equalTo: menuCircles.widthAnchor)
            
            ])

    }
    
    
    // Example of animation
//    private func animateHeartBeat() {
//    
//        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
//            self.menuCircles.smallCircle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }) { (finished) in
//            UIView.animate(withDuration: 0.3, animations: {
//                self.menuCircles.smallCircle.transform = .identity
//            })
//        }
//        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
//            self.menuCircles.mediumCircle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }) { (finished) in
//            UIView.animate(withDuration: 0.3, animations: {
//                self.menuCircles.mediumCircle.transform = .identity
//            })
//        }
//        UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
//            self.menuCircles.bigCircle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }) { (finished) in
//            UIView.animate(withDuration: 0.3, animations: {
//                self.menuCircles.bigCircle.transform = .identity
//            })
//        }
//    }
   

}
