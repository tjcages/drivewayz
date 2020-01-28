//
//  BookingTimerViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var timerStarted: Bool = false
var toTimeParking: Double = 0.0
var bookingTimer: Timer?

class BookingTimerViewController: UIViewController {
    
    var delegate: handleBookingTimer?
    var seconds: Int = 0
    
    var timeLeft: String = "" {
        didSet {
            let minute = "minute"
            let minutes = "minutes"
            let hour = "hour"
            let hours = "hours"
            
            let minuteRange = (self.timeLeft as NSString).range(of: minute)
            let minutesRange = (self.timeLeft as NSString).range(of: minutes)
            let hourRange = (self.timeLeft as NSString).range(of: hour)
            let hoursRange = (self.timeLeft as NSString).range(of: hours)
            let rangeString = (self.timeLeft as NSString).range(of: self.timeLeft)
            
            let attributedString = NSMutableAttributedString(string: self.timeLeft)
//            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GREEN_PIGMENT , range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value:   Fonts.SSPSemiBoldH3, range: minuteRange)
            attributedString.addAttribute(NSAttributedString.Key.font, value:   Fonts.SSPSemiBoldH3, range: minutesRange)
            attributedString.addAttribute(NSAttributedString.Key.font, value:   Fonts.SSPSemiBoldH3, range: hourRange)
            attributedString.addAttribute(NSAttributedString.Key.font, value:   Fonts.SSPSemiBoldH3, range: hoursRange)
            if self.timeLeft == "Times up" {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.STRAWBERRY_PINK, range: rangeString)
            } else {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GREEN_PIGMENT, range: rangeString)
            }
            DispatchQueue.main.async {
                self.durationButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH1
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    func setData(toTime: TimeInterval) {
        if bookingTimer != nil {
            bookingTimer!.invalidate()
        }
        timerStarted = true
        toTimeParking = toTime
        let today = Date().timeIntervalSince1970
        let seconds = toTime - today
        self.seconds = Int(seconds)
        self.runTimer()
    }

    @objc func resartDatabaseTimer() {
        timerStarted = true
        let today = Date().timeIntervalSince1970
        let seconds = toTimeParking - today
        self.seconds = Int(seconds)
        self.runTimer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(resartDatabaseTimer), name: NSNotification.Name(rawValue: "bookingTimerRestart"), object: nil)
        
        self.view.addSubview(durationButton)
        durationButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        durationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationButton.heightAnchor.constraint(lessThanOrEqualToConstant: 35).isActive = true
        
    }
    
    func runTimer() {
        bookingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if self.seconds > 600 {
            self.seconds = self.seconds - 1
            self.timeLeft = timeString(time: TimeInterval(self.seconds))
            self.durationButton.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
        } else if self.seconds > 0 {
            self.seconds = self.seconds - 1
            self.timeLeft = timeString(time: TimeInterval(self.seconds))
            self.durationButton.setTitleColor(Theme.STRAWBERRY_PINK, for: .normal)
            self.delegate?.changeDestinationLabel(text: "Your parking reservation is almost over. Please plan on moving soon or extending time")
        } else {
            self.timeLeft = "Times up"
            self.durationButton.setTitleColor(Theme.STRAWBERRY_PINK, for: .normal)
            self.delegate?.endParkingDuration()
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        if hours == 1 {
            return String(format: "%01i hour  %02i minutes", arguments: [hours, minutes])
        } else if hours >= 10 {
            return String(format: "%02i hours  %02i minutes", arguments: [hours, minutes])
        } else if hours == 0 {
            return String(format: "%02i minutes", arguments: [minutes])
        } else {
            return String(format: "%01i hours  %02i minutes", arguments: [hours, minutes])
        }
    }
    
}
