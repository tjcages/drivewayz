//
//  BookingMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class BookingInfoViewController: UIViewController {
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 4.65
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 20
        view.settings.starMargin = 0
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.65"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var hostMessageLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH5
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    lazy var currentAmenitiesController: CurrentAmenitiesViewController = {
        let controller = CurrentAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.clipsToBounds = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(stars)
        stars.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stars.sizeToFit()
        
        self.view.addSubview(starLabel)
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        starLabel.sizeToFit()
        
        self.view.addSubview(hostMessageLabel)
        hostMessageLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 8).isActive = true
        hostMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        hostMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22).isActive = true
        hostMessageLabel.heightAnchor.constraint(equalToConstant: hostMessageLabel.text.height(withConstrainedWidth: phoneWidth - 48, font: Fonts.SSPRegularH5) + 16).isActive = true
        
        self.view.addSubview(currentAmenitiesController.view)
        currentAmenitiesController.view.topAnchor.constraint(equalTo: hostMessageLabel.bottomAnchor, constant: 8).isActive = true
        currentAmenitiesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentAmenitiesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentAmenitiesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
}
