//
//  Pitch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 30/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


let distanceMoveUp: CGFloat = 110


protocol BallDelegate: class {
    
    func homeScored()
    func awayScored()
}


class Pitch: UIView {

    
    // MARK: - Properties
    
    private var background: PitchBackgroundLayer!
    private var ball: Ball!
    private var homeNameLabel: UILabel!
    private var awayNameLabel: UILabel!
    fileprivate var homeScoreLabel: UILabel!
    fileprivate var awayScoreLabel: UILabel!
    
    fileprivate var delegate: PitchDelegate?
    fileprivate var homeScore: Int = 0
    fileprivate var awayScore: Int = 0
    
    private var swipeUp: UISwipeGestureRecognizer?
    private var swipeDown: UISwipeGestureRecognizer?
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: PitchDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        background = PitchBackgroundLayer()
        background.frame = bounds
        layer.addSublayer(background)
        
        homeNameLabel = nameLabel(title: LS_HOME)
        addSubview(homeNameLabel)
        awayNameLabel = nameLabel(title: LS_AWAY)
        addSubview(awayNameLabel)
        
        homeScoreLabel = scoreLabel()
        addSubview(homeScoreLabel)
        awayScoreLabel = scoreLabel()
        addSubview(awayScoreLabel)
        
        ball = Ball(delegate: self)
        addSubview(ball)
    }
    
    private func nameLabel(title: String) -> UILabel {
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.Theme
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func scoreLabel() -> UILabel {
        
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 56)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.White
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        background.frame = bounds
        background.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            
            homeNameLabel.heightAnchor.constraint(equalToConstant: 25),
            homeNameLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -38 * bounds.height / 202),
            homeNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            homeNameLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            awayNameLabel.heightAnchor.constraint(equalTo: homeNameLabel.heightAnchor),
            awayNameLabel.topAnchor.constraint(equalTo: homeNameLabel.topAnchor),
            awayNameLabel.widthAnchor.constraint(equalTo: homeNameLabel.widthAnchor),
            awayNameLabel.leadingAnchor.constraint(equalTo: homeNameLabel.trailingAnchor),
            
            homeScoreLabel.heightAnchor.constraint(equalToConstant: 75),
            homeScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            homeScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.5 * bounds.width / 375),
            homeScoreLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 102.5 * bounds.width / 375),

            awayScoreLabel.heightAnchor.constraint(equalTo: homeScoreLabel.heightAnchor),
            awayScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            awayScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width - 102.5 * bounds.width / 375),
            awayScoreLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width - 18.5 * bounds.width / 375),
            
            ball.centerXAnchor.constraint(equalTo: centerXAnchor),
            ball.centerYAnchor.constraint(equalTo: centerYAnchor),
            ball.heightAnchor.constraint(equalToConstant: 40),
            ball.widthAnchor.constraint(equalToConstant: 40),
            
            ])
    }
    
    
    // MARK: - User methods
    
    func showBall() {
        
        ball.isUserInteractionEnabled = true
        if ball.alpha < 1 {
            UIView.animate(withDuration: 0.2) {
                self.ball.alpha = 1
            }
        }
    }
    
    func hideBall() {
        
        ball.isUserInteractionEnabled = false
        if ball.alpha > 0 {
            UIView.animate(withDuration: 0.2) {
                self.ball.alpha = 0
            }
        }
    }
    
    func moveUp(completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(translationX: 0, y: CoordinateScalor.convert(y: -110))
        }, completion: { (finished) in
            self.configureSwipes()
            completion?()
        })
    }
    
    func moveBack(completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            completion?()
        })
        disableSwipes()
    }

    func resetScores() {
        
        homeScore = 0
        homeScoreLabel.text = "\(homeScore)"
        awayScore = 0
        awayScoreLabel.text = "\(awayScore)"
    }
    
    
    
    // MARK: - Private Methods
    
    fileprivate func updateScore(for game: HockeyGame) {
        
        if homeScoreLabel.text != "\(game.homeScore)" {
            update(label: homeScoreLabel, withText: "\(game.homeScore)")
        } else if awayScoreLabel.text != "\(game.awayScore)" {
            update(label: awayScoreLabel, withText: "\(game.awayScore)")
        }
    }
    
    fileprivate func update(label: UILabel, withText text: String) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            label.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (finished) in
            label.text = text
            label.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
            label.textColor = COLOR.Affirmation
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
                label.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.delegate?.scoreLabelChanged()
                UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
                    label.textColor = COLOR.White
                }, completion: nil)
            })
        }
    }
    
     func configureSwipes() {
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(swipe:)))
        swipeUp?.direction = .up
        addGestureRecognizer(swipeUp!)
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(swipe:)))
        swipeDown?.direction = .down
        addGestureRecognizer(swipeDown!)
    }
    
    private func disableSwipes() {
        
        gestureRecognizers?.forEach { removeGestureRecognizer($0) }
    }
    
    @objc private func swipeUp(swipe: UISwipeGestureRecognizer) {
        
        let location = swipe.location(in: self)
        if location.x < bounds.width / 2 {
            homeScore += 1
            homeScoreLabel.text = "\(homeScore)"
            delegate?.scoreHome()
        } else {
            awayScore += 1
            awayScoreLabel.text = "\(awayScore)"
            delegate?.scoreAway()
        }
    }
    
    @objc private func swipeDown(swipe: UISwipeGestureRecognizer) {
        
        let location = swipe.location(in: self)
        if location.x < bounds.width / 2 {
            print("down left")
            guard homeScore > 0 else { return }
            homeScore -= 1
            homeScoreLabel.text = "\(homeScore)"
            delegate?.scoreHomeMinusOne()
        } else {
            guard awayScore > 0 else { return }
            awayScore -= 1
            awayScoreLabel.text = "\(awayScore)"
            delegate?.scoreAwayMinusOne()
        }
    }
    
    // Extends the touchable area of the view in order to receive touches
    // Swipe detection in score edit mode
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
            return nil
        }
        let touchRect = CGRect(x: 0, y: -distanceMoveUp, width: bounds.width, height: bounds.height + distanceMoveUp)
        if touchRect.contains(point) {
            for subview in self.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: self)
                let hitTestView = subview.hitTest(convertedPoint, with: event)
                if hitTestView != nil {
                    return hitTestView
                }
            }
            return self
        }
        return nil
        
        
        
//        if (CGRectContainsPoint(touchRect, point)) {
//            for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
//                CGPoint convertedPoint = [subview convertPoint:point fromView:self];
//                UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
//                if (hitTestView) {
//                    return hitTestView;
//                }
//            }
//            return self;
//        }
//        return nil;
    }
    

}


extension Pitch: BallDelegate {
    
    func homeScored() {
        
        homeScore += 1
        update(label: homeScoreLabel, withText: "\(homeScore)")
        delegate?.scoreHome()
    }
    
    func awayScored() {
        
        awayScore += 1
        update(label: awayScoreLabel, withText: "\(awayScore)")
        delegate?.scoreAway()
    }
}
