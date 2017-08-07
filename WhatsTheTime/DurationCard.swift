//
//  DurationCard.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationCard: UIButton {

    
    // MARK: - Properties
    
    fileprivate var miniStopWatch: MiniStopWatch!
    fileprivate var ageLabel: UILabel!
    fileprivate var ageString: String = "" {
        didSet {
            ageLabel.text = ageString
            ageLabel.setNeedsDisplay()
        }
    }
    var duration: MINUTESINHALF = .TwentyFive {
        didSet {
            switch duration {
            case .Twenty:
                backgroundColor = COLOR.DurationCardOne
            case .TwentyFive:
                backgroundColor = COLOR.DurationCardTwo
            case .Thirty:
                backgroundColor = COLOR.DurationCardThree
            case .ThirtyFive:
                backgroundColor = COLOR.DurationCardFour
            default:
                backgroundColor = COLOR.White
            }
            ageString = AgeRange.uString(for: duration)
            miniStopWatch.duration = duration
        }
    }
    

    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(duration: MINUTESINHALF) {
        
        self.init()
        convenienceSet(duration: duration)
    }
    
    private func convenienceSet(duration: MINUTESINHALF) {
        
        self.duration = duration
    }
    
    private func setup() {
        
        backgroundColor = UIColor.cyan
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderColor = COLOR.Theme.cgColor
        layer.borderWidth = 0
        
        miniStopWatch = MiniStopWatch()
        miniStopWatch.duration = duration
        miniStopWatch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(miniStopWatch)
        
        ageLabel = createAgeLabel(title: ageString)
        addSubview(ageLabel)
        
        windUp()
    }
    
    private func createAgeLabel(title: String) -> UILabel {
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 12)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.White
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func windUp() {
        
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        alpha = 0.0
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = 4 * max(bounds.height, bounds.width) / 140
        
        NSLayoutConstraint.activate([
            
            miniStopWatch.centerXAnchor.constraint(equalTo: centerXAnchor),
            miniStopWatch.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80 / 140),
            miniStopWatch.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12 * bounds.height / 140),
            miniStopWatch.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 80 / 140),
            
            ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 120 / 140),
            ageLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 38 * bounds.height / 140),
            ageLabel.heightAnchor.constraint(equalToConstant: 25 * bounds.height / 140),
            
            ])
        
        miniStopWatch.setNeedsLayout()
        ageLabel.setNeedsLayout()
    }
    
}


// MARK: - User Methods

extension DurationCard {
    
    func popup(delay: Double) {
        
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                self.transform = .identity
            }) { (finished) in
                self.animateMiniStopWatch(duration: 0.7)
            }
        }
    }
    
    func shrink(delay: Double) {
        
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            UIView.animate(withDuration: 0.15, delay: delay, options: [.curveEaseIn], animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (finished) in
                self.alpha = 0.0
            })
        }
    }
    
    func slideAway(newAlpha: CGFloat, slideDelay: Double, completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.3, delay: slideDelay, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.alpha = newAlpha
            self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        }, completion: { (finished) in
            completion?()
        })
    }
    
    func highlight() {
        
        UIView.transition(with: self, duration: 0.3, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.3, options: [.curveEaseIn], animations: { 
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (finished) in
                self.alpha = 0.0
            })
        }
    }
    
}


// MARK: - Private Methods

fileprivate extension DurationCard {
    
    func animateMiniStopWatch(duration: Double) {
        
        miniStopWatch.animateProgress(duration: duration)
    }
}





