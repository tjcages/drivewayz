//
//  ListingOptionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingOptionsView: UIViewController {
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Options"
        
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var optionsController: AvailabilityOptionsView = {
        let controller = AvailabilityOptionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.removeString = "Delete"
        controller.options.append(AvailabilityOptions(text: "Mark listing inactive", icon: UIImage(named: "hostAvailabilityClock")))
        controller.options.append(AvailabilityOptions(text: "Report issue", icon: UIImage(named: "hostIssueIcon")))
        controller.options.append(AvailabilityOptions(text: "Delete listing", icon: UIImage(named: "hostAvailabilityNegative")))
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(subLabel)
        view.addSubview(container)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(optionsController.view)
        optionsController.view.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

}
