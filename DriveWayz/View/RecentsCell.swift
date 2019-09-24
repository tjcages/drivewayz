//
//  RecentsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class RecentsCell: UITableViewCell {
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.backgroundColor = lineColor
        button.layer.cornerRadius = 16
        let image = UIImage(named: "parking_history")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPSemiBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        view.text = "Recent"
        
        return view
    }()
    
    var subLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        view.text = "Fortune Towers, Parel East, Mumbai"
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconButton.heightAnchor.constraint(equalTo: iconButton.widthAnchor).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 12).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
