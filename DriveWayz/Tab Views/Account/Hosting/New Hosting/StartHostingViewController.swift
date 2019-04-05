//
//  StartHostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/1/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class StartHostingViewController: UIViewController {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Become a host"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH0
        
        return label
    }()

    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow these easy steps to list your parking space"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH2
        label.numberOfLines = 4
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Make up to an extra $100 a week while helping to improve your parking community"
        label.textColor = Theme.WHITE.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 4
        
        return label
    }()
    
    var noParkingGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "noParkingGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.alpha = 0.9
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 82 - 120).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 92 - 120).isActive = true
        }
        
        self.view.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 29).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 29).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(noParkingGraphic)
        noParkingGraphic.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noParkingGraphic.heightAnchor.constraint(equalToConstant: 260).isActive = true
        noParkingGraphic.widthAnchor.constraint(equalToConstant: 260).isActive = true
        switch device {
        case .iphone8:
            noParkingGraphic.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 0).isActive = true
        case .iphoneX:
            noParkingGraphic.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 100).isActive = true
        }
        
    }
    
    
}
