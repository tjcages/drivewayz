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
}

protocol handleConfigureProcess {
    func moveToNextController()
    func moveBackController()
}

protocol handlePopupTerms {
    func showTerms()
    func hideTerms()
    func finalizeDatabase()
}

class ConfigureParkingViewController: UIViewController, handleImageDrawing {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        switch device {
        case .iphone8:
            let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLACK.withAlphaComponent(0), bottomColor: Theme.BLACK.withAlphaComponent(0.8))
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 72)
            background.zPosition = -10
            view.layer.insertSublayer(background, at: 0)
        case .iphoneX:
            let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLACK.withAlphaComponent(0), bottomColor: Theme.BLACK.withAlphaComponent(0.8))
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
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
        label.font = Fonts.SSPRegularH1
        label.numberOfLines = 2
        label.backgroundColor = UIColor.clear
        label.alpha = 0
        
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.4
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
        button.addTarget(self, action: #selector(imageDrawExited), for: .touchUpInside)
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
        
        return controller
    }()
    
    lazy var mapController: MapParkingViewController = {
        let controller = MapParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    lazy var scheduleController: CalendarViewController = {
        let controller = CalendarViewController()
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
        let background = CAGradientLayer().purpleBlueColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 2)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK, bottomColor: Theme.BLACK.withAlphaComponent(0.92))
        let height = UIApplication.shared.statusBarFrame.height
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + height)
        background.zPosition = -10
        view.layer.addSublayer(background)

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var containerHeightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        containerHeightAnchor = containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            containerHeightAnchor.isActive = true
        
        containerView.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        setupOptions()
    }
    
    var parkingTypeControllerAnchor: NSLayoutConstraint!
    var parkingOptionsControllerAnchor: NSLayoutConstraint!
    var spotNumberControllerAnchor: NSLayoutConstraint!
    var amenitiesControllerAnchor: NSLayoutConstraint!
    var locationControllerAnchor: NSLayoutConstraint!
    var mapControllerAnchor: NSLayoutConstraint!
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
        
        containerView.addSubview(startHostingController.view)
        startHostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        startHostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        startHostingController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        startHostingController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(parkingTypeController.view)
        parkingTypeController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 10).isActive = true
        parkingTypeController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        parkingTypeControllerAnchor = parkingTypeController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            parkingTypeControllerAnchor.isActive = true
        parkingTypeController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(parkingOptionsController.view)
        parkingOptionsController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 10).isActive = true
        parkingOptionsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        parkingOptionsControllerAnchor = parkingOptionsController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            parkingOptionsControllerAnchor.isActive = true
        parkingOptionsController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(spotNumberController.view)
        spotNumberController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 10).isActive = true
        spotNumberController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        spotNumberControllerAnchor = spotNumberController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
        spotNumberControllerAnchor.isActive = true
        spotNumberController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(amenitiesController.view)
        amenitiesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 5).isActive = true
        amenitiesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        amenitiesControllerAnchor = amenitiesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            amenitiesControllerAnchor.isActive = true
        amenitiesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(locationController.view)
        locationController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 10).isActive = true
        locationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        locationControllerAnchor = locationController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            locationControllerAnchor.isActive = true
        locationController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(mapController.view)
        mapController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        mapController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -64).isActive = true
        mapControllerAnchor = mapController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            mapControllerAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(picturesController.view)
        self.addChild(picturesController)
        picturesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        picturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        picturesControllerAnchor = picturesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            picturesControllerAnchor.isActive = true
        picturesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(businessPicturesController.view)
        self.addChild(businessPicturesController)
        businessPicturesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        businessPicturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        businessPicturesControllerAnchor = businessPicturesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            businessPicturesControllerAnchor.isActive = true
        businessPicturesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor).isActive = true
        scheduleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        scheduleControllerAnchor = scheduleController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            scheduleControllerAnchor.isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(timesController.view)
        timesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor).isActive = true
        timesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        timesControllerAnchor = timesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            timesControllerAnchor.isActive = true
        timesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(costsController.view)
        costsController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
        costsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        costsControllerAnchor = costsController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            costsControllerAnchor.isActive = true
        costsController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(messageController.view)
        messageController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
        messageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        messageControllerAnchor = messageController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            messageControllerAnchor.isActive = true
        messageController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(emailController.view)
        emailController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
        emailController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        emailControllerAnchor = emailController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            emailControllerAnchor.isActive = true
        emailController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(confirmController.view)
        confirmController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
        confirmController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        confirmControllerAnchor = confirmController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            confirmControllerAnchor.isActive = true
        confirmController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        setupCountButtons()
        
    }
    
    var progressBarWidthAnchor: NSLayoutConstraint!
    lazy var progress: CGFloat = self.view.frame.width / 12
    
    func setupCountButtons() {
        
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
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
            imageBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26).isActive = true
        case .iphoneX:
            imageBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 38).isActive = true
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
        containerView.bringSubviewToFront(locationController.view)
        progressBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        progressBarWidthAnchor = progressBar.widthAnchor.constraint(equalToConstant: 0)
            progressBarWidthAnchor.isActive = true
        progressBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 84).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func imageDrawSelected() {
        self.parkingLabel.text = "Drag the dots to highlight the parking space"
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.nextButton.alpha = 0
            self.backButton.alpha = 0
            self.exitButton.alpha = 0
            self.darkBlurView.alpha = 0
            self.imageBackButton.alpha = 1
        }
    }
    
    @objc func imageDrawExited() {
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
    
    var popupDim: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var popupContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var popupLabel: UITextView = {
        let label = UITextView()
        label.textColor = Theme.BLACK.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH3
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
        Please select the days your parking space would normally be unavailable throughout the year.
        
        You will always be able to change the specific availability or mark the spot inactive.
        """
        label.isUserInteractionEnabled = false
        label.isEditable = false
        
        return label
    }()
    
    var popupConfirm: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.layer.borderColor = Theme.DARK_GRAY.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        
        return button
    }()
    
    var popupScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()

}

extension ConfigureParkingViewController: handleConfigureProcess {
    
    @objc func moveToNextController() {
        self.view.endEditing(true)
        if self.startHostingController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.startHostingController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 1
                    self.moveDelegate?.hideExitButton()
                    self.parkingTypeControllerAnchor.constant = 0
                    self.parkingLabel.alpha = 1
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    switch device {
                    case .iphone8:
                        self.containerHeightAnchor.constant = 70
                    case .iphoneX:
                        self.containerHeightAnchor.constant = 80
                    }
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
        } else if self.locationControllerAnchor.constant == 0 && self.locationController.view.alpha == 1 {
            if self.locationController.goodToGo == true && self.locationController.streetField.textColor != Theme.WHITE.withAlphaComponent(0.4) && self.locationController.cityField.textColor != Theme.WHITE.withAlphaComponent(0.4) && self.locationController.stateField.textColor != Theme.WHITE.withAlphaComponent(0.4) {
                self.locationController.goodTogo()
                if let address = self.locationController.newHostAddress, let title = self.locationController.streetField.text, let state = self.locationController.stateField.text, let city = self.locationController.cityField.text {
                    self.mapController.setupAddressMarker(address: address, title: title, city: city, state: state)
                    self.costsController.configureCustomPricing(state: state, city: city)
                }
                UIView.animate(withDuration: animationIn, animations: {
                    self.locationController.view.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.progressBarWidthAnchor.constant = self.progress * 6
                        self.mapControllerAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    })
                    self.parkingLabel.text = "Please confirm location"
                }
            } else {
                self.locationController.notGoodToGo()
            }
        } else if self.mapControllerAnchor.constant == 0 && self.mapController.view.alpha == 1 {
            if self.parkingTypeController.parkingType == "parking lot" {
                self.picturesController.view.alpha = 0
                self.businessPicturesController.view.alpha = 1
            } else {
                self.picturesController.view.alpha = 1
                self.businessPicturesController.view.alpha = 0
            }
            if let lattitude = self.mapController.latitude, let longitude = self.mapController.longitude {
                self.picturesController.lattitude = lattitude
                self.businessPicturesController.lattitude = lattitude
                self.picturesController.longitude = longitude
                self.businessPicturesController.longitude = longitude
                let price = self.mapController.dynamicPrice
                self.costsController.dynamicPrice = Double(price)
            }
            UIView.animate(withDuration: animationIn, animations: {
                self.mapController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 7
                    self.picturesControllerAnchor.constant = 0
                    self.businessPicturesControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.picturesController.scrollView.setContentOffset(.zero, animated: false)
                self.businessPicturesController.scrollView.setContentOffset(.zero, animated: false)
                self.parkingLabel.text = "Please upload a picture for each spot"
            }
        } else if (self.picturesControllerAnchor.constant == 0 && self.picturesController.view.alpha == 1) || (self.businessPicturesControllerAnchor.constant == 0 && self.businessPicturesController.view.alpha == 1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.picturesController.view.alpha = 0
                self.businessPicturesController.view.alpha = 0
            }) { (success) in
                self.scheduleController.calendar.setContentOffset(CGPoint(x: 0, y: -40), animated: false)
                self.parkingLabel.text = "What days are available?"
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 8
                    self.scheduleControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    self.showPopup()
                })
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.scheduleController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 9
                    self.timesControllerAnchor.constant = 0
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.timesController.scrollViewParking.setContentOffset(.zero, animated: false)
                self.parkingLabel.text = "Select the available times"
                self.scheduleController.organizeSelectedDays()
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.timesController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 10
                    self.costsControllerAnchor.constant = 0
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Dynamic pricing"
                self.costsController.removeTutorial()
            }
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.costsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 11
                    self.messageControllerAnchor.constant = 0
                    self.messageController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Write a helpful message"
                self.messageController.startMessage()
                self.costsController.removeTutorial()
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.messageController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 12
                    self.emailControllerAnchor.constant = 0
                    self.emailController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Enter your email address"
                self.emailController.startMessage()
            }
        } else if self.emailControllerAnchor.constant == 0 && self.emailController.view.alpha == 1 {
            self.confirmController.checkForPushNotifications()
            UIView.animate(withDuration: animationIn, animations: {
                self.emailController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBar.alpha = 0
                    self.confirmControllerAnchor.constant = 0
                    self.confirmController.view.alpha = 1
                    self.nextButton.alpha = 0
                    self.darkBlurView.alpha = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Save parking"
            }
        } else if self.confirmControllerAnchor.constant == 0 && self.confirmController.view.alpha == 1 {
            self.saveParkingButtonPressed()
            self.nextButton.setTitle("", for: .normal)
            self.activityIndicatorParkingView.startAnimating()
        }
    }
    
    @objc func moveBackController() {
        self.view.endEditing(true)
        if self.parkingTypeControllerAnchor.constant == 0 && self.parkingTypeController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingLabel.alpha = 0
                self.backButton.alpha = 0
                self.exitButton.alpha = 0
                self.containerHeightAnchor.constant = 120
                self.parkingTypeControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 0
                    self.moveDelegate?.bringExitButton()
                    self.startHostingController.view.alpha = 1
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
        } else if self.mapControllerAnchor.constant == 0 && self.mapController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.mapController.removeAllMarkers()
                self.mapControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 5
                    self.locationController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Where is the spot located?"
            }
        } else if (self.picturesControllerAnchor.constant == 0 && self.picturesController.view.alpha == 1) || (self.businessPicturesControllerAnchor.constant == 0 && self.businessPicturesController.view.alpha == 1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.picturesControllerAnchor.constant = self.view.frame.width
                self.businessPicturesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 6
                    self.mapController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Please confirm location"
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.scheduleControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 7
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
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.timesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
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
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.costsControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 9
                    self.timesControllerAnchor.constant = 0
                    self.timesController.view.alpha = 1
                    self.backButton.alpha = 1
                    self.exitButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the available times"
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.messageController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 10
                    self.costsControllerAnchor.constant = 0
                    self.costsController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Dynamic pricing"
                self.costsController.removeTutorial()
            }
        } else if self.emailControllerAnchor.constant == 0 && self.emailController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.emailController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.progressBarWidthAnchor.constant = self.progress * 11
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
                    self.progressBarWidthAnchor.constant = self.progress * 12
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
        
//        self.locationController.streetField.text = ""
//        self.locationController.cityField.text = ""
//        self.locationController.stateField.text = ""
//        self.locationController.zipField.text = ""
//        self.emailController.emailTextField.text = ""
        
        UIView.animate(withDuration: animationIn, animations: {
            self.parkingLabel.alpha = 0
            self.backButton.alpha = 0
            self.exitButton.alpha = 0
            self.containerHeightAnchor.constant = 120
            
            self.parkingTypeControllerAnchor.constant = self.view.frame.width
            self.parkingOptionsControllerAnchor.constant = self.view.frame.width
            self.spotNumberControllerAnchor.constant = self.view.frame.width
            self.amenitiesControllerAnchor.constant = self.view.frame.width
            self.locationControllerAnchor.constant = self.view.frame.width
            self.mapControllerAnchor.constant = self.view.frame.width
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
            self.moveDelegate?.bringExitButton()
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
        self.delegate?.closeAccountView()
        self.delegate?.hideNewHostingController()
        delayWithSeconds(1) {
            self.resetParking()
            delayWithSeconds(0.1, completion: {
                self.delegate?.closeAccountView()
            })
        }
    }
    
}

extension ConfigureParkingViewController: handlePopupTerms {
    
    func showPopup() {
        
        self.view.addSubview(popupDim)
        popupDim.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        popupDim.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        popupDim.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        popupDim.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(popupContainer)
        popupContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        popupContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        popupContainer.bottomAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 12).isActive = true
        popupContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        popupContainer.addSubview(popupLabel)
        popupLabel.leftAnchor.constraint(equalTo: popupContainer.leftAnchor, constant: 12).isActive = true
        popupLabel.rightAnchor.constraint(equalTo: popupContainer.rightAnchor, constant: -12).isActive = true
        popupLabel.topAnchor.constraint(equalTo: popupContainer.topAnchor, constant: 24).isActive = true
        popupLabel.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: -62).isActive = true
        
        popupContainer.addSubview(popupConfirm)
        popupConfirm.leftAnchor.constraint(equalTo: popupContainer.leftAnchor, constant: -1).isActive = true
        popupConfirm.rightAnchor.constraint(equalTo: popupContainer.rightAnchor, constant: 1).isActive = true
        popupConfirm.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: 1).isActive = true
        popupConfirm.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        UIView.animate(withDuration: animationIn) {
            self.popupLabel.alpha = 1
            self.popupDim.alpha = 0.7
            self.popupContainer.alpha = 1
        }
    }
    
    @objc func hidePopup() {
        UIView.animate(withDuration: animationOut, animations: {
            self.popupDim.alpha = 0
            self.popupContainer.alpha = 0
            self.popupScrollView.alpha = 0
        }) { (success) in
            self.hideTerms()
            self.popupDim.removeFromSuperview()
            self.popupContainer.removeFromSuperview()
            self.popupConfirm.removeFromSuperview()
        }
    }
    
    func showTerms() {
        
        self.view.addSubview(popupDim)
        popupDim.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        popupDim.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        popupDim.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        popupDim.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(popupContainer)
        popupContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        popupContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        popupContainer.bottomAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 12).isActive = true
        switch device {
        case .iphone8:
            popupContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        case .iphoneX:
            popupContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 52).isActive = true
        }
        
        self.view.addSubview(popupScrollView)
        popupScrollView.leftAnchor.constraint(equalTo: popupContainer.leftAnchor, constant: 12).isActive = true
        popupScrollView.rightAnchor.constraint(equalTo: popupContainer.rightAnchor).isActive = true
        popupScrollView.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: -62).isActive = true
        popupScrollView.topAnchor.constraint(equalTo: popupContainer.topAnchor).isActive = true
        
        let label1 = agreement
        let label2 = agreement2
        let agreementHeight = agreement.text?.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPRegularH6)
        let agreement2Height = agreement2.text?.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPRegularH6)
        popupScrollView.contentSize = CGSize(width: self.view.frame.width, height: agreementHeight! + agreement2Height!)
        
        popupScrollView.addSubview(label1)
        label1.leftAnchor.constraint(equalTo: popupContainer.leftAnchor, constant: 12).isActive = true
        label1.rightAnchor.constraint(equalTo: popupContainer.rightAnchor, constant: -12).isActive = true
        label1.topAnchor.constraint(equalTo: popupScrollView.topAnchor, constant: 24).isActive = true
        label1.heightAnchor.constraint(equalToConstant: agreementHeight!).isActive = true
        
        popupScrollView.addSubview(label2)
        label2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        label2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        label2.topAnchor.constraint(equalTo: label1.bottomAnchor).isActive = true
        label2.heightAnchor.constraint(equalToConstant: agreement2Height!)
        
        popupContainer.addSubview(popupConfirm)
        popupConfirm.leftAnchor.constraint(equalTo: popupContainer.leftAnchor, constant: -1).isActive = true
        popupConfirm.rightAnchor.constraint(equalTo: popupContainer.rightAnchor, constant: 1).isActive = true
        popupConfirm.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor, constant: 1).isActive = true
        popupConfirm.heightAnchor.constraint(equalToConstant: 63).isActive = true
        
        UIView.animate(withDuration: animationIn) {
            self.popupScrollView.alpha = 1
            self.popupLabel.alpha = 0
            self.popupDim.alpha = 0.7
            self.popupContainer.alpha = 1
        }
    }
    
    @objc func hideTerms() {
        UIView.animate(withDuration: animationOut, animations: {
            self.popupDim.alpha = 0
            self.popupContainer.alpha = 0
            self.popupScrollView.alpha = 0
        }) { (success) in
            self.popupDim.removeFromSuperview()
            self.popupContainer.removeFromSuperview()
            self.popupConfirm.removeFromSuperview()
            self.popupScrollView.removeFromSuperview()
        }
    }
    
}









