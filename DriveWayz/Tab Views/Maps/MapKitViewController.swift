//
//  MapKitViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/4/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import Firebase
import AFNetworking
import MapKitGoogleStyler
import AVFoundation

var userLocation: CLLocation?
var alreadyLoadedSpots: Bool = false

class MapKitViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, removePurchaseView, controlHoursButton, controlNewHosts, controlSaveLocation, handleEventSelection {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        searchBar.delegate = self
        speechSythensizer.delegate = self
        
        setupViews()
        setupMainBar()
        setupEvents()
        setupNetworkConnection()
        setupAdditionalViews()
        setupViewController()
        setupPurchaseStatus()
        checkNetwork()
        if self.currentActive == false {
            checkCurrentParking()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupLocationManager()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    enum CurrentData {
        case notReserved
        case yesReserved
    }
    var currentData: CurrentData = CurrentData.notReserved
    
    var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsPointsOfInterest = true
        view.showsTraffic = true
        view.showsUserLocation = true
        view.showsScale = true
        view.showsBuildings = true
        view.mapType = .standard
        view.showsCompass = false
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.8249, longitude: -122.4194), latitudinalMeters: 22000, longitudinalMeters: 22000)
        view.setRegion(region, animated: false)
        
        return view
    }()
    
    var mainBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 3
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "locationButton") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var microphoneButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "microphoneButton") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(microphoneButtonPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var searchBar: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Where are you parking?"
        view.font = Fonts.SSPLightH3
        view.clearButtonMode = .whileEditing
        
        return view
    }()
    
    var bottomBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        //        view.layer.cornerRadius = 15
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    var hamburgerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = Theme.BLACK
        view1.layer.cornerRadius = 0.75
        button.addSubview(view1)
        view1.topAnchor.constraint(equalTo: button.topAnchor, constant: 6).isActive = true
        view1.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        view1.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -10).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        let view2 = UIView()
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.backgroundColor = Theme.BLACK
        view2.layer.cornerRadius = 0.75
        button.addSubview(view2)
        view2.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -6).isActive = true
        view2.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        view2.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -10).isActive = true
        view2.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        let view3 = UIView()
        view3.translatesAutoresizingMaskIntoConstraints = false
        view3.backgroundColor = Theme.BLACK
        view3.layer.cornerRadius = 0.75
        button.addSubview(view3)
        view3.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 3).isActive = true
        view3.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        view3.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -14).isActive = true
        view3.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        let view4 = UIView()
        view4.translatesAutoresizingMaskIntoConstraints = false
        view4.backgroundColor = Theme.BLACK
        view4.layer.cornerRadius = 0.75
        button.addSubview(view4)
        view4.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -3).isActive = true
        view4.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        view4.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -14).isActive = true
        view4.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        return button
    }()
    
    var diamondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        
        return view
    }()
    
    var profileButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "hamburgerButton") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = Theme.PURPLE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        label.alpha = 0
        
        return label
    }()
    
    lazy var giftButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "giftIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 12.5, left: 12.5, bottom: 12.5, right: 12.5)
        
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        background.zPosition = -10
        button.layer.addSublayer(background)
        
        return button
    }()
    
    lazy var locationRecentResults: MapRecentViewController = {
        let controller = MapRecentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        controller.view.layer.cornerRadius = 3
        
        return controller
    }()
    
    lazy var locationsSearchResults: MapSearchViewController = {
        let controller = MapSearchViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var resultsScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var eventsController: EventsViewController = {
        let controller = EventsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Events"
        controller.delegate = self
        
        return controller
    }()
    
    lazy var checkEventsController: CheckEventsViewController = {
        let controller = CheckEventsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Check Events"
        
        return controller
    }()
    
    lazy var speechSearchResults: SpeechRecognitionViewController = {
        let controller = SpeechRecognitionViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var purchaseViewController: SelectPurchaseViewController = {
        let controller = SelectPurchaseViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.title = "Purchase Controller"
        controller.delegate = self
        controller.removeDelegate = self
        controller.saveDelegate = self
        
        return controller
    }()
    
    lazy var informationViewController: InformationViewController = {
        let controller = InformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.title = "Information Controller"
        controller.delegate = self
        controller.hostDelegate = self
        controller.navigationDelegate = self
        
        return controller
    }()
    
    lazy var reviewsViewController: LeaveReviewViewController = {
        let controller = LeaveReviewViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.title = "Reviews Controller"
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    lazy var darkBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var purchaseStaus: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("", for: .normal)
        view.titleLabel?.textColor = Theme.WHITE
        view.titleLabel?.font = Fonts.SSPSemiBoldH5
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 2
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        view.alpha = 0
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var swipeLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe up for more info, down to dismiss"
        label.textColor = Theme.WHITE
        label.textAlignment = .center
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.alpha = 0
        
        return label
    }()
    
    var navigationLabel: UITextView = {
        let label = UITextView()
        label.backgroundColor = Theme.WHITE
        label.alpha = 0
        label.text = "Start Navigation"
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = Theme.HARMONY_RED.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 0.8
//        label.textAlignment = .center
        label.clipsToBounds = false
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.contentInset = UIEdgeInsets(top: 36, left: 12, bottom: 24, right: 12)
        
        return label
    }()
    
    var currentParkingController: CurrentParkingViewController = {
        let controller = CurrentParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    var networkConnection: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.HARMONY_RED
        button.setTitle("No network connection currently", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(removeNetworkNotification(sender:)), for: .allTouchEvents)

        return button
    }()
    
    var clearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        view.layer.cornerRadius = 3
        view.alpha = 0
        
        return view
    }()
    
    var searchedForPlace: Bool = false
    var timer: Timer?
    var canChangeLocatorButtonTint: Bool = true
    var destinationString: String = "Arrived at destination"
    var annotationSelected: MKAnnotation?
    var currentActive: Bool = false
    
    var currentCoordinate: CLLocationCoordinate2D?
    var navigationSteps = [MKRoute.Step]()
    let speechSythensizer = AVSpeechSynthesizer()
    var stepCounter = 1
    
    var delegate: moveControllers?
    var vehicleDelegate: controlsAccountOptions?
    
    let locationManager = CLLocationManager()
    let delta = 0.1
    
    var parkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [String: ParkingSpots]()
    var destination: CLLocation?
    
    var mapViewConstraint: NSLayoutConstraint!
    var tabPullWidthShort: NSLayoutConstraint!
    var tabPullWidthLong: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    var purchaseStatusWidthAnchor: NSLayoutConstraint!
    var purchaseStatusHeightAnchor: NSLayoutConstraint!
    var navigationLabelHeight: NSLayoutConstraint!
    var diamondTopAnchor: NSLayoutConstraint!
    var locationRecentHeightAnchor: NSLayoutConstraint!
    var resultsScrollAnchor: NSLayoutConstraint!
    
    var mainBarTopAnchor: NSLayoutConstraint!
    var mainBarWidthAnchor: NSLayoutConstraint!
    var mainBarHeightAnchor: NSLayoutConstraint!
    var mainBarCenterAnchor: NSLayoutConstraint!
    var microphoneRightAnchor: NSLayoutConstraint!
    
    var checkEventsAnchor: NSLayoutConstraint!
    var checkEventsBottomAnchor: NSLayoutConstraint!
    var checkEventsWidthAnchor: NSLayoutConstraint!
    var checkEventsHeightAnchor: NSLayoutConstraint!
    var eventsControllerAnchor: NSLayoutConstraint!
    var eventsHeightAnchor: NSLayoutConstraint!
    var giftBottomAnchor: NSLayoutConstraint!
    var giftOnlyBottomAnchor: NSLayoutConstraint!
    var giftRightAnchor: NSLayoutConstraint!

    var networkTopAnchor: NSLayoutConstraint!
    var purchaseViewAnchor: NSLayoutConstraint!
    var informationViewAnchor: NSLayoutConstraint!
    var hoursButtonAnchor: NSLayoutConstraint!
    var previousEventLocation: CGFloat = 0
    
    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        createToolbar()
    }
    
    func setupAdditionalViews() {
        
        self.view.addSubview(currentButton)
        currentButton.addTarget(self, action: #selector(currentParkingPressed(sender:)), for: .touchUpInside)
        currentButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        currentButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        switch device {
        case .iphone8:
            currentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
            currentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        case .iphoneX:
            currentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
            currentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        }
        
        self.view.addSubview(navigationLabel)
        navigationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        navigationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        navigationLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        navigationLabelHeight = navigationLabel.heightAnchor.constraint(equalToConstant: 90)
            navigationLabelHeight.isActive = true
    
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func sendNewHost() {
        self.vehicleDelegate?.bringNewHostingController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
}

protocol controlSaveLocation {
    func zoomToSearchLocation(address: String)
    func saveUserCurrentLocation()
    func bringRecentView()
    func hideRecentView()
}

protocol handleEventSelection {
    func openSpecificEvent()
    func closeSpecificEvent()
    func eventsControllerHidden()
}



