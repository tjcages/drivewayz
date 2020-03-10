//
//  NavigationTopViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationTopViewController: UIViewController {
    
    var timer: Timer?
    var toTimestamp: TimeInterval?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        
        return view
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "1065 University Avenue"
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.9)
        label.text = "2 hours 15 minutes left"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    func setData(booking: Bookings) {
        if let toTimestamp = booking.toDate, let parkingID = booking.parkingID {
            self.toTimestamp = toTimestamp
            self.setHourLabel()
            
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID).child("Location")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let streetAddress = dictionary["streetAddress"] as? String {
                        self.spotLocatingLabel.text = streetAddress
                    }
                }
            }
            
            self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(setHourLabel), userInfo: nil, repeats: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.BLACK
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.6
        
        setupDuration()
    }
    
    func setupDuration() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        container.addSubview(spotLocatingLabel)
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            spotLocatingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        case .iphoneX:
            spotLocatingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        }
        
        container.addSubview(timeRemainingLabel)
        timeRemainingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        timeRemainingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        timeRemainingLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: 4).isActive = true
        timeRemainingLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    @objc func setHourLabel() {
        if let toTimestamp = self.toTimestamp {
            let timestamp = Date().timeIntervalSince1970
            let minutes = Int((toTimestamp - timestamp)/60)
            
            if minutes >= 0 {
                let tuple = minutesToHoursMinutes(minutes: minutes)
                if tuple.hours == 1 {
                    if tuple.leftMinutes == 0 {
                        self.timeRemainingLabel.text = "\(tuple.hours) hour left"
                        self.timeRemainingLabel.textColor = Theme.WHITE
                    } else {
                        self.timeRemainingLabel.text = "\(tuple.hours) hour \(tuple.leftMinutes) minutes left"
                        self.timeRemainingLabel.textColor = Theme.WHITE
                    }
                } else if tuple.hours == 0 {
                    if tuple.leftMinutes == 0 {
                        self.timeRemainingLabel.text = "Time's up!"
                        self.timeRemainingLabel.textColor = Theme.SALMON
                    } else {
                        self.timeRemainingLabel.text = "\(tuple.leftMinutes) minutes left"
                        self.timeRemainingLabel.textColor = Theme.WHITE
                    }
                } else {
                    if tuple.leftMinutes == 0 {
                        self.timeRemainingLabel.text = "\(tuple.hours) hours left"
                        self.timeRemainingLabel.textColor = Theme.WHITE
                    } else {
                        self.timeRemainingLabel.text = "\(tuple.hours) hours \(tuple.leftMinutes) minutes left"
                        self.timeRemainingLabel.textColor = Theme.WHITE
                    }
                }
            } else {
            
            }
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }

}
