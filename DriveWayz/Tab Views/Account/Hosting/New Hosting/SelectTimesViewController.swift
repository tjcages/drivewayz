//
//  SelectTimesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class SelectTimesViewController: UIViewController {
    
    var shouldAskUnavailable: Bool = true
    var shouldAskAvailable: Bool = false
    
    var availableDays: [String] = []
    var unavailableDays: [String] = []
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(width: self.view.frame.width, height: 1440)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    var scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.text = "Tap specific durations or tap the standard button for predetermined times"
        label.numberOfLines = 2
        
        return label
    }()
    
    var mondayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Monday"
        
        return controller
    }()
    
    var tuesdayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Tuesday"
        
        return controller
    }()
    
    var wednesdayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Wednesday"
        
        return controller
    }()
    
    var thursdayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Thursday"
        
        return controller
    }()
    
    var fridayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Friday"
        
        return controller
    }()
    
    var saturdayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Saturday"
        
        return controller
    }()
    
    var sundayAvailabilityController: DayAvailabilityViewController = {
        let controller = DayAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.dayLabel.text = "Sunday"
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTimePickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTimePickers() {
        
        self.view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(scheduleLabel)
        scheduleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        scheduleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        scheduleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        scheduleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(sundayAvailabilityController.view)
        sundayAvailabilityController.view.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 32).isActive = true
        sundayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        sundayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        sundayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.addSubview(mondayAvailabilityController.view)
        mondayAvailabilityController.view.topAnchor.constraint(equalTo: sundayAvailabilityController.view.bottomAnchor, constant: 32).isActive = true
        mondayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mondayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mondayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.addSubview(tuesdayAvailabilityController.view)
        tuesdayAvailabilityController.view.topAnchor.constraint(equalTo: mondayAvailabilityController.view.bottomAnchor, constant: 32).isActive = true
        tuesdayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        tuesdayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        tuesdayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.addSubview(wednesdayAvailabilityController.view)
        wednesdayAvailabilityController.view.topAnchor.constraint(equalTo: tuesdayAvailabilityController.view.bottomAnchor, constant: 32).isActive = true
        wednesdayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        wednesdayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        wednesdayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.addSubview(thursdayAvailabilityController.view)
        thursdayAvailabilityController.view.topAnchor.constraint(equalTo: wednesdayAvailabilityController.view.bottomAnchor, constant: 32).isActive = true
        thursdayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        thursdayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        thursdayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.addSubview(fridayAvailabilityController.view)
        fridayAvailabilityController.view.topAnchor.constraint(equalTo: thursdayAvailabilityController.view.bottomAnchor, constant: 32).isActive = true
        fridayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        fridayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        fridayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.addSubview(saturdayAvailabilityController.view)
        saturdayAvailabilityController.view.topAnchor.constraint(equalTo: fridayAvailabilityController.view.bottomAnchor, constant: 32).isActive = true
        saturdayAvailabilityController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        saturdayAvailabilityController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        saturdayAvailabilityController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
    }
    
    func checkAvailability() -> (String, String) {
        self.availableDays = []
        self.unavailableDays = []
        if self.mondayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Monday")
        } else {
            self.unavailableDays.append("Monday")
        }
        if self.tuesdayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Tuesday")
        } else {
            self.unavailableDays.append("Tuesday")
        }
        if self.wednesdayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Wednesday")
        } else {
            self.unavailableDays.append("Wednesday")
        }
        if self.thursdayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Thursday")
        } else {
            self.unavailableDays.append("Thursday")
        }
        if self.fridayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Friday")
        } else {
            self.unavailableDays.append("Friday")
        }
        if self.saturdayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Saturday")
        } else {
            self.unavailableDays.append("Saturday")
        }
        if self.sundayAvailabilityController.dayAvailable == 1 {
            self.availableDays.append("Sunday")
        } else {
            self.unavailableDays.append("Sunday")
        }
        if self.unavailableDays.count ==  7 {
            self.shouldAskUnavailable = true
        } else {
            self.shouldAskUnavailable = false
        }
        if self.availableDays.count == 7 {
            self.shouldAskAvailable = true
        } else {
            self.shouldAskAvailable = false
        }
        var unavailableString = ""
        for unavailable in self.unavailableDays {
            if unavailableString == "" {
                unavailableString = unavailable
            } else {
                unavailableString = unavailableString + ", " + unavailable
            }
        }
        var availableString = ""
        for available in self.availableDays {
            if availableString == "" {
                availableString = available
            } else {
                availableString = availableString + ", " + available
            }
        }
        return (availableString, unavailableString)
    }

}
