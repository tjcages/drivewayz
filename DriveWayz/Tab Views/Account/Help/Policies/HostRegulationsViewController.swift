//
//  HostRegulationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostRegulationsViewController: UIViewController {
    
    var delegate: handlePopupTerms?
    var counterClockwise: Bool = true
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.backgroundColor = Theme.BLACK.withAlphaComponent(0.9)
        button.layer.cornerRadius = 15
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(dismissViews), for: .touchUpInside)
        
        return button
    }()
    
    var responsibilitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Host policies"
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .center
        
        return label
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.LightBlue, bottomColor: Theme.DarkBlue)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 80)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        
        return view
    }()
    
    var responsibilitiesSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "Check out what it means to become a host and know what rules and regulations to be aware of."
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 6
        label.textAlignment = .center
        
        return label
    }()
    
    var parkingGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "hostMainGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var nextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.LightBlue, bottomColor: Theme.DarkBlue)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 2000)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        
        return view
    }()
    
    var nextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "What you should know"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var nextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "To protect our hosts and their properties, Drivewayz does not disclose the full address of the parking spot until a driver has booked the space. Any images will only be available to the driver when the booking is in progress. After the booking has ended all information will again become hidden."
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 12
        
        return label
    }()
    
    var nextImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "notificationVehicle")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var nextGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 38
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        let background = CAGradientLayer().customColor(topColor: Theme.LightRed, bottomColor: Theme.DarkRed)
        background.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var nextFadedGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        //        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/6)
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.7
        let background = CAGradientLayer().customColor(topColor: Theme.LightRed, bottomColor: Theme.DarkRed)
        background.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var notificationSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "As a host, you will recieve a notification when a driver has parked and again when the driver leaves. The driver may decide to extend their parking duration if it is within the spot's availability."
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 8
        
        return label
    }()
    
    var notificationImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-bell-message")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var extendedSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "In some cases the driver may overstay their duration and will be charged double the hourly rate as an overstay fee. Drivewayz will notify you if the overstay exceeds half an hour you will have options for towing the vehicle if necessary."
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 12
        
        return label
    }()
    
    var extendedImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-phone-hand")
        let newImage = resizeImage(image: image!, targetSize: CGSize(width: 240, height: 240))
        view.image = newImage
        view.contentMode = .scaleAspectFit
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return view
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var regulationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Rules and regulations"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var regulationsSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "When deciding whether to become a Drivewayz host, it's important for you to understand how the laws work in your city."
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 4
        
        return label
    }()
    
    var regulations1ImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-magnifier")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var regulations2ImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-document")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var regulations3ImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-folder")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var regulationsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.6)
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    var regulationsSubLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = """
        Some cities have laws that restrict your ability to host paying guests for short periods. These laws are often part of a city's zoning or administrative codes. In many cities, you must register, get a permit, or obtain a license before you list your property or accept guests. Certain types of short-term bookings may be prohibited altogether. Local governments vary greatly in how they enforce these laws. Penalties may include fines or other enforcement.
        
        These rules can be confusing. We're working with governments around the world to clarify these rules so that everyone has a clear understanding of what the laws are.
        
        In some tax jurisdictions, Drivewayz will take care of calculating, collecting, and remitting local occupancy tax on your behalf. Occupancy tax is calculated differently in every jurisdiction, and we’re moving as quickly as possible to extend this benefit to more hosts around the globe.
        
        Please review your local laws before listing your space on Drivewayz. By accepting our Terms of Service and activating a listing, you certify that you will follow your local laws and regulations.
        """
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 38
        
        return label
    }()
    
    var availabilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Check your availability"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var availabilitySubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "It is extremely important that your parking space will be open for the times that it is listed for. If a driver books your space and the spot is taken, you may receive a poor review and Drivewayz could reach out to you."
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 6
        
        return label
    }()
    
    var clockImageView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostFilledClock")
        view.setImage(image, for: .normal)
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 40
        view.isUserInteractionEnabled = false
        //        view.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return view
    }()
    
    var clockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Rent out your parking space whenever it's unused. Adjust your day-to-day availability anytime in-app."
        label.font = Fonts.SSPSemiBoldH6
        label.numberOfLines = 4
        
        return label
    }()
    
    var calendarImageView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostFilledCalendar")
        view.setImage(image, for: .normal)
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 40
        view.isUserInteractionEnabled = false
        //        view.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return view
    }()
    
    var calendarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Need your space back?\nBlock out days on the calendar or mark it unavailable at any time."
        label.font = Fonts.SSPSemiBoldH6
        label.numberOfLines = 4
        
        return label
    }()
    
    var starsImageView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostFilledStars")
        view.setImage(image, for: .normal)
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 40
        view.isUserInteractionEnabled = false
        view.imageEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Receive good reviews from drivers and your spot will promote itself. Higher rated spots generally see higher profits!"
        label.font = Fonts.SSPSemiBoldH6
        label.numberOfLines = 5
        
        return label
    }()
    
    var questionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Have any questions?"
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var questionsSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "Feel free to reach out to Drivewayz with any questions you have or check the resources below."
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 4
        label.textAlignment = .center
        
        return label
    }()
    
    var FAQButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("FAQs", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.cornerRadius = 55/2
        button.addTarget(self, action: #selector(pushFAQ), for: .touchUpInside)
        
        return button
    }()
    
    var agreementsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var privacyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Privacy policy", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(pushPolicy), for: .touchUpInside)
        
        return button
    }()
    
    var termsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Terms & Conditions", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(pushTerms), for: .touchUpInside)
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Let's get started!", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissViews), for: .touchUpInside)
        
        return button
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.clipsToBounds = true
        
        setupViews()
        setupNext()
        setupNotifications()
        setupRegulations()
        setupAvailability()
        setupQuestions()
        animateCirclesClockwise(counterClockwise: self.counterClockwise)
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 2700)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
        
        scrollView.addSubview(container)
        container.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        
        self.view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        scrollView.addSubview(mainView)
        scrollView.addSubview(responsibilitiesLabel)
        responsibilitiesLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 78).isActive = true
        responsibilitiesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        responsibilitiesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        responsibilitiesLabel.sizeToFit()
        
        mainView.centerYAnchor.constraint(equalTo: responsibilitiesLabel.centerYAnchor).isActive = true
        mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: (responsibilitiesLabel.text?.width(withConstrainedHeight: 50, font: Fonts.SSPSemiBoldH1))! + 40).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(responsibilitiesSubLabel)
        responsibilitiesSubLabel.topAnchor.constraint(equalTo: responsibilitiesLabel.bottomAnchor, constant: 24).isActive = true
        responsibilitiesSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        responsibilitiesSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        responsibilitiesSubLabel.sizeToFit()
        
        scrollView.addSubview(parkingGraphic)
        parkingGraphic.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingGraphic.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 3/4).isActive = true
        parkingGraphic.topAnchor.constraint(equalTo: responsibilitiesSubLabel.bottomAnchor, constant: 8).isActive = true
        parkingGraphic.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
    }
    
    func setupNext() {
        
        scrollView.addSubview(nextView)
        nextView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        nextView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        scrollView.addSubview(nextLabel)
        nextLabel.topAnchor.constraint(equalTo: parkingGraphic.bottomAnchor, constant: 48).isActive = true
        nextLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nextLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextLabel.sizeToFit()
        
        scrollView.addSubview(nextSubLabel)
        scrollView.addSubview(nextGradientView)
        nextSubLabel.topAnchor.constraint(equalTo: nextLabel.bottomAnchor, constant: 16).isActive = true
        nextSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nextSubLabel.rightAnchor.constraint(equalTo: nextGradientView.leftAnchor, constant: -8).isActive = true
        nextSubLabel.sizeToFit()
        
        nextGradientView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextGradientView.centerYAnchor.constraint(equalTo: nextSubLabel.centerYAnchor).isActive = true
        nextGradientView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextGradientView.widthAnchor.constraint(equalTo: nextGradientView.heightAnchor).isActive = true
        
        scrollView.addSubview(nextFadedGradientView)
        scrollView.sendSubviewToBack(nextFadedGradientView)
        scrollView.sendSubviewToBack(nextView)
        scrollView.sendSubviewToBack(container)
        nextFadedGradientView.topAnchor.constraint(equalTo: nextGradientView.topAnchor, constant: 0).isActive = true
        nextFadedGradientView.leftAnchor.constraint(equalTo: nextGradientView.leftAnchor, constant: 0).isActive = true
        nextFadedGradientView.rightAnchor.constraint(equalTo: nextGradientView.rightAnchor, constant: 0).isActive = true
        nextFadedGradientView.bottomAnchor.constraint(equalTo: nextGradientView.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(nextImageView)
        nextImageView.topAnchor.constraint(equalTo: nextGradientView.topAnchor, constant: 24).isActive = true
        nextImageView.leftAnchor.constraint(equalTo: nextGradientView.leftAnchor, constant: 24).isActive = true
        nextImageView.rightAnchor.constraint(equalTo: nextGradientView.rightAnchor, constant: -24).isActive = true
        nextImageView.bottomAnchor.constraint(equalTo: nextGradientView.bottomAnchor, constant: -24).isActive = true
        
    }
    
    func setupNotifications() {
        
        scrollView.addSubview(notificationSubLabel)
        scrollView.addSubview(notificationImageView)
        notificationSubLabel.topAnchor.constraint(equalTo: nextSubLabel.bottomAnchor, constant: 32).isActive = true
        notificationSubLabel.leftAnchor.constraint(equalTo: notificationImageView.rightAnchor, constant: 16).isActive = true
        notificationSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        notificationSubLabel.sizeToFit()
        
        notificationImageView.centerYAnchor.constraint(equalTo: notificationSubLabel.centerYAnchor).isActive = true
        notificationImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        notificationImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        notificationImageView.heightAnchor.constraint(equalTo: notificationImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(extendedSubLabel)
        scrollView.addSubview(extendedImageView)
        extendedSubLabel.topAnchor.constraint(equalTo: notificationSubLabel.bottomAnchor, constant: 32).isActive = true
        extendedSubLabel.rightAnchor.constraint(equalTo: extendedImageView.leftAnchor, constant: -16).isActive = true
        extendedSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        extendedSubLabel.sizeToFit()
        
        extendedImageView.centerYAnchor.constraint(equalTo: extendedSubLabel.centerYAnchor).isActive = true
        extendedImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        extendedImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        extendedImageView.heightAnchor.constraint(equalTo: extendedImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(firstLine)
        firstLine.topAnchor.constraint(equalTo: extendedSubLabel.bottomAnchor, constant: 32).isActive = true
        firstLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }
    
    func setupRegulations() {
        
        scrollView.addSubview(regulationsLabel)
        regulationsLabel.topAnchor.constraint(equalTo: firstLine.topAnchor, constant: 24).isActive = true
        regulationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        regulationsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        regulationsLabel.sizeToFit()
        
        scrollView.addSubview(regulationsSubLabel)
        regulationsSubLabel.topAnchor.constraint(equalTo: regulationsLabel.bottomAnchor, constant: 16).isActive = true
        regulationsSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        regulationsSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        regulationsSubLabel.sizeToFit()
        
        scrollView.addSubview(regulationsView)
        scrollView.addSubview(regulations1ImageView)
        scrollView.addSubview(regulations2ImageView)
        scrollView.addSubview(regulations3ImageView)
        
        regulations1ImageView.topAnchor.constraint(equalTo: regulationsSubLabel.bottomAnchor, constant: 32).isActive = true
        regulations1ImageView.rightAnchor.constraint(equalTo: regulations2ImageView.leftAnchor, constant: -48).isActive = true
        regulations1ImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        regulations1ImageView.heightAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        
        regulations2ImageView.topAnchor.constraint(equalTo: regulationsSubLabel.bottomAnchor, constant: 32).isActive = true
        regulations2ImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        regulations2ImageView.widthAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        regulations2ImageView.heightAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        
        regulations3ImageView.topAnchor.constraint(equalTo: regulationsSubLabel.bottomAnchor, constant: 32).isActive = true
        regulations3ImageView.leftAnchor.constraint(equalTo: regulations2ImageView.rightAnchor, constant: 48).isActive = true
        regulations3ImageView.widthAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        regulations3ImageView.heightAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        
        regulationsView.centerYAnchor.constraint(equalTo: regulations1ImageView.centerYAnchor).isActive = true
        regulationsView.leftAnchor.constraint(equalTo: regulations1ImageView.leftAnchor, constant: -24).isActive = true
        regulationsView.rightAnchor.constraint(equalTo: regulations3ImageView.rightAnchor, constant: 24).isActive = true
        regulationsView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(regulationsSubLabel2)
        regulationsSubLabel2.topAnchor.constraint(equalTo: regulationsView.bottomAnchor, constant: 24).isActive = true
        regulationsSubLabel2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        regulationsSubLabel2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        regulationsSubLabel2.sizeToFit()
        
        firstLine.bottomAnchor.constraint(equalTo: regulationsSubLabel2.bottomAnchor, constant: 24).isActive = true
        
    }
    
    func setupAvailability() {
        
        scrollView.addSubview(availabilityLabel)
        availabilityLabel.topAnchor.constraint(equalTo: firstLine.bottomAnchor, constant: 24).isActive = true
        availabilityLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        availabilityLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        availabilityLabel.sizeToFit()
        
        scrollView.addSubview(availabilitySubLabel)
        availabilitySubLabel.topAnchor.constraint(equalTo: availabilityLabel.bottomAnchor, constant: 16).isActive = true
        availabilitySubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        availabilitySubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        availabilitySubLabel.sizeToFit()
        
        scrollView.addSubview(clockImageView)
        clockImageView.topAnchor.constraint(equalTo: availabilitySubLabel.bottomAnchor, constant: 32).isActive = true
        clockImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        clockImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        clockImageView.heightAnchor.constraint(equalTo: clockImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(clockLabel)
        clockLabel.leftAnchor.constraint(equalTo: clockImageView.rightAnchor, constant: 16).isActive = true
        clockLabel.centerYAnchor.constraint(equalTo: clockImageView.centerYAnchor).isActive = true
        clockLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        clockLabel.sizeToFit()
        
        scrollView.addSubview(calendarImageView)
        calendarImageView.topAnchor.constraint(equalTo: clockImageView.bottomAnchor, constant: 24).isActive = true
        calendarImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        calendarImageView.heightAnchor.constraint(equalTo: calendarImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(calendarLabel)
        calendarLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        calendarLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor).isActive = true
        calendarLabel.rightAnchor.constraint(equalTo: calendarImageView.leftAnchor, constant: -16).isActive = true
        calendarLabel.sizeToFit()
        
        scrollView.addSubview(starsImageView)
        starsImageView.topAnchor.constraint(equalTo: calendarImageView.bottomAnchor, constant: 24).isActive = true
        starsImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        starsImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        starsImageView.heightAnchor.constraint(equalTo: starsImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: starsImageView.rightAnchor, constant: 16).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: starsImageView.centerYAnchor).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.sizeToFit()
        
        nextView.topAnchor.constraint(equalTo: nextLabel.topAnchor, constant: -32).isActive = true
        nextView.bottomAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 32).isActive = true
        
    }
    
    func setupQuestions() {
        
        scrollView.addSubview(questionsLabel)
        questionsLabel.topAnchor.constraint(equalTo: nextView.bottomAnchor, constant: 48).isActive = true
        questionsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        questionsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        questionsLabel.sizeToFit()
        
        scrollView.addSubview(questionsSubLabel)
        questionsSubLabel.topAnchor.constraint(equalTo: questionsLabel.bottomAnchor, constant: 16).isActive = true
        questionsSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        questionsSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        questionsSubLabel.sizeToFit()
        
        scrollView.addSubview(FAQButton)
        FAQButton.topAnchor.constraint(equalTo: questionsSubLabel.bottomAnchor, constant: 24).isActive = true
        FAQButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        FAQButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        FAQButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        scrollView.addSubview(agreementsView)
        scrollView.addSubview(privacyButton)
        privacyButton.topAnchor.constraint(equalTo: agreementsView.topAnchor).isActive = true
        privacyButton.leftAnchor.constraint(equalTo: agreementsView.leftAnchor, constant: 72).isActive = true
        privacyButton.rightAnchor.constraint(equalTo: agreementsView.rightAnchor, constant: -72).isActive = true
        privacyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(termsButton)
        termsButton.topAnchor.constraint(equalTo: privacyButton.bottomAnchor).isActive = true
        termsButton.leftAnchor.constraint(equalTo: agreementsView.leftAnchor, constant: 72).isActive = true
        termsButton.rightAnchor.constraint(equalTo: agreementsView.rightAnchor, constant: -72).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        agreementsView.topAnchor.constraint(equalTo: FAQButton.bottomAnchor, constant: 32).isActive = true
        agreementsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        agreementsView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        agreementsView.bottomAnchor.constraint(equalTo: termsButton.bottomAnchor).isActive = true
        
        agreementsView.addSubview(secondLine)
        secondLine.centerYAnchor.constraint(equalTo: privacyButton.bottomAnchor).isActive = true
        secondLine.leftAnchor.constraint(equalTo: agreementsView.leftAnchor).isActive = true
        secondLine.rightAnchor.constraint(equalTo: agreementsView.rightAnchor).isActive = true
        secondLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        scrollView.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: agreementsView.bottomAnchor, constant: 32).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func pushFAQ() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/faqs.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func pushTerms() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func pushPolicy() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func animateCirclesClockwise(counterClockwise: Bool) {
        var multiplier: CGFloat = 1
        if counterClockwise == true {
            self.counterClockwise = false
            multiplier = -1
        } else { self.counterClockwise = true }
        UIView.animate(withDuration: 2, animations: {
            self.nextGradientView.transform = CGAffineTransform(rotationAngle: multiplier * CGFloat.pi/2)
            self.nextFadedGradientView.transform = CGAffineTransform(rotationAngle: -multiplier * CGFloat.pi/4)
        }) { (success) in
            self.animateCirclesClockwise(counterClockwise: self.counterClockwise)
        }
    }
    
}

// Dismiss controller if it's swiped down and change the color of the exit button based on scroll translation
extension HostRegulationsViewController: UIScrollViewDelegate {
    
    @objc func dismissViews() {
        self.delegate?.dismissView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -120 {
            self.dismissViews()
        } else if translation <= -16 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 0
            }
        } else if translation >= 365 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
                self.exitButton.tintColor = Theme.BLACK
                self.exitButton.layer.borderColor = Theme.BLACK.cgColor
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 1
                self.exitButton.backgroundColor = Theme.BLACK.withAlphaComponent(0.9)
                self.exitButton.tintColor = Theme.WHITE
                self.exitButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
