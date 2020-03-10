//
//  EditInformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditInformationViewController: UIViewController {
    
    var delegate: handleHostEditing?
    var selectedParking: ParkingSpots?
    var selectedType: String = ""
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Parking type"
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
        button.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        
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
        button.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        
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
    
    lazy var typeController: ParkingTypeViewController = {
        let controller = ParkingTypeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var optionsController: ParkingOptionsViewController = {
        let controller = ParkingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var messageController: SpotsMessageViewController = {
        let controller = SpotsMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    func setData(parking: ParkingSpots) {
        self.selectedParking = parking
        if let mainType = parking.mainType, let secondType = parking.secondaryType, let hostMessage = parking.hostMessage {
            self.messageController.messageTextView.text = hostMessage
            self.messageController.characterLabel.text = "\(hostMessage.count)/160"
            self.messageController.messageTextView.textColor = Theme.BLACK
            let type = self.typeController
            type.parkingType = mainType
            self.selectedType = mainType
            if self.typeController.parkingType == "parking lot" || self.typeController.parkingType == "other" {
                self.optionsController.onlyShowBusinessOptions()
            } else {
                self.optionsController.onlyShowRegularOptions()
            }
            self.reset()
            if mainType == "residential" {
                self.selectType(button: type.houseButton, label: type.houseIconLabel, anchor: type.houseAnchor, information: type.houseInformation)
            } else if mainType == "apartment" {
                self.selectType(button: type.apartmentButton, label: type.apartmentIconLabel, anchor: type.apartmentAnchor, information: type.apartmentInformation)
            } else if mainType == "parking lot" {
                self.selectType(button: type.lotButton, label: type.lotIconLabel, anchor: type.parkingLotAnchor, information: type.lotInformation)
            } else if mainType == "other" {
                self.selectType(button: type.otherButton, label: type.otherIconLabel, anchor: type.otherAnchor, information: type.otherInformation)
            }
            let second = self.optionsController
            second.parkingType = secondType
            if secondType == "driveway" {
                self.selectType(button: second.drivewayImageView, label: second.drivewayIconLabel, anchor: second.drivewayAnchor, information: second.drivewayInformation)
            } else if secondType == "apartment" {
                self.selectType(button: second.sharedlotImageView, label: second.sharedlotIconLabel, anchor: second.sharedlotAnchor, information: second.sharedlotInformation)
            } else if secondType == "alley" {
                self.selectType(button: second.alleyImageView, label: second.alleyIconLabel, anchor: second.alleyAnchor, information: second.alleyInformation)
            } else if secondType == "garage" {
                self.selectType(button: second.garageImageView, label: second.garageIconLabel, anchor: second.garageAnchor, information: second.garageInformation)
            } else if secondType == "gated spot" {
                self.selectType(button: second.gatedImageView, label: second.gatedIconLabel, anchor: second.gatedAnchor, information: second.gatedInformation)
            } else if secondType == "street spot" {
                self.selectType(button: second.streetImageView, label: second.streetIconLabel, anchor: second.streetAnchor, information: second.streetInformation)
            } else if secondType == "lot" {
                self.selectType(button: second.parkinglotImageView, label: second.parkinglotIconLabel, anchor: second.parkinglotAnchor, information: second.parkinglotInformation)
            } else if secondType == "underground spot" {
                self.selectType(button: second.undergroundImageView, label: second.undergroundIconLabel, anchor: second.undergroundAnchor, information: second.undergroundInformation)
            } else if secondType == "condo" {
                self.selectType(button: second.condoImageView, label: second.condoIconLabel, anchor: second.condoAnchor, information: second.condoInformation)
            } else if secondType == "circular" {
                self.selectType(button: second.circularImageView, label: second.circularIconLabel, anchor: second.circularAnchor, information: second.circularInformation)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupTopbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.typeController.view.alpha = 1
        self.optionsController.view.alpha = 0
        self.messageController.view.alpha = 0
        self.nextButton.setTitle("Next", for: .normal)
        self.mainLabel.text = "Parking type"
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        self.view.addSubview(typeController.view)
        typeController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        typeController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        typeController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        typeController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(optionsController.view)
        optionsController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        optionsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        optionsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        optionsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(messageController.view)
        messageController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        messageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        messageController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
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
    
    func selectType(button: UIButton, label: UIButton, anchor: NSLayoutConstraint, information: UILabel) {
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.backgroundColor = Theme.BLUE
        button.tintColor = Theme.WHITE
        button.layer.shadowOpacity = 0.2
        anchor.constant = 95
        information.alpha = 1
    }
    
    func savePressed() {
        self.nextButton.alpha = 0.5
        self.nextButton.isUserInteractionEnabled = false
        if let parking = self.selectedParking, let parkingID = parking.parkingID {
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            let hostMessage = self.messageController.messageTextView.text
            let mainType = self.typeController.parkingType
            let secondaryType = self.optionsController.parkingType
            
            ref.updateChildValues(["hostMessage": hostMessage as Any])
            let values = ["mainType": mainType as Any,
                          "secondaryType": secondaryType as Any]
            ref.child("Type").updateChildValues(values)
            self.delegate?.resetParking()
            delayWithSeconds(0.8) {
                self.nextButton.alpha = 1
                self.nextButton.isUserInteractionEnabled = true
                self.exitButtonPressed()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func nextButtonPressed(sender: UIButton) {
        if typeController.view.alpha == 1 {
            if self.typeController.parkingType != self.selectedType {
                if self.typeController.parkingType == "parking lot" || self.typeController.parkingType == "other" {
                    self.optionsController.onlyShowBusinessOptions()
                } else {
                    self.optionsController.onlyShowRegularOptions()
                }
            }
            UIView.animate(withDuration: animationIn, animations: {
                self.typeController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.optionsController.view.alpha = 1
                })
            }
        } else if optionsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.optionsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.messageController.view.alpha = 1
                })
                self.nextButton.setTitle("Save", for: .normal)
                self.mainLabel.text = "Parking message"
                self.view.layoutIfNeeded()
            }
        } else if messageController.view.alpha == 1 {
            self.savePressed()
        }
    }
    
    func reset() {
        self.typeController.resetHouse()
        self.typeController.resetApartment()
        self.typeController.resetLot()
        self.typeController.resetAlley()
        self.optionsController.resetDriveway()
        self.optionsController.resetSharedLot()
        self.optionsController.resetSharedCover()
        self.optionsController.resetStreet()
        self.optionsController.resetAlley()
        self.optionsController.resetStreet()
        self.optionsController.resetParkingLot()
        self.optionsController.resetGarage()
        self.optionsController.resetUnderground()
        self.optionsController.resetCondo()
        self.optionsController.resetCircular()
        self.optionsController.resetGated()
    }
    
    @objc func exitButtonPressed() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        delayWithSeconds(animationOut) {
            self.typeController.view.alpha = 1
            self.optionsController.view.alpha = 0
            self.messageController.view.alpha = 0
            self.nextButton.setTitle("Next", for: .normal)
            self.mainLabel.text = "Parking type"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
