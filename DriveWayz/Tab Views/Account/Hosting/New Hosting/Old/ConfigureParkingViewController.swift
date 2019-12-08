//
//  ConfigureParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleImageDrawing {
    func imageDrawSelected()
    func imageDrawExited()
    func setImageCoordinates(latitude: Double, longitude: Double)
}

protocol handleConfigureProcess {
    func moveToNextController()
    func moveBackController()
    
    func notGoodToGo(text: String)
    func goodTogo()
}

protocol handlePopupTerms {
    func moveToTerms()
    func moveToPrivacy()
    func moveToHostPolicies()
    func moveToHostRegulations()
    
    func finalizeDatabase()
    func dismissView()
}

class ConfigureParkingViewController: UIViewController, handleImageDrawing {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    var hostDelegate: handleHostSpaces?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        switch device {
        case .iphone8:
            let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.OFF_WHITE.withAlphaComponent(0.8))
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 92)
            background.zPosition = -10
            view.layer.insertSublayer(background, at: 0)
        case .iphoneX:
            let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.OFF_WHITE.withAlphaComponent(0.8))
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140)
            background.zPosition = -10
            view.layer.insertSublayer(background, at: 0)
        }
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "What kind of parking is it?"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(moveToNextController), for: .touchUpInside)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveBackController), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var imageBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(imageDrawPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var startHostingController: StartHostingViewController = {
        let controller = StartHostingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var parkingTypeController: ParkingTypeViewController = {
        let controller = ParkingTypeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var parkingOptionsController: ParkingOptionsViewController = {
        let controller = ParkingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var spotNumberController: SpotNumberViewController = {
        let controller = SpotNumberViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var amenitiesController: AmenitiesParkingViewController = {
        let controller = AmenitiesParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var locationController: LocationParkingViewController = {
        let controller = LocationParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var mapController: MapParkingViewController = {
        let controller = MapParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var picturesController: SpotPicturesViewController = {
        let controller = SpotPicturesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var businessPicturesController: BusinessPicturesViewController = {
        let controller = BusinessPicturesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var scheduleController: NewCalendarViewController = {
        let controller = NewCalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var timesController: SelectTimesViewController = {
        let controller = SelectTimesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var costsController: PickCostViewController = {
        let controller = PickCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    lazy var messageController: SpotsMessageViewController = {
        let controller = SpotsMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var emailController: RegisterEmailViewController = {
        let controller = RegisterEmailViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var confirmController: ConfirmParkingViewController = {
        let controller = ConfirmParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var progressBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = Theme.OFF_WHITE
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 2))
        let background = CAGradientLayer().customColor(topColor: Theme.LightPink, bottomColor: Theme.STRAWBERRY_PINK)
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 3)
        background.zPosition = -10
        view2.layer.addSublayer(background)
        view.addSubview(view2)
        
        return view
    }()
    
    lazy var progressBarBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        view.alpha = 0
        
        return view
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .right
        button.alpha = 0
        button.addTarget(self, action: #selector(exitNewHost), for: .touchUpInside)
        
        return button
    }()
    
    var validError: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.HARMONY_RED
        button.setTitle("Please enter a valid address", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.titleLabel?.numberOfLines = 2
        button.alpha = 0
        
        return button
    }()
    
    var availableTimesPopup: ConfirmAvailabilityViewController = {
        let controller = ConfirmAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    var calendarPopup: ConfirmCalendarViewController = {
        let controller = ConfirmCalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupViews() {
        
        self.view.addSubview(containerView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: phoneWidth).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        containerView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        
        self.view.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        parkingLabel.sizeToFit()
        
        setupOptions()
    }
    
    var parkingTypeControllerAnchor: NSLayoutConstraint!
    var parkingOptionsControllerAnchor: NSLayoutConstraint!
    var spotNumberControllerAnchor: NSLayoutConstraint!
    var amenitiesControllerAnchor: NSLayoutConstraint!
    var locationControllerAnchor: NSLayoutConstraint!
    var picturesControllerAnchor: NSLayoutConstraint!
    var businessPicturesControllerAnchor: NSLayoutConstraint!
    var scheduleControllerAnchor: NSLayoutConstraint!
    var timesControllerAnchor: NSLayoutConstraint!
    var costsControllerAnchor: NSLayoutConstraint!
    var messageControllerAnchor: NSLayoutConstraint!
    var emailControllerAnchor: NSLayoutConstraint!
    var confirmControllerAnchor: NSLayoutConstraint!
    
    func setupOptions() {
        
        self.view.addSubview(nextButton)
        
        self.view.addSubview(startHostingController.view)
        startHostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        startHostingController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        startHostingController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        startHostingController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        startHostingController.informationButton.addTarget(self, action: #selector(openHostPolicies), for: .touchUpInside)
        startHostingController.backButton.addTarget(self, action: #selector(moveBackController), for: .touchUpInside)
        
        containerView.addSubview(parkingTypeController.view)
        parkingTypeController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        parkingTypeController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        parkingTypeControllerAnchor = parkingTypeController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            parkingTypeControllerAnchor.isActive = true
        parkingTypeController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(parkingOptionsController.view)
        parkingOptionsController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        parkingOptionsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        parkingOptionsControllerAnchor = parkingOptionsController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            parkingOptionsControllerAnchor.isActive = true
        parkingOptionsController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(spotNumberController.view)
        spotNumberController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        spotNumberController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        spotNumberControllerAnchor = spotNumberController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
        spotNumberControllerAnchor.isActive = true
        spotNumberController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(amenitiesController.view)
        amenitiesController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        amenitiesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        amenitiesControllerAnchor = amenitiesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            amenitiesControllerAnchor.isActive = true
        amenitiesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(locationController.view)
        locationController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        locationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        locationControllerAnchor = locationController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            locationControllerAnchor.isActive = true
        locationController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(picturesController.view)
        self.addChild(picturesController)
        picturesController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        picturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        picturesControllerAnchor = picturesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            picturesControllerAnchor.isActive = true
        picturesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(businessPicturesController.view)
        self.addChild(businessPicturesController)
        businessPicturesController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        businessPicturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        businessPicturesControllerAnchor = businessPicturesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            businessPicturesControllerAnchor.isActive = true
        businessPicturesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        scheduleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        scheduleControllerAnchor = scheduleController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            scheduleControllerAnchor.isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(timesController.view)
        timesController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        timesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        timesControllerAnchor = timesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            timesControllerAnchor.isActive = true
        timesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(costsController.view)
        costsController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        costsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        costsControllerAnchor = costsController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            costsControllerAnchor.isActive = true
        costsController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(messageController.view)
        messageController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        messageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        messageControllerAnchor = messageController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            messageControllerAnchor.isActive = true
        messageController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(emailController.view)
        emailController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        emailController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        emailControllerAnchor = emailController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            emailControllerAnchor.isActive = true
        emailController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(confirmController.view)
        confirmController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        confirmController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        confirmControllerAnchor = confirmController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            confirmControllerAnchor.isActive = true
        confirmController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        setupCountButtons()
        
    }
    
    var progressBarWidthAnchor: NSLayoutConstraint!
    lazy var progress: CGFloat = self.view.frame.width / 12
    var nextButtonLeftAnchor: NSLayoutConstraint!
    var nextButtonBottomAnchor: NSLayoutConstraint!
    
    func setupCountButtons() {
        
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        nextButtonLeftAnchor = nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24)
            nextButtonLeftAnchor.isActive = true
        switch device {
        case .iphone8:
            nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                nextButtonBottomAnchor.isActive = true
        case .iphoneX:
            nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80)
                nextButtonBottomAnchor.isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(imageBackButton)
        imageBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        imageBackButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            imageBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            imageBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(darkBlurView)
        self.view.bringSubviewToFront(nextButton)
        darkBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkBlurView.topAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        nextButton.addSubview(activityIndicatorParkingView)
        activityIndicatorParkingView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        activityIndicatorParkingView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        activityIndicatorParkingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorParkingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(progressBar)
        progressBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        progressBar.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        progressBarWidthAnchor = progressBar.widthAnchor.constraint(equalToConstant: 0)
            progressBarWidthAnchor.isActive = true
        
        containerView.addSubview(progressBarBackground)
        containerView.bringSubviewToFront(progressBar)
        containerView.bringSubviewToFront(locationController.view)
        progressBarBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        progressBarBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        progressBarBackground.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor).isActive = true
        progressBarBackground.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        containerView.addSubview(validError)
        validError.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 16).isActive = true
        validError.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        validError.widthAnchor.constraint(equalToConstant: (validError.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPRegularH5))! + 24).isActive = true
        validError.sizeToFit()
        
        self.view.addSubview(availableTimesPopup.view)
        availableTimesPopup.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        availableTimesPopup.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        availableTimesPopup.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        availableTimesPopup.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        availableTimesPopup.popupConfirm.addTarget(self, action: #selector(availableTimesNext), for: .touchUpInside)
        availableTimesPopup.popupBack.addTarget(self, action: #selector(availableTimesBack), for: .touchUpInside)
        
        self.view.addSubview(calendarPopup.view)
        calendarPopup.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        calendarPopup.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        calendarPopup.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        calendarPopup.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        calendarPopup.popupConfirm.addTarget(self, action: #selector(calendarNext), for: .touchUpInside)
        
        self.view.addSubview(dimmingView)
        dimmingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func goodTogo() {
        UIView.animate(withDuration: animationIn) {
            self.validError.alpha = 0
        }
    }
    
    func notGoodToGo(text: String) {
        self.validError.setTitle(text, for: .normal)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.validError.alpha = 1
        }) { (success) in
            delayWithSeconds(2, completion: {
                UIView.animate(withDuration: animationIn) {
                    self.validError.alpha = 0
                }
            })
        }
    }
    
    func imageDrawSelected() {
        self.parkingLabel.text = "Drag the corners to highlight the parking space"
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.nextButton.alpha = 0
            self.exitButton.alpha = 0
            self.darkBlurView.alpha = 0
            self.imageBackButton.alpha = 1
        }
    }
    
    @objc func imageDrawPressed() {
        if self.picturesController.view.alpha == 1 && self.picturesController.drawController.moveDotsController.view.alpha == 1 {
            self.picturesController.drawController.removeHighlight()
        } else if self.businessPicturesController.view.alpha == 1 && self.businessPicturesController.drawController.moveDotsController.view.alpha == 1 {
            self.businessPicturesController.drawController.removeHighlight()
        } else {
            self.parkingLabel.text = "Please upload a picture for each spot"
            self.view.layoutIfNeeded()
            self.picturesController.imageDrawExited()
            self.businessPicturesController.imageDrawExited()
            UIView.animate(withDuration: animationIn) {
                self.nextButton.alpha = 1
                self.backButton.alpha = 1
                self.exitButton.alpha = 1
                self.darkBlurView.alpha = 1
                self.imageBackButton.alpha = 0
            }
        }
    }
    
    func imageDrawExited() {
        self.parkingLabel.text = "Please upload a picture for each spot"
        self.view.layoutIfNeeded()
        self.picturesController.imageDrawExited()
        self.businessPicturesController.imageDrawExited()
        UIView.animate(withDuration: animationIn) {
            self.nextButton.alpha = 1
            self.backButton.alpha = 1
            self.exitButton.alpha = 1
            self.darkBlurView.alpha = 1
            self.imageBackButton.alpha = 0
        }
    }
    
    func checkParkingType() {
        if self.parkingTypeController.parkingType == "residential" {
            self.spotNumberController.numberOfSpots = 8
        } else if self.parkingTypeController.parkingType == "apartment" {
            self.spotNumberController.numberOfSpots = 8
        } else if self.parkingTypeController.parkingType == "street" {
            self.spotNumberController.numberOfSpots = 3
        } else if self.parkingTypeController.parkingType == "covered" {
            self.spotNumberController.numberOfSpots = 60
        } else if self.parkingTypeController.parkingType == "parking lot" {
            self.spotNumberController.numberOfSpots = 100
        } else if self.parkingTypeController.parkingType == "alley" {
            self.spotNumberController.numberOfSpots = 3
        } else if self.parkingTypeController.parkingType == "gated" {
            self.spotNumberController.numberOfSpots = 60
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension ConfigureParkingViewController: handleConfigureProcess {
    
    @objc func moveToNextController() {
        self.view.endEditing(true)
        if self.startHostingController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.startHostingController.view.alpha = 0
                self.startHostingController.backButton.alpha = 0
            }) { (success) in
                self.nextButtonLeftAnchor.constant = phoneWidth/2 + 32
                self.nextButtonBottomAnchor.constant = self.nextButtonBottomAnchor.constant + 20
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 1
                    self.progressBarBackground.alpha = 1
                    self.moveDelegate?.dismissActiveController()
                    self.parkingTypeControllerAnchor.constant = 0
                    self.parkingLabel.alpha = 1
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingTypeController.scrollView.setContentOffset(.zero, animated: false)
                self.parkingLabel.text = "What kind of parking is it?"
            }
        } else if self.parkingTypeControllerAnchor.constant == 0 && self.parkingTypeController.view.alpha == 1 {
            if self.parkingTypeController.parkingType == "parking lot" || self.parkingTypeController.parkingType == "other" {
                self.parkingOptionsController.onlyShowBusinessOptions()
            } else {
                self.parkingOptionsController.onlyShowRegularOptions()
            }
            self.mapController.typeOfParking = self.parkingTypeController.parkingType
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingTypeController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 2
                    self.parkingOptionsControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingOptionsController.scrollView.setContentOffset(.zero, animated: false)
                self.parkingLabel.text = "What kind of parking is it?"
                self.checkParkingType()
            }
        } else if self.parkingOptionsControllerAnchor.constant == 0 && self.parkingOptionsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingOptionsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 3
                    self.spotNumberControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What kind of parking is it?"
                self.checkParkingType()
            }
        } else if self.spotNumberControllerAnchor.constant == 0 && self.spotNumberController.view.alpha == 1 {
            if let number = Int(self.spotNumberController.numberField.text!) {
                self.picturesController.removeAllImages()
                self.picturesController.setupImages(number: number)
            }
            UIView.animate(withDuration: animationIn, animations: {
                self.spotNumberController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 4
                    self.amenitiesControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.amenitiesController.scrollView.setContentOffset(.zero, animated: false)
                self.parkingLabel.text = "Select the correct amenities"
            }
        } else if self.amenitiesControllerAnchor.constant == 0 && self.amenitiesController.view.alpha == 1 {
            if self.amenitiesController.selectedAmenities.count >= 1 {
                UIView.animate(withDuration: animationIn, animations: {
                    self.amenitiesController.view.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBarWidthAnchor.constant = self.progress * 5
                        self.locationControllerAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    })
                    self.locationController.scrollView.setContentOffset(.zero, animated: false)
                    self.parkingLabel.text = "Where is the spot located?"
                }
            } else {
                self.notGoodToGo(text: "Select at least one amenity")
            }
        } else if self.locationControllerAnchor.constant == 0 && self.locationController.view.alpha == 1 {
            let goodToGo = self.locationController.checkIfGood()
            if goodToGo == true  {
                if let address = self.locationController.newHostAddress, let title = self.locationController.streetField.text, let state = self.locationController.stateField.text, let city = self.locationController.cityField.text {
                    self.mapController.setupAddressMarker(address: address, title: title, city: city, state: state)
                    self.costsController.configureCustomPricing(state: state, city: city)
                }
                if self.parkingTypeController.parkingType == "parking lot" {
                    self.picturesController.view.alpha = 0
                    self.businessPicturesController.view.alpha = 1
                } else {
                    self.picturesController.view.alpha = 1
                    self.businessPicturesController.view.alpha = 0
                }
                UIView.animate(withDuration: animationIn, animations: {
                    self.locationController.view.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBarWidthAnchor.constant = self.progress * 6
                        self.picturesControllerAnchor.constant = 0
                        self.businessPicturesControllerAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    })
                    self.picturesController.scrollView.setContentOffset(.zero, animated: false)
                    self.businessPicturesController.scrollView.setContentOffset(.zero, animated: false)
                    self.parkingLabel.text = "Please upload a picture for each spot"
                }
            } else {
                self.notGoodToGo(text: "Please enter a valid address")
            }
        } else if (self.picturesControllerAnchor.constant == 0 && self.picturesController.view.alpha == 1) || (self.businessPicturesControllerAnchor.constant == 0 && self.businessPicturesController.view.alpha == 1) {
            if (self.picturesController.imagesTaken >= self.picturesController.imageNumber) || (self.businessPicturesController.imagesTaken >= self.businessPicturesController.imageNumber) {
                UIView.animate(withDuration: animationIn, animations: {
                    self.picturesController.view.alpha = 0
                    self.businessPicturesController.view.alpha = 0
                }) { (success) in
                    self.scheduleController.calendar.setContentOffset(CGPoint(x: 0, y: -40), animated: false)
                    self.parkingLabel.text = "Select the available times for each day"
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBarWidthAnchor.constant = self.progress * 7
                        self.timesControllerAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        
                    })
                }
            } else {
                var pictures = 1
                if self.picturesControllerAnchor.constant == 0 {
                    pictures = self.picturesController.imageNumber
                } else if self.businessPicturesControllerAnchor.constant == 0 {
                    pictures = self.businessPicturesController.imageNumber
                }
                if pictures == 1 {
                    self.notGoodToGo(text: "Please take at least \(pictures) picture")
                } else {
                    self.notGoodToGo(text: "Please take at least \(pictures) pictures")
                }
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.scheduleController.view.alpha = 0
            }) { (success) in
                self.nextButtonLeftAnchor.constant = 24
                self.nextButtonBottomAnchor.constant = self.nextButtonBottomAnchor.constant - 20
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 8
                    self.costsControllerAnchor.constant = 0
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.timesController.scrollView.setContentOffset(.zero, animated: false)
                self.parkingLabel.text = "Dynamic cost"
                self.scheduleController.organizeSelectedDays()
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            self.checkAvailability()
            UIView.animate(withDuration: animationIn, animations: {
                self.availableTimesPopup.view.alpha = 1
            }) { (success) in
                self.availableTimesPopup.openContainer()
            }
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            if self.costsController.costTextField.text == "" {
                self.costsController.costTextField.text = String(format:"$%.02f", self.costsController.dynamicPrice)
                self.costsController.selectedPrice = self.costsController.dynamicPrice
            }
            if self.costsController.selectedPrice >= self.costsController.minPrice && self.costsController.selectedPrice <= (self.costsController.dynamicPrice * 2) {
                UIView.animate(withDuration: animationIn, animations: {
                    self.costsController.view.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBarWidthAnchor.constant = self.progress * 9
                        self.messageControllerAnchor.constant = 0
                        self.messageController.view.alpha = 1
                        self.view.layoutIfNeeded()
                    })
                    self.parkingLabel.text = "Write a helpful message"
                    self.messageController.startMessage()
                }
            } else {
                self.notGoodToGo(text: "Please select a price within\nthe allowed range")
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            if self.messageController.goodToGo == true {
                UIView.animate(withDuration: animationIn, animations: {
                    self.messageController.view.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBarWidthAnchor.constant = self.progress * 10
                        self.emailControllerAnchor.constant = 0
                        self.emailController.view.alpha = 1
                        self.view.layoutIfNeeded()
                    })
                    self.parkingLabel.text = "Enter your email address"
                    self.emailController.startMessage()
                }
            } else {
                self.notGoodToGo(text: "Please enter a message")
            }
        } else if self.emailControllerAnchor.constant == 0 && self.emailController.view.alpha == 1 {
            if self.emailController.goodToGo == true {
                self.confirmController.checkForPushNotifications()
                UIView.animate(withDuration: animationIn, animations: {
                    self.emailController.view.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBar.alpha = 0
                        self.progressBarBackground.alpha = 0
                        self.confirmControllerAnchor.constant = 0
                        self.confirmController.view.alpha = 1
                        self.nextButton.alpha = 0
                        self.darkBlurView.alpha = 0
                        self.view.layoutIfNeeded()
                    })
                    self.parkingLabel.text = "Save parking"
                }
            } else {
                self.notGoodToGo(text: "Please enter a valid email")
                self.emailController.messageTextView.becomeFirstResponder()
            }
        } else if self.confirmControllerAnchor.constant == 0 && self.confirmController.view.alpha == 1 {
            self.saveParkingButtonPressed()
            self.nextButton.setTitle("", for: .normal)
            self.activityIndicatorParkingView.startAnimating()
        }
    }
    
    @objc func moveBackController() {
        self.view.endEditing(true)
        if self.startHostingController.view.alpha == 1 {
            self.hostDelegate?.closeBackground()
            self.moveDelegate?.dismissActiveController()
            self.dismiss(animated: true, completion: nil)
        } else if self.parkingTypeControllerAnchor.constant == 0 && self.parkingTypeController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingLabel.alpha = 0
                self.exitButton.alpha = 0
                self.parkingTypeControllerAnchor.constant = self.view.frame.width
                self.backButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.nextButtonLeftAnchor.constant = 24
                self.nextButtonBottomAnchor.constant = self.nextButtonBottomAnchor.constant - 20
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 0
                    self.progressBarBackground.alpha = 0
                    self.startHostingController.view.alpha = 1
                    self.startHostingController.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = ""
            }
        } else if self.parkingOptionsControllerAnchor.constant == 0 && self.parkingOptionsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingOptionsControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 1
                    self.parkingTypeController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What kind of parking is it?"
            }
        } else if self.spotNumberControllerAnchor.constant == 0 && self.spotNumberController.view.alpha == 1 {
            self.spotNumberController.dismissKeyboard()
            UIView.animate(withDuration: animationIn, animations: {
                self.spotNumberControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 2
                    self.parkingOptionsController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What kind of parking is it?"
            }
        } else if self.amenitiesControllerAnchor.constant == 0 && self.amenitiesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.amenitiesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 3
                    self.spotNumberController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What kind of parking is it?"
            }
        } else if self.locationControllerAnchor.constant == 0 && self.locationController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.locationControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 4
                    self.amenitiesController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the correct amenities"
            }
        } else if (self.picturesControllerAnchor.constant == 0 && self.picturesController.view.alpha == 1) || (self.businessPicturesControllerAnchor.constant == 0 && self.businessPicturesController.view.alpha == 1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.picturesControllerAnchor.constant = self.view.frame.width
                self.businessPicturesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 5
                    self.locationController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Where is the spot located?"
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.timesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 6
                    if self.parkingTypeController.parkingType == "parking lot" {
                        self.picturesController.view.alpha = 0
                        self.businessPicturesController.view.alpha = 1
                    } else {
                        self.picturesController.view.alpha = 1
                        self.businessPicturesController.view.alpha = 0
                    }
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Please upload a picture for each spot"
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.scheduleControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 7
                    self.timesControllerAnchor.constant = 0
                    self.timesController.view.alpha = 1
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the available times for each day"
            }
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.costsControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                self.nextButtonLeftAnchor.constant = phoneWidth/2 + 32
                self.nextButtonBottomAnchor.constant = self.nextButtonBottomAnchor.constant + 20
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 8
                    self.scheduleControllerAnchor.constant = 0
                    self.scheduleController.view.alpha = 1
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What days are available?"
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.messageController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 9
                    self.costsControllerAnchor.constant = 0
                    self.costsController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Dynamic cost"
            }
        } else if self.emailControllerAnchor.constant == 0 && self.emailController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.emailController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 10
                    self.messageControllerAnchor.constant = 0
                    self.messageController.view.alpha = 1
                    self.nextButton.alpha = 1
                    self.darkBlurView.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Write a helpful message"
            }
        } else if self.confirmControllerAnchor.constant == 0 && self.confirmController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.confirmController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBar.alpha = 1
                    self.progressBarBackground.alpha = 1
                    self.progressBarWidthAnchor.constant = self.progress * 11
                    self.emailControllerAnchor.constant = 0
                    self.emailController.view.alpha = 1
                    self.nextButton.alpha = 1
                    self.darkBlurView.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Enter your email address"
            }
        }
    }
    
    func setImageCoordinates(latitude: Double, longitude: Double) {
        self.picturesController.lattitude = latitude
        self.businessPicturesController.lattitude = latitude
        self.picturesController.longitude = longitude
        self.businessPicturesController.longitude = longitude
    }
    
    @objc func openHostPolicies() {
        let controller = HostRegulationsViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
        UIView.animate(withDuration: animationIn) {
            self.dimmingView.alpha = 0.6
        }
    }
    
    func checkAvailability() {
        let (available, unavailable) = self.timesController.checkAvailability()
        if self.timesController.shouldAskAvailable {
            self.availableTimesPopup.availableDaysLabel.text = available
            self.availableTimesPopup.unavailableDaysLabel.text = unavailable
            self.availableTimesPopup.onlyAvailable()
        } else if self.timesController.shouldAskUnavailable {
            self.availableTimesPopup.availableDaysLabel.text = available
            self.availableTimesPopup.unavailableDaysLabel.text = unavailable
            self.availableTimesPopup.onlyUnavailable()
        } else {
            self.availableTimesPopup.availableDaysLabel.text = available
            self.availableTimesPopup.unavailableDaysLabel.text = unavailable
            self.availableTimesPopup.bothAvailableAndUnavailable()
        }
    }
    
    @objc func availableTimesNext() {
        self.availableTimesPopup.closeContainer()
        UIView.animate(withDuration: animationIn, animations: {
            self.availableTimesPopup.view.alpha = 0
            self.timesController.view.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.progressBarWidthAnchor.constant = self.progress * 9
                self.scheduleControllerAnchor.constant = 0
                self.backButton.alpha = 1
                self.exitButton.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.parkingLabel.text = "What days are available?"
                UIView.animate(withDuration: animationIn, animations: {
                    self.calendarPopup.view.alpha = 1
                }) { (success) in
                    self.calendarPopup.openContainer()
                }
            })
        }
    }
    
    @objc func availableTimesBack() {
        self.availableTimesPopup.closeContainer()
        UIView.animate(withDuration: animationIn) {
            self.availableTimesPopup.view.alpha = 0
        }
    }
    
    @objc func calendarNext() {
        self.calendarPopup.closeContainer()
        UIView.animate(withDuration: animationIn) {
            self.calendarPopup.view.alpha = 0
        }
    }
    
    func resetParking() {
        self.startHostingController.view.alpha = 1
        self.parkingTypeController.view.alpha = 1
        self.parkingOptionsController.view.alpha = 1
        self.spotNumberController.view.alpha = 1
        self.amenitiesController.view.alpha = 1
        self.locationController.view.alpha = 1
        self.mapController.view.alpha = 1
        self.picturesController.view.alpha = 1
        self.businessPicturesController.view.alpha = 1
        self.scheduleController.view.alpha = 1
        self.timesController.view.alpha = 1
        self.costsController.view.alpha = 1
        self.messageController.view.alpha = 1
        self.emailController.view.alpha = 1
        self.confirmController.view.alpha = 1
        
        UIView.animate(withDuration: animationIn, animations: {
            self.parkingLabel.alpha = 0
            self.backButton.alpha = 0
            self.exitButton.alpha = 0
            
            self.parkingTypeControllerAnchor.constant = self.view.frame.width
            self.parkingOptionsControllerAnchor.constant = self.view.frame.width
            self.spotNumberControllerAnchor.constant = self.view.frame.width
            self.amenitiesControllerAnchor.constant = self.view.frame.width
            self.locationControllerAnchor.constant = self.view.frame.width
            self.picturesControllerAnchor.constant = self.view.frame.width
            self.businessPicturesControllerAnchor.constant = self.view.frame.width
            self.scheduleControllerAnchor.constant = self.view.frame.width
            self.timesControllerAnchor.constant = self.view.frame.width
            self.costsControllerAnchor.constant = self.view.frame.width
            self.messageControllerAnchor.constant = self.view.frame.width
            self.emailControllerAnchor.constant = self.view.frame.width
            self.confirmControllerAnchor.constant = self.view.frame.width
        
            self.progressBar.alpha = 1
            self.progressBarWidthAnchor.constant = self.progress * 0
            self.progressBarBackground.alpha = 0
            self.view.layoutIfNeeded()
            self.nextButton.alpha = 1
            self.darkBlurView.alpha = 1
            self.view.layoutIfNeeded()
        })
        self.parkingLabel.text = ""
    }
    
    func finalizeDatabase() {
        self.loadDatabase()
        delayWithSeconds(15) {
            self.resetParking()
        }
    }
    
    @objc func exitNewHost() {
        let alert = UIAlertController(title: "Are you sure you want to exit?", message: "Your information will not be saved.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (success) in
            self.dismiss(animated: true) {
                self.resetParking()
                self.hostDelegate?.closeBackground()
                self.moveDelegate?.dismissActiveController()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

extension ConfigureParkingViewController: handlePopupTerms {
    
    func moveToTerms() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToPrivacy() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostPolicies() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/host-policies.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostRegulations() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/rules--regulations.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func dismissView() {
        UIView.animate(withDuration: animationOut) {
            self.dimmingView.alpha = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}









