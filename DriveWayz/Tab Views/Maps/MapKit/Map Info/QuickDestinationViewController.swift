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
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        
        return view
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        
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
        view.isHidden = true
        
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
        
    }

}
