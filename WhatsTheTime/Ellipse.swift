//
//  Ellipse.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 19/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Ellipse: UIView {

    
    // MARK: - Properties
    
    var containerView = UIView()
    var ellipse: CAShapeLayer!
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        setNeedsDisplay()
        
        //
//        containerView.setNeedsDisplay()
//        containerView.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        
//        ellipse.path = path().cgPath
//        containerView.setNeedsDisplay()
        ellipse.removeFromSuperlayer()
        ellipse = ellipseShapeLayer()
        containerView.layer.addSublayer(ellipse)

        
        
    }
    

    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        // Add containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.red
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        
        // Add ellipse
        ellipse = ellipseShapeLayer()
        containerView.layer.addSublayer(ellipse)
        
        
        // Set constraints
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ])
    }
    
    
    private func ellipseShapeLayer() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path().cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = COLOR.White.cgColor
        return shapeLayer
    }
    
    
    private func path() -> UIBezierPath {
        
        let path = UIBezierPath(ovalIn: containerView.bounds)
        return path
    }
    

}
