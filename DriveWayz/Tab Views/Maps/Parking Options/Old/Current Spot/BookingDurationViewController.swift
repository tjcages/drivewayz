//
//  BookingDurationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleBookingTimer {
    func changeDestinationLabel(text: String)
    func endParkingDuration()
}

var bookingDurationButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("", for: .normal)
    button.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
    button.titleLabel?.font = Fonts.SSPSemiBoldH1
    button.contentHorizontalAlignment = .left
    
    return button
}()

class BookingDurationViewController: UIViewController, handleBookingTimer {
    
    var duration: String = "" {
        didSet {
            let lastTwo = self.duration.suffix(3)
            let range = (self.duration as NSString).range(of: String(lastTwo))
            let rangeString = (self.duration as NSString).range(of: self.duration)
            let attributedString = NSMutableAttributedString(string: self.duration)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GREEN_PIGMENT , range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value:   Fonts.SSPSemiBoldH3, range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GREEN_PIGMENT, range: rangeString)
            bookingDurationButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "time")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var leaveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leave at"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Make sure to check in once you have parked your vehicle..."
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()

    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.OFF_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 45
        let image = UIImage(named: "Green Scene")
        view.image = image
        
        return view
    }()
    
    var expandButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Expand", for: .normal)
        label.setTitleColor(Theme.BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var shimmerMain: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var shimmerIcon: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 45
        view.alpha = 0
        
        return view
    }()
    
    var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN_PIGMENT
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.alpha = 1
        
        return view
    }()
    
    var navigationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "navigationArrow")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        return button
    }()
    
    var navigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Navigation"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var checkInView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE.withAlphaComponent(0.8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var checkInIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "checkInIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
        
        return button
    }()
    
    var checkInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Check In"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var endReservationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.setTitle("End Booking", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.cornerRadius = 4
        button.alpha = 0
        
        return button
    }()
    
    lazy var timerController: BookingTimerViewController = {
        let controller = BookingTimerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var extendDurationButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Extend duration", for: .normal)
        label.setTitleColor(Theme.BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE

        setupViews()
        setupNavigation()
        setupCheckIn()
        setupShimmer()
        setupShimmerIcon()
    }
    
    var destinationShortRightAnchor: NSLayoutConstraint!
    var destinationLongRightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(timeButton)
        timeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 42).isActive = true
        timeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        timeButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        timeButton.heightAnchor.constraint(equalTo: timeButton.widthAnchor).isActive = true
        
        self.view.addSubview(leaveLabel)
        leaveLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 4).isActive = true
        leaveLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        leaveLabel.sizeToFit()
        
        self.view.addSubview(bookingDurationButton)
        bookingDurationButton.leftAnchor.constraint(equalTo: leaveLabel.rightAnchor, constant: 10).isActive = true
        bookingDurationButton.bottomAnchor.constraint(equalTo: leaveLabel.bottomAnchor, constant: 12).isActive = true
        bookingDurationButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bookingDurationButton.sizeToFit()
        bookingDurationButton.addTarget(self, action: #selector(durationButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(destinationLabel)
        self.view.addSubview(spotIcon)
        destinationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: leaveLabel.bottomAnchor, constant: 8).isActive = true
        destinationShortRightAnchor = destinationLabel.rightAnchor.constraint(equalTo: spotIcon.leftAnchor, constant: -24)
            destinationShortRightAnchor.isActive = true
        destinationLongRightAnchor = destinationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24)
            destinationLongRightAnchor.isActive = false
        destinationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        spotIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotIcon.topAnchor.constraint(equalTo: timeButton.topAnchor).isActive = true
        spotIcon.heightAnchor.constraint(equalToConstant: 90).isActive = true
        spotIcon.widthAnchor.constraint(equalTo: spotIcon.heightAnchor).isActive = true
        
        self.view.addSubview(expandButton)
        expandButton.topAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: -4).isActive = true
        expandButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(timerController.view)
        timerController.view.centerYAnchor.constraint(equalTo: bookingDurationButton.centerYAnchor).isActive = true
        timerController.view.leftAnchor.constraint(equalTo: bookingDurationButton.leftAnchor).isActive = true
        timerController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        timerController.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timerController.durationButton.addTarget(self, action: #selector(durationButtonPressed), for: .touchUpInside)
        
    }
    
    func setupNavigation() {
        
        self.view.addSubview(navigationView)
        navigationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        navigationView.topAnchor.constraint(equalTo: expandButton.bottomAnchor, constant: 20).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        navigationView.widthAnchor.constraint(equalToConstant: phoneWidth/2 - 42).isActive = true
        
        navigationView.addSubview(navigationLabel)
        navigationLabel.rightAnchor.constraint(equalTo: navigationView.rightAnchor, constant: -16).isActive = true
        navigationLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationLabel.sizeToFit()
        
        navigationView.addSubview(navigationIcon)
        navigationIcon.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 12).isActive = true
        navigationIcon.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navigationIcon.widthAnchor.constraint(equalTo: navigationIcon.heightAnchor).isActive = true
        
    }
    
    var endReservationLeftAnchor: NSLayoutConstraint!
    var endReservationFullAnchor: NSLayoutConstraint!
    var endReservationTopAnchor: NSLayoutConstraint!
    
    func setupCheckIn() {
        
        self.view.addSubview(checkInView)
        checkInView.leftAnchor.constraint(equalTo: navigationView.rightAnchor, constant: 16).isActive = true
        checkInView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        checkInView.topAnchor.constraint(equalTo: expandButton.bottomAnchor, constant: 20).isActive = true
        checkInView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkInView.addSubview(checkInLabel)
        checkInLabel.rightAnchor.constraint(equalTo: checkInView.rightAnchor, constant: -40).isActive = true
        checkInLabel.centerYAnchor.constraint(equalTo: checkInView.centerYAnchor).isActive = true
        checkInLabel.sizeToFit()
        
        checkInView.addSubview(checkInIcon)
        checkInIcon.leftAnchor.constraint(equalTo: checkInView.leftAnchor, constant: 8).isActive = true
        checkInIcon.centerYAnchor.constraint(equalTo: checkInView.centerYAnchor).isActive = true
        checkInIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkInIcon.widthAnchor.constraint(equalTo: checkInView.heightAnchor).isActive = true
        
        self.view.addSubview(endReservationButton)
        endReservationTopAnchor = endReservationButton.topAnchor.constraint(equalTo: checkInView.topAnchor)
            endReservationTopAnchor.isActive = true
        endReservationLeftAnchor = endReservationButton.leftAnchor.constraint(equalTo: checkInView.leftAnchor)
            endReservationLeftAnchor.isActive = true
        endReservationFullAnchor = endReservationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24)
            endReservationFullAnchor.isActive = false
        endReservationButton.rightAnchor.constraint(equalTo: checkInView.rightAnchor).isActive = true
        endReservationButton.heightAnchor.constraint(equalTo: checkInView.heightAnchor).isActive = true
        
        self.view.addSubview(extendDurationButton)
        extendDurationButton.topAnchor.constraint(equalTo: endReservationButton.bottomAnchor, constant: 8).isActive = true
        extendDurationButton.leftAnchor.constraint(equalTo: endReservationButton.leftAnchor).isActive = true
        extendDurationButton.rightAnchor.constraint(equalTo: endReservationButton.rightAnchor).isActive = true
        extendDurationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

    func setupShimmer() {
        
        self.view.addSubview(shimmerMain)
        shimmerMain.topAnchor.constraint(equalTo: destinationLabel.topAnchor, constant: 4).isActive = true
        shimmerMain.leftAnchor.constraint(equalTo: destinationLabel.leftAnchor).isActive = true
        shimmerMain.rightAnchor.constraint(equalTo: destinationLabel.rightAnchor).isActive = true
        shimmerMain.bottomAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: -4).isActive = true
        
        let shimmerView = UIView()
        shimmerView.backgroundColor = Theme.WHITE
        shimmerView.frame = shimmerMain.frame
        shimmerView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        shimmerMain.addSubview(shimmerView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Theme.OFF_WHITE.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shimmerView.frame
        
        let angle = 45 * CGFloat.pi/180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        shimmerView.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -phoneWidth
        animation.toValue = phoneWidth
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "key")
        
    }
    
    func setupShimmerIcon() {
        
        self.view.addSubview(shimmerIcon)
        shimmerIcon.topAnchor.constraint(equalTo: spotIcon.topAnchor).isActive = true
        shimmerIcon.leftAnchor.constraint(equalTo: spotIcon.leftAnchor).isActive = true
        shimmerIcon.rightAnchor.constraint(equalTo: spotIcon.rightAnchor).isActive = true
        shimmerIcon.bottomAnchor.constraint(equalTo: spotIcon.bottomAnchor).isActive = true
        
        let shimmerView = UIView()
        shimmerView.backgroundColor = Theme.WHITE
        shimmerView.frame = shimmerIcon.frame
        shimmerView.transform = CGAffineTransform(scaleX: 4.0, y: 1.0)
        shimmerIcon.addSubview(shimmerView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Theme.OFF_WHITE.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shimmerView.frame
        
        let angle = 60 * CGFloat.pi/180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        shimmerView.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -phoneWidth
        animation.toValue = phoneWidth
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "key")
        
    }
    
    func resetDuration() {
        let image = UIImage(named: "Green Scene")
        self.spotIcon.image = image
        self.checkInView.alpha = 1
        self.expandButton.alpha = 1
        self.navigationView.alpha = 1
        self.endReservationButton.alpha = 0
        self.extendDurationButton.alpha = 0
    }
    
    func endParkingDuration() {
        self.leaveLabel.text = " "
        UIView.animate(withDuration: animationIn, animations: {
            self.navigationView.alpha = 0
        }) { (success) in
            self.endReservationLeftAnchor.isActive = false
            self.endReservationFullAnchor.isActive = true
            self.endReservationTopAnchor.constant = -35
            self.destinationLabel.text = "Your parking reservation has ended. You will be charged double for overstay fees"
            delayWithSeconds(3.4 + animationIn, completion: {
                UIView.animate(withDuration: animationIn, animations: {
                    self.extendDurationButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    func changeDestinationLabel(text: String) {
        self.destinationLabel.text = text
        self.openTimeLeft()
    }
    
    func openTimeLeft() {
        UIView.animate(withDuration: animationIn, animations: {
            bookingDurationButton.alpha = 0
            self.spotIcon.alpha = 0
        }) { (success) in
            self.leaveLabel.text = "Time left"
            self.destinationShortRightAnchor.isActive = false
            self.destinationLongRightAnchor.isActive = true
            UIView.animate(withDuration: animationIn, animations: {
                self.timerController.view.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func openLeaveAt() {
        self.endReservationLeftAnchor.isActive = true
        self.endReservationFullAnchor.isActive = false
        UIView.animate(withDuration: animationIn, animations: {
            self.timerController.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.leaveLabel.text = "Leave at"
            self.destinationShortRightAnchor.isActive = true
            self.destinationLongRightAnchor.isActive = false
            UIView.animate(withDuration: animationIn, animations: {
                bookingDurationButton.alpha = 1
                self.spotIcon.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func durationButtonPressed() {
        if self.timerController.view.alpha == 1 {
            self.openLeaveAt()
        } else {
            self.openTimeLeft()
        }
    }
    
    func checkInPressed(secondaryType: String) {
        self.checkInView.isUserInteractionEnabled = false
        self.checkInView.alpha = 0.5
        UIView.animate(withDuration: animationIn, animations: {
            self.destinationLabel.alpha = 0
            self.spotIcon.alpha = 0
        }) { (success) in
            self.changeCheckIn(secondaryType: secondaryType)
            UIView.animate(withDuration: animationIn, animations: {
                self.shimmerMain.alpha = 1
                if bookingDurationButton.alpha == 1 {
                    self.shimmerIcon.alpha = 1
                }
            }, completion: { (success) in
                delayWithSeconds(2, completion: {
                    self.hideCheckIn()
                })
            })
        }
    }
    
    func hideCheckIn() {
        UIView.animate(withDuration: animationIn, animations: {
            self.shimmerMain.alpha = 0
            self.shimmerIcon.alpha = 0
            self.checkInView.alpha = 0
        }) { (success) in
            self.checkInView.isUserInteractionEnabled = true
            UIView.animate(withDuration: animationIn, animations: {
                self.destinationLabel.alpha = 1
                self.endReservationButton.alpha = 1
                if bookingDurationButton.alpha == 1 {
                    self.spotIcon.alpha = 1
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func changeCheckIn(secondaryType: String) {
        self.destinationLabel.text = "We will let you know when your parking reservation is ending!"
        if secondaryType == "driveway" {
            let image = UIImage(named: "Residential Home Driveway")
            self.spotIcon.image = image
        } else if secondaryType == "parking lot" {
            let image = UIImage(named: "Parking Lot")
            self.spotIcon.image = image
        } else if secondaryType == "apartment" {
            let image = UIImage(named: "Apartment Parking")
            self.spotIcon.image = image
        } else if secondaryType == "alley" {
            let image = UIImage(named: "Alley Parking")
            self.spotIcon.image = image
        } else if secondaryType == "garage" {
            let image = UIImage(named: "Parking Garage")
            self.spotIcon.image = image
        } else if secondaryType == "gated spot" {
            let image = UIImage(named: "Gated Spot")
            self.spotIcon.image = image
        } else if secondaryType == "street spot" {
            let image = UIImage(named: "Street Parking")
            self.spotIcon.image = image
        } else if secondaryType == "underground spot" {
            let image = UIImage(named: "UnderGround Parking")
            self.spotIcon.image = image
        } else if secondaryType == "condo" {
            let image = UIImage(named: "Residential Home Driveway")
            self.spotIcon.image = image
        } else if secondaryType == "circular" {
            let image = UIImage(named: "Other Parking")
            self.spotIcon.image = image
        }
    }
    
}

