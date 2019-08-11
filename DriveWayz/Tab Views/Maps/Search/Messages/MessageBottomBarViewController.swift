//
//  MessageBottomBarViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MessageBottomBarViewController: UIViewController {
    
    var imageIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "sendImageIcon")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var microphoneIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "sendMicrophoneIcon")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.LightBlue, bottomColor: Theme.DarkBlue)
        background.frame = CGRect(x: -200, y: -20, width: 300, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(imageIcon)
        imageIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        imageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageIcon.widthAnchor.constraint(equalTo: imageIcon.heightAnchor).isActive = true
        
        self.view.addSubview(microphoneIcon)
        microphoneIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        microphoneIcon.leftAnchor.constraint(equalTo: imageIcon.rightAnchor, constant: 12).isActive = true
        microphoneIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        microphoneIcon.widthAnchor.constraint(equalTo: microphoneIcon.heightAnchor).isActive = true
        
        self.view.addSubview(sendButton)
        sendButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }

}
