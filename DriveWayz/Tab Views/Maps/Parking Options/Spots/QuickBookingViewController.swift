//
//  QuickBookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class QuickBookingViewController: UIViewController {
    
    var numberSpots: String = "2"
    var mainType: String = "main"
    var secondaryType: String = "driveway"
    var streetAddress: String = "1080 14th St.," {
        didSet {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(mainType.capitalizingFirstLetter()) \(secondaryType.capitalizingFirstLetter())"
                    self.spotLabel.text = descriptionAddress
                }
            }
        }
    }
    
    var messageHeight: CGFloat = 0.0
    var message: String = "" {
        didSet {
            self.hostMessageLabel.text = self.message
        }
    }
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Two-Car Residential Driveway"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 3.6
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 16
        view.settings.starMargin = 0
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var hostMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 4
        
        return label
    }()
    
    lazy var amenitiesController: CurrentAmenitiesViewController = {
        let controller = CurrentAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.clipsToBounds = false
    
        return controller
    }()
    
    func setData(parking: ParkingSpots) {
        if let message = parking.hostMessage, let amenities = parking.parkingAmenities {
            self.message = message
            self.amenitiesController.amenitiesName = amenities
        }
        if let mainType = parking.mainType, let secondaryType = parking.secondaryType, let numberSpots = parking.numberSpots, let streetAddress = parking.streetAddress {
            self.mainType = mainType
            self.secondaryType = secondaryType
            self.numberSpots = numberSpots
            self.streetAddress = streetAddress
        }
        if let totalRating = parking.totalRating, let totalBookings = parking.ParkingReviews?.count {
            let averageRating = Double(totalRating)/Double(totalBookings)
            self.stars.rating = averageRating
            self.starLabel.text = "\(totalBookings)"
        } else {
            self.stars.rating = 5.0
            self.starLabel.text = "0"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    var messageLabelHeightAnchor: NSLayoutConstraint!
    var messageLabelRightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(spotLabel)
        spotLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(stars)
        self.view.addSubview(starLabel)
        stars.topAnchor.constraint(equalTo: spotLabel.bottomAnchor, constant: 0).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stars.sizeToFit()
        
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        starLabel.sizeToFit()
        
        self.view.addSubview(hostMessageLabel)
        hostMessageLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 4).isActive = true
        hostMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        hostMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        hostMessageLabel.sizeToFit()
        
        self.view.addSubview(amenitiesController.view)
        amenitiesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        amenitiesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        amenitiesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        amenitiesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true

    }

}
