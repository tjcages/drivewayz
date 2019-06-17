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
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        let origImage = UIImage(named: "profile")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Name"
        view.font = Fonts.SSPSemiBoldH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Samantha Willian"
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        
        return view
    }()
    
    lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
//        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: self.frame.width - 75)
        button.alpha = 0
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        addSubview(paymentButton)
        addSubview(nextButton)
        
        iconView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
        
        titleLabelTopAnchor = titleLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: -4)
            titleLabelTopAnchor.isActive = true
        titleLabelCenterAnchor = titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
            titleLabelCenterAnchor.isActive = false
        titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        paymentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        paymentButton.sizeToFit()
        
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

