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
import GoogleMapsUtils

import Firebase

class MapKitViewController: UIViewController {
    
    var mainViewState: MainViewState = .none {
        didSet {
            reloadRequestedViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true

        setupLocationManager()
        setupClusering()
        setupController()
    }
    
    func setupController() {
        setupViews()
        setupDimmingViews()
        setupMainViews()
        setupMapButtons()
        setupLocator()
        
        setupUserMessages()
        setupNetworkConnection()
        
//            DynamicPricing.readCityCSV()
        
//            if BookedState == .currentlyBooked && mainViewState != .currentBooking {
//                mainViewState = .currentBooking
////                return
//            } else if BookedState == .reserved && mainViewState != .duration { // NEED TO CHANGE TO RESERVATION
//                mainViewState = .mainBar
////                return
//            } else if BookedState == .none && mainViewState != .mainBar {
//                mainViewState = .mainBar
////                return
//            }
        
        reloadRequestedViews()
        observeUserDrivewayzMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CATransaction.begin()
        CATransaction.setValue(3, forKey: kCATransactionAnimationDuration)
//        CATransaction.setValue(3, forKey: kCATransactionAnimationTimingFunction)
        if let userLocation = self.locationManager.location {
            let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel - 1.5)
            mapView.camera = camera
            let camera2 = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
            mapView.animate(to: camera2)
        }
        CATransaction.commit()
        
//        delayWithSeconds(2) {
//            self.mainViewState = .none
//            self.showParking() // TESTING PURPOSES NEED TO REMOVE
//        }
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var currentBookingHeight: CGFloat = phoneHeight - 116 - 252 {
        didSet {
//            currentHeightChange()
        }
    } // 116 corresponds to DurationController
    
    var mapBoxRoute: MKRoute?
    var mapBoxWalkingRoute: MKRoute?
    
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
        view.isMyLocationEnabled = false
        view.settings.tiltGestures = false
        view.settings.compassButton = false
        view.settings.rotateGestures = false
        view.padding = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: mainBarNormalHeight + 72, right: horizontalPadding)

        return view
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
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
    
    var parkingRouteButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_route") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
//        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var currentRouteButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_route") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 28
        button.imageEdgeInsets = UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var currentHeightAnchor: NSLayoutConstraint!
    var previousHeightAnchor: CGFloat = 380
    var canScrollMainView: Bool = true
    
    lazy var mainBarController: MainScreenController = {
        let controller = MainScreenController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)

        return controller
    }()
    
    var welcomeBannerHeightAnchor: NSLayoutConstraint!
    
    var welcomeBannerView: MainWelcomeBannerView = {
        let controller = MainWelcomeBannerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var bookingController: BookingViewController = {
        let controller = BookingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
//        controller.buttonView.timeButton.addTarget(self, action: #selector(durationPressed), for: .touchUpInside)
//        controller.navigationDelegate = self
//        controller.locatorDelegate = self
//        controller.parkingDelegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    var topParkingView: BookingTopView = {
        let view = BookingTopView()
        view.backButton.addTarget(self, action: #selector(parkingBackButtonPressed), for: .touchUpInside)
        
        return view
    }()
    
//    var durationController = TestDurationTabView()
    
    var durationLeftAnchor: NSLayoutConstraint!
    var durationRightAnchor: NSLayoutConstraint!
    var durationTopAnchor: NSLayoutConstraint!
    
    var previousMainBarPercentage: CGFloat = 0
    var previousBookingPercentage: CGFloat = 0
    var previousCurrentPercentage: CGFloat = 0
    
    lazy var currentBookingController: CurrentBookingController = {
        let controller = CurrentBookingController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var networkConnection: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SALMON
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
        button.layer.cornerRadius = 25
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.addTarget(self, action: #selector(parkingBackButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var quickDurationView = QuickDurationView()
    var quickParkingView = QuickParkingView()
    
    var userEnteredDestination: Bool = true
    
    var timer: Timer?
    
    var delegate: moveControllers?
    var accountDelegate: controlsAccountOptions?
    
    let locationManager = CLLocationManager()
    var clusterManager: GMUClusterManager!

    var changeUserInteractionTimer: Timer?
    
    var summaryTopAnchor: NSLayoutConstraint!
    var mainBarPreviousPosition: CGFloat = 0.0
    var currentViewPreviousPosition: CGFloat = 0.0
    var mainBarHighest: Bool = false
    var currentViewHighest: Bool = false
    
    var locatorMainBottomAnchor: NSLayoutConstraint!
    
    var parkingControllerBottomAnchor: NSLayoutConstraint!
    
    var mainBarBottomAnchor: NSLayoutConstraint!
    var mainBarHeightAnchor: NSLayoutConstraint!
    
    var currentBarBottomAnchor: NSLayoutConstraint!
    var currentBarHeightAnchor: NSLayoutConstraint!
    
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
        let image = UIImage(named: "mapCoverView")!.resizableImage(withCapInsets: .zero)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_5
        
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
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
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
