//
//  BannerMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BannerMessageViewController: UIViewController {
    
    var newMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 1
        let image = UIImage(named: "settingsEmail")
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var newMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz sent you a message"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to view"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH6
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.GREEN_PIGMENT
//        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: -1)
//        view.layer.shadowRadius = 6
//        view.layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(newMessageButton)
        newMessageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        newMessageButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newMessageButton.heightAnchor.constraint(equalTo: newMessageButton.widthAnchor).isActive = true
        newMessageButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.view.addSubview(newMessageLabel)
        newMessageLabel.leftAnchor.constraint(equalTo: newMessageButton.rightAnchor, constant: 24).isActive = true
        newMessageLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 14).isActive = true
        newMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        newMessageLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: newMessageButton.rightAnchor, constant: 24).isActive = true
        subLabel.topAnchor.constraint(equalTo: newMessageLabel.bottomAnchor, constant: -2).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

}
