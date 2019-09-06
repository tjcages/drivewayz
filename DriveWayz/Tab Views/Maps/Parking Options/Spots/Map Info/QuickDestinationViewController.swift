//
//  QuickDestinationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/31/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class QuickDestinationViewController: UIViewController {

    var darkContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 min"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var expandButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(darkContainer)
        darkContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        darkContainer.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: darkContainer.leftAnchor, constant: 8).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: -4).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        darkContainer.addSubview(expandButton)
        expandButton.rightAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: 2).isActive = true
        expandButton.centerYAnchor.constraint(equalTo: darkContainer.centerYAnchor).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }

}
