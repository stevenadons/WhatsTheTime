//
//  StopWatch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol StopWatchTimerDelegate: class {
    
    func handleTickCountDown()
    func handleTickCountUp()
    func handleTimerReset()
    func handleReachedZero()
}


class StopWatch: UIControl {
    
    
    // MARK: - Helper Classes
    
    
    // MARK: - Properties
    
    var game: HockeyGame!
    
    var message: String = LS_NEWGAME {
        didSet {
            messageLabel.text = message
            messageLabel.setNeedsDisplay()
        }
    }

    fileprivate var delegate: StopWatchDelegate!
    fileprivate var timer: StopWatchTimer!
    fileprivate var icon: StopWatchControlIcon!
    fileprivate var timeLabel: StopWatchLabel!

    private var half: Half {
        return game.half
    }
    private var duration: MinutesInHalf {
        return game.duration
    }

    private var squareContainer: CALayer!
    private var progressZone: CAShapeLayer!
    private var core: CALayer!
    fileprivate var firstProgressBar: CAShapeLayer!
    fileprivate var secondProgressBar: CAShapeLayer!
    private var messageLabel: UILabel!
    private var halfLabel: UILabel!
    private var durationLabel: UILabel!
    
    private let progressBarWidth: CGFloat = 18
    private let progressBarStrokeInsetRatio: CGFloat = 0.005
    
    private var squareSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        game = HockeyGame(duration: .TwentyFive)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        game = HockeyGame(duration: .TwentyFive)
        setUp()
    }
    
    convenience init(delegate: StopWatchDelegate, game: HockeyGame) {
        self.init()
        self.delegate = delegate
        self.game = game
        timer.set(duration: game.duration)
        timeLabel.text = stopWatchLabelTimeString()
        durationLabel.text = "2x\(game.duration.rawValue)min"
        halfLabel.text = LS_FIRSTHALFLABEL
        setNeedsLayout()
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        squareContainer.frame = bounds.insetBy(dx: (bounds.width - squareSide) / 2, dy: (bounds.height - squareSide) / 2)
        progressZone.frame = squareContainer.bounds
        progressZone.path = UIBezierPath(ovalIn: progressZone.bounds).cgPath
        core.frame = squareContainer.bounds.insetBy(dx: progressBarWidth, dy: progressBarWidth)
        core.cornerRadius = core.bounds.width / 2
        updateProgressBars()
        icon.frame = bounds.insetBy(dx: (130 * bounds.width / 230) / 2, dy: (130 * bounds.height / 230) / 2)
        timeLabel.frame = bounds.insetBy(dx: bounds.width * 0.15, dy: bounds.height * 0.35)
        NSLayoutConstraint.activate([
            
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            messageLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: CoordinateScalor.convert(y: 34)),
            
            durationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            durationLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CoordinateScalor.convert(y: -40)),
            
            halfLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            halfLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            halfLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            halfLabel.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: durationLabel.font.pointSize),
            
            ])
    }
    
    func stopWatchLabelTimeString() -> String {
        var result: String = ""
        let total = (timer.state == .RunningCountUp || timer.state == .Overdue) ? timer.totalSecondsCountingUp : timer.totalSecondsToGo
        if minutes(totalSeconds: total) < 10 {
            result.append("0")
        }
        result.append("\(minutes(totalSeconds: total)):")
        if seconds(totalSeconds: total) < 10 {
            result.append("0")
        }
        result.append("\(seconds(totalSeconds: total))")
        return result
    }
    
    func reset() {
        timer.reset()
        halfLabel.alpha = 1.0
        updateProgressBars()
        resetTimeLabel(withColor: COLOR.Theme, alpha: 1)
        setProgressBarsColor(to: COLOR.Theme)
        icon.icon = .PlayIcon
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
        
        // Add progressZone
        progressZone = CAShapeLayer()
        progressZone.strokeColor = UIColor.clear.cgColor
        progressZone.fillColor = COLOR.LightBackground.cgColor
        squareContainer.addSublayer(progressZone)
        
        // Add core
        core = CALayer()
        core.backgroundColor = COLOR.White.cgColor
        squareContainer.addSublayer(core)
        
        // Add progressbars
        firstProgressBar = progressBarLayer(for: .First)
        firstProgressBar.backgroundColor = UIColor.blue.cgColor
        squareContainer.addSublayer(firstProgressBar)
        secondProgressBar = progressBarLayer(for: .Second)
        squareContainer.addSublayer(secondProgressBar)

        // Add icon
        icon = StopWatchControlIcon(icon: .PlayIcon)
        icon.color = COLOR.Affirmation
        addSubview(icon)
        
        // Set up timer
        timer = StopWatchTimer(delegate: self, duration: duration)
        
        // Add time label
        timeLabel = StopWatchLabel(text: stopWatchLabelTimeString())
        addSubview(timeLabel)
        
        // Add small labels
        durationLabel = StopWatchSmallLabel()
        addSubview(durationLabel)
        messageLabel = StopWatchSmallLabel()
        message = LS_NEWGAME
        messageLabel.font = UIFont(name: FONTNAME.ThemeBold, size: durationLabel.font.pointSize)
        addSubview(messageLabel)
        halfLabel = StopWatchSmallLabel()
        halfLabel.font = UIFont(name: FONTNAME.ThemeBold, size: durationLabel.font.pointSize)
        addSubview(halfLabel)
                
        // Bring subviews to front
        for subview in subviews {
            bringSubview(toFront: subview)
        }
    }
    
    fileprivate func updateProgressBars() {
        
        firstProgressBar.removeFromSuperlayer()
        firstProgressBar = progressBarLayer(for: .First)
        firstProgressBar.strokeEnd = (self.half == .Second) ? strokeEndPosition(progress: 1) : strokeEndPosition(progress: timer.progress)
        squareContainer.addSublayer(firstProgressBar)
        
        secondProgressBar.removeFromSuperlayer()
        secondProgressBar = progressBarLayer(for: .Second)
        secondProgressBar.strokeEnd = (self.half == .First) ? strokeEndPosition(progress: 0) : strokeEndPosition(progress: timer.progress)
        squareContainer.addSublayer(secondProgressBar)
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
        shape.strokeEnd = progressBarStrokeInsetRatio
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
    
    private func strokeEndPosition(progress: CGFloat) -> CGFloat {
        let strokeField = 1.0 - progressBarStrokeInsetRatio * 2
        return progressBarStrokeInsetRatio + strokeField * progress
    }
    
    
    
    // MARK: - Helper methods

    private func seconds(totalSeconds: Int) -> Int {
        return totalSeconds % 60
    }
    
    private func minutes(totalSeconds: Int) -> Int {
        return totalSeconds / 60
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
                handleTap()
            }
        }
    }
    
    
    private func handleTap() {
        
        switch icon.icon {
            
        case .PlayIcon:
            // Start Half or Resume after pausing
            timer.startCountDown()
            game.status = .Running
            icon.change(to: .PauseIcon)
            icon.stopPulsing()
            message = ""
            delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)

        case .PauseIcon:
            // Pause while counting down
            timer.pause()
            game.status = .Pausing
            icon.change(to: .PlayIcon)
            icon.startPulsing()
            message = LS_GAMEPAUSED
            
        case .StopIcon:
            timer.stopCountUp()
            if game.status == .Running {
                // Game running in overtime
                if game.half == .First {
                    // End of first half - will enter half time count up mode
                    game.status = .HalfTime
                    timer.startCountUp()
                    setProgressBarsColor(to: COLOR.Theme)
                    message = LS_HALFTIME
                } else {
                    // End of second half
                    game.status = .Finished
                    setProgressBarsColor(to: UIColor.clear)
                    halfLabel.alpha = 0.0
                    icon.change(to: .NoIcon)
                    message = LS_FULLTIME
                }
                delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)

            } else if game.status == .HalfTime {
                // Half time counter stopped
                game.half = .Second
                halfLabel.text = LS_SECONDHALFLABEL
                timer.reset()
                setProgressBarsColor(to: COLOR.Theme)
                message = LS_READYFORH2
                delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: {
                    self.icon.change(to: .PlayIcon)
                })
            }
            resetTimeLabel(withColor: COLOR.Theme, alpha: 1)
            
        case .NoIcon:
            message = LS_NEWGAME
            delegate?.handleNewGame()
        }
    }
    
    fileprivate func resetTimeLabel(withColor color: UIColor, alpha: CGFloat) {
        timeLabel.textColor = color
        timeLabel.alpha = alpha
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    fileprivate func setProgressBarsColor(to newColor: UIColor) {
        firstProgressBar.strokeColor = newColor.cgColor
        firstProgressBar.setNeedsDisplay()
        secondProgressBar.strokeColor = newColor.cgColor
        secondProgressBar.setNeedsDisplay()
    }
}


extension StopWatch: StopWatchTimerDelegate {
    
    func handleTickCountDown() {
            timeLabel.text = stopWatchLabelTimeString()
            timeLabel.setNeedsDisplay()
            updateProgressBars()
    }
    
    func handleTickCountUp() {
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    func handleTimerReset() {
        timer.set(duration: game.duration)
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    func handleReachedZero() {
        updateProgressBars()
        message = LS_OVERTIME
        resetTimeLabel(withColor: COLOR.Negation, alpha: 1)
        setProgressBarsColor(to: COLOR.Negation)
        icon.change(to: .StopIcon)
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)
    }
}
