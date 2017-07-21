//
//  StopWatch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 20/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


class StopWatch: UIButton {

    
    // MARK: - Helper Classes
    
    enum State {
        
        case Initial
        case CountingDown
        case Pausing
        case CountingUp
    }
    
    
    // MARK: - Properties
    
    var delegate: StopWatchDelegate?
    var session: StopWatchSession?
    
    private var stopWatchState: State = State.Initial
    private var progress: CGFloat = 1  // 0.0 to 1.0
    
    private var container: CALayer!
    private var core: CALayer!
    
    private var progressBar: CAShapeLayer!
    
    private let progressWidth: CGFloat = 18
    private let strokeInsetRatio: CGFloat = 0.005
    
    private var containerSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    private var coreSide: CGFloat {
        return containerSide - 2 * progressWidth
    }
    
    
    
    
    // MARK: - Initializers
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        container.bounds = CGRect(x: 0, y: 0, width: containerSide, height: containerSide)
        container.position = self.center
        
        core.frame = container.bounds.insetBy(dx: progressWidth, dy: progressWidth)
        core.cornerRadius = core.bounds.width / 2
        
        progressBar.removeFromSuperlayer()
        progressBar = progressLayer()
        container.addSublayer(progressBar)
    }
    
    
    
    
    // MARK: - Private methods
    
    private func setup() {
        
        // Configure self
        self.backgroundColor = UIColor.clear
        
        // Add session
        session = StopWatchSession()
        
        // Add container
        container = CALayer()
        container.backgroundColor = UIColor.clear.cgColor
        container.shouldRasterize = true
        container.rasterizationScale = UIScreen.main.scale
        self.layer.addSublayer(container)
        
        // Add core
        core = CALayer()
        core.backgroundColor = COLOR.LightBackground.cgColor
        core.borderColor = COLOR.DarkBackground.cgColor
        core.borderWidth = 1
        container.addSublayer(core)
        
        // Add progressbar
        progressBar = progressLayer()
        container.addSublayer(progressBar)
        
        // Bring subviews to front
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }
    
    
    private func progressLayer() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.strokeColor = COLOR.Theme.cgColor
        shape.lineWidth = progressWidth
        shape.lineCap = kCALineCapButt
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor.clear.cgColor
        shape.position = CGPoint.zero
        shape.strokeStart = strokeInsetRatio
        shape.strokeEnd = strokeEndPosition()
        shape.contentsScale = UIScreen.main.scale
        shape.path = progressPath().cgPath
        return shape
    }

    
    private func progressPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        guard session != nil else {
            return path }
        
        switch session!.half {
        case .First:
            path.move(to: CGPoint(x: bounds.width/2, y: progressWidth/2))
            path.addArc(withCenter: CGPoint(x: containerSide/2, y: containerSide/2), radius: (coreSide/2 + progressWidth/2), startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        case .Second:
            path.move(to: CGPoint(x: bounds.width/2, y: containerSide - progressWidth/2))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: (coreSide/2 + progressWidth/2), startAngle: .pi/2, endAngle: -.pi/2, clockwise: true)
        }
        return path
    }
    
    
    
    // MARK: - Math methods
    
    private func strokeEndPosition() -> CGFloat {
    
        let strokeField = 1.0 - strokeInsetRatio * 2
        return strokeInsetRatio + strokeField * progress
    }
    
    
    
    // MARK: - Touch methods
    
    private func isInsideCore(event: UIEvent) -> Bool {
        
        if let point: CGPoint = event.allTouches?.first?.location(in: self.superview) {
            let distance: CGFloat = sqrt(CGFloat(powf((Float(self.center.x - point.x)), 2) + powf((Float(self.center.y - point.y)), 2)))
            if (distance < coreSide/2) {
                return true
            }
        }
        return false
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        super.beginTracking(touch, with: event)
        if let event = event {
            if isInsideCore(event: event) {
                return true
            }
        }
        return false
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        super.continueTracking(touch, with: event)
        if let event = event {
            if isInsideCore(event: event) {
                return true
            }
        }
        return false
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        super.endTracking(touch, with: event)
        if let event = event {
            if isInsideCore(event: event) {
                handleButtonTapped()
            } 
        }
    }
    
    
    private func handleButtonTapped() {
        
        print("button tapped")
        delegate?.handleTap(button: self)
    }
    
    
    


}
