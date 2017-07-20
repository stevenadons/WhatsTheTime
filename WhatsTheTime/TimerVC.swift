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
    private var ellipse: EllipseView!
    private var timerContainer: UIView!
    private var timer: UIView!
    private var pitchContainer: UIView!
    private var pitch: UIView!
    
    private var timerCenterYConstraint: NSLayoutConstraint!
    private var pitchCenterYConstraint: NSLayoutConstraint!
    private var ellipseTopConstraint: NSLayoutConstraint!
    private var ellipseBottomConstraint: NSLayoutConstraint!
    
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    
    
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.LightBackground
        setupViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        blowUpEllipse()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        animateViewsOnAppear()
    }
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
                
        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
        view.addSubview(logo)
        
        dismissButton = Bundle.main.loadNibNamed(NIBNAME.DismissButton, owner: self, options: nil)?.last as! DismissButton
        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(dismissButton)
        
        ellipse = EllipseView()
        ellipse.translatesAutoresizingMaskIntoConstraints = false
        ellipse.color = COLOR.White
        view.addSubview(ellipse)
        
        timerContainer = UIView()
        timerContainer.translatesAutoresizingMaskIntoConstraints = false
        timerContainer.backgroundColor = UIColor.clear
        view.addSubview(timerContainer)
        
        timer = UIView()
        timer.translatesAutoresizingMaskIntoConstraints = false
        timer.backgroundColor = UIColor.black
        timerContainer.addSubview(timer)
        
        pitchContainer = UIView()
        pitchContainer.translatesAutoresizingMaskIntoConstraints = false
        pitchContainer.backgroundColor = UIColor.clear
        view.addSubview(pitchContainer)
        
        pitch = UIView()
        pitch.translatesAutoresizingMaskIntoConstraints = false
        pitch.backgroundColor = COLOR.Theme
        pitchContainer.addSubview(pitch)

        timerCenterYConstraint = NSLayoutConstraint(item: timer, attribute: .centerY, relatedBy: .equal, toItem: timerContainer, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 207) + initialObjectYOffset)
        pitchCenterYConstraint = NSLayoutConstraint(item: pitch, attribute: .centerY, relatedBy: .equal, toItem: pitchContainer, attribute: .top, multiplier: 1, constant: CoordinateScalor.convert(y: 429) + initialObjectYOffset)
        
        NSLayoutConstraint.activate([
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 200)),
            logo.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 40)),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 23)),
            
            dismissButton.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 20)),
            dismissButton.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 20)),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 30)),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 27)),
            
            ellipse.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 60)),
            ellipse.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CoordinateScalor.convert(y: -100)),
            ellipse.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(x: -250)),
            ellipse.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CoordinateScalor.convert(x: 250)),
            
            timerContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            timerContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            timerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            timer.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 194)),
            timer.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 194)),
            timer.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
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
    
    
    private func blowUpEllipse() {
    
        ellipse.transform = CGAffineTransform(scaleX: 1, y: 2)
    }
    
    
    private func animateViewsOnAppear() {
        
        slideViewController(to: .In, offScreenPosition: .Bottom, completion: nil)
        
        timerCenterYConstraint.constant = CoordinateScalor.convert(y: 207)
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.timerContainer.layoutIfNeeded()
        })
        
        pitchCenterYConstraint.constant = CoordinateScalor.convert(y: 429)
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.pitchContainer.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 2, delay: 2, usingSpringWithDamping: 5, initialSpringVelocity: 0.0, options: [], animations: {
            self.ellipse.transform = CGAffineTransform.identity
        })
    }
    
    
    // MARK: - Private Methods
    
    @objc private func handleDismiss(sender: DismissButton, forEvent event: UIEvent) {
        
        print("dismissed")
    }

   

}
