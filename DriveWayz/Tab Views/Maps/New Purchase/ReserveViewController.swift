//
//  ReserveViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/6/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ReserveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parkingID: String?
    var finalFrom: String?
    var finalTo: String?
    var finalFromDay: String = "Today"
    var finalToDay: String = "Today"
    
    var delegate: handleReservations?
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var daysContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        return view
    }()
    
    var firstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tag = 1
        button.setTitle("M", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showDates(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "24"
        
        return label
    }()
    
    var secondButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tag = 2
        button.setTitle("T", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showDates(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "25"
        
        return label
    }()
    
    var thirdButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tag = 3
        button.setTitle("W", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showDates(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var thirdLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "26"
        
        return label
    }()
    
    var fourthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tag = 4
        button.setTitle("T", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showDates(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var fourthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "27"
        
        return label
    }()
    
    var fifthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tag = 5
        button.setTitle("F", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showDates(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var fifthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "28"
        
        return label
    }()
    
    var infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.alpha = 0
        
        return view
    }()
    
    var selectionLine: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.setTitleColor(UIColor.black, for: .normal)
        button.isUserInteractionEnabled = false
       
        return button
    }()
    
    var selectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Select the days you want to reserve"
        
        return label
    }()
    
    var todayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.SEA_BLUE
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Today"
        
        return label
    }()
    
    var fromDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Thursday 24"
        
        return label
    }()
    
    var toDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Friday 25"
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "to"
        
        return label
    }()
    
    var needHours: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Please select a full hour to park", for: .normal)
        view.titleLabel?.textColor = Theme.WHITE
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 2
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        view.alpha = 0
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    lazy var reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Times", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
        button.backgroundColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.addTarget(self, action: #selector(checkButtonPressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeToPicker.delegate = self
        timeToPicker.dataSource = self
        timeFromPicker.delegate = self
        timeFromPicker.dataSource = self

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setDays()
    }
    
    func setData(parkingID: String) {
        self.parkingID = parkingID
    }
    
    func setupView() {
        
        view.addSubview(viewContainer)
        viewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        viewContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        view.addSubview(needHours)
        needHours.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        needHours.bottomAnchor.constraint(equalTo: viewContainer.topAnchor, constant: -55).isActive = true
        needHours.widthAnchor.constraint(equalToConstant: 250).isActive = true
        needHours.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        viewContainer.addSubview(daysContainer)
        daysContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        daysContainer.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        daysContainer.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, constant: -40).isActive = true
        daysContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(thirdButton)
        thirdButton.centerXAnchor.constraint(equalTo: daysContainer.centerXAnchor).isActive = true
        thirdButton.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        thirdButton.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        thirdButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(secondButton)
        secondButton.rightAnchor.constraint(equalTo: thirdButton.leftAnchor, constant: -20).isActive = true
        secondButton.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        secondButton.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        secondButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(firstButton)
        firstButton.rightAnchor.constraint(equalTo: secondButton.leftAnchor, constant: -20).isActive = true
        firstButton.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        firstButton.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        firstButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(fourthButton)
        fourthButton.leftAnchor.constraint(equalTo: thirdButton.rightAnchor, constant: 20).isActive = true
        fourthButton.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        fourthButton.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        fourthButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(fifthButton)
        fifthButton.leftAnchor.constraint(equalTo: fourthButton.rightAnchor, constant: 20).isActive = true
        fifthButton.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        fifthButton.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        fifthButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(selectionLine)
        daysContainer.sendSubviewToBack(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        selectionLine.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        
        self.dayButtons.append(firstButton)
        self.dayButtons.append(secondButton)
        self.dayButtons.append(thirdButton)
        self.dayButtons.append(fourthButton)
        self.dayButtons.append(fifthButton)
        
        viewContainer.addSubview(firstLabel)
        firstLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        firstLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        firstLabel.topAnchor.constraint(equalTo: daysContainer.bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(secondLabel)
        secondLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secondLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: secondButton.centerXAnchor).isActive = true
        secondLabel.topAnchor.constraint(equalTo: daysContainer.bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(thirdLabel)
        thirdLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        thirdLabel.centerXAnchor.constraint(equalTo: thirdButton.centerXAnchor).isActive = true
        thirdLabel.topAnchor.constraint(equalTo: daysContainer.bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(fourthLabel)
        fourthLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fourthLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        fourthLabel.centerXAnchor.constraint(equalTo: fourthButton.centerXAnchor).isActive = true
        fourthLabel.topAnchor.constraint(equalTo: daysContainer.bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(fifthLabel)
        fifthLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fifthLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        fifthLabel.centerXAnchor.constraint(equalTo: fifthButton.centerXAnchor).isActive = true
        fifthLabel.topAnchor.constraint(equalTo: daysContainer.bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(infoContainer)
        infoContainer.topAnchor.constraint(equalTo: daysContainer.bottomAnchor, constant: 40).isActive = true
        infoContainer.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        infoContainer.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
        infoContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        viewContainer.addSubview(selectionLabel)
        selectionLabel.centerXAnchor.constraint(equalTo: infoContainer.centerXAnchor).isActive = true
        selectionLabel.centerYAnchor.constraint(equalTo: infoContainer.centerYAnchor, constant: -30).isActive = true
        selectionLabel.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
        selectionLabel.heightAnchor.constraint(equalTo: infoContainer.heightAnchor).isActive = true
        
        viewContainer.addSubview(todayLabel)
        todayLabel.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        todayLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor).isActive = true
        todayLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        todayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(fromDayLabel)
        fromDayLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 60).isActive = true
        fromDayLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fromDayLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10).isActive = true
        fromDayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(timeFromPicker)
        timeFromPicker.rightAnchor.constraint(equalTo: infoContainer.rightAnchor, constant: -70).isActive = true
        timeFromPicker.centerYAnchor.constraint(equalTo: fromDayLabel.centerYAnchor).isActive = true
        timeFromPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeFromPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoContainer.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 70).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        toLabel.topAnchor.constraint(equalTo: fromDayLabel.bottomAnchor, constant: 10).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(toDayLabel)
        toDayLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 60).isActive = true
        toDayLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        toDayLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 10).isActive = true
        toDayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(timeToPicker)
        timeToPicker.rightAnchor.constraint(equalTo: infoContainer.rightAnchor, constant: -70).isActive = true
        timeToPicker.centerYAnchor.constraint(equalTo: toDayLabel.centerYAnchor).isActive = true
        timeToPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeToPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(reserveButton)
        reserveButton.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -24).isActive = true
        reserveButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        reserveButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -12).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func checkButtonPressed(sender: UIButton) {
        guard let finalFromStg = finalFrom, let finalToStg = finalTo else { return }
        let from = "\(finalFromStg) \(finalFromDay)"
        let to = "\(finalToStg) \(finalToDay)"

        let formatter = DateFormatter()
        let finalFormatter = DateFormatter()
        formatter.dateFormat = "h:mm a EEEE YYYY/MM/dd"
        finalFormatter.dateFormat = "h:mm a EEEE"
        guard let fromDate = formatter.date(from: from) else { return }
        guard let toDate = formatter.date(from: to) else { return }
        let hours = Double((toDate.hours(from: fromDate)))
        
        let finalFromString = finalFormatter.string(from: fromDate)
        let finalToString = finalFormatter.string(from: toDate)
        
        if hours <= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.needHours.alpha = 0.9
            }) { (success) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.needHours.alpha = 0
                    })
                }
            }
        } else {
            self.delegate?.bringParkNow()
            self.delegate?.reserveCheckPressed(from: finalFromString, to: finalToString, hour: hours, fromTimestamp: fromDate, toTimestamp: toDate)
        }
    }
    
    var currentDays: [String] = []
    var weekDays: [String] = []
    var fullDays: [String] = []
    
    func setDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE YYYY/MM/dd"
        
        var day = Date().yesterday
        for i in 0..<6 {
            day = day.tomorrow
            let dayWeek = formatter.string(from: day)
            let first = dayWeek.index(dayWeek.startIndex, offsetBy: 0)
            let last = dayWeek.index(dayWeek.endIndex, offsetBy: 0)
            let middle = dayWeek.index(dayWeek.endIndex, offsetBy: -2)
            
            let weekDay = dayWeek[first]
            let weekNumber = dayWeek[middle ..< last]
            self.currentDays.append(dayWeek)
            let dayArray = dayWeek.split(separator: " ")
            self.weekDays.append(String(dayArray[0]))
            
            if i == 0 {
                self.firstButton.setTitle("\(weekDay)", for: .normal)
                self.firstLabel.text = String(weekNumber)
            } else if i == 1 {
                self.secondButton.setTitle("\(weekDay)", for: .normal)
                self.secondLabel.text = String(weekNumber)
            } else if i == 2 {
                self.thirdButton.setTitle("\(weekDay)", for: .normal)
                self.thirdLabel.text = String(weekNumber)
            } else if i == 3 {
                self.fourthButton.setTitle("\(weekDay)", for: .normal)
                self.fourthLabel.text = String(weekNumber)
            } else if i == 4 {
                self.fifthButton.setTitle("\(weekDay)", for: .normal)
                self.fifthLabel.text = String(weekNumber)
            }
        }
    }
    
    func setTimes(sender: UIButton, status: Bool) {
        let formatter = DateFormatter()
        let fullFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        formatter.dateFormat = "HH"
        fullFormatter.dateFormat = "h:mm a"
        dayFormatter.dateFormat = "EEEE"
        fullFormatter.amSymbol = "am"
        fullFormatter.pmSymbol = "pm"
        
        let ref = Database.database().reference().child("parking").child(self.parkingID!).child("Availability")
        ref.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let sunday = dictionary["Sunday"] as? [String:AnyObject]
                let saturday = dictionary["Saturday"] as? [String:AnyObject]
                let friday = dictionary["Friday"] as? [String:AnyObject]
                let thursday = dictionary["Thursday"] as? [String:AnyObject]
                let wednesday = dictionary["Wednesday"] as? [String:AnyObject]
                let tuesday = dictionary["Tuesday"] as? [String:AnyObject]
                let monday = dictionary["Monday"] as? [String:AnyObject]
                
                let index = sender.tag - 1
                var day: [String:AnyObject] = [:]
                let value = self.weekDays[index]
                let currentDays = self.currentDays[index]

                if value == "Monday" && monday != nil {
                    day = monday!
                } else if value == "Tuesday" && tuesday != nil {
                    day = tuesday!
                } else if value == "Wednesday" && wednesday != nil {
                    day = wednesday!
                } else if value == "Thursday" && thursday != nil {
                    day = thursday!
                } else if value == "Friday" && friday != nil {
                    day = friday!
                } else if value == "Saturday" && saturday != nil {
                    day = saturday!
                } else if value == "Sunday" && sunday != nil {
                    day = sunday!
                }
                if sender == self.firstButton {
                    //////// first button
                    var currentDate = Date()
                    currentDate = currentDate.nearestHour()!
                    let intDate = Int(formatter.string(from: currentDate))
                    
                    self.firstFromTimeValues = []
                    let from = day["From"] as? String
                    let to = day["To"] as? String
                    
                    if from == nil || to == nil {
                        self.toTimeValues = ["N/A"]
                        self.fromTimeValues = ["N/A"]
                        self.timeToPicker.reloadAllComponents()
                        return
                    }
                    
                    if from != "All day" && to != "All day" {
                        let fromDate = fullFormatter.date(from: from!)
                        let fromDateInt = Int(formatter.string(from: fromDate!))
                        let toDate = fullFormatter.date(from: to!)
                        var toDateInt = Int(formatter.string(from: toDate!))
                        if toDateInt == 0 {
                            toDateInt = 24
                        }
                        if intDate! >= fromDateInt! {
                            for _ in intDate!..<24 {
                                let stringDate = fullFormatter.string(from: currentDate)
                                self.firstFromTimeValues.append(stringDate)
                                currentDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                                self.finalFromDay = currentDays
                            }
                            if status == false {
                                self.toTimeValues = []
                                for date in intDate!..<toDateInt! {
                                    if date == 24 {
                                        let addDate = formatter.date(from: String(0))
                                        let newDate = fullFormatter.string(from: addDate!)
                                        self.toTimeValues.append(newDate)
                                        self.finalToDay = currentDays
                                    } else {
                                        let addDate = formatter.date(from: String(date))
                                        let newDate = fullFormatter.string(from: addDate!)
                                        self.toTimeValues.append(newDate)
                                        self.finalToDay = currentDays
                                    }
                                }
                                self.timeToPicker.reloadAllComponents()
                            }
                        } else {
                            self.fromTimeValues = []
                            for date in fromDateInt!...toDateInt! {
                                if date == 24 {
                                    let addDate = formatter.date(from: String(0))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.fromTimeValues.append(newDate)
                                    self.finalFromDay = currentDays
                                } else {
                                    let addDate = formatter.date(from: String(date))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.fromTimeValues.append(newDate)
                                    self.finalFromDay = currentDays
                                }
                            }
                        }
                    } else {
                        print("All day!")
                        self.fromTimeValues = []
                        for _ in intDate!..<23 {
                            let stringDate = fullFormatter.string(from: currentDate)
                            self.firstFromTimeValues.append(stringDate)
                            currentDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                            self.finalFromDay = currentDays
                        }
                        if status == false {
                            self.toTimeValues = []
                            for date in (intDate!+1)...24 {
                                if date == 24 {
                                    let addDate = formatter.date(from: String(0))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.finalToDay = currentDays
                                } else {
                                    let addDate = formatter.date(from: String(date))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.finalToDay = currentDays
                                }
                            }
                            self.timeToPicker.reloadAllComponents()
                        }
                    }
                    self.fromTimeValues = self.firstFromTimeValues
                    self.timeFromPicker.reloadAllComponents()
                    //////// first button
                } else {
                    let from = day["From"] as? String
                    let to = day["To"] as? String
                    
                    if from == nil || to == nil {
                        self.toTimeValues = ["N/A"]
                        self.timeToPicker.reloadAllComponents()
                        return
                    }
                    
                    if from != "All day" && to != "All day" {
                        let fromDate = fullFormatter.date(from: from!)
                        let fromDateInt = Int(formatter.string(from: fromDate!))
                        let toDate = fullFormatter.date(from: to!)
                        var toDateInt = Int(formatter.string(from: toDate!))
                        if toDateInt == 0 {
                            toDateInt = 24
                        }
                        var appendArray: [String] = []
                        for date in fromDateInt!...toDateInt! {
                            if date == 24 {
                                let addDate = formatter.date(from: String(0))
                                let newDate = fullFormatter.string(from: addDate!)
                                appendArray.append(newDate)
                            } else {
                                let addDate = formatter.date(from: String(date))
                                let newDate = fullFormatter.string(from: addDate!)
                                appendArray.append(newDate)
                            }
                        }
                        self.toTimeValues = []
                        if sender == self.secondButton {
                            self.secondFromTimeValues = appendArray
                            self.toTimeValues = self.secondFromTimeValues
                            self.timeToPicker.reloadAllComponents()
                            self.finalToDay = currentDays
                        } else if sender == self.thirdButton {
                            self.thirdFromTimeValues = appendArray
                            self.toTimeValues = self.thirdFromTimeValues
                            self.timeToPicker.reloadAllComponents()
                            self.finalToDay = currentDays
                        } else if sender == self.fourthButton {
                            self.fourthFromTimeValues = appendArray
                            self.toTimeValues = self.fourthFromTimeValues
                            self.timeToPicker.reloadAllComponents()
                            self.finalToDay = currentDays
                        } else if sender == self.fifthButton {
                            self.fifthFromTimeValues = appendArray
                            self.toTimeValues = self.fifthFromTimeValues
                            self.timeToPicker.reloadAllComponents()
                            self.finalToDay = currentDays
                        }
                        if status == false {
                            self.fromTimeValues = []
                            self.toTimeValues = []
                            for date in fromDateInt!...toDateInt! {
                                if date == 24 {
                                    let addDate = formatter.date(from: String(0))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.fromTimeValues.append(newDate)
                                    self.finalToDay = currentDays
                                    self.finalFromDay = currentDays
                                } else {
                                    let addDate = formatter.date(from: String(date))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.fromTimeValues.append(newDate)
                                    self.finalToDay = currentDays
                                    self.finalFromDay = currentDays
                                }
                            }
                            self.timeToPicker.reloadAllComponents()
                            self.timeFromPicker.reloadAllComponents()
                        }
                    } else {
                        print("All day!")
                        self.toTimeValues = []
                        if status == true {
                            for date in 1...24 {
                                if date == 24 {
                                    let addDate = formatter.date(from: String(0))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.finalToDay = currentDays
                                } else {
                                    let addDate = formatter.date(from: String(date))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.finalToDay = currentDays
                                }
                            }
                            self.timeToPicker.reloadAllComponents()
                        } else if status == false {
                            self.fromTimeValues = []
                            for date in 1...24 {
                                if date == 24 {
                                    let addDate = formatter.date(from: String(0))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.fromTimeValues.append(newDate)
                                    self.finalFromDay = currentDays
                                    self.finalToDay = currentDays
                                } else {
                                    let addDate = formatter.date(from: String(date))
                                    let newDate = fullFormatter.string(from: addDate!)
                                    self.toTimeValues.append(newDate)
                                    self.fromTimeValues.append(newDate)
                                    self.finalFromDay = currentDays
                                    self.finalToDay = currentDays
                                }
                            }
                            self.timeToPicker.reloadAllComponents()
                            self.timeFromPicker.reloadAllComponents()
                        }
                    }
                }
            }
        }
        self.timeFromPicker.selectRow(0, inComponent: 0, animated: true)
        self.timeToPicker.selectRow(0, inComponent: 0, animated: true)
        self.timeFromPicker.reloadAllComponents()
        self.timeToPicker.reloadAllComponents()
    }
    
    var lastDayPressed: UIButton?
    var lastDayFrom: String?
    var lastDayTo: String?
    
    @objc func showDates(sender: UIButton) {
        if sender.backgroundColor == UIColor.clear {
            let formatter = DateFormatter()
            let dayFormatter = DateFormatter()
            formatter.dateFormat = "EEEE YYYY/MM/dd"
            dayFormatter.dateFormat = "EEEE dd"
            let day = formatter.date(from: self.currentDays[sender.tag-1])
            
            let dayIndex = dayFormatter.string(from: day!)
            let daySplit = dayIndex.split(separator: " ")
            let dayName = String(daySplit[0])
            let dayNumber = String(daySplit[1])
            
            if let last = lastDayPressed {
                self.lastDayPressed = sender
                if sender.tag < last.tag {
                    lastDayFrom = fromDayLabel.text
                    fromDayLabel.text = "\(dayName) \(dayNumber)"
                } else if sender.tag > last.tag {
                    lastDayTo = toDayLabel.text
                    toDayLabel.text = "\(dayName) \(dayNumber)"
                } else if sender == self.lastDayPressed {
                    lastDayTo = toDayLabel.text
                    toDayLabel.text = "\(dayName) \(dayNumber)"
                }
            } else {
                self.lastDayPressed = sender
                fromDayLabel.text = "\(dayName) \(dayNumber)"
                toDayLabel.text = "\(dayName) \(dayNumber)"
                lastDayFrom = fromDayLabel.text
                lastDayTo = toDayLabel.text
            }
        } else {
            if sender == lastDayPressed {
                fromDayLabel.text = lastDayFrom
                toDayLabel.text = lastDayTo
            }
        }
    }
    
    var daysSelected: [Int] = []
    var dayButtons: [UIButton] = []
    var selectionLineLeft: NSLayoutConstraint!
    var selectionLineRight: NSLayoutConstraint!
    
    @objc func buttonPressed(sender: UIButton) {
        self.delegate?.hideParkNow()
        if sender.backgroundColor == UIColor.clear {
            self.reserveButton.backgroundColor = Theme.SEA_BLUE
            self.reserveButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                sender.backgroundColor = UIColor.black
                sender.setTitleColor(Theme.WHITE, for: .normal)
            }) { (success) in
                self.daysSelected.append(sender.tag)
                let index = sender.tag
                if self.daysSelected.count > 1 {
                    self.setTimes(sender: sender, status: true)
                    UIView.animate(withDuration: 0.2) {
                        self.selectionLine.alpha = 1
                    }
                    if index > 1 {
                        if let nextIndex = self.daysSelected.index(of: index + 1) {
                            print(self.daysSelected[nextIndex])
                            self.selectionLineLeft.constant = self.selectionLineLeft.constant - 60
                        }
                        if let nextIndex = self.daysSelected.index(of: index - 1) {
                            print(self.daysSelected[nextIndex])
                            self.selectionLineRight.constant = self.selectionLineRight.constant + 60
                        }
                    } else if index == 1 {
                        if let nextIndex = self.daysSelected.index(of: index + 1) {
                            self.selectionLineLeft.constant = self.selectionLineLeft.constant - 60
                            print(self.daysSelected[nextIndex])
                        }
                    }
                } else {
                    self.setTimes(sender: sender, status: false)
                    self.selectionLineLeft = self.selectionLine.leftAnchor.constraint(equalTo: sender.leftAnchor)
                        self.selectionLineLeft.isActive = true
                    self.selectionLineRight = self.selectionLine.rightAnchor.constraint(equalTo: sender.rightAnchor)
                        self.selectionLineRight.isActive = true
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.infoContainer.alpha = 0.7
                    self.selectionLabel.alpha = 0
                    self.todayLabel.alpha = 0
                    self.view.layoutIfNeeded()
                })
            }
        } else if sender.backgroundColor == UIColor.black {
            let index = sender.tag
            if self.daysSelected.count > 1 {
                if index > 1 {
                    if let nextIndex = self.daysSelected.index(of: index + 1) {
                        print(self.daysSelected[nextIndex])
                        self.selectionLineLeft.constant = self.selectionLineLeft.constant + 60
                    }
                    if let nextIndex = self.daysSelected.index(of: index - 1) {
                        print(self.daysSelected[nextIndex])
                        self.selectionLineRight.constant = self.selectionLineRight.constant - 60
                    }
                } else if index == 1 {
                    if let nextIndex = self.daysSelected.index(of: index + 1) {
                        self.selectionLineLeft.constant = self.selectionLineLeft.constant + 60
                        print(self.daysSelected[nextIndex])
                    }
                }
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            } else {
                self.selectionLineLeft.isActive = false
                self.selectionLineLeft = nil
                self.selectionLineRight.isActive = false
                self.selectionLineRight = nil
                self.lastDayPressed = nil
                self.selectionLine.alpha = 0
                self.reserveButton.backgroundColor = Theme.DARK_GRAY
                self.reserveButton.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.backgroundColor = UIColor.clear
                sender.setTitleColor(UIColor.black, for: .normal)
            }) { (success) in
                self.daysSelected.removeLast()
                if self.daysSelected.count == 0 {
                    self.delegate?.bringParkNow()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.infoContainer.alpha = 0
                        self.selectionLabel.alpha = 1
                        self.todayLabel.alpha = 1
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var timeFromPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.DARK_GRAY
        picker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        
        return picker
    }()
    
    var timeToPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.DARK_GRAY
        picker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        
        return picker
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timeToPicker {
            return self.toTimeValues.count
        } else {
            return self.fromTimeValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timeToPicker {
            return self.toTimeValues[row]
        } else {
            return self.fromTimeValues[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        if pickerView == timeToPicker {
            label.text = self.toTimeValues[row]
        } else if pickerView == timeFromPicker {
            label.text = self.fromTimeValues[row]
        }
        view.addSubview(label)
        if self.fromTimeValues.count > 0 {
            self.finalFrom = fromTimeValues[0]
        }
        if self.toTimeValues.count > 0 {
            self.finalTo = toTimeValues[0]
        }
        
        return view

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timeToPicker {
            if self.toTimeValues.count > 0 {
                self.finalTo = self.toTimeValues[row]
            }
        } else if pickerView == timeFromPicker {
            if self.fromTimeValues.count > 0 {
                self.finalFrom = self.fromTimeValues[row]
            }
        }
    }
    
    var toTimeValues: [String] = []
    var fromTimeValues: [String] = []
    
    private var firstFromTimeValues: [String] = []
    private var secondFromTimeValues: [String] = []
    private var thirdFromTimeValues: [String] = []
    private var fourthFromTimeValues: [String] = []
    private var fifthFromTimeValues: [String] = []
    private var sixthFromTimeValues: [String] = []

}


extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 0 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
}



