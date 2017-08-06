//
//  DurationCard.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationCard: UIView {

    
    // MARK: - Properties
    
    private var miniStopWatch: MiniStopWatch!
    private var ageLabel: UILabel!
    private var ageString: String = "" {
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
        
        miniStopWatch = MiniStopWatch()
        miniStopWatch.duration = duration
        miniStopWatch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(miniStopWatch)
        
        ageLabel = createAgeLabel(title: ageString)
        addSubview(ageLabel)
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
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = 8 * max(bounds.height, bounds.width) / 140
        
        NSLayoutConstraint.activate([
            
            miniStopWatch.centerXAnchor.constraint(equalTo: centerXAnchor),
            miniStopWatch.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80 / 140),
            miniStopWatch.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20 * bounds.height / 140),
            miniStopWatch.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 80 / 140),
            
            ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 120 / 140),
            ageLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 30 * bounds.height / 140),
            ageLabel.heightAnchor.constraint(equalToConstant: 25 * bounds.height / 140),
            
            ])
        
        miniStopWatch.setNeedsLayout()
        ageLabel.setNeedsLayout()
    }
    

    
    func animateMiniStopWatch() {
        
    }
    
}
