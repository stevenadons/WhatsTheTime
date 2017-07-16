//
//  TimerVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {

    // MARK: - Properties
    
    private var logo: Logo!
    private var dismissButton: DismissButton!
    
    
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            print("finished")
        }
    }
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
                
//        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
//        view.addSubview(logo)
//        
//        dismissButton = Bundle.main.loadNibNamed(NIBNAME.DismissButton, owner: self, options: nil)?.last as! DismissButton
//        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:forEvent:)), for: [.touchUpInside])
//        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            
//            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            logo.widthAnchor.constraint(equalToConstant: 200),
//            logo.heightAnchor.constraint(equalToConstant: 40),
//            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 23),
//            
//            dismissButton.widthAnchor.constraint(equalToConstant: 20),
//            dismissButton.heightAnchor.constraint(equalToConstant: 20),
//            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
//            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            ])
    }
    
    
    // MARK: - Private Methods
    
    @objc private func handleDismiss(sender: DismissButton, forEvent event: UIEvent) {
        
        print("dismissed")
    }

   

}
