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
import GoogleMaps
import GooglePlaces

import Firebase
//import AFNetworking
//import AVFoundation
//import Mapbox
//import MapboxDirections

//var userLocation: CLLocation?
var hasLoadedMapView: Bool = false

class MapKitViewController: UIViewController, UISearchBarDelegate, controlNewHosts, controlSaveLocation {
    
    var mainViewState: MainViewState = .none {
        didSet {
            self.reloadRequestedViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        monitorSurge()
        observeCurrentParking()
        setupController()
        setupLocationManager()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if self.hasLoaded == false {
//            self.hasLoaded = true
//        }
//    }
    
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
            monitorCoupons()
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
    
    var mapBoxRoute: MKRoute?
    
    lazy var currentBookingHeight: CGFloat = phoneHeight - 116 - 252
    
    enum CurrentData {
        case notReserved
        case yesReserved
    }
    var currentData: CurrentData = CurrentData.notReserved
    var hasLoaded: Bool = false
    
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.8249, longitude: -122.4194, zoom: 14.0)
        let view = GMSMapView(frame: .zero, camera: camera)
        view.delegate = self
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = true
        view.settings.tiltGestures = false
        view.settings.compassButton = false
        view.settings.rotateGestures = false
        view.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: mainBarNormalHeight + 72, right: horizontalPadding)

        return view
    }()
    
    var canShowLocatorButton: Bool = true
    
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
    
    var currentHeightAnchor: NSLayoutConstraint!
    var previousHeightAnchor: CGFloat = 380
    var canScrollMainView: Bool = true
    
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
        self.addChild(controller)
        controller.view.backgroundColor = .red
        
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
    
    var durationController = TestDurationTabView()
    
    lazy var confirmPaymentController: ConfirmViewController = {
        let controller = ConfirmViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.additionalDelegate = self
        
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 24
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.alpha = 0
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
    
    var shouldUpdatePolyline: Bool = true
    
    var previousAnchor: CGFloat = 170.0
    
    var shouldBeSearchingForAnnotations: Bool = true
    
    var searchedForPlace: Bool = false
    var timer: Timer?
//    var canChangeLocatorButtonTint: Bool = true
//    var destinationString: String = "Arrived at destination"
    var annotationSelected: GMSMarker?
    var shouldShowOverlay: Bool = false
    
    var currentCoordinate: CLLocationCoordinate2D?
    var navigationSteps = [CLLocationCoordinate2D]()
//    let speechSythensizer = AVSpeechSynthesizer()
    var stepCounter = 1
    
    var delegate: moveControllers?
    var accountDelegate: controlsAccountOptions?
    
    let locationManager = CLLocationManager()
    let delta = 0.1
    var mapChangedFromUserInteraction = true
    var changeUserInteractionTimer = Timer()
    var changeLocationCounter: Int = 0
    
    var parkingSpots = [ParkingSpots]()
    var availableParkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [String: ParkingSpots]()
    var visibleAnnotationsDistance: [Double] = []
    var visibleAnnotations: [GMSMarker] = []
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

        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        // Load the map style to be applied to Google Maps
        if let path = Bundle.main.path(forResource: "GoogleMapStyle", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                do {
                    // Set the map style by passing a valid JSON string.
                    if let jsonString = jsonToString(json: jsonResult as AnyObject) {
                        mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            } catch {
                // handle error
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
        let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
        let london = GMSMarker(position: position)
        london.title = "London"
        london.icon = UIImage(named: "annotationMapMarker")
        london.map = mapView
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func sendNewHost() {
        self.accountDelegate?.bringNewHostingController()
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

func jsonToString(json: AnyObject) -> String? {
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
        return convertedString
        
    } catch let myJSONError {
        print(myJSONError)
        
        return nil
    }
}
