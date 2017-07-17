//
//  TimerVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class TimerVC: UIViewController, Sliding {

    // MARK: - Properties
    
    private var logo: Logo!
    private var dismissButton: DismissButton!
    
    private var clock: UIView!
    private var fieldContainer: UIView!
    private var field: UIView!
    
    
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        slideViewController(to: .In, offScreenPosition: .Bottom, completion: nil)
        clock.animateConstraintChange(attribute: .centerY, withNewConstraintRelatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 207, duration: 0.6, delay: 0.2, completion: nil)
        field.animateConstraintChange(attribute: .centerY, withNewConstraintRelatedBy: .equal, toItem: fieldContainer, attribute: .top, multiplier: 1, constant: 429, duration: 0.6, delay: 0.4, completion: nil)
//        clock.animateConstraintChange(attribute: .centerY, withNewConstraintRelatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 207, duration: 0.8, delay: 0.2, completion: nil)
//        field.animateConstraintChange(attribute: .centerY, withNewConstraintRelatedBy: .equal, toItem: fieldContainer, attribute: .top, multiplier: 1, constant: 429, duration: 0.8, delay: 0.4, completion: nil)
    }
    
    
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
                
//        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
//        view.addSubview(logo)
//        
//        dismissButton = Bundle.main.loadNibNamed(NIBNAME.DismissButton, owner: self, options: nil)?.last as! DismissButton
//        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:forEvent:)), for: [.touchUpInside])
//        view.addSubview(dismissButton)
        
        clock = UIView()
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.backgroundColor = UIColor.black
        view.addSubview(clock)
        
        fieldContainer = UIView()
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.backgroundColor = UIColor.clear
        view.addSubview(fieldContainer)
        
        field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = COLOR.Theme
        fieldContainer.addSubview(field)
        
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
            
            clock.widthAnchor.constraint(equalToConstant: 194),
            clock.heightAnchor.constraint(equalToConstant: 194),
            clock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clock.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: 100 + clock.bounds.height/2),
            
            fieldContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            fieldContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            fieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            field.widthAnchor.constraint(equalToConstant: 185),
            field.heightAnchor.constraint(equalToConstant: 111),
            field.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor),
            field.centerYAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 100 + field.bounds.height/2),
            
            ])
    }
    
    
    // MARK: - Private Methods
    
    @objc private func handleDismiss(sender: DismissButton, forEvent event: UIEvent) {
        
        print("dismissed")
    }

   

}
