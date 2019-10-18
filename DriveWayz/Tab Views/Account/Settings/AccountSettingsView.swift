//
//  AccountSettingsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AccountSettingsView: UIViewController {
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "background4")
        view.image = image
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var memberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Standard member"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()

    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(memberLabel)
        view.addSubview(arrowButton)
        
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 72, height: 72)
        
        memberLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -12).isActive = true
        memberLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        memberLabel.sizeToFit()
        
        nameLabel.bottomAnchor.constraint(equalTo: memberLabel.topAnchor, constant: -4).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }

}
