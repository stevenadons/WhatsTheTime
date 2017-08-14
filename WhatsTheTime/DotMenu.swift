//
//  DotMenu.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DotMenu: UIView {

    // NOTE
    // How to use:
    // Initialize with DotMenu.init(inView: superView) // f.i. with superView being VC.view
    // Remove with yourDotMenu.removeFromSuperview()
    
    
    // MARK: - Properties
    
    private var tap: UITapGestureRecognizer!
    
    private var menuButton: DotMenuMainButton!
    private var editButton: DotMenuItemButton!
    private var timeButton: DotMenuItemButton!
    private var documentButton: DotMenuItemButton!
    
    private var editLabel: DotMenuItemLabel!
    private var timeLabel: DotMenuItemLabel!
    private var documentLabel: DotMenuItemLabel!
    
    private var delegate: DotMenuDelegate!
    
    private let buttonWidth: CGFloat = 44
    private let buttonHeight: CGFloat = 44
    private let labelWidth: CGFloat = 150
    private let labelHeight: CGFloat = 20
    private let padding: CGFloat = 18
    private let labelInset: CGFloat = 20
    
    
    // MARK: - Initializing
    
    convenience init(inView containingView: UIView, delegate: DotMenuDelegate) {
        
        self.init()
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = UIColor.clear
        self.delegate = delegate
        
        tap = UITapGestureRecognizer(target: self, action: #selector(hideButtons))
        addGestureRecognizer(tap)
        
        menuButton = DotMenuMainButton(shapeColor: UIColor.blue, bgColor: UIColor.white)
        menuButton.addTarget(self, action: #selector(handleMenuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        menuButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        menuButton.frame.origin = CGPoint(x: 22, y: 35)
        addSubview(menuButton)
        
        editButton = DotMenuItemButton(shapeColor: UIColor.blue, bgColor: UIColor.white, path: pathEditButton(buttonWidth: buttonWidth, buttonHeight: buttonHeight))
        editButton.tag = 1
        editButton.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        editButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        editButton.frame.origin = CGPoint(x: 22, y: menuButton.frame.origin.y + editButton.bounds.height + padding)
        insertSubview(editButton, belowSubview: menuButton)
        
        timeButton = DotMenuItemButton(shapeColor: UIColor.blue, bgColor: UIColor.white, path: pathTimeButton(buttonWidth: buttonWidth, buttonHeight: buttonHeight))
        timeButton.tag = 2
        timeButton.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        timeButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        timeButton.frame.origin = CGPoint(x: 22, y: editButton.frame.origin.y + timeButton.bounds.height + padding)
        insertSubview(timeButton, belowSubview: editButton)
        
        documentButton = DotMenuItemButton(shapeColor: UIColor.blue, bgColor: UIColor.white, path: pathDocumentButton(buttonWidth: buttonWidth, buttonHeight: buttonHeight))
        documentButton.tag = 3
        documentButton.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        documentButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        documentButton.frame.origin = CGPoint(x: 22, y: timeButton.frame.origin.y + documentButton.bounds.height + padding)
        insertSubview(documentButton, belowSubview: timeButton)
        
        let labelX = max(editButton.frame.origin.x + editButton.bounds.width,
                         timeButton.frame.origin.x + timeButton.bounds.width,
                         documentButton.frame.origin.x + documentButton.bounds.width) + labelInset
        
        editLabel = DotMenuItemLabel()
        editLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        editLabel.frame.origin = CGPoint(x: labelX, y: editButton.frame.origin.y + (editButton.bounds.height - editLabel.bounds.height) / 2)
        insertSubview(editLabel, belowSubview: documentButton)
        
        timeLabel = DotMenuItemLabel()
        timeLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        timeLabel.frame.origin = CGPoint(x: labelX, y: timeButton.frame.origin.y + (timeButton.bounds.height - timeLabel.bounds.height) / 2)
        insertSubview(timeLabel, belowSubview: editLabel)
        
        documentLabel = DotMenuItemLabel()
        documentLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        documentLabel.frame.origin = CGPoint(x: labelX, y: documentButton.frame.origin.y + (documentButton.bounds.height - documentLabel.bounds.height) / 2)
        insertSubview(documentLabel, belowSubview: timeLabel)
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    private func windUp() {
        
        menuButton.transform = CGAffineTransform(rotationAngle: .pi/4)
        editButton.transform = CGAffineTransform(translationX: 0, y: -padding - editButton.bounds.height)
        timeButton.transform = CGAffineTransform(translationX: 0, y: -padding - editButton.bounds.height - padding - timeButton.bounds.height)
        documentButton.transform = CGAffineTransform(translationX: 0, y: -padding - editButton.bounds.height - padding - timeButton.bounds.height - padding - documentButton.bounds.height)
    }
    
    
    @objc private func handleMenuButtonTapped(sender: MenuButton, forEvent event: UIEvent) {
        
        if menuButton.transform == .identity {
            hideButtons()
        } else {
            showButtons()
        }
    }
    
    @objc private func handleOtherButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideButtons()
        delegate.handleDotMenuButtonTapped(buttonNumber: sender.tag)
    }
    
    private func showButtons() {
        menuButton.invertColors()
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.menuButton.transform = .identity
            self.editButton.transform = .identity
            self.timeButton.transform = .identity
            self.documentButton.transform = .identity
        }, completion: {(finished) in
            self.editLabel.grow(text: "EDIT SCORES", duration: 0.05)
            self.timeLabel.grow(text: "SET GAME TIME", duration: 0.05)
            self.documentLabel.grow(text: "VIEW DOCUMENTS", duration: 0.05)
        })
    }
    
    @objc private func hideButtons() {
        editLabel.title = ""
        timeLabel.title = ""
        documentLabel.title = ""
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
            self.backgroundColor = UIColor.clear
            self.menuButton.resetColors()
            self.menuButton.transform = CGAffineTransform(rotationAngle: .pi/4)
            self.editButton.transform = CGAffineTransform(translationX: 0, y: -self.padding - self.editButton.bounds.height)
            self.timeButton.transform = CGAffineTransform(translationX: 0, y: -self.padding - self.editButton.bounds.height - self.padding - self.timeButton.bounds.height)
            self.documentButton.transform = CGAffineTransform(translationX: 0, y: -self.padding - self.editButton.bounds.height - self.padding - self.timeButton.bounds.height - self.padding - self.documentButton.bounds.height)
        }, completion: nil)
    }
    
    private func pathEditButton(buttonWidth: CGFloat, buttonHeight: CGFloat) -> UIBezierPath {
        let widthScale = buttonWidth / 44
        let heightScale = buttonHeight / 44
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 15.5 * widthScale, y: 19 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 12 * heightScale))
        path.addLine(to: CGPoint(x: 28.5 * widthScale, y: 19 * heightScale))
        path.move(to: CGPoint(x: 15.5 * widthScale, y: 25 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 32 * heightScale))
        path.addLine(to: CGPoint(x: 28.5 * widthScale, y: 25 * heightScale))
        return path
    }
    
    private func pathTimeButton(buttonWidth: CGFloat, buttonHeight: CGFloat) -> UIBezierPath {
        let widthScale = buttonWidth / 44
        let heightScale = buttonHeight / 44
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 22 * widthScale, y: 10 * heightScale))
        path.addArc(withCenter: CGPoint(x: 22 * widthScale, y: 22 * widthScale), radius: 12 * min(widthScale, heightScale), startAngle: -.pi/2, endAngle: .pi * 3 / 2, clockwise: true)
        path.move(to: CGPoint(x: 22 * widthScale, y: 14.5 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 22 * heightScale))
        path.addLine(to: CGPoint(x: 26.5 * widthScale, y: 19 * heightScale))
        return path
    }
    
    private func pathDocumentButton(buttonWidth: CGFloat, buttonHeight: CGFloat) -> UIBezierPath {
        let widthScale = buttonWidth / 44
        let heightScale = buttonHeight / 44
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 24.5 * widthScale, y: 10.5 * heightScale))
        path.addLine(to: CGPoint(x: 14.5 * widthScale, y: 10.5 * heightScale))
        path.addLine(to: CGPoint(x: 14.5 * widthScale, y: 34.5 * heightScale))
        path.addLine(to: CGPoint(x: 30.5 * widthScale, y: 34.5 * heightScale))
        path.addLine(to: CGPoint(x: 30.5 * widthScale, y: 16.5 * heightScale))
        path.addLine(to: CGPoint(x: 24.5 * widthScale, y: 10.5 * heightScale))
        path.addLine(to: CGPoint(x: 24.5 * widthScale, y: 16.5 * heightScale))
        path.addLine(to: CGPoint(x: 30.5 * widthScale, y: 16.5 * heightScale))
        path.move(to: CGPoint(x: 17.5 * widthScale, y: 20.5 * heightScale))
        path.addLine(to: CGPoint(x: 27.5 * widthScale, y: 20.5 * heightScale))
        path.move(to: CGPoint(x: 17.5 * widthScale, y: 24.5 * heightScale))
        path.addLine(to: CGPoint(x: 25.5 * widthScale, y: 24.5 * heightScale))
        path.move(to: CGPoint(x: 17.5 * widthScale, y: 28.5 * heightScale))
        path.addLine(to: CGPoint(x: 27.5 * widthScale, y: 28.5 * heightScale))
        return path
    }
    
    
    
    // MARK: - Touch Methods
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if backgroundColor == UIColor.clear {
            // If menu not collapsed: only return subviews
            var hitTestView = super.hitTest(point, with: event)
            if hitTestView == self {
                hitTestView = nil
            }
            return hitTestView
        }
        // If menu expanded: standard hittesting
        return super.hitTest(point, with: event)
    }
  
}
