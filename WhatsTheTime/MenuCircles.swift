//
//  MenuCircles.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 13/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MenuCircles: UIView {

    
    // MARK: - Properties

    var bigCircle: MenuCircle = MenuCircle()
    var mediumCircle: MenuCircle = MenuCircle()
    var smallCircle: MenuCircle = MenuCircle()
    
    var bigCircleRatio: CGFloat = 1.0 {
        didSet {
            bigCircle.setNeedsDisplay()
        }
    }
    var mediumCircleRatio: CGFloat = 0.9 {
        didSet {
            mediumCircle.setNeedsDisplay()
        }
    }
    var smallCircleRatio: CGFloat = 0.7 {
        didSet {
            smallCircle.setNeedsDisplay()
        }
    }
    
    private var containerView: UIView = UIView()
    private var smallCircleGradientLocations: [CGFloat] = [0.2, 1.0]
    private var timer: Timer?
    
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(smallRatio: CGFloat, mediumRatio: CGFloat, bigRatio: CGFloat?) {
        
        self.init()
        self.smallCircleRatio = smallRatio
        self.mediumCircleRatio = mediumRatio
        if let bigRatio = bigRatio {
            self.bigCircleRatio = bigRatio
        }
    }
    
    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        containerView.layer.cornerRadius = min(bounds.width, bounds.height) / 2

        // Set constraints
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            
            bigCircle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bigCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bigCircle.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            bigCircle.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            mediumCircle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mediumCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            mediumCircle.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: mediumCircleRatio),
            mediumCircle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: mediumCircleRatio),
            
            smallCircle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            smallCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            smallCircle.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: smallCircleRatio),
            smallCircle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: smallCircleRatio),
            
            ])
        
        bigCircle.locations = [(mediumCircle.bounds.width / bigCircle.bounds.width), 1.0]
        mediumCircle.locations = [(smallCircle.bounds.width / mediumCircle.bounds.width), 1.0]
        smallCircle.locations = smallCircleGradientLocations
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
    }
    
    
    
    // MARK: - Public UI Methods
    
    func expandToFullScreen(duration: Double) {
        
        let diagonal = sqrt(pow(UIScreen.main.bounds.height, 2) + pow(UIScreen.main.bounds.width, 2))
        let smallRadius = min(smallCircle.bounds.height, smallCircle.bounds.width)
        let scale = diagonal / smallRadius * 1.5
        
        smallCircle.animate(scale: scale, translateY: 0, duration: duration, delay: 0, completion: nil)
        mediumCircle.animate(scale: scale, translateY: 0, duration: duration, delay: 0.05, completion: nil)
        bigCircle.animate(scale: scale, translateY: 0, duration: duration, delay: 0.1, completion: nil)
    }
    
    
    func bringToOriginal(duration: Double, delay: Double) {
        
        smallCircle.animateToIdentity(duration: duration, delay: delay)
        mediumCircle.animateToIdentity(duration: duration, delay: delay + 0.05)
        bigCircle.animateToIdentity(duration: duration, delay: delay + 0.1)
    }
    
    
    func liftBottom(inset: CGFloat, duration: Double) {
        
        let scale = (bounds.height - inset) / bounds.height
        
        smallCircle.animate(scale: scale, translateY: -inset / 2, duration: duration, delay: 0, completion: nil)
        mediumCircle.animate(scale: scale, translateY: -inset / 2, duration: duration, delay: 0.05, completion: nil)
        bigCircle.animate(scale: scale, translateY: -inset / 2, duration: duration, delay: 0.1, completion: nil)
    }
    
    
    func enableBeat(interval: Double) {
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
                self.beat()
            }
        }
    }
    
    
    func disableBeat() {
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    private func beat() {
        
        let duration = 0.2
        let scale: CGFloat = 1.05
        
        smallCircle.animate(scale: scale, translateY: 0, duration: duration, delay: 0) { 
            self.smallCircle.animateToIdentity(duration: duration, delay: 0)
        }
        mediumCircle.animate(scale: scale, translateY: 0, duration: duration, delay: 0.05) {
            self.mediumCircle.animateToIdentity(duration: duration, delay: 0)
        }
        bigCircle.animate(scale: scale, translateY: 0, duration: duration, delay: 0.1) {
            self.bigCircle.animateToIdentity(duration: duration, delay: 0)
        }
    }
    
    

    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        // Add containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        addSubview(containerView)
        
        
        // Add circles
        bigCircle.insideColor = COLOR.MenuCircleBigInside
        bigCircle.outsideColor = COLOR.MenuCircleBigOutside
        containerView.addSubview(bigCircle)
        
        mediumCircle.insideColor = COLOR.MenuCircleMediumInside
        mediumCircle.outsideColor = COLOR.MenuCircleMediumOutside
        containerView.addSubview(mediumCircle)
        
        smallCircle.insideColor = COLOR.MenuCircleSmallInside
        smallCircle.outsideColor = COLOR.MenuCircleSmallOutside
        containerView.addSubview(smallCircle)
    }

}
