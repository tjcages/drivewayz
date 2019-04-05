//
//  MyOngoingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class MyOngoingViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var reservationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ongoing reservation"
        label.textColor = Theme.GREEN_PIGMENT
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "background4")
        imageView.image = origImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.OFF_WHITE
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Neville"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 1
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 20
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.LIGHT_BLUE
        view.settings.emptyBorderColor = UIColor.clear
        view.settings.filledBorderColor = Theme.BLUE
        view.settings.emptyColor = UIColor.clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.7"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "3:15-5:50pm"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var optionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        
        let size: CGFloat = 5.0
        let color = Theme.DARK_GRAY.withAlphaComponent(0.6)
        let start: CGFloat = 0
        let difference: CGFloat = 9
        
        let dot1 = UIView(frame: CGRect(x: 0.0, y: start, width: size, height: size))
        dot1.backgroundColor = color
        dot1.layer.cornerRadius = size/2
        button.addSubview(dot1)
        
        let dot2 = UIView(frame: CGRect(x: 0.0, y: start + difference, width: size, height: size))
        dot2.backgroundColor = color
        dot2.layer.cornerRadius = size/2
        button.addSubview(dot2)
        
        let dot3 = UIView(frame: CGRect(x: 0.0, y: start + difference * 2, width: size, height: size))
        dot3.backgroundColor = color
        dot3.layer.cornerRadius = size/2
        button.addSubview(dot3)
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var phoneIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "phoneIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN_PIGMENT
        button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        return button
    }()
    
    var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Call"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        
        return label
    }()
    
    var chatIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "messageIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN_PIGMENT
        
        return button
    }()
    
    var chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chat"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        
        return label
    }()
    
    var detailsIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "detailIcons");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN_PIGMENT
        
        return button
    }()
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Details"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
    }
    
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(reservationLabel)
        reservationLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        reservationLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        reservationLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        reservationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        container.addSubview(userName)
        userName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userName.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        userName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(stars)
        stars.leftAnchor.constraint(equalTo: userName.leftAnchor, constant: -2).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stars.topAnchor.constraint(equalTo: userName.bottomAnchor).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 2).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: userName.leftAnchor, constant: 48).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        durationLabel.topAnchor.constraint(equalTo: userName.topAnchor).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(optionsButton)
        optionsButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        optionsButton.topAnchor.constraint(equalTo: reservationLabel.topAnchor, constant: 8).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 8).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(line)
        line.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(phoneIcon)
        phoneIcon.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        phoneIcon.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        phoneIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        phoneIcon.heightAnchor.constraint(equalTo: phoneIcon.widthAnchor).isActive = true
        
        container.addSubview(phoneLabel)
        phoneLabel.leftAnchor.constraint(equalTo: phoneIcon.rightAnchor, constant: 2).isActive = true
        phoneLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        phoneLabel.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor, constant: -2).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(chatIcon)
        chatIcon.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: -60).isActive = true
        chatIcon.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        chatIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        chatIcon.heightAnchor.constraint(equalTo: phoneIcon.widthAnchor).isActive = true
        
        container.addSubview(chatLabel)
        chatLabel.leftAnchor.constraint(equalTo: chatIcon.rightAnchor, constant: 2).isActive = true
        chatLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        chatLabel.centerYAnchor.constraint(equalTo: chatIcon.centerYAnchor, constant: -2).isActive = true
        chatLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(detailsIcon)
        detailsIcon.leftAnchor.constraint(equalTo: container.rightAnchor, constant: -122).isActive = true
        detailsIcon.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        detailsIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        detailsIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(detailsLabel)
        detailsLabel.leftAnchor.constraint(equalTo: detailsIcon.rightAnchor, constant: 6).isActive = true
        detailsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        detailsLabel.centerYAnchor.constraint(equalTo: detailsIcon.centerYAnchor, constant: 3).isActive = true
        detailsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}