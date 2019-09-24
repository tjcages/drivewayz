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
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earn money by renting out your parking space."
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 3
        
        return label
    }()
    
    var hostGraphic: UIImageView = {
        let image = UIImage(named: "newHostGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }

    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(hostGraphic)
        
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: hostGraphic.leftAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12).isActive = true
        subLabel.sizeToFit()
        
        hostGraphic.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 12).isActive = true
        hostGraphic.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        hostGraphic.heightAnchor.constraint(equalToConstant: 90).isActive = true
        hostGraphic.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }

}
