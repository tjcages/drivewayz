//
//  EditCalendarViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditCalendarViewController: UIViewController {
    
    var delegate: handleHostEditing?
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK.withAlphaComponent(0.95), bottomColor: Theme.BLACK.withAlphaComponent(0.87))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth - 24, height: phoneHeight - 48)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: 140, height: 55)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.layer.cornerRadius = 55/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLACK.withAlphaComponent(0), bottomColor: Theme.BLACK.withAlphaComponent(0.8))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit the parking availability"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    lazy var scheduleController: CalendarViewController = {
        let controller = CalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 12).isActive = true
        container.heightAnchor.constraint(equalToConstant: phoneHeight * 3/4).isActive = true
        
        container.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        container.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor).isActive = true
        scheduleController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24).isActive = true
        scheduleController.view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        scheduleController.showMoreHeightAnchor.constant = 100
        scheduleController.showMoreButton.titleEdgeInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        scheduleController.view.layoutIfNeeded()
        
        container.addSubview(darkBlurView)
        darkBlurView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        darkBlurView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
    func setupPreviousAvailability() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                if let value = snapshot.value as? String {
                    let hostRef = Database.database().reference().child("ParkingSpots").child(value).child("UnavailableDays")
                    hostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            if let mondayRef = dictionary["Monday"] as? [String] {
                                for day in mondayRef {
                                    if !self.scheduleController.selectedMondays.contains(day) {
                                        self.scheduleController.selectedMondays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let tuesdayRef = dictionary["Tuesday"] as? [String] {
                                for day in tuesdayRef {
                                    if !self.scheduleController.selectedTuesdays.contains(day) {
                                        self.scheduleController.selectedTuesdays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let wednesdayRef = dictionary["Wednesday"] as? [String] {
                                for day in wednesdayRef {
                                    if !self.scheduleController.selectedWednesdays.contains(day) {
                                        self.scheduleController.selectedWednesdays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let thursdayRef = dictionary["Thursday"] as? [String] {
                                for day in thursdayRef {
                                    if !self.scheduleController.selectedThursdays.contains(day) {
                                        self.scheduleController.selectedThursdays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let fridayRef = dictionary["Friday"] as? [String] {
                                for day in fridayRef {
                                    if !self.scheduleController.selectedFridays.contains(day) {
                                        self.scheduleController.selectedFridays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let saturdayRef = dictionary["Saturday"] as? [String] {
                                for day in saturdayRef {
                                    if !self.scheduleController.selectedSaturdays.contains(day) {
                                        self.scheduleController.selectedSaturdays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let sundayRef = dictionary["Sunday"] as? [String] {
                                for day in sundayRef {
                                    if !self.scheduleController.selectedSundays.contains(day) {
                                        self.scheduleController.selectedSundays.append(day)
                                    }
                                    self.scheduleController.pullDatesFromDatabase(dateString: day)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    @objc func saveButtonPressed() {
        let background = CAGradientLayer().customColor(topColor: Theme.DARK_GRAY.lighter(by: 50)!, bottomColor: Theme.DARK_GRAY.lighter(by: 40)!)
        background.frame = CGRect(x: 0, y: 0, width: 140, height: 55)
        background.zPosition = -10
        self.nextButton.layer.addSublayer(background)
        self.nextButton.isUserInteractionEnabled = false
        self.nextButton.setTitle("Saving...", for: .normal)
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                if let value = snapshot.value as? String {
                    let hostRef = Database.database().reference().child("ParkingSpots").child(value)
                    
                    let mondayUnavailable = self.scheduleController.selectedMondays
                    let tuesdayUnavailable = self.scheduleController.selectedTuesdays
                    let wednesdayUnavailable = self.scheduleController.selectedWednesdays
                    let thursdayUnavailable = self.scheduleController.selectedThursdays
                    let fridayUnavailable = self.scheduleController.selectedFridays
                    let saturdayUnavailable = self.scheduleController.selectedSaturdays
                    let sundayUnavailable = self.scheduleController.selectedSundays
                    
                    let unavailableRef = hostRef.child("UnavailableDays")
                    let unavailableMonday = unavailableRef.child("Monday")
                    let unavailableTuesday = unavailableRef.child("Tuesday")
                    let unavailableWednesday = unavailableRef.child("Wednesday")
                    let unavailableThursday = unavailableRef.child("Thursday")
                    let unavailableFriday = unavailableRef.child("Friday")
                    let unavailableSaturday = unavailableRef.child("Saturday")
                    let unavailableSunday = unavailableRef.child("Sunday")
                    
                    unavailableMonday.setValue(mondayUnavailable)
                    unavailableTuesday.setValue(tuesdayUnavailable)
                    unavailableWednesday.setValue(wednesdayUnavailable)
                    unavailableThursday.setValue(thursdayUnavailable)
                    unavailableFriday.setValue(fridayUnavailable)
                    unavailableSaturday.setValue(saturdayUnavailable)
                    unavailableSunday.setValue(sundayUnavailable)
                    
                    self.delegate?.closeCalendar()
                    delayWithSeconds(animationOut * 2, completion: {
                        let background = CAGradientLayer().purpleColor()
                        background.frame = CGRect(x: 0, y: 0, width: 140, height: 55)
                        background.zPosition = -10
                        self.nextButton.layer.addSublayer(background)
                        self.nextButton.isUserInteractionEnabled = true
                        self.nextButton.setTitle("Save", for: .normal)
                    })
                }
            }
        }
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.closeCalendar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.closeCalendar()
    }

}
