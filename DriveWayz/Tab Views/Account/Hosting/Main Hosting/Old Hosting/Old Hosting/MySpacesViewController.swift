//
//  MySpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class MySpacesViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var spaceImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return button
    }()
    
    var spaceTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPLightH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 4.9
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 16
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5.0"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var expandButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var gradientBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLUE, bottomColor: Theme.LIGHT_BLUE)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    func setData(parking: ParkingSpots) {
        if var streetAddress = parking.streetAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType, let timestamp = parking.timestamp {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter()) on \(streetAddress)"
                    self.spaceTitle.text = descriptionAddress
                }
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateString = dateFormatter.string(from: date)
                self.dateLabel.text = "Listed on \(dateString)"
                
                if let price = parking.parkingCost {
                    self.priceLabel.text = String(format:"$%.02f per hour", price)
                }
                
                if let totalRating = parking.totalRating, let totalBookings = parking.totalBookings {
                    self.starsLabel.text = String(format:"%.01f", Double(totalRating)/Double(totalBookings))
                    self.stars.rating = Double(totalRating)/Double(totalBookings)
                } else {
                    self.starsLabel.text = "5.0"
                    self.stars.rating = 5.0
                }
                
                if let firstImage = parking.firstImage, firstImage != "" {
                    self.spaceImageView.loadImageUsingCacheWithUrlString(firstImage) { (bool) in
                        
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        view.layer.cornerRadius = 4

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(spaceImageView)
        spaceImageView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        spaceImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        spaceImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        spaceImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        container.addSubview(spaceTitle)
        spaceTitle.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        spaceTitle.rightAnchor.constraint(equalTo: spaceImageView.leftAnchor, constant: -12).isActive = true
        spaceTitle.topAnchor.constraint(equalTo: spaceImageView.topAnchor).isActive = true
        spaceTitle.sizeToFit()
        
        container.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: spaceTitle.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        dateLabel.topAnchor.constraint(equalTo: spaceTitle.bottomAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(line)
        line.topAnchor.constraint(equalTo: spaceImageView.bottomAnchor, constant: 20).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(gradientBackground)
        gradientBackground.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        gradientBackground.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        gradientBackground.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        gradientBackground.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        container.addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        priceLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(stars)
        stars.leftAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -2).isActive = true
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -2).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
        container.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 4).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(expandButton)
        expandButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        expandButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 28).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }

}
