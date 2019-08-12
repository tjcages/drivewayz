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
        let background = CAGradientLayer().customColor(topColor: Theme.GREEN_PIGMENT, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        
        return view
    }()
    
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
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to open"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = lineColor
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4).isActive = true
        
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

}
