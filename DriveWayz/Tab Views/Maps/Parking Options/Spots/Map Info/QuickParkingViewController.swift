//
//  QuickParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickParkingViewController: UIViewController {

    var darkContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var lightContainer: UIView = {
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
        
        return button
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 min"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.alpha = 0
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(darkContainer)
        darkContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        darkContainer.addSubview(lightContainer)
        lightContainer.leftAnchor.constraint(equalTo: darkContainer.leftAnchor).isActive = true
        lightContainer.topAnchor.constraint(equalTo: darkContainer.topAnchor).isActive = true
        lightContainer.bottomAnchor.constraint(equalTo: darkContainer.bottomAnchor).isActive = true
        lightContainer.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        darkContainer.addSubview(walkingIcon)
        walkingIcon.centerXAnchor.constraint(equalTo: lightContainer.centerXAnchor).isActive = true
        walkingIcon.topAnchor.constraint(equalTo: darkContainer.topAnchor, constant: 2).isActive = true
        walkingIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        walkingIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        darkContainer.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: lightContainer.rightAnchor, constant: 8).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: -8).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    
}
