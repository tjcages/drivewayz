//
//  PurchaseDurationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PurchaseDurationViewController: UIViewController {
    
    let hourArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let minuteArray = [0, 15, 30, 45]
    
    var selectedHour: Int = 2
    var selectedMinute: Int = 15
//    var delegate: handleDurationSet?
    
    var reservationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reservation"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sat, Jan 12"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2:15 PM"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH1
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:30 PM"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH1
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dec"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var blueSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var hourPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.BLACK
        picker.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return picker
    }()
    
    var minutePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.BLACK
        picker.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return picker
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "hours"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var minuteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "minutes"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    lazy var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK.withAlphaComponent(0.5), bottomColor: Theme.BLACK)
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 164)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourPicker.delegate = self
        hourPicker.dataSource = self
        minutePicker.delegate = self
        minutePicker.dataSource = self

        setupViews()
        setupWeekdays()
        setupDuration()
    }
    
    func didSetTimes() {
        let date = Date()
        let calendar = Calendar.current
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EE"
        let nameOfMonth = monthFormatter.string(from: date)
        let dayOfMonth = calendar.component(.day, from: date)
        let dayOfWeek = dayFormatter.string(from: date)
        let currentDate = "\(dayOfWeek), \(nameOfMonth) \(dayOfMonth)"
        
        self.dateLabel.text = currentDate
        self.monthLabel.text = nameOfMonth
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.calendar = calendar
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        let fromTime = timeFormatter.string(from: date)
        self.fromTimeLabel.text = fromTime
        
        let firstDay = dayFormatter.string(from: date)
        let secondDay = dayFormatter.string(from: date.tomorrow)
        let thirdDay = dayFormatter.string(from: date.tomorrow.tomorrow)
        let fourthDay = dayFormatter.string(from: date.tomorrow.tomorrow.tomorrow)
        let fifthDay = dayFormatter.string(from: date.tomorrow.tomorrow.tomorrow.tomorrow)
        let sixthDay = dayFormatter.string(from: date.tomorrow.tomorrow.tomorrow.tomorrow.tomorrow)
        let seventhDay = dayFormatter.string(from: date.tomorrow.tomorrow.tomorrow.tomorrow.tomorrow.tomorrow)
        self.firstDay.text = String(firstDay.first ?? "S")
        self.secondDay.text = String(secondDay.first ?? "S")
        self.thirdDay.text = String(thirdDay.first ?? "T")
        self.fourthDay.text = String(fourthDay.first ?? "T")
        self.fifthDay.text = String(fifthDay.first ?? "S")
        self.sixthDay.text = String(sixthDay.first ?? "S")
        self.seventhDay.text = String(seventhDay.first ?? "T")
        
        let firstNumber = calendar.component(.day, from: date)
        let secondNumber = calendar.component(.day, from: date.tomorrow)
        let thirdNumber = calendar.component(.day, from: date.tomorrow.tomorrow)
        let fourthNumber = calendar.component(.day, from: date.tomorrow.tomorrow.tomorrow)
        let fifthNumber = calendar.component(.day, from: date.tomorrow.tomorrow.tomorrow.tomorrow)
        let sixthNumber = calendar.component(.day, from: date.tomorrow.tomorrow.tomorrow.tomorrow.tomorrow)
        let seventhNumber = calendar.component(.day, from: date.tomorrow.tomorrow.tomorrow.tomorrow.tomorrow.tomorrow)
        self.firstNumber.setTitle("\(firstNumber)", for: .normal)
        self.secondNumber.setTitle("\(secondNumber)", for: .normal)
        self.thirdNumber.setTitle("\(thirdNumber)", for: .normal)
        self.fourthNumber.setTitle("\(fourthNumber)", for: .normal)
        self.fifthNumber.setTitle("\(fifthNumber)", for: .normal)
        self.sixthNumber.setTitle("\(sixthNumber)", for: .normal)
        self.seventhNumber.setTitle("\(seventhNumber)", for: .normal)
        
        if self.blueSelectionLineRight.isActive == true {
            self.blueSelectionWidth.constant = (self.toTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH1))!
        } else {
            self.blueSelectionWidth.constant = (self.fromTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH1))!
        }
        self.resetTimes()
    }
    
    var blueSelectionLineLeft: NSLayoutConstraint!
    var blueSelectionLineRight: NSLayoutConstraint!
    var blueSelectionWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(reservationLabel)
        reservationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        reservationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        reservationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        reservationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        dateLabel.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 12).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        fromTimeLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(toTimeLabel)
        toTimeLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        monthLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 48).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(blueSelectionLine)
        blueSelectionLineLeft = blueSelectionLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36)
            blueSelectionLineLeft.isActive = false
        blueSelectionLineRight = blueSelectionLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36)
            blueSelectionLineRight.isActive = true
        blueSelectionLine.topAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: 8).isActive = true
        blueSelectionLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        blueSelectionWidth = blueSelectionLine.widthAnchor.constraint(equalToConstant: (self.toTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH3))!)
            blueSelectionWidth.isActive = true
        let tapFromSelection = UITapGestureRecognizer(target: self, action: #selector(timedLabelSelected(sender:)))
        fromTimeLabel.addGestureRecognizer(tapFromSelection)
        let tapToSelection = UITapGestureRecognizer(target: self, action: #selector(timedLabelSelected(sender:)))
        toTimeLabel.addGestureRecognizer(tapToSelection)
        
    }
    
    func setupDuration() {
        
        self.view.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        durationLabel.topAnchor.constraint(equalTo: firstNumber.bottomAnchor, constant: 24).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(hourPicker)
        hourPicker.selectRow(2, inComponent: 0, animated: false)
        hourPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        hourPicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        hourPicker.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 4).isActive = true
        hourPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(minutePicker)
        minutePicker.selectRow(1, inComponent: 0, animated: false)
        minutePicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40).isActive = true
        minutePicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 - 24).isActive = true
        minutePicker.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 4).isActive = true
        minutePicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(hourLabel)
        hourLabel.leftAnchor.constraint(equalTo: hourPicker.centerXAnchor, constant: -15).isActive = true
        hourLabel.rightAnchor.constraint(equalTo: minutePicker.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourPicker.centerYAnchor).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(minuteLabel)
        minuteLabel.leftAnchor.constraint(equalTo: minutePicker.centerXAnchor, constant: 0).isActive = true
        minuteLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        minuteLabel.centerYAnchor.constraint(equalTo: minutePicker.centerYAnchor).isActive = true
        minuteLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        self.view.addSubview(darkView)
        self.view.sendSubviewToBack(darkView)
        darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: monthLabel.topAnchor, constant: -12).isActive = true
    }
    
    func startTiming() {
        self.didSetTimes()
        self.resetTimes()
        self.didSetTimes()
    }
    
    func timeDurationSet() {
        if var fromTime = self.fromTimeLabel.text, var toTime = self.toTimeLabel.text {
            fromTime = fromTime.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
            toTime = toTime.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
            let totalTime = "\(fromTime) to \(toTime)"
            let minutes: Double = Double(self.selectedMinute)/60
            let duration = Double(self.selectedHour) + minutes
            
//            self.delegate?.durationTimeSet(duration: totalTime, time: duration)
        }
    }
    
    @objc func timedLabelSelected(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: animationIn) {
            if sender.view == self.fromTimeLabel {
                self.blueSelectionLineLeft.isActive = true
                self.blueSelectionLineRight.isActive = false
                self.fromTimeLabel.textColor = Theme.BLUE
                self.toTimeLabel.textColor = Theme.WHITE
            } else if sender.view == self.toTimeLabel {
                self.blueSelectionLineLeft.isActive = false
                self.blueSelectionLineRight.isActive = true
                self.toTimeLabel.textColor = Theme.BLUE
                self.fromTimeLabel.textColor = Theme.WHITE
            }
            self.view.layoutIfNeeded()
        }
    }
    
    var selectedDays: [UIButton] = []
    
    @objc func daySelected(sender: UIButton) {
        UIView.animate(withDuration: animationIn, animations: {
            if sender.backgroundColor == Theme.BLUE {
                sender.backgroundColor = UIColor.clear
                sender.setTitleColor(Theme.BLACK, for: .normal)
                self.selectedDays = self.selectedDays.filter {$0 != sender}
                self.hideMiddleViews(tag: sender.tag)
                if self.selectedDays.count == 0 {
                    self.selectedDays.append(self.firstNumber)
                    self.firstNumber.backgroundColor = Theme.BLUE
                    self.firstNumber.setTitleColor(Theme.WHITE, for: .normal)
                }
                return
            } else {
                sender.backgroundColor = Theme.BLUE
                sender.setTitleColor(Theme.WHITE, for: .normal)
                self.selectedDays.append(sender)
            }
            self.checkButtonNext(sender: sender)
        })
    }
    
    func checkButtonNext(sender: UIButton) {
        let above = sender.tag + 1
        let below = sender.tag - 1
        var aboveView: UIView?
        var belowView: UIView?
        if sender.tag == 1 {
            aboveView = self.firstSecondView
            belowView = nil
        } else if sender.tag == 2 {
            aboveView = self.secondThirdView
            belowView = self.firstSecondView
        } else if sender.tag == 3 {
            aboveView = self.thirdFourthView
            belowView = self.secondThirdView
        } else if sender.tag == 4 {
            aboveView = self.fourthFifthView
            belowView = self.thirdFourthView
        } else if sender.tag == 5 {
            aboveView = self.fifthSixthView
            belowView = self.fourthFifthView
        } else if sender.tag == 6 {
            aboveView = self.sixthSeventhView
            belowView = self.fifthSixthView
        } else if sender.tag == 7 {
            aboveView = nil
            belowView = self.sixthSeventhView
        }
        for senders in self.selectedDays {
            if senders.tag == above {
                if let aView = aboveView {
                    delayWithSeconds(animationIn) {
                        UIView.animate(withDuration: animationIn) {
                            aView.alpha = 1
                        }
                    }
                }
            } else if senders.tag == below {
                if let bView = belowView {
                    delayWithSeconds(animationIn) {
                        UIView.animate(withDuration: animationIn) {
                            bView.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
    func hideMiddleViews(tag: Int) {
        if tag == 1 {
            self.firstSecondView.alpha = 0
        } else if tag == 2 {
            self.firstSecondView.alpha = 0
            self.secondThirdView.alpha = 0
        } else if tag == 3 {
            self.secondThirdView.alpha = 0
            self.thirdFourthView.alpha = 0
        } else if tag == 4 {
            self.thirdFourthView.alpha = 0
            self.fourthFifthView.alpha = 0
        } else if tag == 5 {
            self.fourthFifthView.alpha = 0
            self.fifthSixthView.alpha = 0
        } else if tag == 6 {
            self.fifthSixthView.alpha = 0
            self.sixthSeventhView.alpha = 0
        } else if tag == 7 {
            self.sixthSeventhView.alpha = 0
        }
    }

    var firstDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var secondDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "M"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var thirdDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "T"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var fourthDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "W"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var fifthDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "T"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var sixthDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "F"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var seventhDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var firstNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("23", for: .normal)
        label.setTitleColor(Theme.WHITE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.backgroundColor = Theme.BLUE
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 1
        
        return label
    }()
    
    var secondNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("24", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 2
        
        return label
    }()
    
    var thirdNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("25", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 3
        
        return label
    }()
    
    var fourthNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("26", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 4
        
        return label
    }()
    
    var fifthNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("27", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 5
        
        return label
    }()
    
    var sixthNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("28", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 6
        
        return label
    }()
    
    var seventhNumber: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("29", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH3
        label.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        label.addTarget(self, action: #selector(daySelected(sender:)), for: .touchUpInside)
        label.tag = 7
        
        return label
    }()
    
    var firstSecondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var secondThirdView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var thirdFourthView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var fourthFifthView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var fifthSixthView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
    var sixthSeventhView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0
        
        return view
    }()
    
}


extension PurchaseDurationViewController {
    
    func setupWeekdays() {
        
        let width = (self.view.frame.width - 72)/7
        firstNumber.layer.cornerRadius = width/2
        secondNumber.layer.cornerRadius = width/2
        thirdNumber.layer.cornerRadius = width/2
        fourthNumber.layer.cornerRadius = width/2
        fifthNumber.layer.cornerRadius = width/2
        sixthNumber.layer.cornerRadius = width/2
        seventhNumber.layer.cornerRadius = width/2
        
        self.view.addSubview(firstDay)
        self.selectedDays.append(firstNumber)
        firstDay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        firstDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        firstDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        firstDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(secondDay)
        secondDay.leftAnchor.constraint(equalTo: firstDay.rightAnchor).isActive = true
        secondDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        secondDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        secondDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(thirdDay)
        thirdDay.leftAnchor.constraint(equalTo: secondDay.rightAnchor).isActive = true
        thirdDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        thirdDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        thirdDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(fourthDay)
        fourthDay.leftAnchor.constraint(equalTo: thirdDay.rightAnchor).isActive = true
        fourthDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        fourthDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        fourthDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(fifthDay)
        fifthDay.leftAnchor.constraint(equalTo: fourthDay.rightAnchor).isActive = true
        fifthDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        fifthDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        fifthDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(sixthDay)
        sixthDay.leftAnchor.constraint(equalTo: fifthDay.rightAnchor).isActive = true
        sixthDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        sixthDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        sixthDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(seventhDay)
        seventhDay.leftAnchor.constraint(equalTo: sixthDay.rightAnchor).isActive = true
        seventhDay.widthAnchor.constraint(equalToConstant: width).isActive = true
        seventhDay.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 12).isActive = true
        seventhDay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(lineView)
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: firstDay.bottomAnchor, constant: 12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(firstNumber)
        firstNumber.leftAnchor.constraint(equalTo: firstDay.leftAnchor).isActive = true
        firstNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        firstNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        firstNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(secondNumber)
        secondNumber.leftAnchor.constraint(equalTo: firstDay.rightAnchor).isActive = true
        secondNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        secondNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        secondNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(thirdNumber)
        thirdNumber.leftAnchor.constraint(equalTo: secondDay.rightAnchor).isActive = true
        thirdNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        thirdNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        thirdNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(fourthNumber)
        fourthNumber.leftAnchor.constraint(equalTo: thirdDay.rightAnchor).isActive = true
        fourthNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        fourthNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        fourthNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(fifthNumber)
        fifthNumber.leftAnchor.constraint(equalTo: fourthDay.rightAnchor).isActive = true
        fifthNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        fifthNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        fifthNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(sixthNumber)
        sixthNumber.leftAnchor.constraint(equalTo: fifthDay.rightAnchor).isActive = true
        sixthNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        sixthNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        sixthNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(seventhNumber)
        seventhNumber.leftAnchor.constraint(equalTo: sixthDay.rightAnchor).isActive = true
        seventhNumber.widthAnchor.constraint(equalToConstant: width).isActive = true
        seventhNumber.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12).isActive = true
        seventhNumber.heightAnchor.constraint(equalTo: firstNumber.widthAnchor).isActive = true
        
        self.view.addSubview(firstSecondView)
        self.view.sendSubviewToBack(firstSecondView)
        firstSecondView.leftAnchor.constraint(equalTo: firstNumber.centerXAnchor).isActive = true
        firstSecondView.rightAnchor.constraint(equalTo: secondNumber.centerXAnchor).isActive = true
        firstSecondView.topAnchor.constraint(equalTo: firstNumber.topAnchor).isActive = true
        firstSecondView.bottomAnchor.constraint(equalTo: firstNumber.bottomAnchor).isActive = true
        
        self.view.addSubview(secondThirdView)
        self.view.sendSubviewToBack(secondThirdView)
        secondThirdView.leftAnchor.constraint(equalTo: secondNumber.centerXAnchor).isActive = true
        secondThirdView.rightAnchor.constraint(equalTo: thirdNumber.centerXAnchor).isActive = true
        secondThirdView.topAnchor.constraint(equalTo: firstNumber.topAnchor).isActive = true
        secondThirdView.bottomAnchor.constraint(equalTo: firstNumber.bottomAnchor).isActive = true
        
        self.view.addSubview(thirdFourthView)
        self.view.sendSubviewToBack(thirdFourthView)
        thirdFourthView.leftAnchor.constraint(equalTo: thirdNumber.centerXAnchor).isActive = true
        thirdFourthView.rightAnchor.constraint(equalTo: fourthNumber.centerXAnchor).isActive = true
        thirdFourthView.topAnchor.constraint(equalTo: firstNumber.topAnchor).isActive = true
        thirdFourthView.bottomAnchor.constraint(equalTo: firstNumber.bottomAnchor).isActive = true
        
        self.view.addSubview(fourthFifthView)
        self.view.sendSubviewToBack(fourthFifthView)
        fourthFifthView.leftAnchor.constraint(equalTo: fourthNumber.centerXAnchor).isActive = true
        fourthFifthView.rightAnchor.constraint(equalTo: fifthNumber.centerXAnchor).isActive = true
        fourthFifthView.topAnchor.constraint(equalTo: firstNumber.topAnchor).isActive = true
        fourthFifthView.bottomAnchor.constraint(equalTo: firstNumber.bottomAnchor).isActive = true
        
        self.view.addSubview(fifthSixthView)
        self.view.sendSubviewToBack(fifthSixthView)
        fifthSixthView.leftAnchor.constraint(equalTo: fifthNumber.centerXAnchor).isActive = true
        fifthSixthView.rightAnchor.constraint(equalTo: sixthNumber.centerXAnchor).isActive = true
        fifthSixthView.topAnchor.constraint(equalTo: firstNumber.topAnchor).isActive = true
        fifthSixthView.bottomAnchor.constraint(equalTo: firstNumber.bottomAnchor).isActive = true
        
        self.view.addSubview(sixthSeventhView)
        self.view.sendSubviewToBack(sixthSeventhView)
        sixthSeventhView.leftAnchor.constraint(equalTo: sixthNumber.centerXAnchor).isActive = true
        sixthSeventhView.rightAnchor.constraint(equalTo: seventhNumber.centerXAnchor).isActive = true
        sixthSeventhView.topAnchor.constraint(equalTo: firstNumber.topAnchor).isActive = true
        sixthSeventhView.bottomAnchor.constraint(equalTo: firstNumber.bottomAnchor).isActive = true
        
    }
    
}


extension PurchaseDurationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 28
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width/2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPicker && self.hourArray.count > 0 {
            return self.hourArray.count
        } else if pickerView == minutePicker && self.minuteArray.count > 0 {
            return self.minuteArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hourPicker && self.hourArray.count > row {
            return "\(self.hourArray[row])"
        } else if pickerView == minutePicker && self.minuteArray.count > row {
            return "\(self.minuteArray[row])"
        } else {
            return "0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: -40, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        if pickerView == hourPicker && self.hourArray.count > row {
            label.text = "\(self.hourArray[row])"
        } else if pickerView == minutePicker && self.minuteArray.count > row {
            if self.minuteArray[row] == 0 {
                label.text = "00"
            } else {
                label.text = "\(self.minuteArray[row])"
            }
        }
        
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPicker {
            if hourArray.count > row {
                self.selectedHour = hourArray[row]
            }
            if row > 0 {
                self.hourLabel.text = "hours"
            } else {
                self.hourLabel.text = "hour"
            }
        } else {
            if minuteArray.count > row {
                self.selectedMinute = minuteArray[row]
            }
        }
        self.didSetTimes()
        self.resetTimes()
        self.didSetTimes()
    }
    
    func resetTimes() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a EE, MMM dd"
        if let fromTime = self.fromTimeLabel.text, let fromMonth = self.dateLabel.text {
            if let fromDate = formatter.date(from: "\(fromTime) \(fromMonth)") {
                let calendar = Calendar.current
                if let toDateHour = calendar.date(byAdding: .hour, value: self.selectedHour, to: fromDate) {
                    if let toDate = calendar.date(byAdding: .minute, value: self.selectedMinute, to: toDateHour) {
                        let toHour = calendar.component(.minute, from: toDate)
                        let nextDiff = toHour.roundedUp(toMultipleOf: 5) - toHour
                        if let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: toDate) {
                            let toFormatter = DateFormatter()
                            toFormatter.dateFormat = "h:mm a"
                            let toTime = toFormatter.string(from: nextDate)
                            self.toTimeLabel.text = toTime
                        }
                    }
                }
            }
        }
    }
    
}


extension BinaryInteger {
    func roundedTowardZero(toMultipleOf m: Self) -> Self {
        return self - (self % m)
    }
    
    func roundedAwayFromZero(toMultipleOf m: Self) -> Self {
        let x = self.roundedTowardZero(toMultipleOf: m)
        if x == self { return x }
        return (m.signum() == self.signum()) ? (x + m) : (x - m)
    }
    
    func roundedDown(toMultipleOf m: Self) -> Self {
        return (self < 0) ? self.roundedAwayFromZero(toMultipleOf: m)
            : self.roundedTowardZero(toMultipleOf: m)
    }
    
    func roundedUp(toMultipleOf m: Self) -> Self {
        return (self > 0) ? self.roundedAwayFromZero(toMultipleOf: m)
            : self.roundedTowardZero(toMultipleOf: m)
    }
}
