//
//  OngoingMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class OngoingMessageViewController: UIViewController {
    
//    var delegate: handlePreviousBookings?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonDismissed), for: .touchUpInside)
        
        return button
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "background4")
        imageView.image = origImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.BLACK.withAlphaComponent(0.2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.GRAY_WHITE
        imageView.layer.cornerRadius = 45/2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Tyler"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "[8:30 am - 12:00 pm]"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var messageBarBackground: UIView = {let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY.withAlphaComponent(0.6)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 0.5))
        line.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        view.addSubview(line)
        
        return view
    }()
    
    var messageTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.WHITE
        view.font = Fonts.SSPRegularH5
        view.textColor = Theme.BLACK.withAlphaComponent(0.7)
        view.text = "Write a message"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.layer.cornerRadius = 20
        view.layer.borderColor = Theme.BLACK.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 0.5
        view.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 42)
        
        return view
    }()
    
    var userMessageOptions: SendOptionsViewController = {
        let controller = SendOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupMessageBar()
        setupOptions()
    }
    
    func setupViews() {
    
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 24).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo:profileImageView.centerYAnchor, constant: -10).isActive = true
        
        self.view.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo:profileImageView.centerYAnchor, constant: 10).isActive = true
        
    }
    
    var messageBarBottomAnchor: NSLayoutConstraint!
    
    func setupMessageBar() {
        
        self.view.addSubview(messageBarBackground)
        messageBarBottomAnchor = messageBarBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
            messageBarBottomAnchor.isActive = true
        messageBarBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageBarBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            messageBarBackground.heightAnchor.constraint(equalToConstant: 96).isActive = true
        case .iphoneX:
            messageBarBackground.heightAnchor.constraint(equalToConstant: 108).isActive = true
        }
        
        messageBarBackground.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageBarBackground.topAnchor, constant: 12).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: messageBarBackground.leftAnchor, constant: 24).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: messageBarBackground.rightAnchor, constant: -24).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupOptions() {
        
        self.view.addSubview(userMessageOptions.view)
        self.view.bringSubviewToFront(messageBarBackground)
        userMessageOptions.view.bottomAnchor.constraint(equalTo: messageBarBackground.topAnchor, constant: 8).isActive = true
        userMessageOptions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        userMessageOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        userMessageOptions.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
    }
    
    func openMessageBar() {
        self.messageBarBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeMessageBar() {
        self.messageBarBottomAnchor.constant = 100
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonDismissed() {
//        self.delegate?.dismissOngoingMessages()
    }
    
}
