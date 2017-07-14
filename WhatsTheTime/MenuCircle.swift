//
//  MenuCircle.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 13/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MenuCircle: UIView {

    
    // MARK: - Properties
    
    var containerView = UIView()
    var gradientView = RadialGradientView()
    var outsideColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    var insideColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    var locations: [CGFloat] {
        get {
            return gradientView.locations
        }
        set {
            gradientView.locations = newValue
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
//        gradientView.locations = [0.6, 1.0]
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        gradientView.colors = [insideColor, outsideColor]
        gradientView.setNeedsDisplay()
    }
  
    
    // MARK: - Public UI Methods
    
    func animate(scale: CGFloat, translateY: CGFloat, duration: Double, delay: Double, completion: (() -> Void)?) {
        
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: 0, y: translateY)
        })  { (finished) in
            completion?()
        }
    }
    
    
    func animateToIdentity(duration: Double, delay: Double) {
        
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.transform = .identity
        })
    }

    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        // Add containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        
        // Add radialGradient
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(gradientView)
        
        
        // Set constraints
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            gradientView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            
            ])
    }
    
    
    
    
    

}
