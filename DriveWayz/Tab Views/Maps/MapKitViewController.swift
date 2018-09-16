//
//  MapKitViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/4/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import Firebase
import Cluster

var userLocation: CLLocation?

protocol controlSaveLocation {
    func saveUserCurrentLocation()
}

class MapKitViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate, MKMapViewDelegate, removePurchaseView, controlHoursButton, controlNewHosts, controlSaveLocation {
    
    var delegate: moveControllers?
    var vehicleDelegate: controlsNewParking?
    
    let clusterManager = ClusterManager()
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
        search.setImage(image, for: .normal)
        search.translatesAutoresizingMaskIntoConstraints = false
        search.addTarget(self, action: #selector(animateSearchBar(sender:)), for: .touchUpInside)
        
        return search
    }()
    
    let searchBar: UITextField = {
        let search = UITextField()
        search.layer.cornerRadius = 20
        search.backgroundColor = Theme.PRIMARY_DARK_COLOR
        search.textColor = Theme.WHITE
        search.alpha = 0.9
        search.layer.shadowColor = Theme.DARK_GRAY.cgColor
        search.layer.shadowOffset = CGSize(width: 1, height: 1)
        search.layer.shadowRadius = 1
        search.layer.shadowOpacity = 0.8
        search.attributedPlaceholder = NSAttributedString(string: "",
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.PRIMARY_DARK_COLOR
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
        //        controller.hoursDelegate = self
        
        return controller
    }()
    
    lazy var informationViewController: InformationViewController = {
        let controller = InformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.title = "Information Controller"
        controller.delegate = self
        controller.hostDelegate = self
        
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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
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
    
    var couponStaus: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("", for: .normal)
        view.titleLabel?.textColor = Theme.WHITE
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 2
        view.backgroundColor = Theme.PRIMARY_COLOR
        view.alpha = 0
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    lazy var swipeTutorial: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        view.layer.insertSublayer(background, at: 0)
        view.alpha = 0
        
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
    
    
//    ///////////////////////////////////////////// VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        searchBar.delegate = self
        
        clusterManager.cellSize = nil
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 2
        clusterManager.clusterPosition = .nearCenter
        
        setupViews()
        setupAdditionalViews()
        setupViewController()
        setupLocationManager()
        observeUserParkingSpots()
        checkCurrentParking()
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
        self.view.bringSubview(toFront: topSearch)
        
        self.view.addSubview(locatorButton)
        locatorButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        locatorButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        locatorButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupAdditionalViews() {
        
        self.view.addSubview(currentButton)
        currentButton.addTarget(self, action: #selector(currentParkingPressed(sender:)), for: .touchUpInside)
        currentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        currentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        currentButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        currentButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.view.addSubview(purchaseStaus)
        purchaseStaus.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        purchaseStaus.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        purchaseStatusWidthAnchor = purchaseStaus.widthAnchor.constraint(equalToConstant: 120)
        purchaseStatusWidthAnchor.isActive = true
        purchaseStatusHeightAnchor = purchaseStaus.heightAnchor.constraint(equalToConstant: 40)
        purchaseStatusHeightAnchor.isActive = true
        
        self.view.addSubview(swipeTutorial)
        swipeTutorial.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        swipeTutorial.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        swipeTutorial.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        swipeTutorial.heightAnchor.constraint(equalToConstant: 160).isActive = true
    
    }
    
    func setupLeaveAReview(parkingID: String) {
        self.view.addSubview(reviewsViewController.view)
        self.addChildViewController(reviewsViewController)
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
            self.willMove(toParentViewController: nil)
            self.reviewsViewController.view.removeFromSuperview()
            self.reviewsViewController.removeFromParentViewController()
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
        self.addChildViewController(purchaseViewController)
        purchaseViewController.didMove(toParentViewController: self)
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwiped))
        gestureRecognizer.direction = .up
        purchaseViewController.view.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwipedDownSender))
        gestureRecognizer2.direction = .down
        purchaseViewController.view.addGestureRecognizer(gestureRecognizer2)
        purchaseViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseViewAnchor = purchaseViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 160)
            purchaseViewAnchor.isActive = true
        purchaseViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        hoursButtonAnchor = purchaseViewController.view.heightAnchor.constraint(equalToConstant: 140)
            hoursButtonAnchor.isActive = true
        
        self.view.addSubview(informationViewController.view)
        self.addChildViewController(informationViewController)
        informationViewController.didMove(toParentViewController: self)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(informationButtonSwiped))
        gesture.direction = .down
        informationViewController.view.addGestureRecognizer(gesture)
        informationViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationViewController.view.topAnchor.constraint(equalTo: purchaseViewController.view.bottomAnchor, constant: 35).isActive = true
        informationViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10).isActive = true
        informationViewController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height - 30).isActive = true
        
        self.view.addSubview(couponStaus)
        couponStaus.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
        couponStaus.bottomAnchor.constraint(equalTo: purchaseViewController.view.topAnchor, constant: -80).isActive = true
        couponStaus.widthAnchor.constraint(equalToConstant: 80).isActive = true
        couponStaus.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(swipeLabel)
        swipeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swipeLabel.bottomAnchor.constraint(equalTo: purchaseViewController.view.topAnchor, constant: -30).isActive = true
        swipeLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        swipeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func purchaseButtonSwiped() {
        self.delegate?.hideTabController()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = -self.view.frame.height
            self.fullBlurView.alpha = 0.9
            self.swipeTutorial.alpha = 0
            self.swipeLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = true
            UIApplication.shared.statusBarStyle = .default
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
            self.purchaseViewAnchor.constant = 160
            self.swipeTutorial.alpha = 0
            self.fullBlurView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
            UIApplication.shared.statusBarStyle = .default
            self.mapView.deselectAnnotation(Annotation(), animated: true)
        }
    }
    
    @objc func informationButtonSwiped() {
        self.delegate?.showTabController()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBlurView.alpha = 0
            if self.purchaseViewController.view.alpha == 1 {
                self.swipeTutorial.alpha = 1
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
            UIApplication.shared.statusBarStyle = .default
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
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    func currentParkingDisappear() {
        self.delegate?.showTabController()
        self.purchaseViewController.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBlurView.alpha = 0
        }) { (success) in
            self.purchaseViewController.view.alpha = 0
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    func openHoursButton() {
        self.hoursButtonAnchor.constant = 315
        UIView.animate(withDuration: 0.2) {
            self.fullBlurView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func closeHoursButton() {
        self.hoursButtonAnchor.constant = 140
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
    
    func checkForCoupons() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        ref.observe(.childAdded) { (snapshot) in
            let percent = snapshot.value as? Int
            self.couponStaus.setTitle("\(percent!)% off!", for: .normal)
            self.couponStaus.alpha = 0.8
            couponActive = percent!
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.couponStaus.setTitle("", for: .normal)
            self.couponStaus.alpha = 0
        }
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
        self.vehicleDelegate?.setupNewVehicle(vehicleStatus: .noVehicle)
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
            self.swipeTutorial.alpha = 1
            self.swipeLabel.alpha = 0.8
        }
    }
    
    func sendNewHost() {
        self.vehicleDelegate?.setupNewParking(parkingImage: .noImage)
    }
    
    
    
//    ///////////////////////////////// LOCATION MANAGER
    
    
    func setupLocationManager() {
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            
            let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate
            var region = MKCoordinateRegion()
            region.center = location
            region.span.latitudeDelta = 0.01
            region.span.longitudeDelta = 0.01
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = Theme.PRIMARY_COLOR
        renderer.lineWidth = 5
        return renderer
    }

    @objc func animateSearchBar(sender: UIButton) {
        if self.textSearchBarCloseRightAnchor.isActive == true {
            searchBar.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            UIView.animate(withDuration: 0.3, animations: {
                self.textSearchBarFarRightAnchor.isActive = true
                self.textSearchBarCloseRightAnchor.isActive = false
                self.view.layoutIfNeeded()
            })
        } else {
            searchBar.attributedPlaceholder = NSAttributedString(string: "",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            UIView.animate(withDuration: 0.3, animations: {
                self.textSearchBarFarRightAnchor.isActive = false
                self.textSearchBarCloseRightAnchor.isActive = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupTextField(textField: UITextField){
        textField.leftViewMode = UITextFieldViewMode.always
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
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)

        UIView.animate(withDuration: 0.3) {
            self.textSearchBarFarRightAnchor.constant = self.view.frame.width * 1/4
            self.view.layoutIfNeeded()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func observeUserParkingSpots() {
        self.parkingSpots = []
        self.parkingSpotsDictionary = [:]
        let annotations = self.mapView.annotations
        self.clusterManager.remove(annotations)
        self.mapView.removeAnnotations(annotations)
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
    
    private func fetchParking(parkingID: [String]) {
        for parking in parkingID {
            var avgRating: Double = 5
            let messageRef = Database.database().reference().child("parking").child(parking)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if var dictionary = snapshot.value as? [String:AnyObject] {
                    let parkingAddress = dictionary["parkingAddress"] as! String
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(parkingAddress) { (placemarks, error) in
                        guard
                            let placemarks = placemarks,
                            let location = placemarks.first?.location
                            else {
                                // handle no location found
                                return
                        }
                        DispatchQueue.main.async(execute: {
                            if let myLocation: CLLocation = self.mapView.userLocation.location {
                                let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
                                let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                                let formattedDistance = String(format: "%.1f", roundedStepValue)
                                dictionary.updateValue(formattedDistance as AnyObject, forKey: "parkingDistance")
                                
                                if let rating = dictionary["rating"] as? Double {
                                    let reviewsRef = messageRef.child("Reviews")
                                    reviewsRef.observeSingleEvent(of: .value, with: { (count) in
                                        let counting = count.childrenCount
                                        if counting == 0 {
                                            avgRating = rating
                                        } else {
                                            avgRating = rating / Double(counting)
                                        }
                                        
                                        dictionary.updateValue(avgRating as AnyObject, forKey: "rating")
                                        
                                        let parking = ParkingSpots(dictionary: dictionary)
                                        let parkingID = dictionary["parkingID"] as! String
                                        self.parkingSpotsDictionary[parkingID] = parking
                                        DispatchQueue.main.async(execute: {
                                            self.reloadOfTable()
                                        })
                                    })
                                } else {
                                    dictionary.updateValue(avgRating as AnyObject, forKey: "rating")
                                    
                                    let parking = ParkingSpots(dictionary: dictionary)
                                    let parkingID = dictionary["parkingID"] as! String
                                    self.parkingSpotsDictionary[parkingID] = parking
                                    DispatchQueue.main.async(execute: {
                                        self.reloadOfTable()
                                    })
                                }
                            }
                        })
                    }
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
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        self.clusterManager.remove(annotations)
        if parkingSpots.count > 0 {
            for number in 0...(parkingSpots.count - 1) {
                let marker = Annotation()
                let parking = parkingSpots[number]
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(parking.parkingAddress!) { (placemarks, error) in
                    guard let placemarks = placemarks, let location = placemarks.first?.location else {
                        return
                    }
                    marker.title = parking.parkingCost
                    marker.subtitle = "\(number)"
                    marker.coordinate = location.coordinate
                    if parking.currentAvailable == nil {
                        let color = Theme.PRIMARY_COLOR
                        marker.style = .color(color, radius: 25)
                    } else {
                        let color = Theme.DARK_GRAY.withAlphaComponent(0.7)
                        marker.style = .color(color, radius: 25)
                    }
                    self.clusterManager.add(marker)
                    self.clusterManager.reload(mapView: self.mapView)
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
        var region = MKCoordinateRegion()
        region.center = location
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        self.mapView.setRegion(region, animated: true)
        DispatchQueue.main.async {
            self.clusterManager.reload(mapView: self.mapView)
        }
    }
    
    
//    //////////////////////////CHECK FOR CURRENT PARKING
    
    func checkCurrentParking() {
        var avgRating: Double = 5
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded, with: { (snapshot) in
                CurrentParkingViewController().checkCurrentParking()
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
                            
                            let geoCoder = CLGeocoder()
                            geoCoder.geocodeAddressString(parkingAddress!) { (placemarks, error) in
                                guard
                                    let placemarks = placemarks,
                                    let location = placemarks.first?.location
                                    else {
                                        // handle no location found
                                        return
                                }
                                DispatchQueue.main.async(execute: {
                                    if let myLocation: CLLocation = self.mapView.userLocation.location {
                                        let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
                                        let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                                        let formattedDistance = String(format: "%.1f", roundedStepValue)
                                        
                                        self.destination = location
                                        self.currentData = .yesReserved
                                        self.drawCurrentPath(dest: location)
                                        
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
                                                    self.swipeTutorial.alpha = 0
                                                })
                                            })
                                        } else {
                                            self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
                                            UIView.animate(withDuration: 0.5, animations: {
                                                currentButton.alpha = 1
                                                self.swipeTutorial.alpha = 0
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
                self.currentActive = false
                self.observeUserParkingSpots()
                DispatchQueue.main.async {
                    self.clusterManager.reload(mapView: self.mapView)
                }
                self.currentParkingDisappear()
                CurrentParkingViewController().stopTimerTest()
            }, withCancel: nil)
        } else {
            return
        }
    }
    
    func drawCurrentPath(dest: CLLocation) {
        let annotations = self.mapView.annotations
        self.clusterManager.remove(annotations)
        self.mapView.removeAnnotations(annotations)
        self.currentActive = true
        
        let marker = Annotation()
        marker.title = "Destination"
        marker.coordinate = dest.coordinate
        let color = Theme.PRIMARY_COLOR
        marker.style = .color(color, radius: 25)
        self.mapView.addAnnotation(marker)
        
        let sourceCoordinates = self.locationManager.location?.coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: dest.coordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
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
            self.mapView.add(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        })
    }
    
    var annotationSelected: MKAnnotation?
    var currentActive: Bool = false
    
    func saveUserCurrentLocation() {
        userLocation = self.mapView.userLocation.location
    }
    
    
//    ////////////////////////////// BEGIN MAPVIEW DELEGATE
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let style = annotation.style else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? BorderedClusterAnnotationView {
                view.annotation = annotation
                view.style = style
                view.configure()
            } else {
                view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, style: style, borderColor: .white)
            }
            return view
        } else {
            guard let annotation = annotation as? Annotation else { return nil }
            if #available(iOS 11.0, *) {
                return AvailableAnnotationView(annotation: annotation, reuseIdentifier: AvailableAnnotationView.ReuseID)
            } else {
                let annotationIdentifier = "AnnotationIdentifier"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
                
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                }
                
                let pinImage = UIImage(named: "parkingMarker")
                annotationView!.image = pinImage
                annotationView!.frame.size = CGSize(width: 30, height: 35)
                annotationView!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
                return annotationView
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if currentActive == false {
            clusterManager.reload(mapView: mapView) { finished in
                print("")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        self.annotationSelected = annotation
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else if annotation.subtitle! != nil && annotation.subtitle! != "" {
            self.swipeTutorialCheck()
            self.checkForCoupons()
            if let string = view.annotation!.subtitle, string != nil {
                if let intFromString = Int(string!) {
                    if parkingSpots.count >= intFromString {
                        let parking = parkingSpots[intFromString]
                        self.informationViewController.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!, rating: parking.rating!, message: parking.message!)
                        self.purchaseViewController.setData(parkingCost: parking.parkingCost!, parkingID: parking.parkingID!, id: parking.id!)
                    }
                }
            }
            if #available(iOS 11.0, *) {} else {
                UIView.animate(withDuration: 0.2) {
                    view.transform = CGAffineTransform(scaleX: 2, y: 2)
                }
            }
            
            let location: CLLocationCoordinate2D = annotation.coordinate
            var region = MKCoordinateRegion()
            region.center = location
            region.span.latitudeDelta = 0.001
            region.span.longitudeDelta = 0.001
            self.mapView.setRegion(region, animated: true)
            
            self.purchaseViewController.view.alpha = 1
            UIView.animate(withDuration: 0.3, animations: {
                //
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.purchaseViewAnchor.constant = 0
                    self.swipeTutorial.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    //
                }
            }
        }
        searchBar.attributedPlaceholder = NSAttributedString(string: "",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        UIView.animate(withDuration: 0.3, animations: {
            self.textSearchBarFarRightAnchor.isActive = false
            self.textSearchBarCloseRightAnchor.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.purchaseButtonSwipedDown()
        guard let annotation = view.annotation else { return }
        if annotation is ClusterAnnotation {} else {
            UIView.animate(withDuration: 0.2) {
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.couponStaus.alpha = 0
                self.swipeLabel.alpha = 0
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
}

class BorderedClusterAnnotationView: ClusterAnnotationView {
    let borderColor: UIColor
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle, borderColor: UIColor) {
        self.borderColor = borderColor
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        switch style {
        case .image:
            layer.borderWidth = 0
        case .color:
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 2
        }
    }
}





