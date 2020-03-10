//
//  StartHostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/1/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class StartHostingViewController: UIViewController {
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Become a host"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()

    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow these easy steps to list your parking space"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 4
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Make up to $100 a week while helping to improve your parking community"
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 4
        
        return label
    }()
    
    var hostGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "hostGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit

        return view
    }()
    
    var informationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Read our host policies here", for: .normal)
        button.setTitleColor(Theme.BLUE.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: phoneWidth).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
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
        
        self.view.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 16).isActive = true
        parkingLabel.sizeToFit()
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 16).isActive = true
        informationLabel.sizeToFit()
        
        self.view.addSubview(informationButton)
        informationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationButton.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 16).isActive = true
        informationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationButton.sizeToFit()
        
        self.view.addSubview(hostGraphic)
        hostGraphic.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive = true
        hostGraphic.heightAnchor.constraint(equalToConstant: phoneWidth - 40).isActive = true
        hostGraphic.widthAnchor.constraint(equalToConstant: phoneWidth - 40).isActive = true
        switch device {
        case .iphone8:
            hostGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 60).isActive = true
        case .iphoneX:
            hostGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 40).isActive = true
        }
        
    }
    
    
}
