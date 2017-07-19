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
    
    private var timer: UIView!
    private var pitchContainer: UIView!
    private var pitch: UIView!
    
    private var timerCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        animateViewsOnAppear()
    }
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
                
//        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
//        view.addSubview(logo)
//        
//        dismissButton = Bundle.main.loadNibNamed(NIBNAME.DismissButton, owner: self, options: nil)?.last as! DismissButton
//        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:forEvent:)), for: [.touchUpInside])
//        view.addSubview(dismissButton)
        
        timer = UIView()
        timer.translatesAutoresizingMaskIntoConstraints = false
        timer.backgroundColor = UIColor.black
        view.addSubview(timer)
        
        pitchContainer = UIView()
        pitchContainer.translatesAutoresizingMaskIntoConstraints = false
        pitchContainer.backgroundColor = UIColor.clear
        view.addSubview(pitchContainer)
        
        pitch = UIView()
        pitch.translatesAutoresizingMaskIntoConstraints = false
        pitch.backgroundColor = COLOR.Theme
        pitchContainer.addSubview(pitch)

        timerCenterYConstraint = NSLayoutConstraint(item: timer, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 207) + UIScreen.main.bounds.height)
        pitchCenterYConstraint = NSLayoutConstraint(item: pitch, attribute: .centerY, relatedBy: .equal, toItem: pitchContainer, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 429) + UIScreen.main.bounds.height)
        
        
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
            
            timer.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 194)),
            timer.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 194)),
            timer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerCenterYConstraint,
            
            pitchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            pitchContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            pitch.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 185)),
            pitch.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 111)),
            pitch.centerXAnchor.constraint(equalTo: pitchContainer.centerXAnchor),
            pitchCenterYConstraint,
            
            ])
    }
    
    private func animateViewsOnAppear() {
        
        slideViewController(to: .In, offScreenPosition: .Bottom, completion: nil)
        
        timerCenterYConstraint.constant = CoordinateScalor.convert(y: 207)
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
        })
        
        pitchCenterYConstraint.constant = CoordinateScalor.convert(y: 429)
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.pitchContainer.layoutIfNeeded()
        })
    }
    
    
    // MARK: - Private Methods
    
    @objc private func handleDismiss(sender: DismissButton, forEvent event: UIEvent) {
        
        print("dismissed")
    }

   

}
