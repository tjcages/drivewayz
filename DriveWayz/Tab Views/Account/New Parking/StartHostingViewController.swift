//
//  StartHostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/1/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class StartHostingViewController: UIViewController {

    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow these easy steps to list your parking space and start making money"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH2
        label.numberOfLines = 4
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Make up to an extra $100 a week while helping to improve your parking community"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 4
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
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
        
    }
    
    
}
