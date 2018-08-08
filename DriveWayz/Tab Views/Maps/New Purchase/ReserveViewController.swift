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
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 5
//        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        view.layer.shadowRadius = 1
//        view.layer.shadowOpacity = 0.8
        
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "28"
        
        return label
    }()
    
    var sixthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.tag = 6
        button.setTitle("S", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showDates(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var sixthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "29"
        
        return label
    }()
    
    var infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
//        view.layer.cornerRadius = 5
//        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 0.8
        
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Select the days you want to reserve"
        
        return label
    }()
    
    var todayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Today"
        
        return label
    }()
    
    var todayImage: UIImageView = {
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.PRIMARY_DARK_COLOR
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "From:"
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "To:"
        
        return label
    }()
    
    var fromDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Thursday 24"
        
        return label
    }()
    
    var toDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Friday 25"
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        timeToPicker.delegate = self
        timeFromPicker.delegate = self

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
        viewContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        viewContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        viewContainer.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        
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
        
        daysContainer.addSubview(sixthButton)
        sixthButton.leftAnchor.constraint(equalTo: fifthButton.rightAnchor, constant: 20).isActive = true
        sixthButton.topAnchor.constraint(equalTo: daysContainer.topAnchor).isActive = true
        sixthButton.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor).isActive = true
        sixthButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        daysContainer.addSubview(selectionLine)
        daysContainer.sendSubview(toBack: selectionLine)
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
        infoContainer.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, constant: -80).isActive = true
        infoContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        viewContainer.addSubview(selectionLabel)
        selectionLabel.centerXAnchor.constraint(equalTo: infoContainer.centerXAnchor).isActive = true
        selectionLabel.centerYAnchor.constraint(equalTo: infoContainer.centerYAnchor).isActive = true
        selectionLabel.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
        selectionLabel.heightAnchor.constraint(equalTo: infoContainer.heightAnchor).isActive = true
        
        viewContainer.addSubview(todayImage)
        todayImage.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        todayImage.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 5).isActive = true
        todayImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        todayImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        viewContainer.addSubview(todayLabel)
        todayLabel.centerXAnchor.constraint(equalTo: todayImage.centerXAnchor).isActive = true
        todayLabel.topAnchor.constraint(equalTo: todayImage.bottomAnchor, constant: -5).isActive = true
        todayLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        todayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(fromLabel)
        fromLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 10).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fromLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 5).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 10).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        toLabel.topAnchor.constraint(equalTo: infoContainer.centerYAnchor, constant: -10).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(fromDayLabel)
        fromDayLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 40).isActive = true
        fromDayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fromDayLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 0).isActive = true
        fromDayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(timeFromPicker)
        timeFromPicker.rightAnchor.constraint(equalTo: infoContainer.rightAnchor, constant: -20).isActive = true
        timeFromPicker.centerYAnchor.constraint(equalTo: fromDayLabel.centerYAnchor).isActive = true
        timeFromPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeFromPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoContainer.addSubview(toDayLabel)
        toDayLabel.leftAnchor.constraint(equalTo: infoContainer.leftAnchor, constant: 40).isActive = true
        toDayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        toDayLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 0).isActive = true
        toDayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoContainer.addSubview(timeToPicker)
        timeToPicker.rightAnchor.constraint(equalTo: infoContainer.rightAnchor, constant: -20).isActive = true
        timeToPicker.centerYAnchor.constraint(equalTo: toDayLabel.centerYAnchor).isActive = true
        timeToPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeToPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    var currentDays: [String] = []
    
    func setDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd"
        
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
            } else if i == 5 {
                self.sixthButton.setTitle("\(weekDay)", for: .normal)
                self.sixthLabel.text = String(weekNumber)
            }
        }
    }
    
    func setTimes() {
        let ref = Database.database().reference().child("parking").child(self.parkingID!).child("Availability")
        ref.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                print(dictionary)
            }
        }
    }
    
    var lastDayPressed: UIButton?
    var lastDayFrom: String?
    var lastDayTo: String?
    
    @objc func showDates(sender: UIButton) {
        if sender.backgroundColor == UIColor.clear {
            let dayIndex = self.currentDays[sender.tag-1]
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
            self.setTimes()
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
        if sender.backgroundColor == UIColor.clear {
            UIView.animate(withDuration: 0.2, animations: {
                sender.backgroundColor = UIColor.black
                sender.setTitleColor(Theme.WHITE, for: .normal)
            }) { (success) in
                self.daysSelected.append(sender.tag)
                let index = sender.tag
                if self.daysSelected.count > 1 {
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
                    self.selectionLineLeft = self.selectionLine.leftAnchor.constraint(equalTo: sender.leftAnchor)
                        self.selectionLineLeft.isActive = true
                    self.selectionLineRight = self.selectionLine.rightAnchor.constraint(equalTo: sender.rightAnchor)
                        self.selectionLineRight.isActive = true
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.infoContainer.alpha = 0.7
                    self.selectionLabel.alpha = 0
                    self.todayLabel.alpha = 0
                    self.todayImage.alpha = 0
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
                    UIView.animate(withDuration: 0.2, animations: {
                        self.infoContainer.alpha = 0
                        self.selectionLabel.alpha = 1
                        self.todayLabel.alpha = 1
                        self.todayImage.alpha = 1
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
        return self.timeValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.timeValues[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = self.timeValues[row] as? String
        view.addSubview(label)
        
        return view

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    private let timeValues: NSArray = ["All day","1:00 am","1:30 am","2:00 am","2:30 am","3:00 am","3:30 am","4:00 am","4:30 am","5:00 am","5:30 am","6:00 am","6:30 am","7:00 am","7:30 am","8:00 am","8:30 am","9:00 am","9:30 am","10:00 am","10:30 am","11:00 am","11:30 am","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm","8:30 pm","9:00 pm","9:30 pm","10:00 pm","10:30 pm","11:00 pm","11:30 pm","12:00 am","12:30 am"]
//    private let pmTimeValues: NSArray = ["All day","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm","8:30 pm","9:00 pm","9:30 pm","10:00 pm","10:30 pm","11:00 pm","11:30 pm","12:00 am","12:30 am"]
    

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
}



