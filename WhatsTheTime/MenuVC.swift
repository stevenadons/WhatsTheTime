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
    
    private var menuCircles: MenuCircles!
    private var logo: Logo!
    private var dismissButton: DismissButton!
    
    private let topCirclesInset: CGFloat = 70
    private let bottomCirclesInset: CGFloat = 100

    
    
    // MARK: - Public Methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.LightBackground
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        sleep(1)
        
//        menuCircles.liftBottom(inset: 70, duration: 0.3)
//        menuCircles.bringToOriginal(duration: 0.3, delay: 2)
        
//        menuCircles.enableBeat(interval: 1.1)
     
        menuCircles.expandToFullScreen(duration: 0.8)
        menuCircles.bringToOriginal(duration: 0.8, delay: 3)
    }
    
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
        view.addSubview(logo)
        
        dismissButton = Bundle.main.loadNibNamed(NIBNAME.DismissButton, owner: self, options: nil)?.last as! DismissButton
        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(dismissButton)

        menuCircles = MenuCircles(smallRatio: 0.7, mediumRatio: 0.9, bigRatio: 1.0)
        view.addSubview(menuCircles)
        
        NSLayoutConstraint.activate([
            
            menuCircles.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuCircles.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (topCirclesInset - bottomCirclesInset) / 2),
            menuCircles.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -topCirclesInset - bottomCirclesInset),
            menuCircles.widthAnchor.constraint(equalTo: menuCircles.widthAnchor),
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 200),
            logo.heightAnchor.constraint(equalToConstant: 40),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 23),
            
            dismissButton.widthAnchor.constraint(equalToConstant: 20),
            dismissButton.heightAnchor.constraint(equalToConstant: 20),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
        ])
    }
    
    
    // MARK: - Private Methods
    
    @objc private func handleDismiss(sender: DismissButton, forEvent event: UIEvent) {
        
        print("dismissed")
    }
  

}