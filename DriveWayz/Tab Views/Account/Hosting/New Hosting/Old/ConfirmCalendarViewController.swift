//
//  ConfirmCalendarViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ConfirmCalendarViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var popupLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 12
        label.text = """
        Are there any specific days your spot will be unavailable in the upcoming month(s)?
        
        You will always be able to change the specific availability or mark the spot inactive
        """
        
        return label
    }()

    var popupConfirm: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        //        button.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.8)
        
        setupViews()
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        containerTopAnchor = container.heightAnchor.constraint(equalToConstant: 0)
        containerTopAnchor.isActive = true
        switch device {
        case .iphone8:
            container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        }
        
        container.addSubview(popupLabel)
        popupLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24).isActive = true
        popupLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        popupLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        popupLabel.sizeToFit()
        
        container.addSubview(popupConfirm)
        popupConfirm.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -1).isActive = true
        popupConfirm.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 1).isActive = true
        popupConfirm.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 1).isActive = true
        popupConfirm.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func openContainer() {
        self.containerTopAnchor.constant = 300
        UIView.animate(withDuration: animationIn) {
            self.container.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func closeContainer() {
        self.containerTopAnchor.constant = 0
        UIView.animate(withDuration: animationIn) {
            self.container.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

}
