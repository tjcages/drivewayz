//
//  SettingsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {
    
    var iconView: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPSemiBoldH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var defaultButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.2)
        button.setTitle("Default", for: .normal)
        button.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 25/2
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var titleLabelTopAnchor: NSLayoutConstraint!
    var titleLabelCenterAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(nextButton)
        addSubview(defaultButton)
        
        iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
        
        titleLabelTopAnchor = titleLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: -8)
            titleLabelTopAnchor.isActive = true
        titleLabelCenterAnchor = titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
            titleLabelCenterAnchor.isActive = false
        titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.sizeToFit()
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.sizeToFit()
        
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        defaultButton.centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor).isActive = true
        defaultButton.leftAnchor.constraint(equalTo: subtitleLabel.rightAnchor, constant: 12).isActive = true
        defaultButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        defaultButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

