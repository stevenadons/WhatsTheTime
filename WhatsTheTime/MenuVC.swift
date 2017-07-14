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
    
    var menuCircles: MenuCircles!
    
    var topCirclesInset: CGFloat = 70
    var bottomCirclesInset: CGFloat = 100

    
    
    // MARK: - Public Methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Color.lightBackground.value
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        sleep(1)
        
//        menuCircles.liftBottom(inset: 70, duration: 0.3)
//        menuCircles.bringToOriginal(duration: 0.3, delay: 2)
        
        menuCircles.enableBeat(interval: 1.1)
     
//        menuCircles.expandToFullScreen(duration: 0.8)
//        menuCircles.bringToOriginal(duration: 0.8, delay: 3)
    }
    
    
    
    
    // MARK: - UI Methods
    
    private func setupViews() {
        
        menuCircles = MenuCircles(smallRatio: 0.7, mediumRatio: 0.9, bigRatio: 1.0)
        view.addSubview(menuCircles)
        
        NSLayoutConstraint.activate([
            
            menuCircles.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuCircles.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (topCirclesInset - bottomCirclesInset) / 2),
            menuCircles.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -topCirclesInset - bottomCirclesInset),
            menuCircles.widthAnchor.constraint(equalTo: menuCircles.widthAnchor)
            
        ])
    }
  

}
