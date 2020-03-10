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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "navigation_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.GRAY_WHITE_4
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconButton.heightAnchor.constraint(equalTo: iconButton.widthAnchor).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        subLabel.sizeToFit()

        addSubview(line)
        line.anchor(top: nil, left: mainLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
