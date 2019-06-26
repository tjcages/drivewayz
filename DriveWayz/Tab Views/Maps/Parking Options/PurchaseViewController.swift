//
//  PurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHoursSelected {
    func setHourLabel(minutes: Int)
    func changeStartDate(date: Date)
    func setData(isToday: Bool)
}

var bookingFromDate: Date?
var bookingToDate: Date?

class PurchaseViewController: UIViewController, handleHoursSelected {
    
    var delegate: handleCheckoutParking?
    var fromDate = Date()
    var toDate = Date()
    var selectedHours: Int = 2
    var selectedMinutes: Int = 15
    var totalSelectedTime: Double = 2.25
    var parking: ParkingSpots?
    var shouldReverse: Bool = true
    var amPm: String = "am"
    
    var timeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var dateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.setTitle("Select date", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        //        button.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var currentDatesController: PurchaseDaysViewController = {
        let controller = PurchaseDaysViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.clipsToBounds = false
        controller.delegate = self
        
        return controller
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.setTitle("Select time", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
//        button.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var amButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.setTitle("am", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 12
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        return button
    }()
    
    var pmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("pm", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 12
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        return button
    }()
    
    lazy var currentTimesController: PurchaseTimesViewController = {
        let controller = PurchaseTimesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.clipsToBounds = false
        controller.delegate = self
        
        return controller
    }()
    
    var selectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Select duration"
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.text = "2 hrs 15 min"
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var sliderView: PurchaseSliderViewController = {
        let controller = PurchaseSliderViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.setTitle("Set duration", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingFromDate = Date()
        bookingToDate = Date().addingTimeInterval(3600 * 2.25)
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 8

        setupDates()
        setupViews()
        setupDuration()
        initializeTime()
    }
    
    func setupDates() {
        
        self.view.addSubview(timeView)
        timeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        timeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        timeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        timeView.addSubview(dateButton)
        dateButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        dateButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        dateButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateButton.sizeToFit()
        
        timeView.addSubview(currentDatesController.view)
        currentDatesController.view.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 6).isActive = true
        currentDatesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentDatesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentDatesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func setupViews() {
        
        timeView.addSubview(timeButton)
        timeButton.topAnchor.constraint(equalTo: currentDatesController.view.bottomAnchor, constant: 18).isActive = true
        timeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        timeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeButton.sizeToFit()
        
        timeView.addSubview(pmButton)
        pmButton.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        pmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        pmButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        pmButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        timeView.addSubview(amButton)
        amButton.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        amButton.rightAnchor.constraint(equalTo: pmButton.leftAnchor, constant: 4).isActive = true
        amButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        amButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        timeView.addSubview(currentTimesController.view)
        currentTimesController.view.topAnchor.constraint(equalTo: timeButton.bottomAnchor, constant: 12).isActive = true
        currentTimesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentTimesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentTimesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeView.addSubview(selectLabel)
        selectLabel.topAnchor.constraint(equalTo: currentTimesController.view.bottomAnchor, constant: 16).isActive = true
        selectLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        selectLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        selectLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeView.addSubview(totalTimeLabel)
        totalTimeLabel.topAnchor.constraint(equalTo: currentTimesController.view.bottomAnchor, constant: 18).isActive = true
        totalTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        totalTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeView.addSubview(sliderView.view)
        sliderView.view.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 12).isActive = true
        sliderView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        sliderView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22).isActive = true
        sliderView.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupDuration() {
        
        self.view.addSubview(mainButton)
        mainButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28).isActive = true
        
    }
    
    func setData(isToday: Bool) {
        self.currentTimesController.setData(isToday: isToday)
    }
    
    func saveDates() {
        var cellText = self.currentTimesController.selectedString
        if cellText == "Now" {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm"
            let string = formatter.string(from: date)
            cellText = string
        }
        let cellAm = self.amPm
        let dayOfWeek = self.currentDatesController.selectedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: dayOfWeek)
        let startString = dateString + " " + cellText + " " + cellAm
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        if let fromDate = dateFormatter.date(from: startString), let toTime = totalTimeLabel.text {
            self.delegate?.setDurationPressed(fromDate: fromDate, totalTime: toTime)
            var hours: Int = 0
            var minutes: Int = 0
            let timeArray = toTime.split(separator: " ")
            if let hourString = timeArray.dropFirst().first, hourString.contains("h") {
                if let timeHours = timeArray.first {
                    if let intHours = Int(timeHours) {
                        hours = intHours
                    }
                }
            }
            if let minuteString = timeArray.dropFirst().dropFirst().dropFirst().first, minuteString.contains("m") {
                if let timeMinutes = timeArray.dropFirst().dropFirst().first {
                    if let intMinutes = Int(timeMinutes) {
                        minutes = intMinutes
                    }
                }
            }
            let additionalSeconds: Double = Double((hours * 60 + minutes) * 60)
            let toDate = fromDate.addingTimeInterval(additionalSeconds)
            bookingFromDate = fromDate
            bookingToDate = toDate
            self.delegate?.observeAllHosting()
        }
    }
    
    func initializeTime() {
        let minutes = 15 * 9
        self.sliderView.initializeTime(minutes: minutes)
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        saveDates()
    }
    
    func resetDurationTimes() {

    }
    
    func setHourLabel(minutes: Int) {
        let tuple = minutesToHoursMinutes(minutes: minutes)
        if tuple.hours == 1 {
            self.mainButton.alpha = 1
            self.mainButton.isUserInteractionEnabled = true
            if tuple.leftMinutes == 0 {
                self.totalTimeLabel.text = "\(tuple.hours) hr"
            } else {
                self.totalTimeLabel.text = "\(tuple.hours) hr \(tuple.leftMinutes) min"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                self.totalTimeLabel.text = "00 min"
                self.mainButton.alpha = 0.5
                self.mainButton.isUserInteractionEnabled = false
            } else {
                self.mainButton.alpha = 1
                self.mainButton.isUserInteractionEnabled = true
                self.totalTimeLabel.text = "\(tuple.leftMinutes) min"
            }
        } else {
            self.mainButton.alpha = 1
            self.mainButton.isUserInteractionEnabled = true
            if tuple.leftMinutes == 0 {
                self.totalTimeLabel.text = "\(tuple.hours) hrs"
            } else {
                self.totalTimeLabel.text = "\(tuple.hours) hrs \(tuple.leftMinutes) min"
            }
        }
        self.selectedHours = tuple.hours
        self.selectedMinutes = tuple.leftMinutes
        self.totalSelectedTime = Double(tuple.hours) + Double(tuple.leftMinutes)/60
    }
    
    
}
