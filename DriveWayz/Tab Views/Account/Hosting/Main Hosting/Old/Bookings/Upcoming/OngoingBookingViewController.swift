//
//  OngoingBookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class OngoingBookingViewController: UIViewController {
    
    var booking: Bookings? {
        didSet {
            if let booking = self.booking {
                self.ongoingLabel.setTitle(booking.context, for: .normal)
                if booking.context == "Reservation" {
                    self.ongoingLabel.setTitle("Upcoming", for: .normal)
                }
                self.contextLabel.text = "Reservation"
                if let name = booking.userName {
                    let split = name.split(separator: " ")
                    if let first = split.first, let last = split.dropFirst().first?.first {
                        self.titleLabel.text = "\(first) \(last.uppercased())."
                    }
                }
                if let hours = booking.hours {
                    let minutes = Int(hours * 60)
                    self.setHourLabel(minutes: minutes)
                }
                if let fromTime = booking.fromDate, let toTime = booking.toDate {
                    let fromDate = Date(timeIntervalSince1970: fromTime)
                    let toDate = Date(timeIntervalSince1970: toTime)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mma"
                    formatter.amSymbol = "am"
                    formatter.pmSymbol = "pm"
                    let fromString = formatter.string(from: fromDate)
                    let toString = formatter.string(from: toDate)
                    
                    self.fromTimeLabel.text = fromString
                    self.toTimeLabel.text = toString
                    
                    self.fromTimeAnchor.constant = fromString.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1)
                    self.toTimeAnchor.constant = toString.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1)
                    self.view.layoutIfNeeded()
                }
                if let hours = booking.hours, let price = booking.price {
                    let cost = hours * price
                    self.amountLabel.text = NSString(format: "+$%.2f", cost) as String
                }
                if let profileURL = booking.userProfileURL, profileURL != "" {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileURL) { (success) in
                        if success != true {
                            let image = UIImage(named: "background4")
                            self.profileImageView.image = image
                        } else {
                            let image = resizeImage(image: self.profileImageView.image!, targetSize: CGSize(width: 200, height: 200))
                            self.profileImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.DarkGreen, bottomColor: Theme.LightGreen)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 140)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    var gooGraphic: UIImageView = {
        let image = UIImage(named: "gooGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = Theme.WHITE
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        let image = UIImage(named: "background4")
        button.image = image
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ryan E."
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "2 hours 15 minutes"
        label.font = Fonts.SSPRegularH6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        
        return label
    }()
    
    var contextLabel: UILabel = {
        let label = UILabel()
        label.text = "Booking"
        label.font = Fonts.SSPRegularH6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .right
        
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "+$16.50"
        label.font = Fonts.SSPBoldH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GREEN
        label.textAlignment = .right
        
        return label
    }()
    
    var ongoingLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ongoing", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "8:00am"
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10:15am"
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.textAlignment = .right
        
        return label
    }()
    
    var toLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("to", for: .normal)
        button.setTitleColor(Theme.BLACK.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 8

        setupViews()
    }
    
    var fromTimeAnchor: NSLayoutConstraint!
    var toTimeAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        self.view.addSubview(profileImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(durationLabel)
        self.view.addSubview(contextLabel)
        self.view.addSubview(amountLabel)
        
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -16).isActive = true
        
        container.addSubview(gooGraphic)
        gooGraphic.widthAnchor.constraint(equalToConstant: 260).isActive = true
        gooGraphic.heightAnchor.constraint(equalToConstant: 260).isActive = true
        gooGraphic.centerXAnchor.constraint(equalTo: container.rightAnchor, constant: -40).isActive = true
        gooGraphic.centerYAnchor.constraint(equalTo: container.bottomAnchor, constant: -80).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        titleLabel.sizeToFit()
        
        durationLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        durationLabel.sizeToFit()
        
        amountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        amountLabel.sizeToFit()
        
        contextLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor).isActive = true
        contextLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        contextLabel.sizeToFit()
        
        self.view.addSubview(ongoingLabel)
        ongoingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        ongoingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        ongoingLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        ongoingLabel.sizeToFit()
        
        self.view.addSubview(durationView)
        durationView.topAnchor.constraint(equalTo: ongoingLabel.bottomAnchor, constant: -4).isActive = true
        durationView.leftAnchor.constraint(equalTo: ongoingLabel.leftAnchor).isActive = true
        durationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        durationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(fromTimeLabel)
        fromTimeLabel.centerYAnchor.constraint(equalTo: durationView.centerYAnchor).isActive = true
        fromTimeLabel.leftAnchor.constraint(equalTo: durationView.leftAnchor, constant: 12).isActive = true
        fromTimeAnchor = fromTimeLabel.widthAnchor.constraint(equalToConstant: (fromTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1))!)
            fromTimeAnchor.isActive = true
        fromTimeLabel.sizeToFit()
        
        self.view.addSubview(toTimeLabel)
        toTimeLabel.centerYAnchor.constraint(equalTo: durationView.centerYAnchor).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: durationView.rightAnchor, constant: -12).isActive = true
        toTimeAnchor = toTimeLabel.widthAnchor.constraint(equalToConstant: (toTimeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH1))!)
            toTimeAnchor.isActive = true
        toTimeLabel.sizeToFit()
        
        self.view.addSubview(toLabel)
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: -6).isActive = true
        toLabel.leftAnchor.constraint(equalTo: fromTimeLabel.rightAnchor).isActive = true
        toLabel.rightAnchor.constraint(equalTo: toTimeLabel.leftAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(transferButton)
        transferButton.centerYAnchor.constraint(equalTo: ongoingLabel.topAnchor, constant: 8).isActive = true
        transferButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    func setHourLabel(minutes: Int) {
        let tuple = minutesToHoursMinutes(minutes: minutes)
        if tuple.hours == 1 {
            if tuple.leftMinutes == 0 {
                self.durationLabel.text = "\(tuple.hours) hour"
            } else {
                self.durationLabel.text = "\(tuple.hours) hour \(tuple.leftMinutes) minutes"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                self.durationLabel.text = "00 minutes"
            } else {
                self.durationLabel.text = "\(tuple.leftMinutes) minutes"
            }
        } else {
            if tuple.leftMinutes == 0 {
                self.durationLabel.text = "\(tuple.hours) hours"
            } else {
                self.durationLabel.text = "\(tuple.hours) hours \(tuple.leftMinutes) minutes"
            }
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }

}
