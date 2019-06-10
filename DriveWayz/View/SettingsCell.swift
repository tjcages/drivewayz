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
        let imageView = UIButton()
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPLightH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        
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
        button.titleLabel?.font = Fonts.SSPLightH5
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: self.frame.width - 75)
        button.alpha = 0
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var titleTopAnchor: NSLayoutConstraint!
    var titleCenterAnchor: NSLayoutConstraint!
    var titleLeftAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Theme.WHITE
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(paymentButton)
        addSubview(nextButton)
        
        iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleTopAnchor = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4)
            titleTopAnchor.isActive = true
        titleCenterAnchor = titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            titleCenterAnchor.isActive = false
        titleLeftAnchor = titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 30)
            titleLeftAnchor.isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        paymentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        paymentButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

