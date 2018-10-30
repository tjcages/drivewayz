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
//import Cluster

var userLocation: CLLocation?
var alreadyLoadedSpots: Bool = false

protocol controlSaveLocation {
    func saveUserCurrentLocation()
}

class MapKitViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate, MKMapViewDelegate, removePurchaseView, controlHoursButton, controlNewHosts, controlSaveLocation {
    
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
        
        return view
    }()
    
    var topSearch: UIButton = {
        let search = UIButton(type: .custom)
        let image = UIImage(named: "Search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        search.setImage(tintedImage, for: .normal)
        search.tintColor = Theme.SEA_BLUE
        search.translatesAutoresizingMaskIntoConstraints = false
        search.addTarget(self, action: #selector(animateSearchBar(sender:)), for: .touchUpInside)
        
        return search
    }()
    
    let searchBar: UITextField = {
        let search = UITextField()
        search.layer.cornerRadius = 20
        search.backgroundColor = Theme.WHITE
        search.textColor = Theme.SEA_BLUE
        search.layer.shadowColor = Theme.DARK_GRAY.cgColor
        search.layer.shadowOffset = CGSize(width: 1, height: 1)
        search.layer.shadowRadius = 1
        search.layer.shadowOpacity = 0.8
        search.attributedPlaceholder = NSAttributedString(string: "",
                                                          attributes: [NSAttributedString.Key.foregroundColor: Theme.SEA_BLUE])
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.SEA_BLUE
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.8
        button.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 0, bottom: 0, right: 2.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        
        return button
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
    
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
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
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
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
    
    
//    ///////////////////////////////////////////// VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        setupViews()
        setupAdditionalViews()
        setupViewController()
        if self.currentActive == false {
            checkCurrentParking()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupLocationManager()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var textSearchBarFarRightAnchor: NSLayoutConstraint!
    var textSearchBarCloseRightAnchor: NSLayoutConstraint!
    var mapViewConstraint: NSLayoutConstraint!
    var tabPullWidthShort: NSLayoutConstraint!
    var tabPullWidthLong: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    var purchaseStatusWidthAnchor: NSLayoutConstraint!
    var purchaseStatusHeightAnchor: NSLayoutConstraint!
    var locatorButtonTopAnchor: NSLayoutConstraint!
    var locatorButtonBottomAnchor: NSLayoutConstraint!
    var navigationLabelHeight: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(topSearch)
        topSearch.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
        topSearch.widthAnchor.constraint(equalToConstant: 40).isActive = true
        topSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            topSearch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            topSearch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        }
        
        self.view.addSubview(searchBar)
        searchBar.centerYAnchor.constraint(equalTo: topSearch.centerYAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: topSearch.leftAnchor).isActive = true
        textSearchBarFarRightAnchor = searchBar.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
        textSearchBarFarRightAnchor.isActive = false
        textSearchBarCloseRightAnchor = searchBar.rightAnchor.constraint(equalTo: topSearch.rightAnchor)
        textSearchBarCloseRightAnchor.isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setupTextField(textField: searchBar)
        self.view.bringSubviewToFront(topSearch)
        
        self.view.addSubview(locatorButton)
        locatorButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        locatorButtonTopAnchor = locatorButton.topAnchor.constraint(equalTo: topSearch.bottomAnchor, constant: 12)
            locatorButtonTopAnchor.isActive = true
        locatorButtonBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24)
            locatorButtonBottomAnchor.isActive = false
        locatorButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
    
    }
    
    func setupLeaveAReview(parkingID: String) {
        self.view.addSubview(reviewsViewController.view)
        self.addChild(reviewsViewController)
        reviewsViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        reviewsViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        reviewsViewController.setData(parkingID: parkingID)
        UIView.animate(withDuration: 0.3, animations: {
            self.reviewsViewController.view.alpha = 1
        }) { (success) in
            //
        }
    }
    
    func removeLeaveAReview() {
        UIView.animate(withDuration: 0.3, animations: {
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
        
        self.view.addSubview(fullBlurView)
        fullBlurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fullBlurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fullBlurView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        fullBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
        
    }
    
    @objc func purchaseButtonSwiped() {
        self.delegate?.hideTabController()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = -self.view.frame.height
            self.fullBlurView.alpha = 1
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
        UIView.animate(withDuration: 0.3, animations: {
            self.purchaseViewAnchor.constant = 240
            self.fullBlurView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
            self.mapView.deselectAnnotation(MKPointAnnotation(), animated: true)
        }
    }
    
    @objc func informationButtonSwiped() {
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBlurView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
        }
        if isNavigating == false {
            self.delegate?.showTabController()
            self.locatorButtonBottomAnchor.isActive = false
            self.locatorButtonTopAnchor.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.navigationLabel.alpha = 0
                self.searchBar.alpha = 1
                self.topSearch.alpha = 1
                self.delegate?.showTabController()
                self.view.layoutIfNeeded()
            }
        } else {
            self.delegate?.hideTabController()
        }
    }
    
    func currentParkingSender() {
        self.delegate?.hideTabController()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = -self.view.frame.height
            self.fullBlurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = true
            self.purchaseViewController.view.alpha = 0
        }
    }
    
    func currentParkingDisappear() {
        self.purchaseViewController.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBlurView.alpha = 0
        }) { (success) in
            self.purchaseViewController.view.alpha = 0
        }
        if isNavigating == false {
            self.delegate?.showTabController()
            self.locatorButtonBottomAnchor.isActive = false
            self.locatorButtonTopAnchor.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.navigationLabel.alpha = 0
                self.searchBar.alpha = 1
                self.topSearch.alpha = 1
                self.delegate?.showTabController()
                self.view.layoutIfNeeded()
            }
        } else {
            self.delegate?.hideTabController()
        }
    }
    
    func openHoursButton() {
        self.hoursButtonAnchor.constant = 340
        UIView.animate(withDuration: 0.2) {
            self.fullBlurView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func closeHoursButton() {
        self.hoursButtonAnchor.constant = 220
        UIView.animate(withDuration: 0.2) {
            self.fullBlurView.alpha = 0
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
            UIView.animate(withDuration: 0.2) {
                self.purchaseStatusWidthAnchor.constant = 120
                self.purchaseStatusHeightAnchor.constant = 40
                self.purchaseStaus.setTitle("Success!", for: .normal)
                self.purchaseStaus.alpha = 0.9
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.purchaseStatusWidthAnchor.constant = 220
                self.purchaseStatusHeightAnchor.constant = 60
                self.purchaseStaus.setTitle("The charge could not be made", for: .normal)
                self.purchaseStaus.alpha = 0.9
                self.view.layoutIfNeeded()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.2) {
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
        self.vehicleDelegate?.bringNewVehicleController(vehicleStatus: .noVehicle)
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
        UIView.animate(withDuration: 0.3) {
            self.swipeLabel.alpha = 0.8
        }
    }
    
    func sendNewHost() {
        self.vehicleDelegate?.bringNewHostingController(parkingImage: .noImage)
    }
    
    
    
//    ///////////////////////////////// LOCATION MANAGER
    
    var searchedForPlace: Bool = false
    
    func setupLocationManager() {
        
        mapView.delegate = self
        mapView.showsPointsOfInterest = true
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.mapType = .standard
        mapView.showsCompass = false
        
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = Theme.PACIFIC_BLUE
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }

    @objc func animateSearchBar(sender: UIButton) {
        if self.textSearchBarCloseRightAnchor.isActive == true {
            searchBar.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: Theme.SEA_BLUE])
            UIView.animate(withDuration: 0.3, animations: {
                self.textSearchBarFarRightAnchor.isActive = true
                self.textSearchBarCloseRightAnchor.isActive = false
                self.view.layoutIfNeeded()
            })
        } else {
            searchBar.attributedPlaceholder = NSAttributedString(string: "",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: Theme.SEA_BLUE])
            UIView.animate(withDuration: 0.3, animations: {
                self.textSearchBarFarRightAnchor.isActive = false
                self.textSearchBarCloseRightAnchor.isActive = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupTextField(textField: UITextField){
        textField.leftViewMode = UITextField.ViewMode.always
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 60, height: 30))
        textField.leftView = paddingView
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        self.searchedForPlace = true
        return false
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

        UIView.animate(withDuration: 0.3) {
            self.textSearchBarFarRightAnchor.constant = self.view.frame.width * 1/4
            self.view.layoutIfNeeded()
        }
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
    
    @objc func locatorButtonAction(sender: UIButton) {
        let location: CLLocationCoordinate2D = mapView.userLocation.coordinate
        let camera = MKMapCamera()
        camera.pitch = 40
        camera.centerCoordinate = location
        camera.altitude = 1000
        self.mapView.camera = camera
//        self.mapView.setCamera(camera, animated: true)
        self.mapView.userTrackingMode = .followWithHeading
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
                UIView.animate(withDuration: 0.3, animations: {
                    //
                }) { (success) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.purchaseViewAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        //
                    }
                }
            }
            searchBar.attributedPlaceholder = NSAttributedString(string: "",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            UIView.animate(withDuration: 0.3, animations: {
                self.textSearchBarFarRightAnchor.isActive = false
                self.textSearchBarCloseRightAnchor.isActive = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.purchaseButtonSwipedDown()
        guard view.annotation != nil else { return }
//        if annotation is ClusterAnnotation {} else {
            UIView.animate(withDuration: 0.2) {
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
        self.locatorButtonTopAnchor.isActive = false
        self.locatorButtonBottomAnchor.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.navigationLabel.alpha = 1
            self.searchBar.alpha = 0
            self.topSearch.alpha = 0
            self.delegate?.hideTabController()
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
        self.locatorButtonBottomAnchor.isActive = false
        self.locatorButtonTopAnchor.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.navigationLabel.alpha = 0
            self.searchBar.alpha = 1
            self.topSearch.alpha = 1
            self.delegate?.showTabController()
            self.view.layoutIfNeeded()
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





