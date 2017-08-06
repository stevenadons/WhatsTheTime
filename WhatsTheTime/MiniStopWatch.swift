//
//  MiniStopWatch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MiniStopWatch: UIView {

    
    // MARK: - Properties
    
    var duration: MINUTESINHALF = .TwentyFive {
        didSet {
            durationLabel.text = AgeRange.durationString(for: duration)
            durationLabel.setNeedsDisplay()
        }
    }
    
    private var squareContainer: CALayer!
    private var progressZone: CAShapeLayer!
    private var core: CALayer!
    fileprivate var progressBar: CAShapeLayer!
    private var timesLabel: UILabel!
    private var durationLabel: UILabel!
    
    private let progressBarWidth: CGFloat = 9
    
    private var squareSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        squareContainer = CALayer()
        squareContainer.backgroundColor = UIColor.clear.cgColor
        squareContainer.shouldRasterize = true
        squareContainer.rasterizationScale = UIScreen.main.scale
        layer.addSublayer(squareContainer)
        
        progressZone = CAShapeLayer()
        progressZone.strokeColor = UIColor.clear.cgColor
        progressZone.fillColor = UIColor.clear.cgColor
        squareContainer.addSublayer(progressZone)
        
        core = CALayer()
        core.backgroundColor = COLOR.Affirmation.cgColor
        squareContainer.addSublayer(core)
        
        progressBar = progressBarLayer()
        squareContainer.addSublayer(progressBar)
        
        timesLabel = stopWatchLabel(text: "2x", bold: false)
        addSubview(timesLabel)
        durationLabel = stopWatchLabel(text: AgeRange.durationString(for: duration), bold: true)
        addSubview(durationLabel)
    }
    
    private func stopWatchLabel(text: String, bold: Bool) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        label.textColor = COLOR.Theme
        label.text = text
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        if bold {
            label.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        } else {
            label.font = UIFont(name: FONTNAME.ThemeRegular, size: 16)
        }
        return label
    }
    
    private func progressBarLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.strokeColor = COLOR.White.cgColor
        shape.lineWidth = progressBarWidth
        shape.lineCap = kCALineCapButt
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor.clear.cgColor
        shape.position = CGPoint.zero
        shape.strokeStart = 0.0
        shape.strokeEnd = 0.0
        shape.contentsScale = UIScreen.main.scale
        shape.path = progressBarPath().cgPath
        return shape
    }
    
    private func progressBarPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width / 2, y: progressBarWidth / 2))
        path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        return path
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        squareContainer.frame = bounds.insetBy(dx: (bounds.width - squareSide) / 2, dy: (bounds.height - squareSide) / 2)
        progressZone.frame = squareContainer.bounds
        progressZone.path = UIBezierPath(ovalIn: progressZone.bounds).cgPath
        core.frame = squareContainer.bounds.insetBy(dx: progressBarWidth, dy: progressBarWidth)
        core.cornerRadius = core.bounds.width / 2
        
        progressBar.path = progressBarPath().cgPath
        
        NSLayoutConstraint.activate([
            
            timesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timesLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 60 / 80),
            timesLabel.heightAnchor.constraint(equalToConstant: 18),
            timesLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 60 / 80),
            durationLabel.heightAnchor.constraint(equalToConstant: 18),
            durationLabel.topAnchor.constraint(equalTo: centerYAnchor),
            
            ])
    }
    
    
    // MARK: - User Methods

    func animateProgress(duration: Double) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration * Double(self.duration.rawValue) / 30.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fromValue = 0.0
        animation.toValue = CGFloat(Double(self.duration.rawValue) / 60.0)
        progressBar.add(animation, forKey: "timer effect")
        CATransaction.setDisableActions(true)
        progressBar.strokeEnd = CGFloat(Double(self.duration.rawValue) / 60.0)
        CATransaction.setDisableActions(false)
    }
    
    

}
