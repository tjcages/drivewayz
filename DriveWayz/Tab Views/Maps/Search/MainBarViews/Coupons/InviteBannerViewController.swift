//
//  InviteBannerViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class InviteBannerViewController: UIViewController {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earn rewards!"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get discounts and credit"
        label.textColor = Theme.STRAWBERRY_PINK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = false
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -36).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }

}
