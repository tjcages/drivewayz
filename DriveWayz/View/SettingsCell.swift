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
    
    func setIcon(image: UIImage?) {
        iconButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        iconButton.alpha = 1
        titleLabelLeftAnchor.constant = 60
        layoutIfNeeded()
    }
    
    func removeIcon() {
        iconButton.alpha = 0
        titleLabelLeftAnchor.constant = 20
        layoutIfNeeded()
    }
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GRAY_WHITE
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var defaultButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN.withAlphaComponent(0.2)
        button.setTitle("Default", for: .normal)
        button.setTitleColor(Theme.GREEN, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 25/2
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var titleLabelLeftAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(iconButton)
        addSubview(defaultButton)
        addSubview(arrowButton)

        titleLabelLeftAnchor = titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
            titleLabelLeftAnchor.isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.sizeToFit()
        
        subtitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        subtitleLabel.sizeToFit()
        
        iconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        defaultButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        defaultButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        defaultButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        defaultButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        arrowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

