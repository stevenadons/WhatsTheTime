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
    
    var bigCircleInset: CGFloat = 0 {
        didSet {
            bigCircle.setNeedsDisplay()
        }
    }
    var mediumCircleInset: CGFloat = 25 {
        didSet {
            mediumCircle.setNeedsDisplay()
        }
    }
    var smallCircleInset: CGFloat = 60 {
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
    
    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        containerView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
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
        
                
        // Set constraints
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),

            bigCircle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: bigCircleInset),
            bigCircle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -bigCircleInset),
            bigCircle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: bigCircleInset),
            bigCircle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -bigCircleInset),
            
            mediumCircle.topAnchor.constraint(equalTo: bigCircle.topAnchor, constant: mediumCircleInset),
            mediumCircle.bottomAnchor.constraint(equalTo: bigCircle.bottomAnchor, constant: -mediumCircleInset),
            mediumCircle.leadingAnchor.constraint(equalTo: bigCircle.leadingAnchor, constant: mediumCircleInset),
            mediumCircle.trailingAnchor.constraint(equalTo: bigCircle.trailingAnchor, constant: -mediumCircleInset),

            smallCircle.topAnchor.constraint(equalTo: mediumCircle.topAnchor, constant: smallCircleInset),
            smallCircle.bottomAnchor.constraint(equalTo: mediumCircle.bottomAnchor, constant: -smallCircleInset),
            smallCircle.leadingAnchor.constraint(equalTo: mediumCircle.leadingAnchor, constant: smallCircleInset),
            smallCircle.trailingAnchor.constraint(equalTo: mediumCircle.trailingAnchor, constant: -smallCircleInset)

            ])
    }
    

}
