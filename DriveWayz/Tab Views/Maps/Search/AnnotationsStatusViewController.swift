//
//  AnnotationsStatusViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AnnotationsStatusViewController: UIViewController {
    
    var mainLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        label.text = "Zoom in to find available parking spots"
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.GREEN_PIGMENT.lighter(by: 5)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -2).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4).isActive = true
        
    }

    func needToZoom() {
        self.mainLabel.text = "Zoom in to find available parking spots"
        UIView.animate(withDuration: animationIn) {
            self.view.alpha = 1
            self.view.backgroundColor = Theme.GREEN_PIGMENT.lighter(by: 5)
            self.view.layoutIfNeeded()
        }
    }
    
    func noAvailableParking() {
        self.mainLabel.text = "There is currently no parking in this area"
        UIView.animate(withDuration: animationIn) {
            self.view.alpha = 1
            self.view.backgroundColor = Theme.DARK_GRAY.lighter(by: 20)
            self.view.layoutIfNeeded()
        }
    }
    
}
