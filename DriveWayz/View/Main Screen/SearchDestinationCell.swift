//
//  SearchDestinationCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import CoreLocation

class SearchDestinationCell: UITableViewCell {
    
    var specificAddress: String?
    var placeID: String?
    var coordinate: CLLocationCoordinate2D?
    var placemark: CLPlacemark?
        
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "clock_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.GRAY_WHITE_4
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Mission Bay"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "San Diego, CA"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var currentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "navigation_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.backgroundColor = Theme.BLUE_LIGHT
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var currentLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "Current location"
        label.alpha = 0
        
        return label
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
        iconButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        subLabel.sizeToFit()
        
        addSubview(currentButton)
        addSubview(currentLabel)
        
        currentButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        currentButton.heightAnchor.constraint(equalTo: currentButton.widthAnchor).isActive = true
        currentButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        currentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentLabel.leftAnchor.constraint(equalTo: currentButton.rightAnchor, constant: 20).isActive = true
        currentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        currentLabel.sizeToFit()
        
        addSubview(line)
        line.anchor(top: nil, left: mainLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    func showCurrent() {
        currentButton.alpha = 1
        currentLabel.alpha = 1
        iconButton.alpha = 0
        mainLabel.alpha = 0
        subLabel.alpha = 0
    }
    
    func hideCurrent() {
        currentButton.alpha = 0
        currentLabel.alpha = 0
        iconButton.alpha = 1
        mainLabel.alpha = 1
        subLabel.alpha = 1
    }
    
    func autofill() {
        let image = UIImage(named: "pin_filled")?.withRenderingMode(.alwaysTemplate)
        iconButton.setImage(image, for: .normal)
    }
    
    func recent() {
        let image = UIImage(named: "clock_filled")?.withRenderingMode(.alwaysTemplate)
        iconButton.setImage(image, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
