//
//  CurrentDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentDurationView: UIViewController {

    var delegate: mainBarSearchDelegate?
    var durationWidth: CGFloat = phoneWidth - 72
    var seconds: Int = 0
    var startDate: TimeInterval?
    var endDate: TimeInterval?
    var hasShownEndBooking: Bool = false
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time left"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var timeLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var durationBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        
        return view
    }()
    
    var durationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    func setData(toTime: TimeInterval) {
        if bookingTimer != nil {
            bookingTimer!.invalidate()
        }
        hasShownEndBooking = false
        timerStarted = true
        toTimeParking = toTime
        let today = Date().timeIntervalSince1970
        let seconds = toTime - today
        self.seconds = Int(seconds)
        self.runTimer()
    }
    
    @objc func observeBooking() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("CurrentBooking")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            let bookingRef = Database.database().reference().child("UserBookings").child(key)
            bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let booking = Bookings(dictionary: dictionary)
                    if let toTime = booking.toDate, let fromTime = booking.fromDate {
                        self.setData(toTime: toTime)
                        
                        self.startDate = fromTime
                        self.endDate = toTime
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.DARK_GRAY
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        NotificationCenter.default.addObserver(self, selector: #selector(resartDatabaseTimer), name: NSNotification.Name(rawValue: "bookingTimerRestart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observeBooking), name: NSNotification.Name(rawValue: "restartBookingObservations"), object: nil)
        
        observeBooking()
        setupViews()
    }
    
    var durationWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
     
        view.addSubview(durationLabel)
        view.addSubview(timeLeft)
        view.addSubview(durationBackground)
        durationBackground.addSubview(durationLine)
        
        durationBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        durationBackground.leftAnchor.constraint(equalTo: durationLabel.leftAnchor).isActive = true
        durationBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        durationBackground.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        timeLeft.bottomAnchor.constraint(equalTo: durationBackground.topAnchor, constant: -8).isActive = true
        timeLeft.leftAnchor.constraint(equalTo: durationLabel.leftAnchor).isActive = true
        timeLeft.sizeToFit()
        
        durationLabel.bottomAnchor.constraint(equalTo: timeLeft.topAnchor).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        durationLabel.sizeToFit()
        
        durationLine.topAnchor.constraint(equalTo: durationBackground.topAnchor).isActive = true
        durationLine.leftAnchor.constraint(equalTo: durationBackground.leftAnchor).isActive = true
        durationLine.bottomAnchor.constraint(equalTo: durationBackground.bottomAnchor).isActive = true
        durationWidthAnchor = durationLine.rightAnchor.constraint(equalTo: durationBackground.leftAnchor)
            durationWidthAnchor.isActive = true
        
    }
    
    @objc func resartDatabaseTimer() {
        timerStarted = true
        let today = Date().timeIntervalSince1970
        let seconds = toTimeParking - today
        self.seconds = Int(seconds)
        self.runTimer()
    }
    
    func runTimer() {
        if seconds != 0 {
            bookingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer() {
        if self.seconds > 600 {
            self.seconds = self.seconds - 1
            durationLabel.text = "Time left"
            timeLeft.text = timeString(time: TimeInterval(self.seconds))
            if hasShownEndBooking {
                hasShownEndBooking = false
                delegate?.hideEndBookingView()
            }
        } else if self.seconds > 0 {
            self.seconds = self.seconds - 1
            durationLabel.text = "Please plan on moving soon"
            timeLeft.text = timeString(time: TimeInterval(self.seconds))
            if !hasShownEndBooking {
                hasShownEndBooking = true
                delegate?.showEndBookingView()
            }
        } else {
            durationLabel.text = "Please move your vehicle or extend time"
            timeLeft.text = "Times up"
            if !hasShownEndBooking {
                hasShownEndBooking = true
                delegate?.showEndBookingView()
            }
        }
        
        if let fromDate = startDate, let toDate = endDate {
            let totalSeconds = toDate - fromDate
            let percentage = Double(seconds)/totalSeconds
            
            let width = view.bounds.width - 40
            durationWidthAnchor.constant = width * CGFloat(percentage)
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        if hours == 1 {
            if minutes == 1 {
                return String(format: "%01i hour  %02i minute", arguments: [hours, minutes])
            } else {
                return String(format: "%01i hour  %02i minutes", arguments: [hours, minutes])
            }
        } else if hours >= 1 {
            if minutes == 1 {
                return String(format: "%01i hours  %02i minute", arguments: [hours, minutes])
            } else {
                return String(format: "%01i hours  %02i minutes", arguments: [hours, minutes])
            }
        } else if hours == 0 {
            if minutes == 1 {
                return String(format: "%02i minute", arguments: [minutes])
            } else {
                return String(format: "%02i minutes", arguments: [minutes])
            }
        } else {
            return String(format: "%01i hours  %02i minutes", arguments: [hours, minutes])
        }
    }

}
