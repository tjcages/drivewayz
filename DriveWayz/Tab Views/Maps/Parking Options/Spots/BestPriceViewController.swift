//
//  BestPriceViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation
import NVActivityIndicatorView

class BestPriceViewController: UIViewController {
    
    var delegate: handleParkingImages?
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 60
        let image = UIImage(named: "exampleParking")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var spotLocatingLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "One-Car Driveway on University Heights Avenue"
        label.font = Fonts.SSPRegularH2
        label.isUserInteractionEnabled = false
        //        label.isScrollEnabled = false
        label.isEditable = false
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.text = "$3.15 / hour"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 15
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.SEA_BLUE
        view.settings.emptyBorderColor = Theme.OFF_WHITE
        view.settings.filledBorderColor = Theme.SEA_BLUE
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
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        loading.contentMode = .left
        loading.color = Theme.DARK_GRAY.withAlphaComponent(0.7)
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func configureDynamicParking(parking: ParkingSpots, overallDestination: CLLocationCoordinate2D) {
        if let latitude = parking.latitude, let longitude = parking.longitude, let state = parking.stateAddress, let city = parking.cityAddress {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            dynamicPricing.getDynamicPricing(place: location, state: state, city: city, overallDestination: overallDestination) { (dynamicPrice: CGFloat) in
                let price = String(format: "%.2f", dynamicPrice)
                self.priceLabel.text = "$\(price) per hour"
                self.loadingActivity.alpha = 0
                self.loadingActivity.stopAnimating()
            }
        }
    }
    
    func setData(parking: ParkingSpots) {
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
        self.priceLabel.text = ""
        if var streetAddress = parking.streetAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let publicAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter()) on \(streetAddress)"
                    self.spotLocatingLabel.text = publicAddress
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
                        self.delegate?.setBestPriceImage(imageString: firstPhoto)
                    }
                }
            }
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(spotLocatingLabel)
        spotLocatingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 136).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: (spotLocatingLabel.text?.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPRegularH2))! + 12).isActive = true
        
        self.view.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -4).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 26).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(stars)
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 26).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.view.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.leftAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -4).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        loadingActivity.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}
