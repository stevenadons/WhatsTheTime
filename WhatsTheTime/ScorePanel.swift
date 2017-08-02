//
//  ScorePanel.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 2/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ScorePanel: UIView {

    
    // MARK: - Properties
    
    private var homeNameLabel: UILabel!
    private var awayNameLabel: UILabel!
    private var homeScoreLabel: UILabel!
    private var awayScoreLabel: UILabel!
    
    private var delegate: ScorePanelDelegate?
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: ScorePanelDelegate) {
        
        self.init()
        self.delegate = delegate
    }

    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        homeNameLabel = nameLabel(title: LS_HOME)
        addSubview(homeNameLabel)
        awayNameLabel = nameLabel(title: LS_AWAY)
        addSubview(awayNameLabel)
        
        homeScoreLabel = scoreLabel()
        addSubview(homeScoreLabel)
        awayScoreLabel = scoreLabel()
        addSubview(awayScoreLabel)
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
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 36)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.Theme
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            homeNameLabel.heightAnchor.constraint(equalToConstant: 25),
            homeNameLabel.topAnchor.constraint(equalTo: topAnchor),
            homeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            awayNameLabel.heightAnchor.constraint(equalTo: homeNameLabel.heightAnchor),
            awayNameLabel.topAnchor.constraint(equalTo: topAnchor),
            awayNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            awayNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            homeScoreLabel.topAnchor.constraint(equalTo: homeNameLabel.bottomAnchor),
            homeScoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            homeScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeScoreLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            awayScoreLabel.topAnchor.constraint(equalTo: awayNameLabel.bottomAnchor),
            awayScoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            awayScoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            awayScoreLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            ])
    }
    
    
    
    // MARK: - User methods
    
    func updateScore(for game: HockeyGame) {
        
        if homeScoreLabel.text != "\(game.homeScore)" {
            update(label: homeScoreLabel, withText: "\(game.homeScore)")
        } else if awayScoreLabel.text != "\(game.awayScore)" {
            update(label: awayScoreLabel, withText: "\(game.awayScore)")
        }
        
    }
    
    func update(label: UILabel, withText text: String) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: { 
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
                    label.textColor = COLOR.Theme
                }, completion: nil)
            })
        }
    }
   
    
    
    // MARK: - Hit testing
    
    //  Sometimes it is necessary for a view to ignore touch events and pass them through to the views below.
    //  For example, assume a transparent overlay view placed above all other application views.
    //  The overlay has some subviews in the form of controls and buttons which should respond to touches normally.
    //  But touching the overlay somewhere else should pass the touch events to the views below the overlay.
    //  http://smnh.me/hit-testing-in-ios/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var hitTestView = super.hitTest(point, with: event)
        if hitTestView == self {
            hitTestView = nil
        }
        return hitTestView
    }
    


}
