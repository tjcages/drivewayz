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

//var userLocation: CLLocation?
var hasLoadedMapView: Bool = false

class MapKitViewController: UIViewController, UISearchBarDelegate, controlNewHosts, controlSaveLocation, handleEventSelection {
    
    var mainViewState: MainViewState = .none {
        didSet {
            self.reloadRequestedViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        monitorSurge()
        observeAllParking()
        observeCurrentParking()
        setupController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.hasLoaded == false {
            self.hasLoaded = true
            self.setupLocationManager()
        }
    }
    
    func setupController() {
        if !hasLoadedMapView {
            hasLoadedMapView = true
            
            setupViews()
            setupDimmingViews()
            setupMainViews()
            setupMapButtons()
            setupSearch()
            setupLocator()
            
            setupCurrentViews()
            setupUserMessages()
            setupCoupons()
            setupNetworkConnection()
            DynamicPricing.readCityCSV()
            
            if BookedState == .currentlyBooked && mainViewState != .currentBooking {
                mainViewState = .currentBooking
//                return
            } else if BookedState == .reserved && mainViewState != .duration { // NEED TO CHANGE TO RESERVATION
                mainViewState = .mainBar
//                return
            } else if BookedState == .none && mainViewState != .mainBar {
                mainViewState = .mainBar
//                return
            }
            
            reloadRequestedViews()
            observeUserDrivewayzMessages()
        }
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var mapBoxRoute: Route? {
        didSet {
//            delayWithSeconds(1) {
//                self.animateRouteLine()
//            }
        }
    }
    
    var lowestHeight: CGFloat = 450
    var minimizedHeight: CGFloat = 150
    
    enum CurrentData {
        case notReserved
        case yesReserved
    }
    var currentData: CurrentData = CurrentData.notReserved
    var hasLoaded: Bool = false
    
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
        view.showsUserHeadingIndicator = true
        view.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0), animated: false, completionHandler: nil)
        view.decelerationRate = 2.0
        
        return view
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.DARK_GRAY
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 28
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var polyRouteLocatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.8)
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
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

    var currentHeightAnchor: NSLayoutConstraint!
    var previousHeightAnchor: CGFloat = 380
    
    lazy var mainBarController: TestMainBar = {
        let controller = TestMainBar()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)

        return controller
    }()
    
//    lazy var mainBarController: MainBarViewController = {
//        let controller = MainBarViewController()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.delegate = self
//        self.addChild(controller)
//
//        return controller
//    }()
    
    lazy var summaryController: SearchSummaryViewController = {
        let controller = SearchSummaryViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var searchBarController: SearchBarViewController = {
        let controller = SearchBarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        //        controller.delegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var locationsSearchResults: MapSearchViewController = {
        let controller = MapSearchViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)
        
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
        self.addChild(controller)
        
        return controller
    }()
    
//    lazy var durationController: DurationViewController = {
//        let controller = DurationViewController()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.title = "Purchase"
//        controller.delegate = self
//        self.addChild(controller)
//
//        return controller
//    }()
//
    var durationController = TestDurationView()
    
    lazy var confirmPaymentController: ConfirmViewController = {
        let controller = ConfirmViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var currentBottomController: CurrentBookingView = {
        let controller = CurrentBookingView()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var durationLeftAnchor: NSLayoutConstraint!
    var durationRightAnchor: NSLayoutConstraint!
    var durationTopAnchor: NSLayoutConstraint!
    lazy var currentMainBarHeight: CGFloat = phoneHeight - lowestHeight
    var currentBookingHeight: CGFloat = phoneHeight - 116 - 252
    
    var previousMainBarPercentage: CGFloat = 0
    var previousBookingPercentage: CGFloat = 0
    
    lazy var currentDurationController: CurrentDurationView = {
        let controller = CurrentDurationView()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var endBookingController: EndCurrentBookingView = {
        let controller = EndCurrentBookingView()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return controller
    }()
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
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
    
    var parkingBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(parkingBackButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var quickDestinationController: QuickDestinationViewController = {
        let controller = QuickDestinationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Destination"
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var quickParkingController: QuickParkingViewController = {
        let controller = QuickParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Destination"
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var quickCouponController: QuickCouponsViewController = {
        let controller = QuickCouponsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        self.addChild(controller)
        
        return controller
    }()
    
    var reviewBookingTopAnchor: NSLayoutConstraint!
    
    lazy var reviewBookingController: ReviewBookingViewController = {
        let controller = ReviewBookingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        controller.view.alpha = 0
        self.addChild(controller)
        
        return controller
    }()
    
    var newMessageTopAnchor: NSLayoutConstraint!
    var shouldUpdatePolyline: Bool = true
    
    var previousAnchor: CGFloat = 170.0
    
    var shouldBeSearchingForAnnotations: Bool = true
    
    var searchedForPlace: Bool = false
    var timer: Timer?
    var canChangeLocatorButtonTint: Bool = true
    var destinationString: String = "Arrived at destination"
    var annotationSelected: MGLAnnotation?
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
    var availableParkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [String: ParkingSpots]()
    var visibleAnnotationsDistance: [Double] = []
    var visibleAnnotations: [MGLPointAnnotation] = []
//    var visibleParkingSpots: Int = 0
    var destination: CLLocation?
    
    var currentUserBooking: Bookings?
    
    var mapViewConstraint: NSLayoutConstraint!
    var tabPullWidthShort: NSLayoutConstraint!
    var tabPullWidthLong: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    var purchaseStatusWidthAnchor: NSLayoutConstraint!
    var purchaseStatusHeightAnchor: NSLayoutConstraint!
    var navigationLabelHeight: NSLayoutConstraint!
    var diamondTopAnchor: NSLayoutConstraint!
    var locationResultsHeightAnchor: NSLayoutConstraint!
    
    var summaryTopAnchor: NSLayoutConstraint!
    var mainBarPreviousPosition: CGFloat = 0.0
    var currentViewPreviousPosition: CGFloat = 0.0
    var mainBarHighest: Bool = false
    var currentViewHighest: Bool = false
    
    var parkingBackButtonBookAnchor: NSLayoutConstraint!
    var parkingBackButtonPurchaseAnchor: NSLayoutConstraint!
    var parkingBackButtonConfirmAnchor: NSLayoutConstraint!
    
    var locatorMainBottomAnchor: NSLayoutConstraint!
    var locatorParkingBottomAnchor: NSLayoutConstraint!
    var locatorCurrentBottomAnchor: NSLayoutConstraint!
    
    var parkingControllerBottomAnchor: NSLayoutConstraint!
//    var mainBarTopAnchor: NSLayoutConstraint!
    var mainBarBottomAnchor: NSLayoutConstraint!
//    var durationControllerBottomAnchor: NSLayoutConstraint!
    var confirmControllerBottomAnchor: NSLayoutConstraint!
    var currentBottomHeightAnchor: NSLayoutConstraint!
    
    var parkingControllerHeightAnchor: NSLayoutConstraint!
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
    
    var quickDestinationRightAnchor: NSLayoutConstraint!
    var quickDestinationTopAnchor: NSLayoutConstraint!
    var quickParkingRightAnchor: NSLayoutConstraint!
    var quickParkingTopAnchor: NSLayoutConstraint!
    var navigationTopAnchor: NSLayoutConstraint!
    
    var quickDestinationWidthAnchor: NSLayoutConstraint!
    var quickParkingWidthAnchor: NSLayoutConstraint!
    ///////////////////////////////////////////////////////////////////
    
    let backgroundImageView: UIImageView = {
        let image = UIImage(named: "mapCoverBackground")!.resizableImage(withCapInsets: .zero)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.8249, longitude: -122.4194), animated: false)
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        let url = URL(string: "mapbox://styles/tcagle717/cjjnibq7002v22sowhbsqkg22")
        self.mapView.styleURL = url
        
        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        
        self.view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}

protocol handleEventSelection {
    func zoomToSearchLocation(address: String)
}



