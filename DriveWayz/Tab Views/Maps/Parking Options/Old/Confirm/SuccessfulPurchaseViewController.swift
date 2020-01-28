//
//  SuccessfulPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos
import NVActivityIndicatorView

class SuccessfulPurchaseViewController: UIViewController {

//    var delegate: handleMinimizingFullController?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var starImageView: UIImageView = {
        let image = UIImage(named: "successStar")
        let button = UIImageView(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.alpha = 0
        
        return button
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 60
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        view.alpha = 0
        
        return view
    }()
    
    var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Booking was successful!"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var reservationEndsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reservation ends in"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var middleSeparator: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.text = ":"
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var hourBox: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PACIFIC_BLUE
        label.text = "3"
        label.backgroundColor = Theme.WHITE
        label.layer.shadowColor = Theme.DARK_GRAY.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.2
        //        label.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        label.font = Fonts.SSPBoldH0
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.clipsToBounds = false
        label.layer.cornerRadius = 4
        label.alpha = 0
        
        return label
    }()
    
    var minuteBox: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PACIFIC_BLUE
        label.text = "14"
        label.backgroundColor = Theme.WHITE
        label.layer.shadowColor = Theme.DARK_GRAY.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.2
        //        label.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        label.font = Fonts.SSPBoldH0
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.clipsToBounds = false
        label.layer.cornerRadius = 4
        label.alpha = 0
        
        return label
    }()
    
    var hoursLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hours"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var minutesLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "minutes"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()

    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        return loading
    }()
    
    func changeDates(totalTime: String) {
        var hours: Int = 0
        var minutes: Int = 0
        let timeArray = totalTime.split(separator: " ")
        if let hourString = timeArray.dropFirst().first, hourString.contains("h") {
            if let timeHours = timeArray.first {
                if let intHours = Int(timeHours) {
                    hours = intHours
                }
            }
        }
        if timeArray.count == 2 {
            if let minuteString = timeArray.dropFirst().first, minuteString.contains("m") {
                if let timeMinutes = timeArray.first {
                    if let intMinutes = Int(timeMinutes) {
                        minutes = intMinutes
                    }
                }
            }
        } else {
            if let minuteString = timeArray.dropFirst().dropFirst().dropFirst().first, minuteString.contains("m") {
                if let timeMinutes = timeArray.dropFirst().dropFirst().first {
                    if let intMinutes = Int(timeMinutes) {
                        minutes = intMinutes
                    }
                }
            }
        }
        self.hourBox.text = "\(hours)"
        if minutes == 0 {
            self.minuteBox.text = "00"
        } else {
            self.minuteBox.text = "\(minutes)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        setupViews()
        setupDuration()
    }
    
    var containerWidthAnchor: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerWidthAnchor = container.widthAnchor.constraint(equalToConstant: 168)
            containerWidthAnchor.isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 184)
            containerHeightAnchor.isActive = true
        
        container.addSubview(spotIcon)
        container.addSubview(starImageView)
        starImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        starImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        starImageView.heightAnchor.constraint(equalTo: starImageView.widthAnchor).isActive = true
        
        spotIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spotIcon.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 120).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        container.addSubview(successLabel)
        successLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        successLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 2).isActive = true
        successLabel.sizeToFit()
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    func setupDuration() {
        
        container.addSubview(reservationEndsLabel)
        reservationEndsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        reservationEndsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        reservationEndsLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 32).isActive = true
        reservationEndsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(middleSeparator)
        middleSeparator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        middleSeparator.topAnchor.constraint(equalTo: reservationEndsLabel.bottomAnchor, constant: 28).isActive = true
        middleSeparator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        middleSeparator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(hourBox)
        hourBox.rightAnchor.constraint(equalTo: middleSeparator.leftAnchor, constant: 0).isActive = true
        hourBox.centerYAnchor.constraint(equalTo: middleSeparator.centerYAnchor).isActive = true
        hourBox.heightAnchor.constraint(equalToConstant: 62).isActive = true
        hourBox.widthAnchor.constraint(equalToConstant: 62).isActive = true
        
        container.addSubview(minuteBox)
        minuteBox.leftAnchor.constraint(equalTo: middleSeparator.rightAnchor, constant: 0).isActive = true
        minuteBox.centerYAnchor.constraint(equalTo: middleSeparator.centerYAnchor).isActive = true
        minuteBox.heightAnchor.constraint(equalToConstant: 62).isActive = true
        minuteBox.widthAnchor.constraint(equalToConstant: 62).isActive = true
        
        container.addSubview(hoursLeftLabel)
        hoursLeftLabel.centerXAnchor.constraint(equalTo: hourBox.centerXAnchor).isActive = true
        hoursLeftLabel.topAnchor.constraint(equalTo: hourBox.bottomAnchor, constant: 4).isActive = true
        hoursLeftLabel.widthAnchor.constraint(equalTo: hourBox.widthAnchor).isActive = true
        hoursLeftLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(minutesLeftLabel)
        minutesLeftLabel.centerXAnchor.constraint(equalTo: minuteBox.centerXAnchor).isActive = true
        minutesLeftLabel.topAnchor.constraint(equalTo: minuteBox.bottomAnchor, constant: 4).isActive = true
        minutesLeftLabel.widthAnchor.constraint(equalTo: minuteBox.widthAnchor).isActive = true
        minutesLeftLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
   
    func animateSuccess() {
        self.containerWidthAnchor.constant = phoneWidth - 48
        self.containerHeightAnchor.constant = 380
        UIView.animate(withDuration: animationOut, animations: {
            self.loadingActivity.alpha = 0
            self.starImageView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.starImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.starImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (success) in
                    UIView.animate(withDuration: animationOut * 2, animations: {
                        self.successLabel.alpha = 1
                        self.reservationEndsLabel.alpha = 1
                        self.middleSeparator.alpha = 1
                        self.hourBox.alpha = 1
                        self.minuteBox.alpha = 1
                        self.hoursLeftLabel.alpha = 1
                        self.minutesLeftLabel.alpha = 1
                        
                        var transform = CGAffineTransform.identity
                        transform = transform.translatedBy(x: 30, y: 0)
                        transform = transform.rotated(by: CGFloat.pi * 0.8)
                        transform = transform.scaledBy(x: 0.7, y: 0.7)
                        self.starImageView.transform = transform
                        var transform2 = CGAffineTransform.identity
                        transform2 = transform2.translatedBy(x: -30, y: 0)
                        transform2 = transform2.scaledBy(x: 0.65, y: 0.65)
                        self.spotIcon.transform = transform2
                        self.spotIcon.alpha = 1
                    }, completion: { (success) in
                        
                    })
                })
            }

        }
    }
    
    func closeSuccess() {
        UIView.animate(withDuration: animationIn, animations: {
            self.successLabel.alpha = 0
            self.reservationEndsLabel.alpha = 0
            self.middleSeparator.alpha = 0
            self.hourBox.alpha = 0
            self.minuteBox.alpha = 0
            self.hoursLeftLabel.alpha = 0
            self.minutesLeftLabel.alpha = 0
            self.spotIcon.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.starImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.spotIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (success) in
                self.containerWidthAnchor.constant = 168
                self.containerHeightAnchor.constant = 184
                self.loadingActivity.stopAnimating()
                UIView.animate(withDuration: animationIn, animations: {
                    self.loadingActivity.alpha = 1
                    self.starImageView.alpha = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
}
