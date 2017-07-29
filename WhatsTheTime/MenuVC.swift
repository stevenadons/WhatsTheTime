//
//  MenuVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 13/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol MenuDelegate: class {
    
    func handleNavigation(for menuItem: MenuItem)
}



class MenuVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var logo: Logo!
    private var dismissButton: DismissButtonIconOnly!
    private var menu: Menu!
    
    private let topCirclesInset: CGFloat = 70
    private let bottomCirclesInset: CGFloat = 100

    
    
    // MARK: - Public Methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.LightBackground
        setupViews()
        
        // to skip menu
        handleNavigation(for: MenuItem.Timer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        menu.enableBeat(interval: 5)
    }
    
    
    
    
    // MARK: - Private UI Methods
    
    private func setupViews() {
        
        logo = Bundle.main.loadNibNamed(NIBNAME.Logo, owner: self, options: nil)?.last as! Logo
        view.addSubview(logo)
        
        dismissButton = DismissButtonIconOnly()
        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(dismissButton)
        
        menu = Menu()
        menu.delegate = self
        view.addSubview(menu)
        
        NSLayoutConstraint.activate([
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: CoordinateScalor.convert(width: 200)),
            logo.heightAnchor.constraint(equalToConstant: CoordinateScalor.convert(height: 40)),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 23)),
            
            dismissButton.widthAnchor.constraint(equalToConstant: 44),
            dismissButton.heightAnchor.constraint(equalToConstant: 44),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: CoordinateScalor.convert(y: 30)),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CoordinateScalor.convert(y: 13)),
            
            menu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menu.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (topCirclesInset - bottomCirclesInset) / 2),
            menu.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -topCirclesInset - bottomCirclesInset),
            menu.widthAnchor.constraint(equalTo: menu.heightAnchor),
            
        ])
    }
    
    
    // MARK: - Private Methods
    
    @objc private func handleDismiss(sender: DismissButtonIconOnly, forEvent event: UIEvent) {
        
        print("dismissed")
    }
  
}



extension MenuVC: MenuDelegate {
    
    func handleNavigation(for menuItem: MenuItem) {
        
        var newVC = UIViewController()
        switch menuItem {
        case .Timer:
            newVC = TimerVC()
        case .SetGameTime:
            print("to be implemented")
        case .EditScore:
            print("to be implemented")
        case .Documents:
            print("to be implemented")
        }
        
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.height)
        if let view = newVC.view {
            view.frame = frameForView
            self.addChildViewController(newVC)
            self.view.addSubview(view)
            newVC.didMove(toParentViewController: self)
        }
    }
}







