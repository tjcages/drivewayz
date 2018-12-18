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
import AVFoundation
import GooglePlaces
import Firebase
import AFNetworking
import MapKitGoogleStyler

var userLocation: CLLocation?
var alreadyLoadedSpots: Bool = false

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

class MapKitViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate, MKMapViewDelegate, removePurchaseView, controlHoursButton, controlNewHosts, controlSaveLocation, handleEventSelection {
    
    var delegate: moveControllers?
    var vehicleDelegate: controlsAccountOptions?
    
//    let clusterManager = ClusterManager()
    let locationManager = CLLocationManager()
    let delta = 0.1
    
    var parkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [String: ParkingSpots]()
    var destination: CLLocation?
    
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
        controller.view.layer.cornerRadius = 10
        
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
    
    
//    ///////////////////////////////////////////// VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        searchBar.delegate = self
        
        setupViews()
        setupAdditionalViews()
        setupViewController()
        configureTileOverlay()
        checkNetwork()
        if self.currentActive == false {
            checkCurrentParking()
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarSwiped(sender:)))
        mainBar.addGestureRecognizer(pan)
    }
    
    @objc func mainBarSwiped(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if sender.state == .changed && abs(translation.x) <= 16 && abs(translation.y) <= 16 {
            if self.mainBarCenterAnchor.constant < 16 && self.mainBarCenterAnchor.constant > -16 {
                self.mainBarCenterAnchor.constant = translation.x
            }
            var constant: CGFloat = 0
            switch device {
            case .iphone8:
                constant = 100
            case .iphoneX:
                constant = 120
            }
            if self.mainBarTopAnchor.constant < constant + 16 && self.mainBarTopAnchor.constant > constant - 16 {
                self.mainBarTopAnchor.constant = self.mainBarTopAnchor.constant + translation.y
            }
            self.view.layoutIfNeeded()
        } else if sender.state == .ended {
            UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.mainBarCenterAnchor.constant = 0
                    switch device {
                    case .iphone8:
                        self.mainBarTopAnchor.constant = 100
                    case .iphoneX:
                        self.mainBarTopAnchor.constant = 120
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        self.setupLocationManager()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(mainBar)
        mainBarWidthAnchor = mainBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -72)
            mainBarWidthAnchor.isActive = true
        mainBarCenterAnchor = mainBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            mainBarCenterAnchor.isActive = true
        mainBarHeightAnchor = mainBar.heightAnchor.constraint(equalToConstant: 60)
            mainBarHeightAnchor.isActive = true
        switch device {
        case .iphone8:
            mainBarTopAnchor = mainBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
                mainBarTopAnchor.isActive = true
        case .iphoneX:
            mainBarTopAnchor = mainBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
                mainBarTopAnchor.isActive = true
        }
        
        mapView.addSubview(hamburgerButton)
        hamburgerButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 24).isActive = true
        hamburgerButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        hamburgerButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            hamburgerButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40).isActive = true
        case .iphoneX:
            hamburgerButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50).isActive = true
        }
        
        mainBar.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: mainBar.rightAnchor, constant: -6).isActive = true
        locatorButton.centerYAnchor.constraint(equalTo: mainBar.centerYAnchor).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        
        mainBar.addSubview(diamondView)
        diamondView.leftAnchor.constraint(equalTo: mainBar.leftAnchor, constant: 20).isActive = true
        diamondTopAnchor = diamondView.centerYAnchor.constraint(equalTo: locatorButton.centerYAnchor)
            diamondTopAnchor.isActive = true
        diamondView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        diamondView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        mainBar.addSubview(microphoneButton)
        microphoneRightAnchor = microphoneButton.rightAnchor.constraint(equalTo: locatorButton.leftAnchor, constant: 4)
            microphoneRightAnchor.isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: mainBar.centerYAnchor, constant: 30).isActive = true
        microphoneButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
        mainBar.addSubview(searchBar)
        searchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchBar.leftAnchor.constraint(equalTo: diamondView.rightAnchor, constant: 16).isActive = true
        searchBar.rightAnchor.constraint(equalTo: microphoneButton.leftAnchor, constant: -2).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: diamondView.centerYAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalTo: mainBar.heightAnchor).isActive = true
        
        mainBar.addSubview(searchLabel)
        searchLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: mainBar.rightAnchor).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            searchLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            searchLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 40).isActive = true
        }
        
        self.view.addSubview(resultsScrollView)
        resultsScrollView.contentSize = CGSize.zero
        resultsScrollView.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
        resultsScrollView.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
        resultsScrollView.topAnchor.constraint(equalTo: mainBar.bottomAnchor, constant: -10).isActive = true
        resultsScrollAnchor = resultsScrollView.heightAnchor.constraint(equalToConstant: 0)
            resultsScrollAnchor.isActive = true
        
        resultsScrollView.addSubview(locationRecentResults.view)
        locationRecentResults.view.topAnchor.constraint(equalTo: resultsScrollView.topAnchor).isActive = true
        locationRecentResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        locationRecentResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        locationRecentHeightAnchor = locationRecentResults.view.heightAnchor.constraint(equalToConstant: 110)
            locationRecentHeightAnchor.isActive = true
        
        resultsScrollView.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: locationRecentResults.view.bottomAnchor).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        locationsSearchResults.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(eventsController.view)
        eventsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        eventsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        eventsControllerAnchor = eventsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 150)
            eventsControllerAnchor.isActive = true
        eventsHeightAnchor = eventsController.view.heightAnchor.constraint(equalToConstant: 150)
            eventsHeightAnchor.isActive = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(eventsControllerPanned(sender:)))
        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(eventsControllerPanned(sender:)))
        eventsController.view.addGestureRecognizer(panGesture)
        checkEventsController.view.addGestureRecognizer(panGesture2)
        
        self.view.addSubview(checkEventsController.view)
        checkEventsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        checkEventsWidthAnchor = checkEventsController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 24)
            checkEventsWidthAnchor.isActive = true
        checkEventsHeightAnchor = checkEventsController.view.heightAnchor.constraint(equalToConstant: 70)
            checkEventsHeightAnchor.isActive = true
        checkEventsBottomAnchor = checkEventsController.view.bottomAnchor.constraint(equalTo: eventsController.view.topAnchor, constant: 4)
            checkEventsBottomAnchor.isActive = false
        checkEventsAnchor = checkEventsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 70)
            checkEventsAnchor.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsControllerOpenTapped))
        checkEventsController.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(giftButton)
        self.view.bringSubviewToFront(eventsController.view)
        giftButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -16).isActive = true
        giftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        giftButton.heightAnchor.constraint(equalTo: giftButton.widthAnchor).isActive = true
        giftBottomAnchor = giftButton.bottomAnchor.constraint(equalTo: checkEventsController.view.topAnchor, constant: -12)
            giftBottomAnchor.isActive = false
        switch device {
        case .iphone8:
            giftOnlyBottomAnchor = giftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12)
            giftOnlyBottomAnchor.isActive = true
        case .iphoneX:
            giftOnlyBottomAnchor = giftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24)
            giftOnlyBottomAnchor.isActive = true
        }
        
        createToolbar()
    }
    
    func openSpecificEvent() {
        self.checkEventsController.view.alpha = 0
        UIView.animate(withDuration: animationIn) {
            self.mainBarTopAnchor.constant = -60
            self.eventsHeightAnchor.constant = self.view.frame.height
            self.giftBottomAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }
    
    func closeSpecificEvent() {
        UIView.animate(withDuration: animationOut) {
            switch device {
            case .iphone8:
                self.mainBarTopAnchor.constant = 100
            case .iphoneX:
                self.mainBarTopAnchor.constant = 120
            }
            self.eventsHeightAnchor.constant = 150
            self.checkEventsController.view.alpha = 1
            self.giftBottomAnchor.constant = 40
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func eventsControllerPanned(sender: UIPanGestureRecognizer) {
        if self.checkEventsWidthAnchor.constant != self.view.frame.width - 24 && self.checkEventsController.view.alpha == 1 {
            if sender.state == .changed {
                let location = sender.location(in: self.view).y
                let difference = self.view.frame.height - location
                if difference < 50 {
                    self.eventsControllerHidden()
                } else {
                    self.eventsControllerAnchor.constant = 120 - difference
                    if self.eventsControllerAnchor.constant <= 0 {
                        self.eventsControllerAnchor.constant = 0
                    }
                    self.view.layoutIfNeeded()
                }
            } else if sender.state == .ended {
                if self.eventsControllerAnchor.constant > 40 {
                    self.eventsControllerHidden()
                } else {
                    self.eventsControllerOpenTapped()
                }
            }
        }
    }
    
    @objc func eventsControllerOpenTapped() {
        self.checkEventsController.changeToCurrentEvents()
        UIView.animate(withDuration: animationIn) {
            self.checkEventsAnchor.isActive = false
            self.checkEventsBottomAnchor.isActive = true
            self.checkEventsHeightAnchor.constant = 40
            self.checkEventsWidthAnchor.constant = 205
            self.eventsControllerAnchor.constant = 0
            self.giftBottomAnchor.constant = 40
            self.view.layoutIfNeeded()
        }
    }
    
    func eventsControllerHidden() {
        self.giftOnlyBottomAnchor.isActive = false
        self.giftBottomAnchor.isActive = true
        self.checkEventsController.changeToBanner()
        UIView.animate(withDuration: animationIn) {
            self.checkEventsAnchor.isActive = true
            self.checkEventsAnchor.constant = -12
            self.checkEventsBottomAnchor.isActive = false
            self.checkEventsHeightAnchor.constant = 70
            self.checkEventsWidthAnchor.constant = self.view.frame.width - 24
            self.eventsControllerAnchor.constant = 150
            self.giftBottomAnchor.constant = -12
            self.view.layoutIfNeeded()
        }
    }
    
    func takeAwayEvents() {
        self.giftOnlyBottomAnchor.isActive = false
        self.giftBottomAnchor.isActive = true
        self.checkEventsAnchor.constant = 70
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    var networkTopAnchor: NSLayoutConstraint!
    
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
        
        self.view.addSubview(purchaseStaus)
        purchaseStaus.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        purchaseStaus.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        purchaseStatusWidthAnchor = purchaseStaus.widthAnchor.constraint(equalToConstant: 120)
        purchaseStatusWidthAnchor.isActive = true
        purchaseStatusHeightAnchor = purchaseStaus.heightAnchor.constraint(equalToConstant: 40)
        purchaseStatusHeightAnchor.isActive = true
        
        self.view.addSubview(navigationLabel)
        navigationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        navigationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        navigationLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        navigationLabelHeight = navigationLabel.heightAnchor.constraint(equalToConstant: 90)
            navigationLabelHeight.isActive = true
        
        self.view.addSubview(networkConnection)
        networkConnection.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        networkConnection.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        networkTopAnchor = networkConnection.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -80)
            networkTopAnchor.isActive = true
        networkConnection.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
    }
    
    func checkNetwork() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let status = previousNetworkReachabilityStatus.rawValue
            if status == 0 {
                self.networkConnection.setTitle("We can't seem to find a network connection", for: .normal)
                self.view.layoutIfNeeded()
                self.networkConnection.backgroundColor = Theme.HARMONY_RED
                switch device {
                case .iphone8:
                    self.networkTopAnchor.constant = -20
                case .iphoneX:
                    self.networkTopAnchor.constant = 0
                }
                self.takeAwayEvents()
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        NotificationCenter.default.addObserver(forName: NetworkReachabilityChanged, object: nil, queue: nil, using: {
            (notification) in
            if let userInfo = notification.userInfo {
                if let reachableStatus = userInfo["reachabilityStatus"] as? String {
                    if reachableStatus == "Connection Status : Not Reachable" {
                        self.networkConnection.setTitle("We can't seem to find a network connection", for: .normal)
                        self.view.layoutIfNeeded()
                        self.networkConnection.backgroundColor = Theme.HARMONY_RED
                        switch device {
                        case .iphone8:
                            self.networkTopAnchor.constant = -20
                        case .iphoneX:
                            self.networkTopAnchor.constant = 0
                        }
                        self.takeAwayEvents()
                        UIView.animate(withDuration: animationIn, animations: {
                            self.view.layoutIfNeeded()
                        })
                    } else {
                        self.networkConnection.setTitle("Successfully connected", for: .normal)
                        self.view.layoutIfNeeded()
                        self.networkConnection.backgroundColor = Theme.GREEN_PIGMENT
                        switch device {
                        case .iphone8:
                            self.networkTopAnchor.constant = -20
                        case .iphoneX:
                            self.networkTopAnchor.constant = 0
                        }
                        UIView.animate(withDuration: animationIn, animations: {
                            self.view.layoutIfNeeded()
                        }, completion: { (success) in
                            self.eventsController.checkEvents()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                UIView.animate(withDuration: animationOut, animations: {
                                    self.networkTopAnchor.constant = -80
                                    self.view.layoutIfNeeded()
                                })
                            }
                        })
                    }
                }
            }
        })
    }
    
    @objc func removeNetworkNotification(sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: animationOut, animations: {
            self.networkTopAnchor.constant = -80
            self.view.layoutIfNeeded()
        })
    }
    
    func setupLeaveAReview(parkingID: String) {
        self.view.addSubview(reviewsViewController.view)
        self.addChild(reviewsViewController)
        reviewsViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        reviewsViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        reviewsViewController.setData(parkingID: parkingID)
        UIView.animate(withDuration: animationIn, animations: {
            self.reviewsViewController.view.alpha = 1
        }) { (success) in
            //
        }
    }
    
    func removeLeaveAReview() {
        UIView.animate(withDuration: animationIn, animations: {
            self.reviewsViewController.view.alpha = 0
        }) { (success) in
            self.willMove(toParent: nil)
            self.reviewsViewController.view.removeFromSuperview()
            self.reviewsViewController.removeFromParent()
        }
    }
    
    var purchaseViewAnchor: NSLayoutConstraint!
    var informationViewAnchor: NSLayoutConstraint!
    var hoursButtonAnchor: NSLayoutConstraint!
    
    func setupViewController() {
        
        self.view.addSubview(fullBackgroundView)
        fullBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fullBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fullBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(darkBlurView)
        darkBlurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        darkBlurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkBlurView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(purchaseViewController.view)
        self.addChild(purchaseViewController)
        purchaseViewController.didMove(toParent: self)
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwiped))
        gestureRecognizer.direction = .up
        purchaseViewController.view.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwipedDownSender))
        gestureRecognizer2.direction = .down
        purchaseViewController.view.addGestureRecognizer(gestureRecognizer2)
        
        purchaseViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseViewAnchor = purchaseViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 240)
            purchaseViewAnchor.isActive = true
        purchaseViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        hoursButtonAnchor = purchaseViewController.view.heightAnchor.constraint(equalToConstant: 220)
            hoursButtonAnchor.isActive = true
        
        self.view.addSubview(informationViewController.view)
        self.addChild(informationViewController)
        informationViewController.didMove(toParent: self)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(informationButtonSwiped))
        gesture.direction = .down
        informationViewController.view.addGestureRecognizer(gesture)
        informationViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationViewController.view.topAnchor.constraint(equalTo: purchaseViewController.view.bottomAnchor, constant: 35).isActive = true
        informationViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        informationViewController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height - 30).isActive = true
        
        self.view.addSubview(swipeLabel)
        swipeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swipeLabel.bottomAnchor.constraint(equalTo: purchaseViewController.view.topAnchor, constant: -20).isActive = true
        swipeLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        swipeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(speechSearchResults.view)
        speechSearchResults.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        speechSearchResults.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        speechSearchResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        speechSearchResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }
    
    @objc func purchaseButtonSwiped() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = -self.view.frame.height
            self.mainBarTopAnchor.constant = -80
            self.diamondTopAnchor.constant = 40
            self.fullBackgroundView.alpha = 1
            self.swipeLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = true
        }
        UserDefaults.standard.set(true, forKey: "swipeTutorialCompleted")
        UserDefaults.standard.synchronize()
    }
    
    @objc func purchaseButtonSwipedDownSender() {
        self.purchaseButtonSwipedDown()
    }
    
    func purchaseButtonSwipedDown() {
        self.mapView.deselectAnnotation(annotationSelected, animated: true)
        purchaseViewController.minimizeHours()
        purchaseViewController.currentSender()
        purchaseViewController.checkButtonSender()
        UserDefaults.standard.set(true, forKey: "swipeTutorialCompleted")
        UserDefaults.standard.synchronize()
        switch device {
        case .iphone8:
            self.mainBarTopAnchor.constant = 100
        case .iphoneX:
            self.mainBarTopAnchor.constant = 120
        }
        self.diamondTopAnchor.constant = 0
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.purchaseViewAnchor.constant = 240
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
            self.mapView.deselectAnnotation(MKPointAnnotation(), animated: true)
        }
    }
    
    @objc func informationButtonSwiped() {
        switch device {
        case .iphone8:
            self.mainBarTopAnchor.constant = 100
        case .iphoneX:
            self.mainBarTopAnchor.constant = 120
        }
        self.diamondTopAnchor.constant = 0
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
        }
        if isNavigating == false {
            UIView.animate(withDuration: animationIn) {
                self.navigationLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func currentParkingSender() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = -self.view.frame.height
            self.mainBarTopAnchor.constant = -40
            self.diamondTopAnchor.constant = 40
            self.fullBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = true
            self.purchaseViewController.view.alpha = 0
        }
    }
    
    func currentParkingDisappear() {
        switch device {
        case .iphone8:
            self.mainBarTopAnchor.constant = 100
        case .iphoneX:
            self.mainBarTopAnchor.constant = 120
        }
        self.diamondTopAnchor.constant = 0
        self.purchaseViewController.view.alpha = 0
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.purchaseViewController.view.alpha = 0
        }
        if isNavigating == false {
            UIView.animate(withDuration: animationIn) {
                self.navigationLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func profileButtonPressed() {
        self.delegate?.moveToProfile()
    }
    
    func openHoursButton() {
        self.hoursButtonAnchor.constant = 340
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func closeHoursButton() {
        self.hoursButtonAnchor.constant = 220
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func sendAvailability(availability: Bool) {
        purchaseViewController.setAvailability(available: availability)
    }
    
    @objc func currentParkingPressed(sender: UIButton) {
        currentParkingSender()
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    func showPurchaseStatus(status: Bool) {
        if status == true {
            UIView.animate(withDuration: animationIn) {
                self.purchaseStatusWidthAnchor.constant = 120
                self.purchaseStatusHeightAnchor.constant = 40
                self.purchaseStaus.setTitle("Success!", for: .normal)
                self.purchaseStaus.alpha = 0.9
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.purchaseStatusWidthAnchor.constant = 220
                self.purchaseStatusHeightAnchor.constant = 60
                self.purchaseStaus.setTitle("The charge could not be made", for: .normal)
                self.purchaseStaus.alpha = 0.9
                self.view.layoutIfNeeded()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: animationIn) {
                self.purchaseStatusWidthAnchor.constant = 120
                self.purchaseStatusHeightAnchor.constant = 40
                self.purchaseStaus.setTitle("", for: .normal)
                self.purchaseStaus.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    func addAVehicleReminder() {
        self.vehicleDelegate?.openAccountView()
    }
    
    func swipeTutorialCheck() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if dictionary["recentParking"] != nil {
                    self.swipeLabel.removeFromSuperview()
                    return
                }
            }
        }
        UIView.animate(withDuration: animationIn) {
            self.swipeLabel.alpha = 0.8
        }
    }
    
    func sendNewHost() {
        self.vehicleDelegate?.bringNewHostingController()
    }
    
    
    
//    ///////////////////////////////// LOCATION MANAGER
    
    var searchedForPlace: Bool = false
    
    func setupLocationManager() {
        
        mapView.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            if self.currentActive == false && self.searchedForPlace == false && alreadyLoadedSpots == false {
                self.observeUserParkingSpots()
            }
        }
        self.resultsScrollAnchor.constant = 0
        if self.searchedForPlace == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate
                var region = MKCoordinateRegion()
                region.center = location
                region.span.latitudeDelta = 0.01
                region.span.longitudeDelta = 0.01
                self.mapView.setRegion(region, animated: true)
            }
        } else {
            return
        }
    }
    
    private func configureTileOverlay() {  //UNCOMMENT FOR GOOGLE MAP OVERLAY
//        // We first need to have the path of the overlay configuration JSON
//        guard let overlayFileURLString = Bundle.main.path(forResource: "overlay", ofType: "json") else {
//            return
//        }
//        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
//
//        // After that, you can create the tile overlay using MapKitGoogleStyler
//        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
//            return
//        }
//
//        // And finally add it to your MKMapView
//        mapView.addOverlay(tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = Theme.PACIFIC_BLUE
            renderer.lineWidth = 5
            return renderer
        } else if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        return MKOverlayRenderer()
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.PRUSSIAN_BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.searchBar.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func bringRecentView() {
        self.resultsScrollView.contentSize = CGSize.zero
        self.resultsScrollAnchor.constant = 110
        UIView.animate(withDuration: animationOut) {
            self.locationRecentHeightAnchor.constant = 110
            self.locationRecentResults.view.layer.cornerRadius = 10
            self.view.layoutIfNeeded()
        }
    }
    
    func hideRecentView() {
        self.resultsScrollView.contentSize = CGSize(width: self.view.frame.width, height: 400)
        switch device {
        case .iphone8:
            self.resultsScrollAnchor.constant = 250
        case .iphoneX:
            self.resultsScrollAnchor.constant = 300
        }
        UIView.animate(withDuration: animationOut) {
            self.locationRecentHeightAnchor.constant = 120
            self.locationRecentResults.view.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.bringSubviewToFront(resultsScrollView)
        self.view.bringSubviewToFront(mainBar)
        self.view.bringSubviewToFront(speechSearchResults.view)
        self.locationRecentResults.checkRecentSearches()
        self.resultsScrollAnchor.constant = 0
        self.eventsControllerHidden()
        UIView.animate(withDuration: animationIn, animations: {
            self.locationRecentResults.view.alpha = 1
            self.microphoneButton.alpha = 1
            self.mainBar.layer.cornerRadius = 0
            self.diamondTopAnchor.constant = 30
            self.mainBarTopAnchor.constant = 0
            self.mainBarWidthAnchor.constant = 0
            self.microphoneRightAnchor.constant = 30
            switch device {
            case .iphone8:
                self.mainBarHeightAnchor.constant = 122
            case .iphoneX:
                self.mainBarHeightAnchor.constant = 142
            }
            self.hamburgerButton.alpha = 0
            self.locatorButton.alpha = 0
            self.darkBlurView.alpha = 0.4
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.searchLabel.alpha = 1
                self.resultsScrollAnchor.constant = 110
                self.view.layoutIfNeeded()
            })
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bringRecentView()
        UIView.animate(withDuration: 0.1, animations: {
            self.searchLabel.alpha = 0
            self.locationRecentResults.view.alpha = 0
            self.resultsScrollAnchor.constant = 0
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.microphoneButton.alpha = 0
                self.mainBar.layer.cornerRadius = 5
                self.mainBarHeightAnchor.constant = 60
                self.mainBarWidthAnchor.constant = -72
                self.microphoneRightAnchor.constant = 4
                switch device {
                case .iphone8:
                    self.mainBarTopAnchor.constant = 100
                case .iphoneX:
                    self.mainBarTopAnchor.constant = 120
                }
                self.diamondTopAnchor.constant = 0
                self.hamburgerButton.alpha = 1
                self.locatorButton.alpha = 1
                self.darkBlurView.alpha = 0
                self.locationsSearchResults.view.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.view.bringSubviewToFront(self.darkBlurView)
            })
        }
    }
    
    func zoomToSearchLocation(address: String) {
        self.searchBar.text = address
        self.dismissKeyboard()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print(error?.localizedDescription as Any)
                    return
            }
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get data
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        // Create Annotation
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        annotation.title = "\(place.name)"
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        searchBar.text = place.formattedAddress
        
        // Zoom in on coordinate
        let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)

        self.dismiss(animated: true, completion: nil)
    }
    
    func observeUserParkingSpots() {
        if alreadyLoadedSpots == false {
            alreadyLoadedSpots = true
            let ref = Database.database().reference().child("parking")
            ref.observe(.childAdded, with: { (snapshot) in
                let parkingID = [snapshot.key]
                self.fetchParking(parkingID: parkingID)
            }, withCancel: nil)
            ref.observe(.childRemoved, with: { (snapshot) in
                self.parkingSpotsDictionary.removeValue(forKey: snapshot.key)
                self.reloadOfTable()
            }, withCancel: nil)
        }
    }
    
    private func fetchParking(parkingID: [String]) {
        for parking in parkingID {
            let parkingID = parking
            let ref = Database.database().reference().child("parking").child(parkingID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if var dictionary = snapshot.value as? [String:AnyObject] {
                    let parking = ParkingSpots(dictionary: dictionary)
                    if let avgRating = dictionary["rating"] as? Double { parking.rating = avgRating } else { parking.rating = 5.0 }
                    guard let parkingType = dictionary["parkingType"] as? String else { return }
                    self.checkAvailabilityForMarkers(parking: parking, ref: ref, parkingType: parkingType)
                    DispatchQueue.main.async(execute: {
                        let parkingID = dictionary["parkingID"] as! String
                        self.parkingSpotsDictionary[parkingID] = parking
                        self.reloadOfTable()
                    })
                }
            }, withCancel: nil)
        }
    }
    
    private func reloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.parkingSpots = Array(self.parkingSpotsDictionary.values)
        self.parkingSpots.sort(by: { (message1, message2) -> Bool in
            return ((message1.parkingDistance! as NSString).intValue) < ((message2.parkingDistance! as NSString).intValue)
        })
        DispatchQueue.main.async(execute: {
            self.showPartyMarkers()
        })
    }
    
    func showPartyMarkers() {
        if parkingSpots.count > 0 {
            for number in 0...(parkingSpots.count - 1) {
                let marker = MKPointAnnotation()
                let parking = parkingSpots[number]
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(parking.parkingAddress!) { (placemarks, error) in
                    guard let placemarks = placemarks, let location = placemarks.first?.location else {
                        print("Couldn't find location showing party markers")
                        return
                    }
                    marker.title = parking.parkingCost
                    marker.subtitle = "\(number)"
                    marker.coordinate = location.coordinate

                    if let myLocation: CLLocation = self.mapView.userLocation.location {
                        let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
                        let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                        let formattedDistance = String(format: "%.1f", roundedStepValue)
                        parking.parkingDistance = formattedDistance
                    }
                    self.mapView.addAnnotation(marker)
                }
            }
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var canChangeLocatorButtonTint: Bool = true
    
    @objc func locatorButtonAction(sender: UIButton) {
        let location: CLLocationCoordinate2D = mapView.userLocation.coordinate
        let camera = MKMapCamera()
        camera.pitch = 40
        camera.centerCoordinate = location
        camera.altitude = 1000
        self.mapView.camera = camera
        self.mapView.userTrackingMode = .followWithHeading
        self.locatorButton.tintColor = Theme.SEA_BLUE
        self.locatorButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.canChangeLocatorButtonTint = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.canChangeLocatorButtonTint = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if self.canChangeLocatorButtonTint == true {
            self.locatorButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.locatorButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
//    //////////////////////////CHECK FOR CURRENT PARKING
    
    func checkCurrentParking() {
        var avgRating: Double = 5
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded, with: { (snapshot) in
//                CurrentParkingViewController().checkCurrentParking()
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let parkingID = dictionary["parkingID"] as? String
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    parkingRef.observeSingleEvent(of: .value, with: { (pull) in
                        if var pullRef = pull.value as? [String:AnyObject] {
                            let parkingCity = pullRef["parkingCity"] as? String
                            let parkingImageURL = pullRef["parkingImageURL"] as? String
                            let parkingCost = pullRef["parkingCost"] as? String
                            let timestamp = pullRef["timestamp"] as? NSNumber
                            let id = pullRef["id"] as? String
                            let parkingID = pullRef["parkingID"] as? String
                            let parkingAddress = pullRef["parkingAddress"] as? String
                            let message = pullRef["message"] as? String
                            self.destinationString = parkingAddress!
                            
                            let geoCoder = CLGeocoder()
                            geoCoder.geocodeAddressString(parkingAddress!) { (placemarks, error) in
                                guard
                                    let placemarks = placemarks,
                                    let location = placemarks.first?.location
                                    else {
                                        print("MapKit can't find location")
                                        return
                                }
                                self.informationViewController.parkingLocation = location
                                DispatchQueue.main.async(execute: {
                                    if let myLocation: CLLocation = self.mapView.userLocation.location {
                                        let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
                                        let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                                        let formattedDistance = String(format: "%.1f", roundedStepValue)
                                        
                                        self.destination = location
                                        self.currentData = .yesReserved
                                        self.drawCurrentPath(dest: location, navigation: false)
                                        
                                        if let rating = pullRef["rating"] as? Double {
                                            let reviewsRef = parkingRef.child("Reviews")
                                            reviewsRef.observeSingleEvent(of: .value, with: { (count) in
                                                let counting = count.childrenCount
                                                if counting == 0 {
                                                    avgRating = rating
                                                } else {
                                                    avgRating = rating / Double(counting)
                                                }
                                                self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
                                                UIView.animate(withDuration: 0.5, animations: {
                                                    currentButton.alpha = 1
                                                })
                                            })
                                        } else {
                                            self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
                                            UIView.animate(withDuration: 0.5, animations: {
                                                currentButton.alpha = 1
                                                self.purchaseViewController.view.alpha = 0
                                                self.view.layoutIfNeeded()
                                            })
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }, withCancel: nil)
            currentRef.observe(.childRemoved, with: { (snapshot) in
                self.parkingSpots = []
                self.parkingSpotsDictionary = [:]
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                alreadyLoadedSpots = false
                self.searchedForPlace = false
                self.currentActive = false

                let mapOverlays = self.mapView.overlays
                self.mapView.removeOverlays(mapOverlays)
                let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate
                var region = MKCoordinateRegion()
                region.center = location
                region.span.latitudeDelta = 0.01
                region.span.longitudeDelta = 0.01
                self.mapView.setRegion(region, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    currentButton.alpha = 0
                    self.purchaseViewController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.currentData = .notReserved
                self.currentParkingDisappear()
                self.currentParkingController.stopTimerTest()
                DispatchQueue.main.async {
                    self.observeUserParkingSpots()
                }
            }, withCancel: nil)
        } else {
            return
        }
    }
    
    func drawCurrentPath(dest: CLLocation, navigation: Bool) {
        let mapOverlays = self.mapView.overlays
        self.mapView.removeOverlays(mapOverlays)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            self.currentActive = true

            let marker = MKPointAnnotation()
            marker.title = "Destination"
            marker.coordinate = dest.coordinate
            self.mapView.addAnnotation(marker)
        }
        let sourceCoordinates = self.locationManager.location?.coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: dest.coordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
            self.navigationLabel.alpha = 0
            self.view.layoutIfNeeded()
            if navigation == true {
                self.getDirections(to: route)
            }
        })
    }
    
    var destinationString: String = "Arrived at destination"
    var annotationSelected: MKAnnotation?
    var currentActive: Bool = false
    
    func saveUserCurrentLocation() {
        userLocation = self.mapView.userLocation.location
    }
    
    
//    ////////////////////////////// BEGIN MAPVIEW DELEGATE
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKClusterAnnotation {
            return ClusterAnnotationView(annotation: annotation, reuseIdentifier: ClusterAnnotationView.ReuseID)
        } else {
            guard let annotation = annotation as? MKPointAnnotation else { return nil }
            var parkingType: String = "house"
            var currentAvailable: Bool = true
            if annotation.title == "Destination" {
                return DestinationAnnotationView(annotation: annotation, reuseIdentifier: DestinationAnnotationView.ReuseID)
            }
            if let subtitle = annotation.subtitle {
                if subtitle != "" {
                    if let string = annotation.subtitle {
                        if let intFromString = Int(string) {
                            if parkingSpots.count >= intFromString {
                                let parking = parkingSpots[intFromString]
                                parkingType = parking.parkingType!
                                if parking.currentAvailable == true || parking.currentAvailable == nil {
                                    currentAvailable = true
                                } else {
                                    currentAvailable = false
                                }
                            }
                        }
                    }
                }
            }
            if parkingType == "parkingLot" {
                if currentAvailable == false {
                    return UnavailableLotAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
                } else {
                    return AvailableLotAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
                }
            } else if parkingType == "apartment" {
                if currentAvailable == false {
                    return UnavailableApartmentAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
                } else {
                    return AvailableApartmentAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
                }
            } else {
                if currentAvailable == false {
                    return UnavailableHouseAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
                } else {
                    return AvailableHouseAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
                }
            }
        }
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        self.annotationSelected = annotation
        if let cluster = annotation as? MKClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.memberAnnotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                if MKMapRectEqualToRect(zoomRect, MKMapRect.null) {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else if let annotation = annotation as? MKPointAnnotation {
            let location: CLLocationCoordinate2D = annotation.coordinate
            var region = MKCoordinateRegion()
            region.center = location
            region.span.latitudeDelta = 0.001
            region.span.longitudeDelta = 0.001
            self.mapView.setRegion(region, animated: true)
            if annotation.title == "Destination" { return }
            if annotation.subtitle! != "" {
                self.swipeTutorialCheck()
                if let string = view.annotation!.subtitle, string != nil {
                    if let intFromString = Int(string!) {
                        if parkingSpots.count >= intFromString {
                            let parking = parkingSpots[intFromString]
                            self.informationViewController.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!, rating: parking.rating!, message: parking.message!)
                            self.purchaseViewController.setData(parkingCost: parking.parkingCost!, parkingID: parking.parkingID!, id: parking.id!)
                            self.purchaseViewController.resetReservationButton()
                        }
                    }
                }
                
                self.purchaseViewController.view.alpha = 1
                UIView.animate(withDuration: animationIn, animations: {
                    //
                }) { (success) in
                    UIView.animate(withDuration: animationIn, animations: {
                        self.purchaseViewAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        //
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.purchaseButtonSwipedDown()
        guard view.annotation != nil else { return }
//        if annotation is ClusterAnnotation {} else {
            UIView.animate(withDuration: animationIn) {
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.swipeLabel.alpha = 0
            }
//        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
//    ////////////////////////////////// MAP NAVIGATION
    
    var currentCoordinate: CLLocationCoordinate2D?
    var navigationSteps = [MKRoute.Step]()
    let speechSythensizer = AVSpeechSynthesizer()
    var stepCounter = 1
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentActive == true {
            locationManager.stopUpdatingLocation()
            guard let currentLocation = locations.first else { return }
            self.currentCoordinate = currentLocation.coordinate
            self.mapView.userTrackingMode = .followWithHeading
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.stepCounter += 1
        if self.stepCounter < self.navigationSteps.count {
            let currentStep = self.navigationSteps[stepCounter]
            let nextMessage = "In \(currentStep.distance) meters \(currentStep.instructions)."
            self.speakDirections(message: nextMessage)
        } else {
            let message = self.destinationString
            self.speakDirections(message: message)
            self.stepCounter = 0
            self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
        }
    }
    
    func getDirections(to primaryRoute: MKRoute) {
        self.mapView.userTrackingMode = .followWithHeading
        self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
        self.navigationSteps = primaryRoute.steps
        for i in 0 ..< primaryRoute.steps.count {
            let step = primaryRoute.steps[i]
            let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20, identifier: "\(i)")
            self.locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: region.center, radius: region.radius)
            self.mapView.addOverlay(circle)
        }
        let firstDistance = self.convertDistance(dist: self.navigationSteps[1].distance, nav: self.navigationSteps[1].instructions)
        let secondDistance = self.convertDistance(dist: self.navigationSteps[2].distance, nav: self.navigationSteps[2].instructions)
        let initialMessage = "In \(firstDistance), then in \(secondDistance)."
        self.speakDirections(message: initialMessage)
        self.stepCounter += 1
    }
    
    func speakDirections(message: String) {
        self.navigationLabel.text = message
        let numLines = (self.navigationLabel.contentSize.height / (self.navigationLabel.font?.lineHeight)!)
        if numLines < 2 {
            self.navigationLabelHeight.constant = 70
        } else if numLines < 3 {
            self.navigationLabelHeight.constant = 90
        } else if numLines < 4 {
            self.navigationLabelHeight.constant = 110
        } else {
            self.navigationLabelHeight.constant = 130
        }
        UIView.animate(withDuration: animationIn) {
            self.navigationLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        self.speechSythensizer.delegate = self
        let audioSession = AVAudioSession.sharedInstance()
        do { try audioSession.setCategory(.playback, mode: .default, options: .duckOthers) } catch { print("Error playing audio over music") }
        let speechUtterance = AVSpeechUtterance(string: message)
        self.speechSythensizer.speak(speechUtterance)
    }
    
    func convertDistance(dist: Double, nav: String) -> String {
        let first = String(nav.prefix(1)).lowercased()
        let other = String(nav.dropFirst())
        let feetDist = dist * 3.28084
        if feetDist > 500 {
            let mileDist = feetDist/5280
            return "\(mileDist.rounded(toPlaces: 1)) miles \(first+other)"
        } else {
            return "\(Int(round(feetDist/10)*10)) feet \(first+other)"
        }
    }
    
    func hideNavigation() {
        isEditing = false
        self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
        UIView.animate(withDuration: animationIn) {
            self.navigationLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func textFieldDidChange(textField: UITextField){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField.text!])
        if textField.text == "" {
            UIView.animate(withDuration: animationOut) {
                self.locationsSearchResults.view.alpha = 0
            }
        }
    }
    
    @objc func microphoneButtonPressed(sender: UIButton) {
        self.dismissKeyboard()
        UIView.animate(withDuration: animationIn, animations: {
            self.speechSearchResults.view.alpha = 1
        }) { (success) in
            self.speechSearchResults.recordAndRecognizeSpeech()
        }
    }
    
}

extension MapKitViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
}

extension MapKitViewController {
    func checkAvailabilityForMarkers(parking: ParkingSpots, ref: DatabaseReference, parkingType: String) {
        ref.child("Current").observe(.childAdded) { (snapshot) in
            if let vailable = snapshot.value as? String {
                if vailable == "Unavailable" {
                    parking.currentAvailable = false
                }
            }
            ref.observeSingleEvent(of: .value, with: { (currentSnap) in
                let count = currentSnap.childrenCount
                ref.observeSingleEvent(of: .value, with: { (parkSnap) in
                    if let dictionary = parkSnap.value as? [String:AnyObject] {
                        if let numberString = dictionary["numberOfSpots"] as? String {
                            let numberSpots: Int = Int(numberString)!
                            if numberSpots > count {
                                parking.currentAvailable = true
                            } else {
                                parking.currentAvailable = false
                            }
                        }
                    }
                })
            })
        }
        ref.child("Availability").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if dictionary["Monday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
                if dictionary["Tuesday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
                if dictionary["Wednesday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
                if dictionary["Thursday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
                if dictionary["Friday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
                if dictionary["Saturday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
                if dictionary["Sunday"] as? Int == 0 {
                    parking.currentAvailable = false
                } else {
                    parking.currentAvailable = true
                }
            }
        }
        if parkingType == "house" {
            parking.parkingType = parkingType
        } else if parkingType == "apartment" {
            parking.parkingType = parkingType
        } else if parkingType == "parkingLot" {
            parking.parkingType = parkingType
        }
    }
    
    func openMessages() {
        self.vehicleDelegate?.openAccountView()
        self.vehicleDelegate?.bringMessagesController()
    }
    
}





