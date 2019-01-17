//
//  HostingExpandedViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingExpandedViewController: UIViewController {
    
    var hostDelegate: handleHostEditing?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    lazy var expandedInformation: ExpandedInformationViewController = {
        let controller = ExpandedInformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedCost: ExpandedCostViewController = {
        let controller = ExpandedCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    lazy var expandedNumber: ExpandedSpotsViewController = {
        let controller = ExpandedSpotsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedAmenities: ExpandedAmenitiesViewController = {
        let controller = ExpandedAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        container.addSubview(expandedInformation.view)
        expandedInformation.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        expandedInformation.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        expandedInformation.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        expandedInformation.view.heightAnchor.constraint(equalToConstant: expandedInformation.messageLabel.text.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPRegularH5) + 148).isActive = true
        
        container.addSubview(expandedCost.view)
        expandedCost.view.topAnchor.constraint(equalTo: expandedInformation.view.bottomAnchor).isActive = true
        expandedCost.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        expandedCost.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        expandedCost.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        container.addSubview(expandedNumber.view)
        expandedNumber.view.topAnchor.constraint(equalTo: expandedCost.view.bottomAnchor).isActive = true
        expandedNumber.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        expandedNumber.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        expandedNumber.view.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        container.addSubview(expandedAmenities.view)
        expandedAmenities.view.topAnchor.constraint(equalTo: expandedNumber.view.bottomAnchor).isActive = true
        expandedAmenities.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        expandedAmenities.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        expandedAmenities.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        expandedInformation.editInformation.addTarget(self, action: #selector(editInformationPressed), for: .touchUpInside)
        expandedCost.editInformation.addTarget(self, action: #selector(editCostPressed), for: .touchUpInside)
        expandedNumber.editInformation.addTarget(self, action: #selector(editSpotsPressed), for: .touchUpInside)
        expandedAmenities.editInformation.addTarget(self, action: #selector(editAmenitiesPressed), for: .touchUpInside)
        
    }
    
    @objc func editInformationPressed() {
        self.hostDelegate?.setupEditingInformation()
    }
    
    @objc func editCostPressed() {
        self.hostDelegate?.setupEditingCost()
    }
    
    @objc func editSpotsPressed() {
        self.hostDelegate?.setupEditingSpots()
    }
    
    @objc func editAmenitiesPressed() {
        self.hostDelegate?.setupEditingAmenities()
    }
    
}
