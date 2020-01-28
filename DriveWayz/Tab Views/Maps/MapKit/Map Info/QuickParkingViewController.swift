//
//  QuickParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickParkingViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        
        return view
    }()
    
    var darkContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var walkingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "walkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "vehicle");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 min"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    var expandButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.alpha = 0
        view.isHidden = true
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        container.addSubview(darkContainer)
        darkContainer.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        darkContainer.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        darkContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        darkContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(walkingIcon)
        walkingIcon.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
        walkingIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        walkingIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        walkingIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(carIcon)
        carIcon.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
        carIcon.centerYAnchor.constraint(equalTo: darkContainer.centerYAnchor).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        carIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        container.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: 8).isActive = true
        parkingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -8).isActive = true
        parkingLabel.sizeToFit()
        
        container.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: parkingLabel.leftAnchor).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4).isActive = true
        distanceLabel.sizeToFit()
        
        container.addSubview(expandButton)
        expandButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 2).isActive = true
        expandButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
}
