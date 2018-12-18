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
    
    var iconView: UIButton = {
        let imageView = UIButton()
        let image = UIImage(named: "feed")
        imageView.setImage(image, for: .normal)
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
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
    
    var titleTopAnchor: NSLayoutConstraint!
    var titleCenterAnchor: NSLayoutConstraint!
    var titleLeftAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

