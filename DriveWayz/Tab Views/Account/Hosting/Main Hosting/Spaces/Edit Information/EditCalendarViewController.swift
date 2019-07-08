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
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit the parking availability"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        return view
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
    
    lazy var scheduleController: CalendarViewController = {
        let controller = CalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupTopbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 600)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        }
        
        scrollView.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scheduleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        scheduleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scheduleController.showMoreHeightAnchor.constant = 100
        scheduleController.showMoreButton.titleEdgeInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        scheduleController.view.layoutIfNeeded()
        
        scrollView.addSubview(darkBlurView)
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
        self.nextButton.alpha = 0.5
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
                        self.nextButton.alpha = 1
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
