//
//  EditAvailabilityViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditAvailabilityViewController: UIViewController {
    
    var delegate: handleHostEditing?
    var selectedParking: ParkingSpots?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Parking availability"
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
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.WHITE.withAlphaComponent(1))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var scheduleController: SelectTimesViewController = {
        let controller = SelectTimesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    func setData(parking: ParkingSpots) {
        self.selectedParking = parking
        if let from = parking.mondayAvailableFrom, let to = parking.mondayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.mondayAvailabilityController, from: from, to: to)
        }
        if let from = parking.tuesdayAvailableFrom, let to = parking.tuesdayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.tuesdayAvailabilityController, from: from, to: to)
        }
        if let from = parking.wednesdayAvailableFrom, let to = parking.wednesdayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.wednesdayAvailabilityController, from: from, to: to)
        }
        if let from = parking.thursdayAvailableFrom, let to = parking.thursdayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.thursdayAvailabilityController, from: from, to: to)
        }
        if let from = parking.fridayAvailableFrom, let to = parking.fridayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.fridayAvailabilityController, from: from, to: to)
        }
        if let from = parking.saturdayAvailableFrom, let to = parking.saturdayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.saturdayAvailabilityController, from: from, to: to)
        }
        if let from = parking.sundayAvailableFrom, let to = parking.sundayAvailableTo {
            self.selectAvailableDay(controller: self.scheduleController.sundayAvailabilityController, from: from, to: to)
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
            gradientContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        self.view.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scheduleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scheduleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scheduleController.view.layoutIfNeeded()
        
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
    
    func selectAvailableDay(controller: DayAvailabilityViewController, from: String, to: String) {
        controller.durationFromButton.text = from
        controller.selectedFromTime = from
        controller.durationToButton.text = to
        controller.selectedToTime = to
        controller.secondSelection.alpha = 1
        controller.dayAvailable = 1
        if from == "All day" || to == "All day" {
            controller.customPressed()
        }
    }
    
    @objc func saveButtonPressed() {
        if let parking = self.selectedParking, let parkingID = parking.parkingID {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID).child("AvailableTimes")
            ref.removeValue()
            
            let mondayFromTimes = self.scheduleController.mondayAvailabilityController.selectedFromTime
            let mondayToTimes = self.scheduleController.mondayAvailabilityController.selectedToTime
            let tuesdayFromTimes = self.scheduleController.tuesdayAvailabilityController.selectedFromTime
            let tuesdayToTimes = self.scheduleController.tuesdayAvailabilityController.selectedToTime
            let wednesdayFromTimes = self.scheduleController.wednesdayAvailabilityController.selectedFromTime
            let wednesdayToTimes = self.scheduleController.wednesdayAvailabilityController.selectedToTime
            let thursdayFromTimes = self.scheduleController.thursdayAvailabilityController.selectedFromTime
            let thursdayToTimes = self.scheduleController.thursdayAvailabilityController.selectedToTime
            let fridayFromTimes = self.scheduleController.fridayAvailabilityController.selectedFromTime
            let fridayToTimes = self.scheduleController.fridayAvailabilityController.selectedToTime
            let saturdayFromTimes = self.scheduleController.saturdayAvailabilityController.selectedFromTime
            let saturdayToTimes = self.scheduleController.saturdayAvailabilityController.selectedToTime
            let sundayFromTimes = self.scheduleController.sundayAvailabilityController.selectedFromTime
            let sundayToTimes = self.scheduleController.sundayAvailabilityController.selectedToTime
            
            let availableMonday = ref.child("Monday")
            let availableTuesday = ref.child("Tuesday")
            let availableWednesday = ref.child("Wednesday")
            let availableThursday = ref.child("Thursday")
            let availableFriday = ref.child("Friday")
            let availableSaturday = ref.child("Saturday")
            let availableSunday = ref.child("Sunday")
            
            if self.scheduleController.mondayAvailabilityController.dayAvailable == 1 {
                availableMonday.updateChildValues(["From": mondayFromTimes, "To": mondayToTimes])
            } else {
                availableMonday.removeValue()
            }
            if self.scheduleController.tuesdayAvailabilityController.dayAvailable == 1 {
                availableTuesday.updateChildValues(["From": tuesdayFromTimes, "To": tuesdayToTimes])
            } else {
                availableTuesday.removeValue()
            }
            if self.scheduleController.wednesdayAvailabilityController.dayAvailable == 1 {
                availableWednesday.updateChildValues(["From": wednesdayFromTimes, "To": wednesdayToTimes])
            } else {
                availableWednesday.removeValue()
            }
            if self.scheduleController.thursdayAvailabilityController.dayAvailable == 1 {
                availableThursday.updateChildValues(["From": thursdayFromTimes, "To": thursdayToTimes])
            } else {
                availableThursday.removeValue()
            }
            if self.scheduleController.fridayAvailabilityController.dayAvailable == 1 {
                availableFriday.updateChildValues(["From": fridayFromTimes, "To": fridayToTimes])
            } else {
                availableFriday.removeValue()
            }
            if self.scheduleController.saturdayAvailabilityController.dayAvailable == 1 {
                availableSaturday.updateChildValues(["From": saturdayFromTimes, "To": saturdayToTimes])
            } else {
                availableSaturday.removeValue()
            }
            if self.scheduleController.sundayAvailabilityController.dayAvailable == 1 {
                availableSunday.updateChildValues(["From": sundayFromTimes, "To": sundayToTimes])
            } else {
                availableSunday.removeValue()
            }
            
            self.delegate?.resetParking()
            delayWithSeconds(0.8) {
                self.nextButton.alpha = 1
                self.nextButton.isUserInteractionEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func exitButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
