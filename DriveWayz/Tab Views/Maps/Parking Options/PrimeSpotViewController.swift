//
//  PrimeSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Cosmos

class PrimeSpotViewController: UIViewController {
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var parkingGraphic: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "twoCarParkingGraphic")
        button.setImage(image, for: .normal)
//        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        button.setImage(tintedImage, for: .normal)
//        button.tintColor = nil
        
        return button
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "400 FT | 4 MINUTE WALK"
        label.font = Fonts.SSPBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Two-Car Driveway on 9th"
        label.font = Fonts.SSPLightH2
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.text = "$4.50 per hour"
        label.font = Fonts.SSPRegularH5
        
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
    
    var walkingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "walkingIcon")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }

    func setupViews() {
        
//        self.view.addSubview(parkingImageView)
//        parkingImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
//        parkingImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
//        parkingImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
//        parkingImageView.heightAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        
        self.view.addSubview(parkingGraphic)
        parkingGraphic.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        parkingGraphic.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingGraphic.widthAnchor.constraint(equalToConstant: 100).isActive = true
        parkingGraphic.heightAnchor.constraint(equalTo: parkingGraphic.widthAnchor).isActive = true
        
        self.view.addSubview(distanceLabel)
        distanceLabel.topAnchor.constraint(equalTo: parkingGraphic.bottomAnchor, constant: 4).isActive = true
        distanceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -13).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: (distanceLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH3))!).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(walkingIcon)
        walkingIcon.leftAnchor.constraint(equalTo: distanceLabel.rightAnchor, constant: -2).isActive = true
        walkingIcon.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor, constant: 2).isActive = true
        walkingIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
        walkingIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.view.addSubview(spotLocatingLabel)
        spotLocatingLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 2).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -4).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(stars)
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.view.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func saveDurationPressed() {
        UIView.animate(withDuration: animationIn) {
            self.stars.alpha = 0
            self.starsLabel.alpha = 0
            self.priceLabel.alpha = 0
        }
    }
    
    func confirmPurchaseDismissed() {
        UIView.animate(withDuration: animationIn) {
            self.stars.alpha = 1
            self.starsLabel.alpha = 1
            self.priceLabel.alpha = 1
        }
    }
    
}
