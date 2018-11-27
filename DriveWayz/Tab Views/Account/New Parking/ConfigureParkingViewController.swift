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

class ConfigureParkingViewController: UIViewController, handleImageDrawing {
    
    var delegate: controlsAccountOptions?
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var whiteBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "What kind of parking is it?"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH2
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = 10
        button.alpha = 1
        button.addTarget(self, action: #selector(moveToNextController(sender:)), for: .touchUpInside)
        button.disclosureButton(baseColor: Theme.WHITE)
        button.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: -90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveBackController(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var imageBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: -90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
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
    
    lazy var scheduleController: ScheduleAvailabilityViewController = {
        let controller = ScheduleAvailabilityViewController()
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
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        containerHeightAnchor = containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            containerHeightAnchor.isActive = true
        
        containerView.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 42).isActive = true
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
    
    func setupOptions() {
        
        self.view.addSubview(nextButton)
        
        containerView.addSubview(startHostingController.view)
        startHostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        startHostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        startHostingController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        startHostingController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(parkingTypeController.view)
        parkingTypeController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        parkingTypeController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        parkingTypeControllerAnchor = parkingTypeController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            parkingTypeControllerAnchor.isActive = true
        parkingTypeController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(parkingOptionsController.view)
        parkingOptionsController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        parkingOptionsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        parkingOptionsControllerAnchor = parkingOptionsController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            parkingOptionsControllerAnchor.isActive = true
        parkingOptionsController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(spotNumberController.view)
        spotNumberController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 10).isActive = true
        spotNumberController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        spotNumberControllerAnchor = spotNumberController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
        spotNumberControllerAnchor.isActive = true
        spotNumberController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(amenitiesController.view)
        amenitiesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
        amenitiesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        amenitiesControllerAnchor = amenitiesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            amenitiesControllerAnchor.isActive = true
        amenitiesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(locationController.view)
        locationController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        locationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
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
        picturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        picturesControllerAnchor = picturesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            picturesControllerAnchor.isActive = true
        picturesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(businessPicturesController.view)
        self.addChild(businessPicturesController)
        businessPicturesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        businessPicturesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        businessPicturesControllerAnchor = businessPicturesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            businessPicturesControllerAnchor.isActive = true
        businessPicturesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
        scheduleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        scheduleControllerAnchor = scheduleController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            scheduleControllerAnchor.isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(timesController.view)
        timesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 25).isActive = true
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
        
        setupCountButtons()
        
    }
    
    var nextButtonWidthAnchor: NSLayoutConstraint!
    
    func setupCountButtons() {
        
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButtonWidthAnchor = nextButton.widthAnchor.constraint(equalToConstant: 120)
            nextButtonWidthAnchor.isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(imageBackButton)
        imageBackButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24).isActive = true
        imageBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageBackButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        imageBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(whiteBlurView)
        self.view.bringSubviewToFront(nextButton)
        whiteBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        whiteBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        whiteBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        whiteBlurView.topAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
        
        nextButton.addSubview(activityIndicatorParkingView)
        activityIndicatorParkingView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        activityIndicatorParkingView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        activityIndicatorParkingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorParkingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func moveToNextController(sender: UIButton) {
        self.view.endEditing(true)
        if self.startHostingController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.startHostingController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.parkingTypeControllerAnchor.constant = 0
                    self.backButton.alpha = 1
                    switch device {
                    case .iphone8:
                        self.containerHeightAnchor.constant = 70
                    case .iphoneX:
                        self.containerHeightAnchor.constant = 80
                    }
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What kind of parking is it?"
            }
        } else if self.parkingTypeControllerAnchor.constant == 0 && self.parkingTypeController.view.alpha == 1 {
            if self.parkingTypeController.parkingType == "parkingLot" {
                self.parkingOptionsController.onlyShowBusinessOptions()
            } else {
                self.parkingOptionsController.onlyShowRegularOptions()
            }
            self.mapController.typeOfParking = self.parkingTypeController.parkingType
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingTypeController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.parkingOptionsControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "More specifically"
                self.checkParkingType()
            }
        } else if self.parkingOptionsControllerAnchor.constant == 0 && self.parkingOptionsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingOptionsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.spotNumberControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Some more spot info"
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
                    self.amenitiesControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the correct amenities"
            }
        } else if self.amenitiesControllerAnchor.constant == 0 && self.amenitiesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.amenitiesController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.locationControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Where is the spot located?"
            }
        } else if self.locationControllerAnchor.constant == 0 && self.locationController.view.alpha == 1 {
            if let address = self.locationController.newHostAddress, let title = self.locationController.streetField.text, let state = self.locationController.stateField.text, let city = self.locationController.cityField.text {
                self.mapController.setupAddressMarker(address: address, title: title)
                self.costsController.configureCustomPricing(state: state, city: city)
            }
            UIView.animate(withDuration: animationIn, animations: {
                self.locationController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.mapControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Please confirm location before continuing"
            }
        } else if self.mapControllerAnchor.constant == 0 && self.mapController.view.alpha == 1 {
            if self.parkingTypeController.parkingType == "parkingLot" {
                self.picturesController.view.alpha = 0
                self.businessPicturesController.view.alpha = 1
            } else {
                self.picturesController.view.alpha = 1
                self.businessPicturesController.view.alpha = 0
            }
            if let lattitude = self.mapController.lattitude, let longitude = self.mapController.longitude {
                self.picturesController.lattitude = lattitude
                self.businessPicturesController.lattitude = lattitude
                self.picturesController.longitude = longitude
                self.businessPicturesController.longitude = longitude
            }
            UIView.animate(withDuration: animationIn, animations: {
                self.mapController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.picturesControllerAnchor.constant = 0
                    self.businessPicturesControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Please upload a picture for each spot"
            }
        } else if (self.picturesControllerAnchor.constant == 0 && self.picturesController.view.alpha == 1) || (self.businessPicturesControllerAnchor.constant == 0 && self.businessPicturesController.view.alpha == 1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.picturesController.view.alpha = 0
                self.businessPicturesController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.scheduleControllerAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "What days are available?"
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.scheduleController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.timesControllerAnchor.constant = 0
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the available times"
                self.timesController.setData(monday: self.scheduleController.monday, tuesday: self.scheduleController.tuesday, wednesday: self.scheduleController.wednesday, thursday: self.scheduleController.thursday, friday: self.scheduleController.friday, saturday: self.scheduleController.saturday, sunday: self.scheduleController.sunday)
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.timesController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.costsControllerAnchor.constant = 0
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the cost for parking"
                self.costsController.removeTutorial()
            }
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.costsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.messageControllerAnchor.constant = 0
                    self.messageController.view.alpha = 1
                    self.nextButtonWidthAnchor.constant = 200
                    self.nextButton.setTitle("Save Parking", for: .normal)
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Write a helpful message"
                self.costsController.removeTutorial()
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            self.saveParkingButtonPressed()
            self.nextButton.setTitle("", for: .normal)
            self.activityIndicatorParkingView.startAnimating()
        }
    }
    
    @objc func moveBackController(sender: UIButton) {
        self.view.endEditing(true)
        if self.parkingTypeControllerAnchor.constant == 0 && self.parkingTypeController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.backButton.alpha = 0
                self.containerHeightAnchor.constant = 120
                self.parkingTypeControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.startHostingController.view.alpha = 1
                })
                self.parkingLabel.text = ""
            }
        } else if self.parkingOptionsControllerAnchor.constant == 0 && self.parkingOptionsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingOptionsControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.parkingTypeController.view.alpha = 1
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
                    self.parkingOptionsController.view.alpha = 1
                })
                self.parkingLabel.text = "More specifically"
            }
        } else if self.amenitiesControllerAnchor.constant == 0 && self.amenitiesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.amenitiesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.spotNumberController.view.alpha = 1
                })
                self.parkingLabel.text = "Some more spot info"
            }
        } else if self.locationControllerAnchor.constant == 0 && self.locationController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.locationControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.amenitiesController.view.alpha = 1
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
                    self.locationController.view.alpha = 1
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
                    self.mapController.view.alpha = 1
                })
                self.parkingLabel.text = "Please confirm location before continuing"
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.scheduleControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    if self.parkingTypeController.parkingType == "parkingLot" {
                        self.picturesController.view.alpha = 0
                        self.businessPicturesController.view.alpha = 1
                    } else {
                        self.picturesController.view.alpha = 1
                        self.businessPicturesController.view.alpha = 0
                    }
                })
                self.parkingLabel.text = "Please upload a picture for each spot"
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.timesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.scheduleControllerAnchor.constant = 0
                    self.scheduleController.view.alpha = 1
                    self.backButton.alpha = 1
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
                    self.timesControllerAnchor.constant = 0
                    self.timesController.view.alpha = 1
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the available times"
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.messageController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.costsControllerAnchor.constant = 0
                    self.costsController.view.alpha = 1
                    self.nextButtonWidthAnchor.constant = 120
                    self.nextButton.setTitle("Next", for: .normal)
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the cost for parking"
                self.costsController.removeTutorial()
            }
        }
    }
    
    func imageDrawSelected() {
        self.parkingLabel.text = "Drag the dots to highlight the parking space"
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.nextButton.alpha = 0
            self.backButton.alpha = 0
            self.whiteBlurView.alpha = 0
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
            self.whiteBlurView.alpha = 1
            self.imageBackButton.alpha = 0
        }
    }
    
    func checkParkingType() {
        if self.parkingTypeController.parkingType == "house" {
            self.spotNumberController.numberOfSpots = 8
        } else if self.parkingTypeController.parkingType == "apartment" {
            self.spotNumberController.numberOfSpots = 8
        } else if self.parkingTypeController.parkingType == "street" {
            self.spotNumberController.numberOfSpots = 3
        } else if self.parkingTypeController.parkingType == "covered" {
            self.spotNumberController.numberOfSpots = 60
        } else if self.parkingTypeController.parkingType == "parkingLot" {
            self.spotNumberController.numberOfSpots = 100
        } else if self.parkingTypeController.parkingType == "alley" {
            self.spotNumberController.numberOfSpots = 3
        } else if self.parkingTypeController.parkingType == "gated" {
            self.spotNumberController.numberOfSpots = 60
        }
    }
    
    func saveParkingButtonPressed() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let storageRef = Storage.storage().reference().child("parking_images").child("\(formattedAddress).jpg")
        if let uploadData = parkingSpotImage!.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if url?.absoluteString != nil {
                        let parkingImageURL = url?.absoluteString
                        let address = formattedAddress as AnyObject
                        let values = ["parkingImageURL": parkingImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        let properties = ["parkingAddress": address, "parkingImageURL": parkingImageURL!, "parkingCity": cityAddress, "parkingDistance": "0", "parkingType": self.parkingTypeController.parkingType, "numberOfSpots": self.spotNumberController.numberField.text!] as [String : AnyObject]
                        self.addParkingWithProperties(properties: properties)
                    } else {
                        print("Error finding image url:", error!)
                        return
                    }
                })
            })
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersRef = ref.child("users").child(uid)
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    private func addParkingWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("parking")
        let childRef = ref.childByAutoId()
        let id = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let userParkingRef = Database.database().reference().child("user-parking")
        let userRef = Database.database().reference().child("users").child(id).child("Parking")
        
        let parkingID = childRef.key
        userParkingRef.updateChildValues([parkingID!: 1])
        userRef.updateChildValues(["parkingID": parkingID!])

        var values = ["parkingID": parkingID!, "id": id, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
        }
        finishAddingParking()
        addOtherProperties(parkingID: parkingID!)
    }
    
    func finishAddingParking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            UIView.animate(withDuration: 1, animations: {
            }, completion: nil)
            
            self.delegate?.hideNewHostingController()
            self.delegate?.bringHostingController()
            self.view.layoutIfNeeded()
            self.activityIndicatorParkingView.stopAnimating()
            self.nextButton.setTitle("Save Parking", for: .normal)
        })
    }
    
    func addOtherProperties(parkingID: String) {
        self.timesController.addParkingWithProperties(parkingID: parkingID)
        self.costsController.addPropertiesToDatabase(parkingID: parkingID)
        self.messageController.addPropertiesToDatabase(parkingID: parkingID)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}











