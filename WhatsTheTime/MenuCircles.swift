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

    var containerView: UIView = UIView()
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
        
        setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        bigCircle.locations = [(mediumCircle.bounds.width / bigCircle.bounds.width), 1.0]
        mediumCircle.locations = [(smallCircle.bounds.width / mediumCircle.bounds.width), 1.0]
        smallCircle.locations = [0.2, 1.0]
    }
    
    
    
    // MARK: - UI Methods
    
    private func setupViews() {
        
        // Add containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        
        // Add circles
        bigCircle.insideColor = Color.menuCircleBigInside.value
        bigCircle.outsideColor = Color.menuCircleBigOutside.value
        containerView.addSubview(bigCircle)
        
        mediumCircle.insideColor = Color.menuCircleMediumInside.value
        mediumCircle.outsideColor = Color.menuCircleMediumOutside.value
        containerView.addSubview(mediumCircle)
        
        smallCircle.insideColor = Color.menuCircleSmallInside.value
        smallCircle.outsideColor = Color.menuCircleSmallOutside.value
        containerView.addSubview(smallCircle)
        
                
            }
    

}
