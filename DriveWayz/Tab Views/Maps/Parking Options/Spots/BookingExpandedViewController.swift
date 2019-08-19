//
//  BookingExpandedViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class BookingExpandedViewController: UIViewController {
    
    var price: String = "$1.50/hour" {
        didSet {
            self.priceLabel.text = price
            self.priceWidthAnchor.constant = (self.priceLabel.text?.width(withConstrainedHeight: 25, font: Fonts.SSPSemiBoldH4))! + 16
            self.spotWidthAnchor.constant = (self.spotLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 16
            self.view.layoutIfNeeded()
        }
    }
    
    var numberSpots: String = "2"
    var streetAddress: String = "1080 14th St.," {
        didSet {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                    self.spotLabel.text = descriptionAddress
                }
            }
        }
    }
    
    var secondaryType: String = "driveway" {
        didSet {
            if secondaryType == "driveway" {
                let image = UIImage(named: "Residential Home Driveway")
                self.spotIcon.image = image
            } else if secondaryType == "parking lot" {
                let image = UIImage(named: "Parking Lot")
                self.spotIcon.image = image
            } else if secondaryType == "apartment" {
                let image = UIImage(named: "Apartment Parking")
                self.spotIcon.image = image
            } else if secondaryType == "alley" {
                let image = UIImage(named: "Alley Parking")
                self.spotIcon.image = image
            } else if secondaryType == "garage" {
                let image = UIImage(named: "Parking Garage")
                self.spotIcon.image = image
            } else if secondaryType == "gated spot" {
                let image = UIImage(named: "Gated Spot")
                self.spotIcon.image = image
            } else if secondaryType == "street spot" {
                let image = UIImage(named: "Street Parking")
                self.spotIcon.image = image
            } else if secondaryType == "underground spot" {
                let image = UIImage(named: "UnderGround Parking")
                self.spotIcon.image = image
            } else if secondaryType == "condo" {
                let image = UIImage(named: "Residential Home Driveway")
                self.spotIcon.image = image
            } else if secondaryType == "circular" {
                let image = UIImage(named: "Other Parking")
                self.spotIcon.image = image
            }
        }
    }
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 50
        let image = UIImage(named: "Residential Home Driveway")
        view.image = image
        
        return view
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Two-Car Driveway"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
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
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1.40/hour"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        label.backgroundColor = Theme.GREEN_PIGMENT
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.textAlignment = .center
        //        label.alpha = 0
        //        label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return label
    }()
    
    lazy var quickBookingController: QuickBookingViewController = {
        let controller = QuickBookingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        
        return controller
    }()
    
    func setData(parking: ParkingSpots) {
        self.quickBookingController.setData(parking: parking)
        if let secondaryType = parking.secondaryType, let numberSpots = parking.numberSpots, let streetAddress = parking.streetAddress {
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
        if let parkingCost = parking.dynamicCost {
            let cost = String(format: "$%.2f/hour", parkingCost)
            self.price = cost
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        setupViews()
        setupDetails()
        setupController()
    }
    
    var priceWidthAnchor: NSLayoutConstraint!
    var spotIconTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(spotIcon)
        self.view.addSubview(priceLabel)
        
        spotIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spotIconTopAnchor = spotIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12)
            spotIconTopAnchor.isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        priceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        priceWidthAnchor = priceLabel.widthAnchor.constraint(equalToConstant: (priceLabel.text?.width(withConstrainedHeight: 25, font: Fonts.SSPSemiBoldH4))! + 16)
            priceWidthAnchor.isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: spotIcon.bottomAnchor).isActive = true
        
    }
    
    var spotWidthAnchor: NSLayoutConstraint!
    
    func setupDetails() {
        
        self.view.addSubview(spotLabel)
        self.view.addSubview(stars)
        self.view.addSubview(starLabel)
        
        spotLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 4).isActive = true
        spotLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spotWidthAnchor = spotLabel.widthAnchor.constraint(equalToConstant: (spotLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 16)
            spotWidthAnchor.isActive = true
        spotLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
        stars.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -12).isActive = true
        stars.sizeToFit()
        
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        starLabel.sizeToFit()
        
    }
    
    func setupController() {
        
        self.view.addSubview(quickBookingController.view)
        quickBookingController.view.topAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: 16).isActive = true
        quickBookingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        quickBookingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        quickBookingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func changeHeight(amount: CGFloat, state: UIPanGestureRecognizer.State) {
        let percentage = amount/140
        let reducedPercentage = amount/60
        if state == .changed {
            if self.quickBookingController.view.alpha == 1 {
                UIView.animate(withDuration: animationIn, animations: {
                    self.quickBookingController.view.alpha = 0
                })
            }
            self.spotIconTopAnchor.constant = 12 + 20 * percentage
            self.spotIcon.transform = CGAffineTransform(scaleX: 1 + 0.2 * percentage, y: 1 + 0.2 * percentage)
            self.priceLabel.alpha = 1 - reducedPercentage
            self.stars.alpha = 1 - reducedPercentage
            self.starLabel.alpha = 1 - reducedPercentage
            self.spotLabel.alpha = 1 - reducedPercentage
            self.view.layoutIfNeeded()
        } else if state == .ended {
            if amount == 140 {
                UIView.animate(withDuration: animationOut, animations: {
                    self.spotIcon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.spotIconTopAnchor.constant = 32
                    self.priceLabel.alpha = 0
                    self.stars.alpha = 0
                    self.starLabel.alpha = 0
                    self.spotLabel.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.quickBookingController.view.alpha = 1
                    })
                }
            } else {
                UIView.animate(withDuration: animationOut, animations: {
                    self.spotIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.spotIconTopAnchor.constant = 12
                    self.priceLabel.alpha = 1
                    self.stars.alpha = 1
                    self.starLabel.alpha = 1
                    self.spotLabel.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.quickBookingController.view.alpha = 0
                    })
                }
            }
        }
    }
    
}
