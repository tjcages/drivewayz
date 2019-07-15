//
//  EditAmenitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditAmenitiesViewController: UIViewController {
    
    var delegate: handleHostEditing?
    var selectedParking: ParkingSpots?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Parking info"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.WHITE.withAlphaComponent(1))
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var amenitiesController: AmenitiesParkingViewController = {
        let controller = AmenitiesParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    func setData(parking: ParkingSpots) {
        self.selectedParking = parking
        if let amenities = parking.parkingAmenities {
            let cont = self.amenitiesController
            if amenities.contains("Covered parking") {
                self.amenitiesController.selectedAmenities = amenities
                self.selectAmenity(button: cont.coveredImageView, label: cont.coveredIconLabel, anchor: cont.coveredAnchor, information: cont.coveredInformation)
            }
            if amenities.contains("Charging station") {
                self.selectAmenity(button: cont.chargingImageView, label: cont.chargingIconLabel, anchor: cont.chargingAnchor, information: cont.chargingInformation)
            }
            if amenities.contains("Stadium parking") {
                self.selectAmenity(button: cont.stadiumImageView, label: cont.stadiumIconLabel, anchor: cont.stadiumAnchor, information: cont.stadiumInformation)
            }
            if amenities.contains("Gated spot") {
                self.selectAmenity(button: cont.gatedImageView, label: cont.gatedIconLabel, anchor: cont.gatedAnchor, information: cont.gatedInformation)
            }
            if amenities.contains("Nighttime parking") {
                self.selectAmenity(button: cont.nightImageView, label: cont.nightIconLabel, anchor: cont.nightAnchor, information: cont.nightInformation)
            }
            if amenities.contains("Near Airport") {
                self.selectAmenity(button: cont.airportImageView, label: cont.airportIconLabel, anchor: cont.airportAnchor, information: cont.airportInformation)
            }
            if amenities.contains("Lit space") {
                self.selectAmenity(button: cont.lightedImageView, label: cont.lightedIconLabel, anchor: cont.lightingAnchor, information: cont.lightingInformation)
            }
            if amenities.contains("Large space") {
                self.selectAmenity(button: cont.largeImageView, label: cont.largeIconLabel, anchor: cont.largeAnchor, information: cont.largeInformation)
            }
            if amenities.contains("Compact space") {
                self.selectAmenity(button: cont.smallImageView, label: cont.smallIconLabel, anchor: cont.smallAnchor, information: cont.smallInformation)
            }
            if amenities.contains("Easy to find") {
                self.selectAmenity(button: cont.easyImageView, label: cont.easyIconLabel, anchor: cont.easyAnchor, information: cont.easyInformation)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupTopbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        }
        
        self.view.addSubview(amenitiesController.view)
        amenitiesController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 24).isActive = true
        amenitiesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        amenitiesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        amenitiesController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        amenitiesController.scrollView.contentSize.height = amenitiesController.scrollView.contentSize.height - 300
        
        self.view.addSubview(darkBlurView)
        darkBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkBlurView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    func setupTopbar() {
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 32).isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        }
        
    }
    
    @objc func savePressed() {
        self.nextButton.alpha = 0.5
        self.nextButton.isUserInteractionEnabled = false
        if let parking = self.selectedParking, let parkingID = parking.parkingID {
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID).child("Type").child("Amenities")
            ref.removeValue()
            ref.setValue(self.amenitiesController.selectedAmenities)
            
            self.delegate?.resetParking()
            delayWithSeconds(0.8) {
                self.nextButton.alpha = 1
                self.nextButton.isUserInteractionEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func selectAmenity(button: UIButton, label: UIButton, anchor: NSLayoutConstraint, information: UILabel) {
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.tintColor = Theme.WHITE
        button.layer.shadowOpacity = 0.2
        anchor.constant = 95
        information.alpha = 1
        self.amenitiesController.scrollView.contentSize.height = self.amenitiesController.scrollView.contentSize.height + 95
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
