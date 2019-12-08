//
//  HostListingController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/23/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import ViewAnimator

protocol HandleListingDetailViews {
    func changeScrollHeight(height: CGFloat)
    func scrollToView(view: UIView)
    func scrollToTop()
    
    func dimBackground()
    func removeDim()
}

struct MainType {
    var type: String
    var description: String
    var image: UIImage?
    var amenity: UIImage?
}

var mainType: String?
var secondaryType: String?
var selectedAmenities: [String]?

var numberSpots: Int?
var parkingNumber: [Int]?
var gateNumber: Int?

class HostListingController: UIViewController {
    
    var selectedMainRow: Int = -1
    var selectedSecondaryRow: Int = -1
    var selectAmenities: [String] = [] {
        didSet {
            if mainTypeState == .amenities {
                showAmenitiesButton()
                let count = selectAmenities.count
                var text = "\(count) amenities selected"
                if count == 0 {
                    text = "Please select an amenity"
                    amenitiesButton.setTitleColor(Theme.WHITE, for: .normal)
                    amenitiesButton.backgroundColor = Theme.HARMONY_RED
                } else if count == 1 {
                    text = "\(count) amenity selected"
                    amenitiesButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                    amenitiesButton.backgroundColor = Theme.WHITE
                } else {
                    amenitiesButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                    amenitiesButton.backgroundColor = Theme.WHITE
                }
                amenitiesButton.setTitle(text, for: .normal)
                let width = text.width(withConstrainedHeight: 36, font: Fonts.SSPRegularH4)
                amenitiesButtonWidthAnchor.constant = width + 16
                view.layoutIfNeeded()
            }
        }
    }
    
    var onDoneBlock : ((Bool) -> Void)?
    var transform = CGAffineTransform.identity
    
    var options: [MainType] = []
    var potentialOptions: [MainType] = [MainType(type: "Residential", description: "This is our most common parking space. Typically, these are owned or leased properties with a driveway or shared parking lot.", image: UIImage(named: "Residential Home Driveway"), amenity: nil),
                                        MainType(type: "Apartment", description: "These parking spots must be specifically designated for your unit, numbered, and cannot require a parking permit to be parked in.", image: UIImage(named: "Alley Parking"), amenity: nil),
                                        MainType(type: "Business/Parking lot", description: "These parking spots be clearly designated solely for the business signing up or the individual with rights to the parking lot.", image: UIImage(named: "Apartment Parking"), amenity: nil),
                                        MainType(type: "Other", description: "None of the above options. Drivewayz will contact you prior to your parking spot becoming live.", image: UIImage(named: "Parking Garage"), amenity: nil)]
    
    var secondaryOptions: [MainType] = [MainType(type: "Driveway", description: "A short private road that leads to a house or garage which is maintained by an individual or group.", image: UIImage(named: "Residential Home Driveway"), amenity: nil),
                                        MainType(type: "Shared parking lot", description: "A parking space that is owned by the property owner and leased by the tenant. Usually has a spot number.", image: UIImage(named: "Alley Parking"), amenity: nil),
                                        MainType(type: "Shared parking garage", description: "Generally, the parking spot is in a parking garage, but it can also be covered by a patio or deck.", image: UIImage(named: "Apartment Parking"), amenity: nil),
                                        MainType(type: "Alley parking", description: "Only select this option if your parking space is between two buildings or behind a residential home.", image: UIImage(named: "Parking Garage"), amenity: nil),
                                        MainType(type: "Gated spot", description: "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code.", image: UIImage(named: "Apartment Parking"), amenity: nil),
                                        MainType(type: "Street parking", description: "Parking is on the street near a residential home. Spot must be owned or leased and cannot require a permit to park.", image: UIImage(named: "Apartment Parking"), amenity: nil),]
    
    var amenityOptions: [MainType] = [MainType(type: "Covered parking", description: "These spots keep cars out of poor weather or the hot sun.", image: nil, amenity: UIImage(named: "newHostCovered")),
                                      MainType(type: "Charging station", description: "A universal car charger is accessible from the parking spot.", image: nil, amenity: UIImage(named: "newHostCharging")),
                                      MainType(type: "Gated spot", description: "The parking spot is in a gated complex.", image: nil, amenity: UIImage(named: "newHostGate")),
                                      MainType(type: "Wheelchair accessible", description: "The parking spot is handicap accessible and large enough for a mobility van.", image: nil, amenity: UIImage(named: "newHostWheelchair")),
                                      MainType(type: "Stadium parking", description: "The parking spot is within 1 mile of a stadium or event center.", image: nil, amenity: UIImage(named: "newHostStadium")),
                                      MainType(type: "Beach parking", description: "The parking spot is within 5 blocks of a public beach area.", image: nil, amenity: UIImage(named: "newHostBeach")),
                                      MainType(type: "Nighttime parking", description: "The parking spot is available between 9PM to 7AM.", image: nil, amenity: UIImage(named: "newHostNight")),
                                      MainType(type: "Near airport", description: "The parking spot is within 2 miles of an airport.", image: nil, amenity: UIImage(named: "newHostAirport")),
                                      MainType(type: "Lit space", description: "Well-lit parking spots provide an added form of security, especially at night.", image: nil, amenity: UIImage(named: "newHostLight")),
                                      MainType(type: "Large space", description: "These parking spots generally have easy access for a large pickup truck.", image: nil, amenity: UIImage(named: "newHostLarge")),
                                      MainType(type: "Compact space", description: "These parking spots are generally used for compact vehicles.", image: nil, amenity: UIImage(named: "newHostSmall")),
                                      MainType(type: "Easy to find", description: "If your parking space is easily located without any additional instructions.", image: nil, amenity: UIImage(named: "newHostEasy"))]

    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = ""
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 1200
        controller.scrollView.isHidden = true
        
        return controller
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainTypeCell.self, forCellReuseIdentifier: "cellId")
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: abs(cancelBottomHeight * 2), right: 0)
        view.keyboardDismissMode = .interactive
        
        return view
    }()
    
    lazy var amenitiesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 18
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        button.isUserInteractionEnabled = false
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.transform = transform
        button.alpha = 0
        
        return button
    }()

    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var detailsController = ListingDetailsView()
    
    let paging: ProgressPagingDisplay = {
        let view = ProgressPagingDisplay()
        view.changeProgress(index: 0)
        view.alpha = 0
        
        return view
    }()
    
    // Rest of the Host Signup process
    var hostLocationController = HostLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(progressTapped))
        paging.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    @objc func progressTapped() {
        let controller = HostProgressView()
        controller.shouldDismiss = true
        controller.progressController.firstStep()
        present(controller, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        if mainTypeState != .amenities {
            gradientController.animateText(text: "Basic details")
            delayWithSeconds(animationOut) {
                self.gradientController.setSublabel(text: "What kind of parking is this?")
                UIView.animate(withDuration: animationIn) {
                    self.paging.alpha = 1
                    self.dimView.alpha = 0
                    self.view.layoutIfNeeded()
                }
                if self.nextButton.tintColor != Theme.WHITE {
                    self.showNextButton()
                    self.animate()
                }
            }
        } else {
            removeDim()
            showNextButton()
        }
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!
    
    var detailsLeftAnchor: NSLayoutConstraint!
    var amenitiesButtonWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(optionsTableView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.view.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 86).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        optionsTableView.contentSize = CGSize(width: phoneWidth, height: 1200)
        optionsTableView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
        addChild(detailsController)
        detailsController.delegate = self
        optionsTableView.addSubview(detailsController.view)
        detailsController.view.topAnchor.constraint(equalTo: optionsTableView.topAnchor).isActive = true
        detailsController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        detailsLeftAnchor = detailsController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: phoneWidth/2)
            detailsLeftAnchor.isActive = true
        
        transform = transform.scaledBy(x: 0.6, y: 0.6)
        transform = transform.translatedBy(x: 0.0, y: 32.0)
        
        view.addSubview(amenitiesButton)
        amenitiesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amenitiesButton.topAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: 20).isActive = true
        amenitiesButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        amenitiesButtonWidthAnchor = amenitiesButton.widthAnchor.constraint(equalToConstant: 120)
            amenitiesButtonWidthAnchor.isActive = true
        
        view.addSubview(dimView)
        
    }
    
    @objc func nextButtonPressed() {
        view.endEditing(true)
        hideAmenitiesButton()
        nextButton.isUserInteractionEnabled = false
        switch mainTypeState {
        case .main:
            showSecondaryOptions(forward: true)
        case .secondary:
            showNumberOptions(forward: true)
        case .numbers:
            let check = detailsController.checkNumber()
            if check {
                showAmenityOptions()
            } else {
                nextButton.isUserInteractionEnabled = true
            }
        case .amenities:
            nextButton.isUserInteractionEnabled = true
            if selectAmenities.count > 0 {
                transitionToLocation()
            } else {
                selectAmenities.removeAll()
                showAmenitiesButton()
            }
        default:
            nextButton.isUserInteractionEnabled = false
            return
        }
    }
    
    func transitionToLocation() {
        mainTypeState = .location
        hideNextButton(completion: {})
        delayWithSeconds(animationOut + animationIn/2) {
            self.navigationController?.pushViewController(self.hostLocationController, animated: true)
            
            mainType = self.potentialOptions[self.selectedMainRow].type
            secondaryType = self.secondaryOptions[self.selectedSecondaryRow].type
            selectedAmenities = self.selectAmenities
            
            if let text = Int(self.detailsController.numbersView.mainTextView.text) {
                numberSpots = text
            }
            if self.detailsController.spotView.switchButton.isOn {
                parkingNumber = self.detailsController.spotView.spotRange
            }
            if let text = Int(self.detailsController.gateView.mainTextView.text), self.detailsController.gateView.switchButton.isOn {
                gateNumber = text
            }
            if let number = Int(self.detailsController.numbersView.mainTextView.text) {
                self.hostLocationController.picturesController.selectImages = number
            }
        }
    }
    
    func showMainOptions() {
        mainTypeState = .main
        let fromAnimation = AnimationType.from(direction: .right, offset: phoneWidth/2)
        let toAnimation = AnimationType.from(direction: .left, offset: phoneWidth/2)
           
        options.removeAll()
        UIView.animate(views: optionsTableView.visibleCells, animations: [fromAnimation], reversed: true, initialAlpha: 1.0, finalAlpha: 0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
            
            self.options = self.potentialOptions
            self.optionsTableView.reloadData()
            
            UIView.animate(views: self.optionsTableView.visibleCells, animations: [toAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1.0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                self.gradientController.backButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func showSecondaryOptions(forward: Bool) {
        mainTypeState = .secondary
        if forward {
            let fromAnimation = AnimationType.from(direction: .left, offset: phoneWidth/2)
            let toAnimation = AnimationType.from(direction: .right, offset: phoneWidth/2)
               
            options.removeAll()
            UIView.animate(views: optionsTableView.visibleCells, animations: [fromAnimation], reversed: true, initialAlpha: 1.0, finalAlpha: 0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.options = self.secondaryOptions
                self.optionsTableView.reloadData()
                
                if self.selectedSecondaryRow < 0 {
                    let index = IndexPath(row: 0, section: 0)
                    self.optionsTableView.selectRow(at: index, animated: true, scrollPosition: .top)
                    self.tableView(self.optionsTableView, didSelectRowAt: index)
                }
                
                UIView.animate(views: self.optionsTableView.visibleCells, animations: [toAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1.0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                    self.nextButton.isUserInteractionEnabled = true
                }
            }
        } else {
            self.detailsLeftAnchor.constant = phoneWidth/2
            UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.detailsController.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                let toAnimation = AnimationType.from(direction: .left, offset: phoneWidth/2)
                
                self.options = self.secondaryOptions
                self.optionsTableView.reloadData()
                
                self.gradientController.setSublabel(text: "What kind of parking is this?")
                UIView.animate(views: self.optionsTableView.visibleCells, animations: [toAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1.0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                    self.gradientController.backButton.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func showNumberOptions(forward: Bool) {
        mainTypeState = .numbers
        if forward {
            let fromAnimation = AnimationType.from(direction: .left, offset: phoneWidth/2)
               
            gradientController.setSublabel(text: "Spot numbers and gate codes")
            options.removeAll()
            UIView.animate(views: optionsTableView.visibleCells, animations: [fromAnimation], reversed: true, initialAlpha: 1.0, finalAlpha: 0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.optionsTableView.reloadData()
                
                if self.detailsController.numbersView.mainTextView.text == "" {
                    self.detailsController.numbersView.mainTextView.becomeFirstResponder()
                }
                
                self.detailsLeftAnchor.constant = 0
                UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.detailsController.view.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.nextButton.isUserInteractionEnabled = true
                }
            }
        } else {
            let fromAnimation = AnimationType.from(direction: .right, offset: phoneWidth/2)
               
            options.removeAll()
            UIView.animate(views: optionsTableView.visibleCells, animations: [fromAnimation], reversed: true, initialAlpha: 1.0, finalAlpha: 0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                self.optionsTableView.reloadData()
                
                self.gradientController.setSublabel(text: "Spot numbers and gate codes")
                self.detailsLeftAnchor.constant = 0
                UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.detailsController.view.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.gradientController.backButton.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func showAmenityOptions() {
        guard let numbers = Int(detailsController.numbersView.mainTextView.text) else {
            nextButton.isUserInteractionEnabled = true
            return
        }
        let check = detailsController.spotView.collectNumbers(numberz: numbers)
        if check {
            mainTypeState = .amenities
            detailsLeftAnchor.constant = -phoneWidth/2
            gradientController.setSublabel(text: "Select the correct amenities")
            UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.detailsController.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                let toAnimation = AnimationType.from(direction: .right, offset: phoneWidth/2)
                
                self.options = self.amenityOptions
                self.optionsTableView.reloadData()
                
                UIView.animate(views: self.optionsTableView.visibleCells, animations: [toAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1.0, delay: 0, animationInterval: 0, duration: animationOut, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {
                    self.nextButton.isUserInteractionEnabled = true
                }
            }
        } else {
            // Range doesn't match with total number of spots
            UIView.animate(withDuration: animationIn, animations: {
                self.detailsController.bubbleArrow.alpha = 1
            }) { (success) in
                delayWithSeconds(3) {
                    if self.detailsController.bubbleArrow.alpha == 1 {
                        UIView.animate(withDuration: animationIn) {
                            self.detailsController.bubbleArrow.alpha = 0
                        }
                    }
                }
            }
            nextButton.isUserInteractionEnabled = true
        }
    }

    @objc func backButtonPressed() {
        view.endEditing(true)
        hideAmenitiesButton()
        gradientController.backButton.isUserInteractionEnabled = false
        switch mainTypeState {
        case .main:
            dismissController()
        case .secondary:
            showMainOptions()
        case .numbers:
            showSecondaryOptions(forward: false)
        case .amenities:
            showNumberOptions(forward: false)
        default:
            gradientController.backButton.isUserInteractionEnabled = true
            return
        }
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.nextButton.tintColor = Theme.WHITE
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.DARK_GRAY
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.dimBackground()
                completion()
            }
        }
    }
    
    func showAmenitiesButton() {
        UIView.animate(withDuration: animationOut) {
            self.amenitiesButton.alpha = 1
            self.amenitiesButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func hideAmenitiesButton() {
        UIView.animate(withDuration: animationOut) {
            self.amenitiesButton.alpha = 0
            self.amenitiesButton.transform = self.transform
        }
    }
    
    func dismissController() {
        self.dismiss(animated: true) {
            self.onDoneBlock!(true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension HostListingController: HandleListingDetailViews {
    
    func scrollToView(view: UIView) {
        scrollMinimized()
        optionsTableView.scrollToView(view: view, animated: true, offset: 0)
    }
    
    func scrollToTop() {
        optionsTableView.scrollToTop(animated: true)
        scrollExpanded()
    }
    
    func changeScrollHeight(height: CGFloat) {
        optionsTableView.contentSize = CGSize(width: phoneWidth, height: height)
    }
    
    func dimBackground() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0.4
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0
        }
    }
    
}

extension HostListingController: UITableViewDelegate, UITableViewDataSource {

    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let height = keyboardViewEndFrame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            nextButtonBottomAnchor.isActive = true
            nextButtonKeyboardAnchor.isActive = false
//            detailsController.spotView.switchButton.isUserInteractionEnabled = true
        } else {
            nextButtonBottomAnchor.isActive = false
            nextButtonKeyboardAnchor.isActive = true
            nextButtonKeyboardAnchor.constant = -height - 16
//            detailsController.spotView.switchButton.isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mainTypeState == .main {
            if indexPath.row == selectedMainRow {
                return 152
            }
        } else if mainTypeState == .secondary {
            if indexPath.row == selectedSecondaryRow {
                return 132
            }
        }
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MainTypeCell
        cell.selectionStyle = .none
        
        if options.count > indexPath.row {
            cell.option = options[indexPath.row]
        }
        
        if mainTypeState != .amenities {
            cell.moreDetails()
            if indexPath.row == selectedMainRow && mainTypeState == .main {
                cell.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
                cell.setSubLabel()
            } else if indexPath.row == selectedSecondaryRow && mainTypeState == .secondary {
                cell.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
                cell.setSubLabel()
            }
        } else {
            cell.setSubLabel()
            if let text = cell.mainLabel.text {
                if selectAmenities.contains(text) {
                    cell.selectAmenity()
                } else {
                    cell.unselectAmenity()
                }
            } else {
                cell.unselectAmenity()
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainTypeState != .amenities {
            var selectedRow = selectedMainRow
            
            if mainTypeState == .secondary {
                selectedRow = selectedSecondaryRow
            }
            
            if selectedRow != indexPath.row {
                if selectedRow >= 0 && selectedRow < options.count {
                    // Paint the last cell tapped to white again
                    let previousCell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0) as IndexPath) as! MainTypeCell
                    previousCell.backgroundColor = Theme.WHITE
                    previousCell.moreDetails()
                }

                // Save the selected index
                if mainTypeState == .secondary {
                    self.selectedSecondaryRow = indexPath.row
                } else if mainTypeState == .main {
                    self.selectedMainRow = indexPath.row
                }

                // Paint the selected cell to gray
                let cell = tableView.cellForRow(at: indexPath) as! MainTypeCell
                cell.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
                cell.setSubLabel()

                // Update the height for all the cells
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! MainTypeCell
            guard let text = cell.mainLabel.text else { return }
            
            if selectAmenities.contains(text) {
                selectAmenities = selectAmenities.filter { $0 != text }
                cell.unselectAmenity()
            } else {
                selectAmenities.append(text)
                cell.selectAmenity()
            }
            // Update the height for all the cells
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func animate() {
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 72)
        
        options = potentialOptions
        optionsTableView.reloadData()

        let index = IndexPath(row: 0, section: 0)
        self.optionsTableView.selectRow(at: index, animated: true, scrollPosition: .top)
        self.tableView(self.optionsTableView, didSelectRowAt: index)
        
        UIView.animate(views: optionsTableView.visibleCells, animations: [fromAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1.0, delay: 0, animationInterval: 0, duration: animationOut * 3, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut) {

        }
    }
    
}

extension HostListingController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight - (gradientController.gradientNewHeight - gradientHeight + 60) * percent
                gradientController.subLabelBottom.constant = gradientController.subHeight * percent
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    gradientController.subLabel.alpha = 1 - 1 * percentage
                    paging.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    gradientController.subLabel.alpha = 0
                    paging.alpha = 0
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientController.gradientNewHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        gradientController.subLabelBottom.constant = 0
        gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.subLabel.alpha = 1
            self.paging.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.subLabelBottom.constant = gradientController.subHeight
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.gradientController.subLabel.alpha = 0
            self.paging.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
