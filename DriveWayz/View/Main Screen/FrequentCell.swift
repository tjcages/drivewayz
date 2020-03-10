//
//  FrequentCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class FrequentCell: UITableViewCell {
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "work_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "Add work"
        
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
    
        addSubview(mainButton)
        addSubview(mainLabel)
        
        mainButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalTo: mainButton.widthAnchor).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: mainButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        mainLabel.sizeToFit()
        
        addSubview(line)
        line.anchor(top: nil, left: mainLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
