//
//  StopWatch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol StopWatchTimerDelegate: class {
    
    func handleTick(for: StopWatchTimer, timeString: String)
    func handlePause(for: StopWatchTimer)
    func handleReset(for: StopWatchTimer)
    func handleReachedZero(for: StopWatchTimer, timeString: String)
    
}


class StopWatch: UIControl {
    
    
    // MARK: - Helper Classes
    
    enum Mode {
        
        case CountingDown
        case CountingUp
    }
    
    
    // MARK: - Properties
    
    
    fileprivate var delegate: StopWatchDelegate!
    fileprivate var timer: StopWatchTimer!
    fileprivate var icon: StopWatchControlIcon!
    fileprivate var timeLabel: StopWatchLabel!
    
    private var mode: Mode = .CountingDown
    private var progress: CGFloat = 1  // 0.0 to 1.0

    private var squareContainer: CALayer!
    private var core: CALayer!
    private var firstProgressBar: CAShapeLayer!
    private var secondProgressBar: CAShapeLayer!
    
    private let progressBarWidth: CGFloat = 18
    private let progressBarStrokeInsetRatio: CGFloat = 0.005
    
    private var squareSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    convenience init(delegate: StopWatchDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        squareContainer.frame = bounds.insetBy(dx: (bounds.width - squareSide) / 2, dy: (bounds.height - squareSide) / 2)

        core.frame = squareContainer.bounds.insetBy(dx: progressBarWidth, dy: progressBarWidth)
        core.cornerRadius = core.bounds.width / 2
        
        firstProgressBar.removeFromSuperlayer()
        firstProgressBar = progressBarLayer(for: .First)
        squareContainer.addSublayer(firstProgressBar)
        
        secondProgressBar.removeFromSuperlayer()
        secondProgressBar = progressBarLayer(for: .Second)
        squareContainer.addSublayer(secondProgressBar)
        
        icon.frame = bounds.insetBy(dx: (130 * bounds.width / 230) / 2, dy: (130 * bounds.height / 230) / 2)
        timeLabel.frame = bounds.insetBy(dx: bounds.width * 0.15, dy: bounds.height * 0.35)
    }
    
    
    
    // MARK: - Private methods
    
    private func setUp() {
        
        // Configure self
        backgroundColor = UIColor.clear
        
        // Add container
        squareContainer = CALayer()
        squareContainer.backgroundColor = UIColor.clear.cgColor
        squareContainer.shouldRasterize = true
        squareContainer.rasterizationScale = UIScreen.main.scale
        layer.addSublayer(squareContainer)
        
        // Add core
        core = CALayer()
        core.backgroundColor = COLOR.LightBackground.cgColor
        core.borderColor = COLOR.DarkBackground.cgColor
        core.borderWidth = 1
        squareContainer.addSublayer(core)
        
        // Add progressbars
        firstProgressBar = progressBarLayer(for: .First)
        squareContainer.addSublayer(firstProgressBar)
        secondProgressBar = progressBarLayer(for: .Second)
        squareContainer.addSublayer(secondProgressBar)
        
        // Add icon
        icon = StopWatchControlIcon(icon: .PlayIcon)
        icon.color = COLOR.Affirmation
        addSubview(icon)
        
        // Set up timer
        timer = StopWatchTimer(delegate: self)
        
        // Add timeLabel
        timeLabel = StopWatchLabel(timer: timer)
        addSubview(timeLabel)
        
        // Bring subviews to front
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }
    
    
    
    // MARK: - Progress Bar Methods
    
    private func progressBarLayer(for half: Half) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.strokeColor = COLOR.Theme.cgColor
        shape.lineWidth = progressBarWidth
        shape.lineCap = kCALineCapButt
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor.clear.cgColor
        shape.position = CGPoint.zero
        shape.strokeStart = progressBarStrokeInsetRatio
        shape.strokeEnd = strokeEndPosition()
        shape.contentsScale = UIScreen.main.scale
        shape.path = progressBarPath(for: half).cgPath
        return shape
    }
    
    
    private func progressBarPath(for half: Half) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        switch half {
        case .First:
            path.move(to: CGPoint(x: bounds.width / 2, y: progressBarWidth / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        case .Second:
            path.move(to: CGPoint(x: bounds.width / 2, y: bounds.height - progressBarWidth / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: .pi/2, endAngle: -.pi/2, clockwise: true)
        }
        return path
    }
    
    
    private func strokeEndPosition() -> CGFloat {
        
        let strokeField = 1.0 - progressBarStrokeInsetRatio * 2
        return progressBarStrokeInsetRatio + strokeField * progress
    }
    
    
    
    // MARK: - Touch methods
    
    private func isInsideCore(event: UIEvent) -> Bool {
        
        if let point: CGPoint = event.allTouches?.first?.location(in: self.superview) {
            let distance: CGFloat = sqrt(CGFloat(powf((Float(self.center.x - point.x)), 2) + powf((Float(self.center.y - point.y)), 2)))
            if (distance < (squareSide / 2 - progressBarWidth)) {
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
                iconTapped()
            }
        }
    }
    
    private func iconTapped() {
        
        print("icon tapped")
    }
}


extension StopWatch: StopWatchTimerDelegate {
    
    func handleTick(for: StopWatchTimer, timeString: String) {
        timeLabel.text = timeString
    }
    
    func handlePause(for: StopWatchTimer) {
    }
    
    func handleReset(for: StopWatchTimer) {
    }
    
    func handleReachedZero(for: StopWatchTimer, timeString: String) {
        timeLabel.text = timeString
    }
}
