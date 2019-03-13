//
//  TestOneOptionViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation

class TestOneOptionViewController: UIViewController {
    
    var delegate: handleTestParking?
    
    var spotImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
//        view.layer.cornerRadius = 3
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var spotDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "One-Car Driveway"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var searchLocation: UIButton = {
        let button = UIButton(type: .custom)
        let origImage = UIImage(named: "searchLocation")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "University Heights Avenue"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "$3.15/hour"
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 15
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.LIGHT_BLUE
        view.settings.emptyBorderColor = Theme.OFF_WHITE
        view.settings.filledBorderColor = Theme.LIGHT_BLUE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "10"
        label.font = Fonts.SSPLightH5
        
        return label
    }()
    
    var bookButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book spot", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.clipsToBounds = true
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(bookSpotPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().darkBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 120)
        background.zPosition = -10
        background.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi))
        view.layer.addSublayer(background)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
    }
    
    func configureDynamicParking(parking: ParkingSpots, overallDestination: CLLocationCoordinate2D) {
        if let latitude = parking.latitude, let longitude = parking.longitude, let state = parking.stateAddress, let city = parking.cityAddress {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            dynamicPricing.getDynamicPricing(place: location, state: state, city: city, overallDestination: overallDestination) { (dynamicPrice: CGFloat) in
                let price = String(format: "%.2f", dynamicPrice)
                self.priceLabel.text = "$\(price) per hour"
            }
        }
    }
    
    func setData(parking: ParkingSpots) {
        self.priceLabel.text = ""
        if var streetAddress = parking.streetAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let publicAddress = "\(streetAddress)"
                    let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                    self.locationLabel.text = publicAddress
                    self.spotDescription.text = descriptionAddress
                    if let numberRatings = parking.numberRatings, let totalRating = parking.totalRating {
                        if let ratings = Double(numberRatings), let total = Double(totalRating) {
                            let averageRating: Double = total/ratings
                            self.stars.rating = averageRating
                            self.starsLabel.text = numberRatings
                        }
                    } else {
                        self.stars.rating = 5
                        self.starsLabel.text = ""
                    }
                    if let firstPhoto = parking.firstImage {
                        self.spotImageView.loadImageUsingCacheWithUrlString(firstPhoto)
                    }
                }
            }
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 6).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -6).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -56).isActive = true
        
        container.addSubview(spotImageView)
        spotImageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        spotImageView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        spotImageView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        spotImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -70).isActive = true
        
        spotImageView.addSubview(dimView)
        dimView.bottomAnchor.constraint(equalTo: spotImageView.bottomAnchor).isActive = true
        dimView.leftAnchor.constraint(equalTo: spotImageView.leftAnchor).isActive = true
        dimView.rightAnchor.constraint(equalTo: spotImageView.rightAnchor).isActive = true
        dimView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        container.addSubview(spotDescription)
        spotDescription.leftAnchor.constraint(equalTo: spotImageView.leftAnchor, constant: 24).isActive = true
        spotDescription.rightAnchor.constraint(equalTo: spotImageView.rightAnchor, constant: -24).isActive = true
        spotDescription.bottomAnchor.constraint(equalTo: spotImageView.bottomAnchor, constant: -8).isActive = true
        spotDescription.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(priceLabel)
        priceLabel.bottomAnchor.constraint(equalTo: spotDescription.topAnchor).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: spotImageView.leftAnchor, constant: 24).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: spotImageView.rightAnchor, constant: -24).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(searchLocation)
        container.addSubview(locationLabel)
        searchLocation.leftAnchor.constraint(equalTo: spotImageView.leftAnchor, constant: 24).isActive = true
        searchLocation.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        searchLocation.widthAnchor.constraint(equalToConstant: 20).isActive = true
        searchLocation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: searchLocation.rightAnchor, constant: 8).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: spotImageView.rightAnchor, constant: -24).isActive = true
        locationLabel.topAnchor.constraint(equalTo: spotImageView.bottomAnchor, constant: 12).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(stars)
        stars.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6).isActive = true
        stars.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        container.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(bookButton)
        bookButton.centerYAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        bookButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -8).isActive = true
        bookButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bookButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
    }
    
    @objc func bookSpotPressed(sender: UIButton) {
        if let purchaseString = self.priceLabel.text {
            let amount = purchaseString.replacingOccurrences(of: " per hour", with: "")
            if let price = Double(amount.replacingOccurrences(of: "$", with: "")) {
                self.delegate?.bookSpotPressed(amount: price)
            }
        }
    }

}
