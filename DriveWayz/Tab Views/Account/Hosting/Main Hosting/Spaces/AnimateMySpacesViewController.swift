//
//  TestMySpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class AnimateMySpacesViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        let background = CAGradientLayer().customColor(topColor: Theme.DarkPink, bottomColor: Theme.LightPink)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 220)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var spotImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius =  4
        
        return view
    }()
    
    var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "Two-Car Driveway"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.text = "University Avenue, Boulder CO"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var destinationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DarkPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()
    
    var listedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.setTitle("Listed on 09/28/2019", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        return button
    }()
    
    var availableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("ACTIVE", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.layer.cornerRadius = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 8)
        let background = CAGradientLayer().customColor(topColor: Theme.LightGreen, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.clipsToBounds = true
        let icon = UIImage(named: "liveCircle")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.WHITE
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        return button
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.settings.filledImage = UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Star Empty")?.withRenderingMode(.alwaysOriginal)
        view.text = "10"
        view.semanticContentAttribute = .forceRightToLeft
        view.settings.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        view.settings.textFont = Fonts.SSPSemiBoldH6
        
        return view
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Today, 10:00AM - 4:00PM", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        button.clipsToBounds = true
        let icon = UIImage(named: "time")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 3, right: 1)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        return button
    }()
    
    func setData(parking: ParkingSpots, image: UIImage) {
        if var streetAddress = parking.streetAddress, let stateAddress = parking.stateAddress, let cityAddress = parking.cityAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType, let timestamp = parking.timestamp {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                    self.spotLabel.text = descriptionAddress
                    self.locationLabel.text = "\(streetAddress), \(cityAddress) \(stateAddress)"
                }
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateString = dateFormatter.string(from: date)
                self.listedButton.setTitle("Listed on \(dateString)", for: .normal)
                
                let available = parking.isSpotAvailable
                if available {
                    self.makeActiveButton()
                } else {
                    self.makeInactiveButton()
                }
                
                if let totalRating = parking.totalRating, let totalBookings = parking.totalBookings {
                    self.stars.text = "\(totalBookings)"
                    self.stars.rating = Double(totalRating)/Double(totalBookings)
                } else {
                    self.stars.text = "0"
                    self.stars.rating = 5.0
                }
                
                self.spotImageView.image = image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        
        setupViews()
        setupContainer()
        setupImage()
        setupSpotLabel()
        setupTopButtons()
        setupMiddleButtons()
    }

    func setupViews() {
        
        self.view.addSubview(container)
        self.view.addSubview(imageContainer)
        self.view.addSubview(whiteView)
        self.view.addSubview(spotImageView)
        self.view.addSubview(spotLabel)
        self.view.addSubview(destinationIcon)
        self.view.addSubview(locationLabel)
        self.view.addSubview(listedButton)
        self.view.addSubview(availableButton)
        self.view.addSubview(stars)
        self.view.addSubview(durationButton)
        
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    var containerImageAnchor: NSLayoutConstraint!
    
    func setupContainer() {
        
        containerTopAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor)
            containerTopAnchor.isActive = true
        containerImageAnchor = container.topAnchor.constraint(equalTo: imageContainer.bottomAnchor)
            containerImageAnchor.isActive = false
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        whiteView.topAnchor.constraint(equalTo: availableButton.bottomAnchor, constant: 16).isActive = true
        whiteView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    var imageContainerTopAnchor: NSLayoutConstraint!
    var imageContainerLeftAnchor: NSLayoutConstraint!
    var imageContainerWidthAnchor: NSLayoutConstraint!
    var imageContainerHeightAnchor: NSLayoutConstraint!
    
    func setupImage() {
        
        imageContainerTopAnchor = imageContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16)
            imageContainerTopAnchor.isActive = true
        imageContainerLeftAnchor = imageContainer.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20)
            imageContainerLeftAnchor.isActive = true
        imageContainerWidthAnchor = imageContainer.widthAnchor.constraint(equalToConstant: 112)
            imageContainerWidthAnchor.isActive = true
        imageContainerHeightAnchor = imageContainer.heightAnchor.constraint(equalToConstant: 112)
            imageContainerHeightAnchor.isActive = true
        
        spotImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor).isActive = true
        spotImageView.leftAnchor.constraint(equalTo: imageContainer.leftAnchor).isActive = true
        spotImageView.rightAnchor.constraint(equalTo: imageContainer.rightAnchor).isActive = true
        spotImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor).isActive = true
        
    }
    
    var destinationBottomAnchor: NSLayoutConstraint!
    
    func setupSpotLabel() {
        
        spotLabel.bottomAnchor.constraint(equalTo: destinationIcon.topAnchor, constant: -2).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        spotLabel.sizeToFit()
        
        destinationIcon.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        destinationBottomAnchor = destinationIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
            destinationBottomAnchor.isActive = true
        destinationIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        destinationIcon.widthAnchor.constraint(equalTo: destinationIcon.heightAnchor).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: destinationIcon.rightAnchor, constant: 6).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: destinationIcon.bottomAnchor, constant: 4).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        locationLabel.sizeToFit()
        
    }
    
    var availableButtonWidth: NSLayoutConstraint!
    
    func setupTopButtons() {
        
        listedButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        listedButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        listedButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        listedButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        availableButton.topAnchor.constraint(equalTo: listedButton.bottomAnchor, constant: 4).isActive = true
        availableButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        availableButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        availableButtonWidth = availableButton.widthAnchor.constraint(equalToConstant: 78)
            availableButtonWidth.isActive = true
        
    }
    
    var durationTopAnchor: NSLayoutConstraint!
    
    func setupMiddleButtons() {
        
        durationTopAnchor = durationButton.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 12)
            durationTopAnchor.isActive = true
        durationButton.rightAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        durationButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        durationButton.sizeToFit()
        
        stars.topAnchor.constraint(equalTo: durationButton.bottomAnchor, constant: 4).isActive = true
        stars.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stars.sizeToFit()
        
    }
    
    func animateOpening() {
        self.imageContainerTopAnchor.constant = 0
        self.imageContainerLeftAnchor.constant = 0
        self.imageContainerWidthAnchor.constant = phoneWidth
        self.imageContainerHeightAnchor.constant = 280
        self.containerTopAnchor.isActive = false
        self.containerImageAnchor.isActive = true
        self.durationTopAnchor.constant = 24
        self.destinationBottomAnchor.constant = -phoneHeight/2
        UIView.animate(withDuration: animationIn * 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.locationLabel.alpha = 0
            self.spotLabel.alpha = 0
            self.destinationIcon.alpha = 0
            self.durationButton.alpha = 0
            self.stars.alpha = 0
            self.spotImageView.layer.cornerRadius = 0
            self.container.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func restartView() {
        self.imageContainerTopAnchor.constant = 16
        self.imageContainerLeftAnchor.constant = 20
        self.imageContainerWidthAnchor.constant = 112
        self.imageContainerHeightAnchor.constant = 112
        self.containerTopAnchor.isActive = true
        self.containerImageAnchor.isActive = false
        self.durationTopAnchor.constant = 12
        self.destinationBottomAnchor.constant = -16
        self.locationLabel.alpha = 1
        self.spotLabel.alpha = 1
        self.destinationIcon.alpha = 1
        self.durationButton.alpha = 1
        self.stars.alpha = 1
        self.view.layoutIfNeeded()
    }

    func makeActiveButton() {
        self.availableButton.setTitle("ACTIVE", for: .normal)
        self.availableButtonWidth.constant = 78
        let background = CAGradientLayer().customColor(topColor: Theme.LightGreen, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        self.availableButton.layer.addSublayer(background)
    }
    
    func makeInactiveButton() {
        self.availableButton.setTitle("INACTIVE", for: .normal)
        self.availableButtonWidth.constant = 86
        let background = CAGradientLayer().customColor(topColor: Theme.LightBlue, bottomColor: Theme.BLUE)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        self.availableButton.layer.addSublayer(background)
    }
    
}
