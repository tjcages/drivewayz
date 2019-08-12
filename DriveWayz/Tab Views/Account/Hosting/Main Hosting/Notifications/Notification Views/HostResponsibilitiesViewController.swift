//
//  HostResponsibilitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostResponsibilitiesViewController: UIViewController {
    
    var delegate: handleHostResponsibilities?
    var counterClockwise: Bool = true
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
//        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
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
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        button.layer.cornerRadius = 15
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var responsibilitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Welcome new host"
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
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.text = "Congrats, your new parking space is listed! Make sure all of you information is up to date and that the space is available for the correct times listed."
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
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 900)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        
        return view
    }()

    var nextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "What you can expect"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var nextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Now that your spot is active, drivers can reserve and book your parking space for given lengths of time as long as it is within your custom availability."
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 6
        
        return label
    }()
    
    var nextImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "notificationVehicle")
        view.image = image
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        
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
        view.isUserInteractionEnabled = false
        
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
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var notificationSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Once your spot is booked, you will receive a notification and you can view the details of the booking."
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 5
        
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
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
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
        label.text = "It is extremely important that your parking space will be open for the times that it is listed for. If a driver books your space and the spot is taken, you may receive a poor review and Drivewayz may reach out to you."
        label.font = Fonts.SSPRegularH5
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
        label.text = "Need your space back some days? Block out days on the calendar or mark it unavailable at any time."
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
        label.textColor = Theme.DARK_GRAY
        label.text = "Have any questions?"
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var questionsSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
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
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var rulesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Rules & Regulations", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(pushRules), for: .touchUpInside)
        
        return button
    }()
    
    var privacyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Privacy policy", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(pushPolicy), for: .touchUpInside)
        
        return button
    }()
    
    var termsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Terms & Conditions", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
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
        
        return button
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var thirdLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
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

        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        
        setupViews()
        setupNext()
        setupNotifications()
        setupAvailability()
        setupQuestions()
        animateCirclesClockwise(counterClockwise: self.counterClockwise)
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1900)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
        
        scrollView.addSubview(firstLine)
        firstLine.topAnchor.constraint(equalTo: notificationSubLabel.bottomAnchor, constant: 24).isActive = true
        firstLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        firstLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
    }
    
    func setupAvailability() {
        
        scrollView.addSubview(availabilityLabel)
        availabilityLabel.topAnchor.constraint(equalTo: notificationSubLabel.bottomAnchor, constant: 48).isActive = true
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
        scrollView.addSubview(rulesButton)
        rulesButton.topAnchor.constraint(equalTo: agreementsView.topAnchor).isActive = true
        rulesButton.leftAnchor.constraint(equalTo: agreementsView.leftAnchor, constant: 72).isActive = true
        rulesButton.rightAnchor.constraint(equalTo: agreementsView.rightAnchor, constant: -72).isActive = true
        rulesButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(privacyButton)
        privacyButton.topAnchor.constraint(equalTo: rulesButton.bottomAnchor).isActive = true
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
        
        agreementsView.addSubview(thirdLine)
        thirdLine.centerYAnchor.constraint(equalTo: rulesButton.bottomAnchor).isActive = true
        thirdLine.leftAnchor.constraint(equalTo: agreementsView.leftAnchor).isActive = true
        thirdLine.rightAnchor.constraint(equalTo: agreementsView.rightAnchor).isActive = true
        thirdLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
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
    
    @objc func pushRules() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "")
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
extension HostResponsibilitiesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -120 {
            self.delegate?.dismissView()
        } else if translation <= -16 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 0
            }
        } else if translation >= 365 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
                self.exitButton.tintColor = Theme.DARK_GRAY
                self.exitButton.layer.borderColor = Theme.DARK_GRAY.cgColor
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 1
                self.exitButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
                self.exitButton.tintColor = Theme.WHITE
                self.exitButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
}
