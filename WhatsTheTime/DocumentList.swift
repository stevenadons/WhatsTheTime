//
//  DocumentList.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DocumentList: UIView {

    
    // MARK: - Properties
    
    fileprivate var buttons: [DocumentButton] = []
    
    fileprivate let topInset: CGFloat = 135
    fileprivate let bottomInset: CGFloat = 185
    fileprivate let smallPadding: CGFloat = 8
    var bigPadding: CGFloat {
        let totalButtonsHeight = 7 * DocumentButton.fixedHeight
        let totalsmallPadding = 3 * smallPadding
        let totalbigPadding = bounds.height - topInset - bottomInset - totalButtonsHeight - totalsmallPadding
        return totalbigPadding / 3
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
    
    private func setup() {
        
        backgroundColor = UIColor.cyan
        translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0..<Document.allDocuments().count {
            let document = Document.allDocuments()[index]
            let button: DocumentButton
            if index == 3 || index == 6 {
                button = DocumentButton.yellowButton(document: document)
            } else {
                button = DocumentButton.blueButton(document: document)
            }
            button.heightAnchor.constraint(equalToConstant: DocumentButton.fixedHeight).isActive = true
            button.widthAnchor.constraint(equalToConstant: DocumentButton.fixedWidth).isActive = true
            addSubview(button)
            buttons.append(button)
        }
        windUp()
    }
    
    private func windUp() {
        
        for index in 0..<buttons.count {
            if index == 3 || index == 6 {
                buttons[index].transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            } else {
                buttons[index].transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            }
        }
    }
    
    
    
    // MARK: - Layout And Draw Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            
            buttons[0].leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            buttons[0].topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            buttons[1].leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            buttons[1].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: smallPadding),
            buttons[2].leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: smallPadding),
            buttons[3].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
            buttons[3].topAnchor.constraint(equalTo: buttons[2].bottomAnchor, constant: bigPadding),
            buttons[4].leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            buttons[4].topAnchor.constraint(equalTo: buttons[3].bottomAnchor, constant: bigPadding),
            buttons[5].leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            buttons[5].topAnchor.constraint(equalTo: buttons[4].bottomAnchor, constant: smallPadding),
            buttons[6].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
            buttons[6].topAnchor.constraint(equalTo: buttons[5].bottomAnchor, constant: bigPadding),
            
            ])
    }
    

    // MARK: - User Methods

    func animateFlyIn() {
        
        for index in 0..<buttons.count {
            var extraDelay: Double
            switch index {
            case 3:
                extraDelay = 0.2
            case 4...5:
                extraDelay = 0.4
            case 6:
                extraDelay = 0.6
            default:
                extraDelay = 0
            }
            UIView.animate(withDuration: 0.2, delay: 0.05 * Double(index) + extraDelay, options: [.allowUserInteraction, .curveEaseOut], animations: {
                self.buttons[index].transform = .identity
            }, completion: nil)
        }
    }
    
}


