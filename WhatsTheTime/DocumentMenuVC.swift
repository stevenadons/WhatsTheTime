//
//  DocumentMenuVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol DocumentListDelegate: class {
    
     func handleButtonTapped(sender: DocumentButton)
}


class DocumentMenuVC: UIViewController {

    
    // MARK: - Properties
    
    fileprivate var backButton: BackButtonIconOnly!
    fileprivate var titleLabel: UILabel!
    fileprivate var documentList: DocumentList!

    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
        
    private func setup() {
        
        view.backgroundColor = UIColor.white

        documentList = DocumentList(delegate: self)
        documentList.backgroundColor = UIColor.clear
        view.addSubview(documentList)
        
        backButton = BackButtonIconOnly()
        backButton.alpha = 0.0
        backButton.addTarget(self, action: #selector(backButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(backButton)
        
        titleLabel = titleLabel(text: LS_TITLE_DOCUMENTS)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            documentList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            documentList.topAnchor.constraint(equalTo: view.topAnchor),
            documentList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 29)),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            ])
    }
    
    private func titleLabel(text: String) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.Theme
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        showBackButton(delay: 0.8)
        documentList.animateFlyIn()
    }
    
    
    
    // MARK: - Private Methods
    
    @objc private func backButtonTapped(sender: BackButton, forEvent event: UIEvent) {
        
        dismissVC()
    }
    
    private func showBackButton(delay: Double) {
        
        UIView.animate(withDuration: 0.2, delay: delay, options: [], animations: {
            self.backButton.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func dismissVC() {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension DocumentMenuVC: DocumentListDelegate {
    
    func handleButtonTapped(sender: DocumentButton) {
        
        let newVC = DocumentVC()
        newVC.urlString = sender.document.url
        newVC.modalTransitionStyle = .crossDissolve
        present(newVC, animated: true, completion: nil)
    }

}



