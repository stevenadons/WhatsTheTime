//
//  StopWatchUI.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


class StopWatchUI: UIButton {
    
    
    // MARK: - Helper Classes
    
    enum State {
        
        case Initial
        case CountingDown
        case Pausing
        case CountingUp
    }
    
    
    // MARK: - Properties
    
    var delegate: StopWatchUIDelegate?
    
    private var stopWatchState: State = State.Initial
    private var progress: CGFloat = 1  // 0.0 to 1.0
    
    private var container: CALayer!
    private var core: CALayer!
    private var firstProgressBar: CAShapeLayer!
    private var secondProgressBar: CAShapeLayer!
    
    private let progressWidth: CGFloat = 18
    private let strokeInsetRatio: CGFloat = 0.005
    
    private var containerSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    var coreSide: CGFloat {
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
    
    
    convenience init(delegate: StopWatchUIDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        container.bounds = CGRect(x: 0, y: 0, width: containerSide, height: containerSide)
        container.position = self.center
        
        core.frame = container.bounds.insetBy(dx: progressWidth, dy: progressWidth)
        core.cornerRadius = core.bounds.width / 2
        
        firstProgressBar.removeFromSuperlayer()
        firstProgressBar = progressLayer(for: .First)
        container.addSublayer(firstProgressBar)
        
        secondProgressBar.removeFromSuperlayer()
        secondProgressBar = progressLayer(for: .Second)
        container.addSublayer(secondProgressBar)
    }
    
    
    
    // MARK: - Private methods
    
    private func setup() {
        
        // Configure self
        self.backgroundColor = UIColor.clear
        
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
        
        // Add progressbars
        firstProgressBar = progressLayer(for: .First)
        container.addSublayer(firstProgressBar)
        secondProgressBar = progressLayer(for: .Second)
        container.addSublayer(secondProgressBar)
        
        // Bring subviews to front
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }
    
    
    private func progressLayer(for half: Half) -> CAShapeLayer {
        
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
        shape.path = progressPath(for: half).cgPath
        return shape
    }
    
    
    private func progressPath(for half: Half) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        switch half {
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
                handleTap()
            }
        }
    }
    
    
    private func handleTap() {
        
        print("button tapped")
        delegate?.handleTap(stopWatchUI: self)
    }
    
    
    
    
    
}
