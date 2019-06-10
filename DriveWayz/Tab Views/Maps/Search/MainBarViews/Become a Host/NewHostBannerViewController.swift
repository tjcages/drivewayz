//
//  NewHostBannerViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NewHostBannerViewController: UIViewController {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Become a Host"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Make your parking area to earn for you."
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }

    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }

}
