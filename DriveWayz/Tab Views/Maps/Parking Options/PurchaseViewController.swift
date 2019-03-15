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
}

class PurchaseViewController: UIViewController, handleHoursSelected {
    
    var delegate: handleCheckoutParking?
    var fromDate = Date()
    var toDate = Date()
    var selectedHours: Int = 2
    var selectedMinutes: Int = 15
    var totalSelectedTime: Double = 2.25
    
    var timeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Time"
        label.font = Fonts.SSPRegularH3
        
        return label
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
        button.backgroundColor = Theme.BLUE
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
        label.text = "Selected duration"
        label.font = Fonts.SSPRegularH4
        
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
    
    var reservationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Booking"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "$9.10"
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "9:50"
        label.transform = CGAffineTransform(scaleX: 0.9, y: 1.0)
        label.font = Fonts.SSPRegularH0
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "12:50"
        label.transform = CGAffineTransform(scaleX: 0.9, y: 1.0)
        label.font = Fonts.SSPRegularH0
        label.textAlignment = .right
        
        return label
    }()
    
    var timeLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
        label.text = "4h 24m"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return label
    }()
    
    var leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE.darker(by: 2)
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = Theme.OFF_WHITE.darker(by: 2)
        circle.layer.cornerRadius = 3
        view.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 6).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
        
        return view
    }()
    
    var rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE.darker(by: 1)
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = Theme.OFF_WHITE.darker(by: 1)
        circle.layer.cornerRadius = 3
        view.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 6).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
        
        return view
    }()
    
    var arriveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        label.text = "arrive"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var leaveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        label.text = "depart"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var confirmDurationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set Duration", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 30
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4

        setupViews()
        setupDuration()
        readjustCenter()
    }
    
    func setupViews() {
        
        self.view.addSubview(timeView)
        timeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        timeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        timeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        timeView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeView.addSubview(pmButton)
        pmButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        pmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        pmButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        pmButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        timeView.addSubview(amButton)
        amButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        amButton.rightAnchor.constraint(equalTo: pmButton.leftAnchor, constant: 4).isActive = true
        amButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        amButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        timeView.addSubview(currentTimesController.view)
        currentTimesController.view.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12).isActive = true
        currentTimesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentTimesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentTimesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeView.addSubview(selectLabel)
        selectLabel.topAnchor.constraint(equalTo: currentTimesController.view.bottomAnchor, constant: 18).isActive = true
        selectLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        selectLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        selectLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeView.addSubview(totalTimeLabel)
        totalTimeLabel.topAnchor.constraint(equalTo: currentTimesController.view.bottomAnchor, constant: 18).isActive = true
        totalTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        totalTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        totalTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeView.addSubview(sliderView.view)
        sliderView.view.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 12).isActive = true
        sliderView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        sliderView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22).isActive = true
        sliderView.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var timeLeftCenterAnchor: NSLayoutConstraint!
    var timeLeftWidthAnchor: NSLayoutConstraint!
    var fromTimeWidthAnchor: NSLayoutConstraint!
    var toTimeWidthAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        self.view.addSubview(reservationLabel)
        reservationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        reservationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        reservationLabel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -240).isActive = true
        reservationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(totalCostLabel)
        totalCostLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        totalCostLabel.topAnchor.constraint(equalTo: reservationLabel.topAnchor).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        fromTimeWidthAnchor = fromTimeLabel.widthAnchor.constraint(equalToConstant: 100)
            fromTimeWidthAnchor.isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 16).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(toTimeLabel)
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        toTimeWidthAnchor = toTimeLabel.widthAnchor.constraint(equalToConstant: 100)
            toTimeWidthAnchor.isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 16).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(timeLeft)
        timeLeftCenterAnchor = timeLeft.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            timeLeftCenterAnchor.isActive = true
        timeLeftWidthAnchor = timeLeft.widthAnchor.constraint(equalToConstant: 100)
            timeLeftWidthAnchor.isActive = true
        timeLeft.centerYAnchor.constraint(equalTo: fromTimeLabel.centerYAnchor).isActive = true
        timeLeft.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(leftLine)
        leftLine.rightAnchor.constraint(equalTo: timeLeft.leftAnchor, constant: -12).isActive = true
        leftLine.leftAnchor.constraint(equalTo: fromTimeLabel.rightAnchor, constant: 12).isActive = true
        leftLine.centerYAnchor.constraint(equalTo: timeLeft.centerYAnchor).isActive = true
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(rightLine)
        rightLine.leftAnchor.constraint(equalTo: timeLeft.rightAnchor, constant: 12).isActive = true
        rightLine.rightAnchor.constraint(equalTo: toTimeLabel.leftAnchor, constant: -12).isActive = true
        rightLine.centerYAnchor.constraint(equalTo: timeLeft.centerYAnchor).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(arriveLabel)
        arriveLabel.leftAnchor.constraint(equalTo: fromTimeLabel.leftAnchor, constant: 6).isActive = true
        arriveLabel.topAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor).isActive = true
        arriveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        arriveLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(leaveLabel)
        leaveLabel.rightAnchor.constraint(equalTo: toTimeLabel.rightAnchor, constant: -6).isActive = true
        leaveLabel.topAnchor.constraint(equalTo: toTimeLabel.bottomAnchor).isActive = true
        leaveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        leaveLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(confirmDurationButton)
        confirmDurationButton.topAnchor.constraint(equalTo: leaveLabel.bottomAnchor, constant: 36).isActive = true
        confirmDurationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        confirmDurationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        confirmDurationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func initializeTime() {
        self.sliderView.initializeTime()
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        self.delegate?.setDurationPressed()
    }
    
    func resetDurationTimes() {

    }
    
    func readjustCenter() {
        if let leftText = fromTimeLabel.text, let rightText = toTimeLabel.text, var timeText = totalTimeLabel.text {
            timeText = timeText.replacingOccurrences(of: " hrs", with: "h")
            timeText = timeText.replacingOccurrences(of: " hr", with: "h")
            timeText = timeText.replacingOccurrences(of: " min", with: "m")
            self.timeLeft.text = timeText
            let leftWidth = leftText.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH0)
            let rightWidth = rightText.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH0)
            let difference = leftWidth - rightWidth
            self.timeLeftCenterAnchor.constant = difference/2
            self.timeLeftWidthAnchor.constant = timeText.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5)
            self.fromTimeWidthAnchor.constant = leftWidth
            self.toTimeWidthAnchor.constant = rightWidth
            self.view.layoutIfNeeded()
        }
    }
    
    func setHourLabel(minutes: Int) {
        let tuple = minutesToHoursMinutes(minutes: minutes)
        if tuple.hours == 1 {
            if tuple.leftMinutes == 0 {
                self.totalTimeLabel.text = "\(tuple.hours) hr"
            } else {
                self.totalTimeLabel.text = "\(tuple.hours) hr \(tuple.leftMinutes) min"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                self.totalTimeLabel.text = "00 min"
            } else {
                self.totalTimeLabel.text = "\(tuple.leftMinutes) min"
            }
        } else {
            if tuple.leftMinutes == 0 {
                self.totalTimeLabel.text = "\(tuple.hours) hrs"
            } else {
                self.totalTimeLabel.text = "\(tuple.hours) hrs \(tuple.leftMinutes) min"
            }
        }
        self.selectedHours = tuple.hours
        self.selectedMinutes = tuple.leftMinutes
        self.updateTimes(hours: tuple.hours, minutes: tuple.leftMinutes)
        self.readjustCenter()
    }
    
    func updateTimes(hours: Int, minutes: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        let startString = formatter.string(from: self.fromDate)
        self.fromTimeLabel.text = startString
        let calendar = Calendar.current
        if let toDateHour = calendar.date(byAdding: .hour, value: hours, to: self.fromDate) {
            if let toDate = calendar.date(byAdding: .minute, value: minutes, to: toDateHour) {
                let toHour = calendar.component(.minute, from: toDate)
                let nextDiff = toHour.roundedUp(toMultipleOf: 5) - toHour
                if let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: toDate) {
                    let toTime = formatter.string(from: nextDate)
                    self.toDate = nextDate
                    self.totalSelectedTime = Double(Double(self.selectedHours) + Double(self.selectedMinutes) / 60.0)
                    self.toTimeLabel.text = toTime
                }
            }
        }
    }
    
    func changeStartDate(date: Date) {
        self.fromDate = date
        self.updateTimes(hours: self.selectedHours, minutes: self.selectedMinutes)
        self.readjustCenter()
    }

    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
}
