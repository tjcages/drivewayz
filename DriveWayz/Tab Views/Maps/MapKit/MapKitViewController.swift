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
import AVFoundation
import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

var userLocation: CLLocation?
var alreadyLoadedSpots: Bool = false

class MapKitViewController: UIViewController, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, controlNewHosts, controlSaveLocation, handleEventSelection {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        searchBar.delegate = self
        fromSearchBar.delegate = self
        speechSythensizer.delegate = self
        
        setupViews()
        setupMainBar()
        setupParking()
        setupNetworkConnection()
        setupAdditionalViews()
        setupViewController()
        setupPurchaseStatus()
        setupCurrent()
        checkDayTimeStatus()
        checkNetwork()
        if self.currentActive == false {
//            checkCurrentParking()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupLocationManager()
    }
    
    //Prime location, Best price, Reserve spot
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    enum CurrentData {
        case notReserved
        case yesReserved
    }
    var currentData: CurrentData = CurrentData.notReserved
    
    lazy var mapView: MGLMapView = {
        let view = MGLMapView(frame: self.view.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        view.showsScale = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.userTrackingMode = .followWithHeading
        view.logoView.isHidden = true
        view.attributionButton.isHidden = true
        
        return view
    }()
    
    var mainBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 3
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    var mainBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "locator") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 25
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var polyRouteLocatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "locator") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var locatorArrow: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "locationArrow")
        button.setImage(image, for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.8
        button.isUserInteractionEnabled = false
        
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
        view.text = "Where are you headed?"
        view.textColor = Theme.BLACK.withAlphaComponent(0.4)
        view.font = Fonts.SSPRegularH3
        view.clearButtonMode = .never
        
        return view
    }()
    
    var fromSearchBar: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Current location"
        view.textColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.8)
        view.font = Fonts.SSPRegularH3
        view.clearButtonMode = .never
        view.alpha = 0
        
        return view
    }()
    
    var searchLocation: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var fromSearchIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0.7
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var fromSearchLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        
        return view
    }()
    
    var fromSearchLocation: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "locator")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchLocationPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var currentSpotController: CurrentSpotViewController = {
        let controller = CurrentSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var currentTopAnchor: NSLayoutConstraint!
    var currentHeightAnchor: NSLayoutConstraint!
    var previousHeightAnchor: CGFloat = 380
    
    var couponView: ActiveCouponViewController = {
        let controller = ActiveCouponViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var loadingParkingLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var loadingParkingLeftAnchor: NSLayoutConstraint!
    var loadingParkingRightAnchor: NSLayoutConstraint!
    var loadingParkingWidthAnchor: NSLayoutConstraint!
    var shouldBeLoading: Bool = false
    
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
    
    lazy var giftButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let origImage = UIImage(named: "giftIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 12.5, left: 12.5, bottom: 12.5, right: 12.5)
        
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        background.zPosition = -10
        button.layer.addSublayer(background)
        view.addSubview(button)
        
        return view
    }()
    
    lazy var locationsSearchResults: MapSearchViewController = {
        let controller = MapSearchViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
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
    
    lazy var parkingController: ParkingViewController = {
        let controller = ParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Parking"
        controller.delegate = self
        controller.navigationDelegate = self
        controller.locatorDelegate = self
        controller.parkingDelegate = self
        
        return controller
    }()
    
    lazy var purchaseController: PurchaseSpotViewController = {
        let controller = PurchaseSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Purchase"
        controller.delegate = self
        
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
//        controller.delegate = self
        controller.saveDelegate = self
        
        return controller
    }()
    
    lazy var informationViewController: InformationViewController = {
        let controller = InformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.title = "Information Controller"
        controller.hostDelegate = self
//        controller.navigationDelegate = self
        
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
    
    var searchBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchBackButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var parkingBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        
        return button
    }()
    
    lazy var quickDestinationController: QuickDestinationViewController = {
        let controller = QuickDestinationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Destination"
        
        return controller
    }()
    
    var navigationRouteController: NavigationViewController?
    
    var searchedForPlace: Bool = false
    var timer: Timer?
    var canChangeLocatorButtonTint: Bool = true
    var destinationString: String = "Arrived at destination"
    var annotationSelected: MGLAnnotation?
    var currentActive: Bool = false
    var shouldShowOverlay: Bool = false
    
    var currentCoordinate: CLLocationCoordinate2D?
    var navigationSteps = [CLLocationCoordinate2D]()
    let speechSythensizer = AVSpeechSynthesizer()
    var stepCounter = 1
    
    var delegate: moveControllers?
    var vehicleDelegate: controlsAccountOptions?
    
    let locationManager = CLLocationManager()
    let delta = 0.1
    var mapChangedFromUserInteraction = true
    var changeUserInteractionTimer = Timer()
    var changeLocationCounter: Int = 0
    
    var parkingSpots = [ParkingSpots]()
    var closeParkingSpots = [ParkingSpots]()
    var cheapestParkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [String: ParkingSpots]()
    var visibleAnnotationsDistance: [Double] = []
    var visibleAnnotations: [MGLPointAnnotation] = []
    var destination: CLLocation?
    
    var mapViewConstraint: NSLayoutConstraint!
    var tabPullWidthShort: NSLayoutConstraint!
    var tabPullWidthLong: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    var purchaseStatusWidthAnchor: NSLayoutConstraint!
    var purchaseStatusHeightAnchor: NSLayoutConstraint!
    var navigationLabelHeight: NSLayoutConstraint!
    var diamondTopAnchor: NSLayoutConstraint!
    var locationResultsHeightAnchor: NSLayoutConstraint!
    
    var mainBarTopAnchor: NSLayoutConstraint!
    var mainBarWidthAnchor: NSLayoutConstraint!
    var mainBarHeightAnchor: NSLayoutConstraint!
    var searchBarBottomAnchor: NSLayoutConstraint!
    var searchBarLeftAnchor: NSLayoutConstraint!
    var microphoneRightAnchor: NSLayoutConstraint!
    var fromSeachTopAnchor: NSLayoutConstraint!
    
    var checkEventsAnchor: NSLayoutConstraint!
    var checkEventsBottomAnchor: NSLayoutConstraint!
    var checkEventsWidthAnchor: NSLayoutConstraint!
    var checkEventsHeightAnchor: NSLayoutConstraint!
    var eventsControllerAnchor: NSLayoutConstraint!
    var eventsHeightAnchor: NSLayoutConstraint!
    var giftBottomAnchor: NSLayoutConstraint!
    var giftOnlyBottomAnchor: NSLayoutConstraint!
    var giftRightAnchor: NSLayoutConstraint!
    
    var parkingBackButtonBookAnchor: NSLayoutConstraint!
    var parkingBackButtonPurchaseAnchor: NSLayoutConstraint!
    
    var mapViewBottomAnchor: NSLayoutConstraint!
    var mapViewTopAnchor: NSLayoutConstraint!
    var parkingControllerBottomAnchor: NSLayoutConstraint!
    var purchaseControllerBottomAnchor: NSLayoutConstraint!
    var purchaseControllerHeightAnchor: NSLayoutConstraint!
    var shouldFlipGradient: Bool = false

    var networkTopAnchor: NSLayoutConstraint!
    var purchaseViewAnchor: NSLayoutConstraint!
    var informationViewAnchor: NSLayoutConstraint!
    var hoursButtonAnchor: NSLayoutConstraint!
    var previousEventLocation: CGFloat = 0
    
    ///////////////////////////////MAPBOX///////////////////////////////
    var polylineFirstTimer: Timer?
    var polylineSecondTimer: Timer?
    var polylineSource: MGLShapeSource?
    var polylineSecondSource: MGLShapeSource?
    var navigationRegionSource: MGLShapeSource?
    var polylineLayer: MGLLineStyleLayer?
    var polylineSecondLayer: MGLLineStyleLayer?
    var currentFirstIndex = 1
    var currentSecondIndex = 1
    var destinationCoordinates: [CLLocationCoordinate2D] = []
    var parkingCoordinates: [CLLocationCoordinate2D] = []
    
    var firstParkingRoute: Route?
    var secondParkingRoute: Route?
    var thirdParkingRoute: Route?
    var firstPolyline: MGLPolyline?
    var secondPolyline: MGLPolyline?
    var thirdPolyline: MGLPolyline?
    var destinationFirstCoordinates: [CLLocationCoordinate2D] = []
    var destinationSecondCoordinates: [CLLocationCoordinate2D] = []
    var destinationThirdCoordinates: [CLLocationCoordinate2D] = []
    var firstMapView: MGLCoordinateBounds?
    var secondMapView: MGLCoordinateBounds?
    var thirdMapView: MGLCoordinateBounds?
    var firstPurchaseMapView: MGLCoordinateBounds?
    var secondPurchaseMapView: MGLCoordinateBounds?
    var thirdPurchaseMapView: MGLCoordinateBounds?
    
    var quickDestinationRightAnchor: NSLayoutConstraint!
    var quickDestinationTopAnchor: NSLayoutConstraint!
    var navigationTopAnchor: NSLayoutConstraint!
    ///////////////////////////////////////////////////////////////////
    
    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapViewTopAnchor = mapView.topAnchor.constraint(equalTo: self.view.topAnchor)
            mapViewTopAnchor.isActive = true
        mapViewBottomAnchor = mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            mapViewBottomAnchor.isActive = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.8249, longitude: -122.4194), animated: false)
        mapView.userTrackingMode = .follow
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mapDragged(sender:)))
        pan.delegate = self
        mapView.addGestureRecognizer(pan)
        
        createToolbar()
    }
    
    func setupAdditionalViews() {
        
        self.view.addSubview(navigationLabel)
        navigationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        navigationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        navigationLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        navigationLabelHeight = navigationLabel.heightAnchor.constraint(equalToConstant: 90)
            navigationLabelHeight.isActive = true
    
    }
    
    func checkDayTimeStatus() {
        switch solar {
        case .day:
            let url = URL(string: "mapbox://styles/mapbox/streets-v11")
            self.mapView.styleURL = url
            hamburgerView1.backgroundColor = Theme.BLACK
            hamburgerView2.backgroundColor = Theme.BLACK
            hamburgerView3.backgroundColor = Theme.BLACK
            self.parkingBackButton.tintColor = Theme.BLACK
            self.mainBar.backgroundColor = Theme.WHITE
            self.mainBarView.backgroundColor = Theme.WHITE
            self.locationsSearchResults.tableView.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        case .night:
//            let url = URL(string: "mapbox://styles/tcagle717/cjqdiaqzof9gp2sr4ulfgug3j")
//            self.mapView.styleURL = url
//            hamburgerView1.backgroundColor = Theme.OFF_WHITE
//            hamburgerView2.backgroundColor = Theme.OFF_WHITE
//            hamburgerView3.backgroundColor = Theme.OFF_WHITE
//            self.parkingBackButton.tintColor = Theme.OFF_WHITE
//            self.mainBar.backgroundColor = Theme.OFF_WHITE
//            self.mainBarView.backgroundColor = Theme.OFF_WHITE
//            self.locationsSearchResults.tableView.backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
            
            let url = URL(string: "mapbox://styles/mapbox/streets-v11")
            self.mapView.styleURL = url
            hamburgerView1.backgroundColor = Theme.BLACK
            hamburgerView2.backgroundColor = Theme.BLACK
            hamburgerView3.backgroundColor = Theme.BLACK
            self.parkingBackButton.tintColor = Theme.BLACK
            self.mainBar.backgroundColor = Theme.WHITE
            self.mainBarView.backgroundColor = Theme.WHITE
            self.locationsSearchResults.tableView.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.hideSearchBar(regular: true)
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
}

protocol handleEventSelection {
    func openSpecificEvent()
    func closeSpecificEvent()
    func eventsControllerHidden()
    func zoomToSearchLocation(address: String)
}



