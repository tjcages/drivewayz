//
//  BookingCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class BookingCell: UICollectionViewCell {
    
    var price: String = "$1.50/hour" {
        didSet {
            self.priceLabel.text = price
            self.priceWidthAnchor.constant = (self.priceLabel.text?.width(withConstrainedHeight: 25, font: Fonts.SSPSemiBoldH4))! + 16
            self.spotWidthAnchor.constant = (self.spotLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 16
            self.layoutIfNeeded()
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
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 50
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        
        return view
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Two-Car Gated Spot"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var starView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
//        view.layer.cornerRadius = 13
        
        return view
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
    
    var destinationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "parkingSpaceIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        
        return button
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "University Heights Avenue"
        label.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
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
    
    var detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View details", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var shimmerMain: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        
        return view
    }()
    
    var shimmerIcon: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        beginAnimations()
        setupViews()
        setupDetails()
//        setupStars()
        setupShimmer()
        setupShimmerIcon()
    }
    
    var priceWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(spotIcon)
        addSubview(priceLabel)
        
        spotIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spotIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        priceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        priceWidthAnchor = priceLabel.widthAnchor.constraint(equalToConstant: (priceLabel.text?.width(withConstrainedHeight: 25, font: Fonts.SSPSemiBoldH4))! + 16)
            priceWidthAnchor.isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: spotIcon.bottomAnchor).isActive = true
        
    }
    
    var spotWidthAnchor: NSLayoutConstraint!
    
    func setupDetails() {
        
        addSubview(spotLabel)
        addSubview(stars)
        addSubview(starLabel)
//        addSubview(destinationIcon)
//        addSubview(destinationLabel)
        
        spotLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 4).isActive = true
        spotLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spotWidthAnchor = spotLabel.widthAnchor.constraint(equalToConstant: (spotLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 16)
            spotWidthAnchor.isActive = true
        spotLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        destinationIcon.rightAnchor.constraint(equalTo: destinationLabel.leftAnchor, constant: -4).isActive = true
//        destinationIcon.topAnchor.constraint(equalTo: spotLabel.bottomAnchor).isActive = true
//        destinationIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        destinationIcon.heightAnchor.constraint(equalTo: destinationIcon.widthAnchor).isActive = true
//
//        destinationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 11).isActive = true
//        destinationLabel.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor).isActive = true
//        destinationLabel.sizeToFit()
        
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
        stars.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -12).isActive = true
        stars.sizeToFit()
        
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        starLabel.sizeToFit()
        
    }
    
    func setupStars() {
        
        addSubview(starView)
        addSubview(stars)
        addSubview(starLabel)
        
        stars.centerYAnchor.constraint(equalTo: starLabel.centerYAnchor).isActive = true
        stars.rightAnchor.constraint(equalTo: starLabel.leftAnchor, constant: -6).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 18).isActive = true
        stars.heightAnchor.constraint(equalTo: stars.widthAnchor).isActive = true
        
        starLabel.topAnchor.constraint(equalTo: spotIcon.topAnchor, constant: 12).isActive = true
        starLabel.rightAnchor.constraint(equalTo: spotIcon.leftAnchor, constant: 12).isActive = true
        starLabel.sizeToFit()
        
        starView.topAnchor.constraint(equalTo: starLabel.topAnchor, constant: -8).isActive = true
        starView.leftAnchor.constraint(equalTo: stars.leftAnchor, constant: -4).isActive = true
        starView.rightAnchor.constraint(equalTo: starLabel.rightAnchor, constant: 4).isActive = true
        starView.bottomAnchor.constraint(equalTo: starLabel.bottomAnchor, constant: 8).isActive = true
        
    }
    
    func expandPrice() {
        UIView.animate(withDuration: animationIn) {
            self.priceLabel.alpha = 1
            self.priceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func minimizePrice() {
        UIView.animate(withDuration: animationIn) {
            self.priceLabel.alpha = 0
            self.priceLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    func setupShimmer() {
        
        self.addSubview(shimmerMain)
        shimmerMain.topAnchor.constraint(equalTo: spotLabel.topAnchor, constant: -40).isActive = true
        shimmerMain.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        shimmerMain.rightAnchor.constraint(equalTo: spotLabel.rightAnchor).isActive = true
        shimmerMain.bottomAnchor.constraint(equalTo: spotLabel.bottomAnchor, constant: -40).isActive = true
        
        let shimmerView = UIView()
        shimmerView.backgroundColor = Theme.WHITE
        shimmerView.frame = shimmerMain.frame
        shimmerView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        shimmerMain.addSubview(shimmerView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Theme.OFF_WHITE.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shimmerView.frame
        
        let angle = 45 * CGFloat.pi/180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        shimmerView.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -phoneWidth
        animation.toValue = phoneWidth
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "key")
        
    }
    
    func setupShimmerIcon() {
        
        self.addSubview(shimmerIcon)
        shimmerIcon.topAnchor.constraint(equalTo: spotIcon.topAnchor).isActive = true
        shimmerIcon.leftAnchor.constraint(equalTo: spotIcon.leftAnchor).isActive = true
        shimmerIcon.rightAnchor.constraint(equalTo: spotIcon.rightAnchor).isActive = true
        shimmerIcon.bottomAnchor.constraint(equalTo: spotIcon.bottomAnchor).isActive = true
        
        let shimmerView = UIView()
        shimmerView.backgroundColor = Theme.WHITE
        shimmerView.frame = shimmerIcon.frame
        shimmerView.transform = CGAffineTransform(scaleX: 4.0, y: 1.0)
        shimmerIcon.addSubview(shimmerView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Theme.OFF_WHITE.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shimmerView.frame
        
        let angle = 45 * CGFloat.pi/180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        shimmerView.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -phoneWidth
        animation.toValue = phoneWidth
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "key")
        
    }
    
    func beginAnimations() {
        self.shimmerMain.alpha = 1
        self.shimmerIcon.alpha = 1
        self.spotIcon.alpha = 0
        self.priceLabel.alpha = 0
        self.spotLabel.alpha = 0
        self.stars.alpha = 0
        self.starLabel.alpha = 0
    }
    
    func endAnimations() {
        self.shimmerMain.alpha = 0
        self.shimmerIcon.alpha = 0
        self.spotIcon.alpha = 1
        self.priceLabel.alpha = 1
        self.spotLabel.alpha = 1
        self.stars.alpha = 1
        self.starLabel.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

