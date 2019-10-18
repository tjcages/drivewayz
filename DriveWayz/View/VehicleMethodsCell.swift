//
//  VehicleCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class VehicleMethodsCell: UITableViewCell {
    
    var vehicleMethod: Vehicles? {
        didSet {
            if let method = self.vehicleMethod {
                if let make = method.vehicleMake, let model = method.vehicleModel, let year = method.vehicleYear {
                    mainLabel.text = "\(year) \(make) \(model)"
                }
                if let license = method.vehicleLicensePlate {
                    licenseIcon.setTitle(license, for: .normal)
                    licenseIconWidthAnchor.constant = license.width(withConstrainedHeight: 48, font: Fonts.SSPSemiBoldH6) + 16
                }
                if method.defaultVehicle {
                    defaultButton.alpha = 1
                } else {
                    defaultButton.alpha = 0
                }
            }
        }
    }
    
    var licenseIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 4
        button.layer.borderColor = Theme.LIGHT_GRAY.cgColor
        button.layer.borderWidth = 3
        button.setTitle("••• •••", for: .normal)
        button.setTitleColor(Theme.DarkYellow, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return button
    }()
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.alpha = 0
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var newVehicleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add new vehicle", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
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
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25/2
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.alpha = 0
        
        return button
    }()
    
    var licenseIconWidthAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(licenseIcon)
        addSubview(plusButton)
        addSubview(mainLabel)
        addSubview(arrowButton)
        addSubview(newVehicleButton)
        addSubview(defaultButton)
        addSubview(checkmark)
        
        licenseIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        licenseIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        licenseIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        licenseIconWidthAnchor = licenseIcon.widthAnchor.constraint(equalToConstant: 56)
            licenseIconWidthAnchor.isActive = true
        
        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: licenseIcon.rightAnchor, constant: 12).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: defaultButton.leftAnchor, constant: -8).isActive = true
        mainLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        newVehicleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        newVehicleButton.leftAnchor.constraint(equalTo: plusButton.rightAnchor, constant: 12).isActive = true
        newVehicleButton.sizeToFit()
        
        defaultButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        defaultButton.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 12).isActive = true
        defaultButton.rightAnchor.constraint(lessThanOrEqualTo: arrowButton.leftAnchor, constant: -4).isActive = true
        defaultButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        defaultButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        checkmark.rightAnchor.constraint(equalTo: arrowButton.rightAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
    }
    
    func newVehicle() {
        newVehicleButton.alpha = 1
        plusButton.alpha = 1
        defaultButton.alpha = 0
        licenseIcon.alpha = 0
        mainLabel.alpha = 0
        arrowButton.alpha = 0
    }
    
    func oldVehicle() {
        newVehicleButton.alpha = 0
        plusButton.alpha = 0
        licenseIcon.alpha = 1
        mainLabel.alpha = 1
        arrowButton.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

