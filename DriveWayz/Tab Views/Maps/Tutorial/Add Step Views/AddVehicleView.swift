//
//  AddVehicleView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AddVehicleView: UIViewController {
    
    var currentVehicleMethod: Vehicles? {
        didSet {
            if let vehicleMethod = self.currentVehicleMethod {
                if let make = vehicleMethod.vehicleMake, let model = vehicleMethod.vehicleModel, let year = vehicleMethod.vehicleYear {
                    mainLabel.text = "\(year) \(make) \(model)"
                }
            } else {
                mainLabel.text = "Add a default vehicle"
                subLabel.text = "Vehicle information is available to hosts for monitoring purposes."
            }
        }
    }

    var checkmark: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 15)
        check.checkmarkColor = Theme.DARK_GRAY
        check.checkedBorderColor = UIColor.clear
        check.isUserInteractionEnabled = false
        check.backgroundColor = lineColor
        check.layer.cornerRadius = 15
        check.clipsToBounds = true
        
        return check
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add a default vehicle"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vehicle information is available to hosts for monitoring purposes."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 3
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(checkmark)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        checkmark.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        checkmark.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: checkmark.topAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: checkmark.rightAnchor, constant: 16).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func completed() {
        UIView.animate(withDuration: animationOut) {
            self.checkmark.backgroundColor = Theme.BLUE
            self.checkmark.checkmarkColor = Theme.WHITE
            self.view.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.view.layer.shadowColor = UIColor.clear.cgColor
            self.view.layoutIfNeeded()
        }
    }
    
    func incomplete() {
        UIView.animate(withDuration: animationOut) {
            self.checkmark.backgroundColor = lineColor
            self.checkmark.checkmarkColor = Theme.DARK_GRAY
            self.view.backgroundColor = Theme.WHITE
            self.view.layer.shadowColor = Theme.DARK_GRAY.cgColor
            self.view.layoutIfNeeded()
        }
    }
    
}
