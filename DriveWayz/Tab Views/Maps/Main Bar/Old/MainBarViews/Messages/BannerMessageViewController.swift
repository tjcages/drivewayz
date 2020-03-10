//
//  BannerMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BannerMessageViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.GREEN, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var newMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.WHITE
        button.layer.borderColor = Theme.GREEN.cgColor
        button.layer.borderWidth = 1.5
        let image = UIImage(named: "settingsEmail")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GREEN
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var newMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Contact Drivewayz support"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to open"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(newMessageButton)
        newMessageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        newMessageButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newMessageButton.heightAnchor.constraint(equalTo: newMessageButton.widthAnchor).isActive = true
        newMessageButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.view.addSubview(newMessageLabel)
        newMessageLabel.leftAnchor.constraint(equalTo: newMessageButton.rightAnchor, constant: 24).isActive = true
        newMessageLabel.topAnchor.constraint(equalTo: newMessageButton.topAnchor, constant: -6).isActive = true
        newMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        newMessageLabel.sizeToFit()
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: newMessageButton.rightAnchor, constant: 24).isActive = true
        subLabel.topAnchor.constraint(equalTo: newMessageLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func currentMessage() {
        self.container.alpha = 1
        self.newMessageButton.layer.borderColor = UIColor.clear.cgColor
        self.newMessageButton.tintColor = Theme.GRAY_WHITE.withAlphaComponent(0.6)
        self.newMessageLabel.textColor = Theme.WHITE
        self.subLabel.textColor = Theme.WHITE
        self.newMessageLabel.text = "Drivewayz sent you a message"
    }
    
    func previousMessage() {
        self.container.alpha = 0
        self.newMessageButton.layer.borderColor = Theme.GREEN.cgColor
        self.newMessageButton.tintColor = Theme.GREEN
        self.newMessageLabel.textColor = Theme.BLACK
        self.subLabel.textColor = Theme.BLACK
        self.newMessageLabel.text = "Contact Drivewayz support"
    }

}
