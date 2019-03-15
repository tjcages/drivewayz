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
    var height: CGFloat = 0
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
//        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 1
//        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.01)
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        view.clipsToBounds = false
        
        return view
    }()
    
    var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1065 University Ave. Boulder, CO"
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var expandedImages: ExpandedImageViewController = {
        let controller = ExpandedImageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
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

    }
    
    func setData(hosting: ParkingSpots) {
        expandedInformation.setData(hosting: hosting)
        expandedCost.setData(hosting: hosting)
        expandedNumber.setData(hosting: hosting)
        expandedAmenities.setData(hosting: hosting)
        expandedImages.setData(hosting: hosting)
        if let overallAddress = hosting.overallAddress {
            self.spotLocatingLabel.text = overallAddress
        }
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        container.addSubview(darkView)
        darkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        darkView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        darkView.addSubview(imageContainer)
        imageContainer.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        imageContainer.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        
        imageContainer.addSubview(expandedImages.view)
        expandedImages.view.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        expandedImages.view.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        expandedImages.view.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        expandedImages.view.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -90).isActive = true
        
        darkView.addSubview(spotLocatingLabel)
        spotLocatingLabel.topAnchor.constraint(equalTo: expandedImages.view.bottomAnchor, constant: 20).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: darkView.leftAnchor, constant: 12).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: darkView.rightAnchor, constant: -12).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(expandedInformation.view)
        expandedInformation.view.topAnchor.constraint(equalTo: darkView.bottomAnchor, constant: 12).isActive = true
        expandedInformation.view.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        expandedInformation.view.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        expandedInformation.view.heightAnchor.constraint(equalToConstant: expandedInformation.height).isActive = true
        
        container.addSubview(expandedCost.view)
        expandedCost.view.topAnchor.constraint(equalTo: expandedInformation.view.bottomAnchor).isActive = true
        expandedCost.view.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        expandedCost.view.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        expandedCost.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        container.addSubview(expandedNumber.view)
        expandedNumber.view.topAnchor.constraint(equalTo: expandedCost.view.bottomAnchor).isActive = true
        expandedNumber.view.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        expandedNumber.view.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        expandedNumber.view.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        container.addSubview(expandedAmenities.view)
        expandedAmenities.view.topAnchor.constraint(equalTo: expandedNumber.view.bottomAnchor).isActive = true
        expandedAmenities.view.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        expandedAmenities.view.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        expandedAmenities.view.heightAnchor.constraint(equalToConstant: expandedAmenities.height).isActive = true
        
        expandedInformation.editInformation.addTarget(self, action: #selector(editInformationPressed), for: .touchUpInside)
        expandedCost.editInformation.addTarget(self, action: #selector(editCostPressed), for: .touchUpInside)
        expandedNumber.editInformation.addTarget(self, action: #selector(editSpotsPressed), for: .touchUpInside)
        expandedAmenities.editInformation.addTarget(self, action: #selector(editAmenitiesPressed), for: .touchUpInside)
        
        height = expandedInformation.height + 100 + 132 + expandedAmenities.height + 280
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
