//
//  AccountListingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class AccountListingView: UIViewController {

    var hostListing: ParkingSpots? {
        didSet {
            if let parking = hostListing {
                if let timestamp = parking.timestamp {
                    
                }
            }
        }
    }
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Your listings"
        
        return label
    }()
    
    var newListingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New listing", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 40
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        
        return view
    }()
    
    var starView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 14
        
        return view
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.totalStars = 1
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.WHITE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.text = "4.80"
        view.settings.textFont = Fonts.SSPSemiBoldH5
        view.settings.textColor = Theme.WHITE
        view.settings.textMargin = 8
        view.settings.filledImage = UIImage(named: "Star Filled White")
        
        return view
    }()

    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "945 Diamond Street"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subSpotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2-Car Residential"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("11:00am • 3:30pm", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var optionsController: AvailabilityOptionsView = {
        let controller = AvailabilityOptionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.options.append(AvailabilityOptions(text: "Edit information", icon: UIImage(named: "hostAccountGear")))
        controller.options.append(AvailabilityOptions(text: "Mark spot inactive", icon: UIImage(named: "hostAvailabilityNegative")))

        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDetails()
    }
    
    func setupViews() {
        
        view.addSubview(subLabel)
        view.addSubview(newListingButton)
        view.addSubview(container)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        newListingButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        newListingButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        newListingButton.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setupDetails() {
        
        view.addSubview(spotIcon)
        spotIcon.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
        view.addSubview(starView)
        starView.centerXAnchor.constraint(equalTo: spotIcon.centerXAnchor).isActive = true
        starView.centerYAnchor.constraint(equalTo: spotIcon.bottomAnchor).isActive = true
        starView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        starView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        starView.addSubview(stars)
        stars.centerXAnchor.constraint(equalTo: starView.centerXAnchor).isActive = true
        stars.centerYAnchor.constraint(equalTo: starView.centerYAnchor, constant: 1).isActive = true
        stars.sizeToFit()
        
        view.addSubview(spotLabel)
        spotLabel.bottomAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: -4).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 16).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        spotLabel.sizeToFit()
        
        view.addSubview(subSpotLabel)
        view.addSubview(informationIcon)
        
        subSpotLabel.topAnchor.constraint(equalTo: spotLabel.bottomAnchor, constant: 0).isActive = true
        subSpotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 16).isActive = true
        subSpotLabel.sizeToFit()
        
        informationIcon.centerYAnchor.constraint(equalTo: subSpotLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: subSpotLabel.rightAnchor, constant: 4).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
        view.addSubview(durationButton)
        durationButton.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        durationButton.topAnchor.constraint(equalTo: subSpotLabel.bottomAnchor, constant: 0).isActive = true
        durationButton.sizeToFit()
        
        container.addSubview(optionsController.view)
        optionsController.view.anchor(top: starView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }

}
