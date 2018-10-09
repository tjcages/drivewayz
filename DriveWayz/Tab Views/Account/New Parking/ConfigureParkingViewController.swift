//
//  ConfigureParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ConfigureParkingViewController: UIViewController {
    
    var delegate: controlsAccountOptions?
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let visualBlurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.alpha = 0.9
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the type of parking:"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    var houseImageView: UIImageView = {
        let image = UIImage(named: "houseIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PRIMARY_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var houseIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Residential parking", for: .normal)
        label.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return label
    }()
    
    var houseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        
        return view
    }()

    var apartmentImageView: UIImageView = {
        let image = UIImage(named: "apartmentIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PRIMARY_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var apartmentIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Apartment parking", for: .normal)
        label.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return label
    }()
    
    var apartmentLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        
        return view
    }()

    
    var lotImageView: UIImageView = {
        let image = UIImage(named: "parkinglotIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PRIMARY_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var lotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Parking lot", for: .normal)
        label.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return label
    }()
    
    var lotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        
        return view
    }()
    
    var numberOfLabel: UILabel = {
        let label = UILabel()
        label.text = "How many spots?"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()

    var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus-1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minus-1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = Theme.BLACK
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.textAlignment = .center
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.addTarget(self, action: #selector(moveToNextController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.addTarget(self, action: #selector(moveBackController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(removeAddNewParking(sender:)), for: .touchUpInside)
        
        return button
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
    

    func setupViews() {
        
        self.view.addSubview(visualBlurEffect)
        visualBlurEffect.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        visualBlurEffect.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        visualBlurEffect.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        visualBlurEffect.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 160).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 34).isActive = true
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupOptions()
    }
    
    var houseHeightAnchor: NSLayoutConstraint!
    var apartmentHeightAnchor: NSLayoutConstraint!
    var lotHeightAnchor: NSLayoutConstraint!
    
    var stepperHouseAnchor: NSLayoutConstraint!
    var stepperApartmentAnchor: NSLayoutConstraint!
    var stepperLotAnchor: NSLayoutConstraint!
    
    var scheduleControllerAnchor: NSLayoutConstraint!
    var timesControllerAnchor: NSLayoutConstraint!
    var costsControllerAnchor: NSLayoutConstraint!
    var messageControllerAnchor: NSLayoutConstraint!
    
    func setupOptions() {
        
        self.view.addSubview(houseImageView)
        houseImageView.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 20).isActive = true
        houseImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 48).isActive = true
        houseImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        houseImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(houseIconLabel)
        houseIconLabel.leftAnchor.constraint(equalTo: houseImageView.rightAnchor, constant: 12).isActive = true
        houseIconLabel.centerYAnchor.constraint(equalTo: houseImageView.centerYAnchor).isActive = true
        houseIconLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        houseIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(houseLine)
        houseLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        houseLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20).isActive = true
        houseHeightAnchor = houseLine.topAnchor.constraint(equalTo: houseIconLabel.bottomAnchor, constant: 5)
            houseHeightAnchor.isActive = true
        houseLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(apartmentImageView)
        apartmentImageView.topAnchor.constraint(equalTo: houseLine.bottomAnchor, constant: 10).isActive = true
        apartmentImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 48).isActive = true
        apartmentImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        apartmentImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(apartmentIconLabel)
        apartmentIconLabel.leftAnchor.constraint(equalTo: apartmentImageView.rightAnchor, constant: 12).isActive = true
        apartmentIconLabel.centerYAnchor.constraint(equalTo: apartmentImageView.centerYAnchor).isActive = true
        apartmentIconLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        apartmentIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(apartmentLine)
        apartmentLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        apartmentLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20).isActive = true
         apartmentHeightAnchor = apartmentLine.topAnchor.constraint(equalTo: apartmentIconLabel.bottomAnchor, constant: 5)
            apartmentHeightAnchor.isActive = true
        apartmentLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(lotImageView)
        lotImageView.topAnchor.constraint(equalTo: apartmentLine.bottomAnchor, constant: 5).isActive = true
        lotImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 43).isActive = true
        lotImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lotImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(lotIconLabel)
        lotIconLabel.leftAnchor.constraint(equalTo: lotImageView.rightAnchor, constant: 12).isActive = true
        lotIconLabel.centerYAnchor.constraint(equalTo: lotImageView.centerYAnchor).isActive = true
        lotIconLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        lotIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(lotLine)
        lotLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        lotLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20).isActive = true
        lotHeightAnchor = lotLine.topAnchor.constraint(equalTo: lotIconLabel.bottomAnchor, constant: 5)
            lotHeightAnchor.isActive = true
        lotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(numberOfLabel)
        numberOfLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stepperHouseAnchor = numberOfLabel.topAnchor.constraint(equalTo: houseIconLabel.bottomAnchor, constant: 20)
        stepperHouseAnchor.isActive = true
        stepperApartmentAnchor = numberOfLabel.topAnchor.constraint(equalTo: apartmentIconLabel.bottomAnchor, constant: 20)
        stepperApartmentAnchor.isActive = false
        stepperLotAnchor = numberOfLabel.topAnchor.constraint(equalTo: lotIconLabel.bottomAnchor, constant: 20)
        stepperLotAnchor.isActive = false
        numberOfLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        numberOfLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(scheduleController.view)
        scheduleController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 15).isActive = true
        scheduleController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        scheduleControllerAnchor = scheduleController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            scheduleControllerAnchor.isActive = true
        scheduleController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(timesController.view)
        timesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 15).isActive = true
        timesController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -80).isActive = true
        timesControllerAnchor = timesController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            timesControllerAnchor.isActive = true
        timesController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(costsController.view)
        costsController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 15).isActive = true
        costsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        costsControllerAnchor = costsController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            costsControllerAnchor.isActive = true
        costsController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(messageController.view)
        messageController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 15).isActive = true
        messageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        messageControllerAnchor = messageController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: self.view.frame.width)
            messageControllerAnchor.isActive = true
        messageController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        setupCountButtons()
        
    }
    
    var nextButtonCenterAnchor: NSLayoutConstraint!
    var nextButtonWidthAnchor: NSLayoutConstraint!
    var nextButtonHeightAnchor: NSLayoutConstraint!
    var nextButtonTopAnchor: NSLayoutConstraint!
    
    func setupCountButtons() {
        
        self.view.addSubview(numberLabel)
        numberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        numberLabel.topAnchor.constraint(equalTo: numberOfLabel.bottomAnchor, constant: 10).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(plusButton)
        plusButton.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor).isActive = true
        plusButton.leftAnchor.constraint(equalTo: numberLabel.rightAnchor, constant: 10).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(minusButton)
        minusButton.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor).isActive = true
        minusButton.rightAnchor.constraint(equalTo: numberLabel.leftAnchor, constant: -10).isActive = true
        minusButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(nextButton)
        nextButtonCenterAnchor = nextButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            nextButtonCenterAnchor.isActive = true
        nextButtonTopAnchor = nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            nextButtonTopAnchor.isActive = true
        nextButtonHeightAnchor = nextButton.heightAnchor.constraint(equalToConstant: 40)
            nextButtonHeightAnchor.isActive = true
        nextButtonWidthAnchor = nextButton.widthAnchor.constraint(equalToConstant: 160)
            nextButtonWidthAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -90).isActive = true
        backButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        nextButton.addSubview(activityIndicatorParkingView)
        activityIndicatorParkingView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        activityIndicatorParkingView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        activityIndicatorParkingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorParkingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    var parkingType: String = "house"
    
    @objc func optionTapped(sender: UIButton) {
        if sender == houseIconLabel {
            self.parkingType = "house"
            self.numberOfSpots = 2
            self.numberLabel.text = "1"
            self.houseHeightAnchor.constant = 105
            self.apartmentHeightAnchor.constant = 5
            self.lotHeightAnchor.constant = 5
            self.stepperHouseAnchor.isActive = true
            self.stepperApartmentAnchor.isActive = false
            self.stepperLotAnchor.isActive = false
            UIView.animate(withDuration: 0.2, animations: {
                self.numberLabel.alpha = 0
                self.plusButton.alpha = 0
                self.minusButton.alpha = 0
                self.numberOfLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.numberLabel.alpha = 1
                    self.plusButton.alpha = 1
                    self.minusButton.alpha = 1
                    self.numberOfLabel.alpha = 1
                    self.nextButton.alpha = 1
                })
            }
        } else if sender == apartmentIconLabel {
            self.parkingType = "apartment"
            self.numberOfSpots = 2
            self.numberLabel.text = "1"
            self.houseHeightAnchor.constant = 5
            self.apartmentHeightAnchor.constant = 105
            self.lotHeightAnchor.constant = 5
            self.stepperHouseAnchor.isActive = false
            self.stepperApartmentAnchor.isActive = true
            self.stepperLotAnchor.isActive = false
            UIView.animate(withDuration: 0.2, animations: {
                self.numberLabel.alpha = 0
                self.plusButton.alpha = 0
                self.minusButton.alpha = 0
                self.numberOfLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.numberLabel.alpha = 1
                    self.plusButton.alpha = 1
                    self.minusButton.alpha = 1
                    self.numberOfLabel.alpha = 1
                    self.nextButton.alpha = 1
                })
            }
        } else if sender == lotIconLabel {
            self.parkingType = "parkingLot"
            self.numberOfSpots = 50
            self.numberLabel.text = "1"
            self.houseHeightAnchor.constant = 5
            self.apartmentHeightAnchor.constant = 5
            self.lotHeightAnchor.constant = 105
            self.stepperHouseAnchor.isActive = false
            self.stepperApartmentAnchor.isActive = false
            self.stepperLotAnchor.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.numberLabel.alpha = 0
                self.plusButton.alpha = 0
                self.minusButton.alpha = 0
                self.numberOfLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.numberLabel.alpha = 1
                    self.plusButton.alpha = 1
                    self.minusButton.alpha = 1
                    self.numberOfLabel.alpha = 1
                    self.nextButton.alpha = 1
                })
            }
        }
    }
    
    var numberOfSpots: Int = 1
    
    @objc func stepperValueChanged(sender: UIButton) {
        if sender == plusButton {
            var int = Int(self.numberLabel.text!)
            if int! < numberOfSpots {
                int = int! + 1
                self.numberLabel.text = "\(int!)"
            }
        } else if sender == minusButton {
            var int = Int(self.numberLabel.text!)
            if int! > 1 {
                int = int! - 1
                self.numberLabel.text = "\(int!)"
            }
        }
    }
    
    @objc func moveToNextController(sender: UIButton) {
        if self.houseIconLabel.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.houseImageView.alpha = 0
                self.houseIconLabel.alpha = 0
                self.houseLine.alpha = 0
                self.apartmentImageView.alpha = 0
                self.apartmentIconLabel.alpha = 0
                self.apartmentLine.alpha = 0
                self.lotImageView.alpha = 0
                self.lotIconLabel.alpha = 0
                self.lotLine.alpha = 0
                self.numberOfLabel.alpha = 0
                self.numberLabel.alpha = 0
                self.plusButton.alpha = 0
                self.minusButton.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.scheduleControllerAnchor.constant = 0
                    self.nextButtonCenterAnchor.constant = 50
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the days of availablility:"
            }
        } else if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.scheduleController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.timesControllerAnchor.constant = 0
                    self.nextButtonCenterAnchor.constant = 50
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the times of availablility:"
                self.timesController.setData(monday: self.scheduleController.monday, tuesday: self.scheduleController.tuesday, wednesday: self.scheduleController.wednesday, thursday: self.scheduleController.thursday, friday: self.scheduleController.friday, saturday: self.scheduleController.saturday, sunday: self.scheduleController.sunday)
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.timesController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.costsControllerAnchor.constant = 0
                    self.nextButtonCenterAnchor.constant = 50
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the cost for parking:"
                self.costsController.removeTutorial()
            }
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.costsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageControllerAnchor.constant = 0
                    self.messageController.view.alpha = 1
                    self.nextButtonCenterAnchor.constant = 0
                    self.nextButtonTopAnchor.constant = -80
                    self.nextButtonHeightAnchor.constant = 50
                    self.nextButtonWidthAnchor.constant = 200
                    self.nextButton.layer.cornerRadius = 25
                    self.nextButton.setTitle("Save Parking", for: .normal)
                    self.nextButton.setTitleColor(Theme.WHITE, for: .normal)
                    self.nextButton.backgroundColor = Theme.PRIMARY_DARK_COLOR
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Write a helpful message:"
                self.costsController.removeTutorial()
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            self.saveParkingButtonPressed()
            self.nextButton.setTitle("", for: .normal)
            self.activityIndicatorParkingView.startAnimating()
        }
    }
    
    @objc func moveBackController(sender: UIButton) {
        if self.scheduleControllerAnchor.constant == 0 && self.scheduleController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.scheduleControllerAnchor.constant = self.view.frame.width
                self.nextButtonCenterAnchor.constant = 0
                self.backButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.houseImageView.alpha = 1
                    self.houseIconLabel.alpha = 1
                    self.houseLine.alpha = 1
                    self.apartmentImageView.alpha = 1
                    self.apartmentIconLabel.alpha = 1
                    self.apartmentLine.alpha = 1
                    self.lotImageView.alpha = 1
                    self.lotIconLabel.alpha = 1
                    self.lotLine.alpha = 1
                    self.numberOfLabel.alpha = 1
                    self.numberLabel.alpha = 1
                    self.plusButton.alpha = 1
                    self.minusButton.alpha = 1
                })
                self.parkingLabel.text = "Select the type of parking:"
            }
        } else if self.timesControllerAnchor.constant == 0 && self.timesController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.timesControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.scheduleControllerAnchor.constant = 0
                    self.scheduleController.view.alpha = 1
                    self.nextButtonCenterAnchor.constant = 50
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the days of availablility:"
            }
        } else if self.costsControllerAnchor.constant == 0 && self.costsController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.costsControllerAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.timesControllerAnchor.constant = 0
                    self.timesController.view.alpha = 1
                    self.nextButtonCenterAnchor.constant = 50
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the times of availablility:"
            }
        } else if self.messageControllerAnchor.constant == 0 && self.messageController.view.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.messageController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.costsControllerAnchor.constant = 0
                    self.costsController.view.alpha = 1
                    self.nextButtonCenterAnchor.constant = 50
                    self.nextButtonTopAnchor.constant = -20
                    self.nextButtonHeightAnchor.constant = 40
                    self.nextButtonWidthAnchor.constant = 160
                    self.nextButton.layer.cornerRadius = 20
                    self.nextButton.setTitle("Next", for: .normal)
                    self.nextButton.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
                    self.nextButton.backgroundColor = UIColor.clear
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.parkingLabel.text = "Select the cost for parking:"
                self.costsController.removeTutorial()
            }
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
                        let values = ["parkingImageURL": parkingImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        let properties = ["parkingAddress": formattedAddress, "parkingImageURL": parkingImageURL!, "parkingCity": cityAddress, "parkingDistance": "0", "parkingType": self.parkingType, "numberOfSpots": self.numberLabel.text] as [String : AnyObject]
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
    
    @objc func removeAddNewParking(sender: UIButton) {
        self.delegate?.hideNewHostingController()
    }

}











