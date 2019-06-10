//
//  VehicleCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class VehicleCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Some sample text!"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Some sample text!"
        view.font = Fonts.SSPLightH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        
        return view
    }()
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Add")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return button
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35/2
        button.layer.borderColor = Theme.GREEN_PIGMENT.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.alpha = 0
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return button
    }()
    
    var titleTopAnchor: NSLayoutConstraint!
    var titleCenterAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Theme.WHITE
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(plusButton)
        addSubview(checkmark)
        
        titleTopAnchor = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4)
            titleTopAnchor.isActive = true
        titleCenterAnchor = titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            titleCenterAnchor.isActive = false
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
     
        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor).isActive = true
     
        checkmark.centerXAnchor.constraint(equalTo: plusButton.centerXAnchor).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 35).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

