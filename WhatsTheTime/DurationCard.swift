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
                backgroundColor = COLOR.Blue
                miniStopWatch.color = COLOR.BlueLight
            case .TwentyFive:
                backgroundColor = COLOR.Green
                miniStopWatch.color = COLOR.GreenLight
            case .Thirty:
                backgroundColor = COLOR.Orange
                miniStopWatch.color = COLOR.OrangeLight
            case .ThirtyFive:
                backgroundColor = COLOR.Red
                miniStopWatch.color = COLOR.RedLight
            default:
                backgroundColor = COLOR.White
            }
            ageString = AgeRange.uString(for: duration)
            miniStopWatch.duration = duration
            miniStopWatch.setNeedsDisplay()
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
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        
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
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 14)
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
        
        layer.cornerRadius = 8 * max(bounds.height, bounds.width) / 140
        
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
                self.animateMiniStopWatch(duration: 0.4)
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
    
    func fadeOut(delay: Double, completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.3, delay: delay, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.alpha = 0.0
        }, completion: { (finished) in
            completion?()
        })
    }
    
    func highlight() {
        
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.2
        animation.fromValue = 0.0
        animation.toValue = 6.0
        layer.add(animation, forKey: "border")
        layer.borderWidth = 6.0
    }
    
}


// MARK: - Private Methods

fileprivate extension DurationCard {
    
    func animateMiniStopWatch(duration: Double) {
        
        miniStopWatch.animateProgress(duration: duration)
    }
}





