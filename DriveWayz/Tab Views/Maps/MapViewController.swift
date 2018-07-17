//
//  MapViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GeoFire
import Alamofire
import SwiftyJSON

struct Parking {
    var name: String
    var lattitude: Double
    var longitude: Double
}

var userEmail: String?

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    let cellId = "cellId"
    var currentActive: Bool = false
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var places: Parking?
    var currentPolyline = [GMSPolyline]()
    
    var parkingSpots = [ParkingSpots]()
    var parkingSpotsDictionary = [String: ParkingSpots]()
    var parkingAvailability = [ParkingSpots]()
    var parkingAvailabilityDictionary = [String: String]()
    var destination: CLLocation?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    var topSearch: UIButton = {
        let search = UIButton(type: .custom)
        let image = UIImage(named: "Search")
        search.setImage(image, for: .normal)
        search.translatesAutoresizingMaskIntoConstraints = false
        search.addTarget(self, action: #selector(animateSearchBar(sender:)), for: .touchUpInside)

        return search
    }()
    
    lazy var tabPull: UIView = {
        let tabPull = UIView()
        tabPull.layer.cornerRadius = 20
        tabPull.translatesAutoresizingMaskIntoConstraints = false
        tabPull.backgroundColor = Theme.PRIMARY_COLOR
        tabPull.alpha = 0.9
        
        return tabPull
    }()
    
    var tabFeed: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "feed")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionsTabGestureTapped))
        button.addTarget(self, action: #selector(optionsTabGestureTapped(sender:)), for: .touchUpInside)
        let gestureOpen = UISwipeGestureRecognizer(target: self, action: #selector(optionsTabGestureSwiped(sender:)))
        gestureOpen.direction = .right
        button.addGestureRecognizer(gestureOpen)
        
        return button
    }()
    
    let mapView: GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 100)
        
        return view
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
    
    let locatorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.PRIMARY_DARK_COLOR
        let image = UIImage(named: "my_location")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 20
        button.alpha = 0.9
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.8
        button.addTarget(self, action: #selector(locatorButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var parkingPreviewView: ParkingPreviewView = {
        let preview = ParkingPreviewView()
        preview.layer.cornerRadius = 15
        preview.clipsToBounds = true
        preview.backgroundColor = UIColor.clear
        preview.layer.backgroundColor = UIColor.clear.cgColor
        return preview
    }()
    
    var parkingTableView: UITableView = {
       let parking = UITableView()
        parking.translatesAutoresizingMaskIntoConstraints = false
        return parking
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        return view
    }()
    
    lazy var purchaseViewController: ParkingDetailsViewController = {
        let controller = ParkingDetailsViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Purchase Controller"
        controller.view.layer.cornerRadius = 10
        
        return controller
    }()
    
    var hoursButton: dropDownButton = {
        let hours = dropDownButton()
        hours.translatesAutoresizingMaskIntoConstraints = false
        hours.backgroundColor = Theme.WHITE
        hours.setTitleColor(Theme.DARK_GRAY, for: .normal)
        hours.setTitle("^ hours", for: .normal)
        hours.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        hours.dropView.dropDownOptions = ["1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours", "11 hours", "12 hours"]
        hours.layer.cornerRadius = 10

        return hours
    }()
    
    lazy var container: UIView = {
        let containerBar = UIView()
        containerBar.translatesAutoresizingMaskIntoConstraints = false
        containerBar.backgroundColor = UIColor.clear
        let gestureOpen = UISwipeGestureRecognizer(target: self, action: #selector(optionsTabGestureSwiped(sender:)))
        gestureOpen.direction = .right
        containerBar.addGestureRecognizer(gestureOpen)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(optionsTabGestureSwiped(sender:)))
        gesture.direction = .left
        containerBar.addGestureRecognizer(gesture)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 1
        containerBar.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true
        
        let whiteView = UIButton(type: .custom)
        whiteView.backgroundColor = UIColor.white
        whiteView.alpha = 0.5
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.isUserInteractionEnabled = false
        containerBar.insertSubview(whiteView, belowSubview: blurView)
        
        whiteView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        whiteView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true
        
        return containerBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = true
        mapView.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        locationManager.delegate = self
        parkingTableView.delegate = self
        parkingTableView.dataSource = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()

        setupViews()
        setupViewController()
        fetchUserEmail()
        locationAuthStatus()
        checkCurrentParking()
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkCurrentParking()
    }
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.isMyLocationEnabled = true
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            observeUserParkingSpots()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkCurrentParking() {
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
                currentRef.observe(.childAdded, with: { (snapshot) in
                    CurrentParkingViewController().checkCurrentParking()
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        let parkingID = dictionary["parkingID"] as? String
                        let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                        parkingRef.observeSingleEvent(of: .value, with: { (pull) in
                            if let pullRef = pull.value as? [String:AnyObject] {
                                let parkingAddress = pullRef["parkingAddress"] as? String
                                let geoCoder = CLGeocoder()
                                geoCoder.geocodeAddressString(parkingAddress!) { (placemarks, error) in
                                    guard
                                        let placemarks = placemarks,
                                        let location = placemarks.first?.location
                                        else {
                                            print("Couldn't find location.")
                                            return
                                    }
                                    self.destination = location
                                    self.drawPath(endLocation: location)
                                    UIView.animate(withDuration: 0.5, animations: {

                                    })
                                }
                            }
                        })
                    }
                }, withCancel: nil)
                currentRef.observe(.childRemoved, with: { (snapshot) in
                    for poly in (0..<self.currentPolyline.count) {
                        self.currentPolyline[poly].map = nil
                    }
                    let location: CLLocation? = self.mapView.myLocation
                    if location != nil {
                        self.mapView.animate(toLocation: (location?.coordinate)!)
                        self.mapView.animate(toZoom: 15.0)
                    }
                    UIView.animate(withDuration: 0.5, animations: {
                        
                    })
                    CurrentParkingViewController().stopTimerTest()
                    self.navigationController?.popViewController(animated: true)
                }, withCancel: nil)
            } else {
                return
            }
    }
    
    func observeUserParkingSpots() {
        if Auth.auth().currentUser?.uid != nil {
            print("Welcome User")
        } else {
            return
        }
        let ref = Database.database().reference().child("user-parking")
        ref.observe(.childAdded, with: { (snapshot) in
            let parkingID = [snapshot.key]
            self.fetchParking(parkingID: parkingID)
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
            self.parkingSpotsDictionary.removeValue(forKey: snapshot.key)
            self.reloadOfTable()
        }, withCancel: nil)
    }
    
    func fetchUserEmail() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                userEmail = dictionary["email"] as? String
            }
        }, withCancel: nil)
        return
    }
    
    private func fetchParking(parkingID: [String]) {
        for parking in parkingID {
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
                            let myLocation: CLLocation? = self.mapView.myLocation
                            let distanceToParking = (location.distance(from: myLocation!)) / 1609.34 // miles
                            let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                            let formattedDistance = String(format: "%.1f", roundedStepValue)
                            dictionary.updateValue(formattedDistance as AnyObject, forKey: "parkingDistance")
                            
                            let parking = ParkingSpots(dictionary: dictionary)
                            let parkingID = dictionary["parkingID"] as! String
                            self.parkingSpotsDictionary[parkingID] = parking
                            self.reloadOfTable()
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
            self.parkingTableView.reloadData()
            self.showPartyMarkers()
        })
    }
    
    var optionsTabView: UIView!
    var optionsTabViewConstraint: NSLayoutConstraint!
    var textSearchBarFarRightAnchor: NSLayoutConstraint!
    var textSearchBarCloseRightAnchor: NSLayoutConstraint!
    var mapViewConstraint: NSLayoutConstraint!
    var tabPullWidthShort: NSLayoutConstraint!
    var tabPullWidthLong: NSLayoutConstraint!
    
    func setupViews() {
        
        optionsTabView = UIView()
        optionsTabView.translatesAutoresizingMaskIntoConstraints = false
        optionsTabView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(optionsTabView)
        
        optionsTabViewConstraint = optionsTabView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -215)
        optionsTabViewConstraint.isActive = true
        optionsTabView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        optionsTabView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        optionsTabView.widthAnchor.constraint(equalToConstant: 215).isActive = true
        
        let parkingView = UIView()
        parkingView.backgroundColor = Theme.PRIMARY_DARK_COLOR
        parkingView.alpha = 0.8
        parkingView.translatesAutoresizingMaskIntoConstraints = false
        parkingView.layer.borderColor = Theme.DARK_GRAY.cgColor
        parkingView.layer.borderWidth = 3
        parkingView.clipsToBounds = false
        optionsTabView.addSubview(parkingView)
        
        parkingView.leftAnchor.constraint(equalTo: optionsTabView.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
        parkingView.topAnchor.constraint(equalTo: optionsTabView.topAnchor).isActive = true
        parkingView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let parkingLabel = UILabel()
        parkingLabel.text = "Parking:"
        parkingLabel.textColor = UIColor.white
        parkingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        parkingLabel.translatesAutoresizingMaskIntoConstraints = false
        parkingLabel.textAlignment = .center
        parkingView.addSubview(parkingLabel)
        
        parkingLabel.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
        parkingLabel.centerYAnchor.constraint(equalTo: parkingView.centerYAnchor, constant: 10).isActive = true
        parkingLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(parkingTableView)
        parkingTableView.leftAnchor.constraint(equalTo: optionsTabView.leftAnchor).isActive = true
        parkingTableView.rightAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
        parkingTableView.bottomAnchor.constraint(equalTo: optionsTabView.bottomAnchor, constant: -50).isActive = true
        parkingTableView.topAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
        
        let shadow = UIImageView()
        shadow.backgroundColor = UIColor.darkGray
        shadow.layer.shadowColor = Theme.DARK_GRAY.cgColor
        shadow.layer.shadowRadius = 5
        shadow.layer.shadowOpacity = 0.8
        shadow.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(shadow)
        
        shadow.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
        shadow.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        shadow.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        shadow.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        mapView.layer.shadowColor = Theme.DARK_GRAY.cgColor
        mapView.layer.shadowOpacity = 0.8
        mapView.layer.shadowRadius = 5
        mapView.isUserInteractionEnabled = true
        
        self.view.addSubview(mapView)
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
        mapViewConstraint = mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        mapViewConstraint.isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.insertSubview(tabPull, belowSubview: optionsTabView)
        tabPull.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -20).isActive = true
        tabPull.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        tabPullWidthShort = tabPull.widthAnchor.constraint(equalToConstant: 60)
            tabPullWidthShort.isActive = true
        tabPullWidthLong = tabPull.widthAnchor.constraint(equalToConstant: 80)
        tabPullWidthLong.isActive = false
        tabPull.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tabPull.addSubview(tabFeed)
        tabFeed.widthAnchor.constraint(equalToConstant: 25).isActive = true
        tabFeed.heightAnchor.constraint(equalToConstant: 25).isActive = true
        tabFeed.centerYAnchor.constraint(equalTo: tabPull.centerYAnchor).isActive = true
        tabFeed.rightAnchor.constraint(equalTo: tabPull.rightAnchor, constant: -10).isActive = true
        
        view.addSubview(topSearch)
        topSearch.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
        topSearch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        topSearch.widthAnchor.constraint(equalToConstant: 40).isActive = true
        topSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        locatorButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        locatorButton.centerXAnchor.constraint(equalTo: topSearch.centerXAnchor).isActive = true
        locatorButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        locatorButton.heightAnchor.constraint(equalTo: locatorButton.widthAnchor).isActive = true
        
        view.bringSubview(toFront: tabPull)
        view.bringSubview(toFront: locatorButton)

    }
    
    var currentParkingControllerAnchor: NSLayoutConstraint!
    var expandTopAnchor: NSLayoutConstraint!
    
    func setupViewController() {
        
        self.view.addSubview(purchaseViewController.view)
        purchaseViewController.didMove(toParentViewController: self)
        purchaseViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -65).isActive = true
        purchaseViewController.view.widthAnchor.constraint(equalToConstant: 300).isActive = true
        purchaseViewController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(hoursButton)
        hoursButton.rightAnchor.constraint(equalTo: purchaseViewController.view.rightAnchor).isActive = true
        hoursButton.topAnchor.constraint(equalTo: purchaseViewController.view.topAnchor).isActive = true
        hoursButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hoursButton.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
    }
    
    @objc func updateCurrentView() {
        //
    }
    
    @objc func optionsTabGestureTapped(sender: UIButton) {
        optionsTabGesture()
    }
    
    @objc func optionsTabGestureSwiped(sender: UITapGestureRecognizer) {
        optionsTabGesture()
    }
    
    @objc func optionsTabGesture() {
        if optionsTabViewConstraint.constant == -215 {
            self.optionsTabViewConstraint.constant = 0
            self.topSearch.isUserInteractionEnabled = false
            self.tabPullWidthShort.isActive = false
            self.tabPullWidthLong.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.optionsTabAnimations()
            }
        } else {
            self.optionsTabViewConstraint.constant = -215
            self.topSearch.isUserInteractionEnabled = true
            self.tabPullWidthShort.isActive = true
            self.tabPullWidthLong.isActive = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.optionsTabAnimations()
            }
        }
    }
    
    func optionsTabAnimations() {
        if self.optionsTabViewConstraint.constant == 0 {
            self.textSearchBarFarRightAnchor.constant = 225
        } else {
            self.textSearchBarFarRightAnchor.constant = -10
        }
        UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
        }, completion: nil)
        
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
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        mapView.camera = camera
        searchBar.text = place.formattedAddress
        
        UIView.animate(withDuration: 0.3) {
            self.textSearchBarFarRightAnchor.constant = self.view.frame.width * 1/4
            self.view.layoutIfNeeded()
        }
        
        places = Parking(name: place.formattedAddress!, lattitude: lat, longitude: long)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = mapView
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locationManager.delegate = nil
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let imageURL = customMarkerView.parkingImageURL!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), parkingImageURL: imageURL, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let parking = parkingSpots[customMarkerView.tag]
        let infoWindow = MapMarkerWindowView.instanceFromNib() as! MapMarkerWindowView
        infoWindow.setData(city: parking.parkingCity!, distance: parking.parkingDistance!, price: parking.parkingCost!)
        
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        markerTapped(tag: tag, marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let imageURL = customMarkerView.parkingImageURL
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), parkingImageURL: imageURL!, borderColor: Theme.PRIMARY_COLOR, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
            mapView.animate(to: camera)
            
            if let currentDestination = self.destination {
                let direction = getBearingBetweenTwoPoints1(point1 : mapView.myLocation!, point2 : currentDestination)
                let heading = GMSOrientation.init(heading: direction, pitch: 0.0)
//                    .maps.geometry.spherical.computeHeading(mapView.myLocation,currentDestination)
                mapView.animate(toBearing: heading.heading)
            }
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
    
    func showPartyMarkers() {
        mapView.clear()
        for number in 0...(parkingSpots.count - 1) {
            let marker = GMSMarker()
            let parking = parkingSpots[number]
            
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), parkingImageURL: parking.parkingImageURL!, borderColor: Theme.PRIMARY_COLOR, tag: number)
            marker.iconView = customMarker
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(parking.parkingAddress!) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    return
                }
                marker.position = location.coordinate
            }
            marker.map = self.mapView
        }
    }
    
    @objc func locatorButtonAction() {
//        locationAuthStatus()
        let location: CLLocation? = mapView.myLocation
        if location != nil {
            mapView.animate(toLocation: (location?.coordinate)!)
            mapView.animate(toZoom: 15.0)
        }
    }
    
    @objc func markerTapped(tag: Int, marker: GMSMarker) {
        let detailedView = ParkingDetailsViewController()
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let parking = parkingSpots[customMarkerView.tag]
//        detailedView.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!)
        self.navigationController?.pushViewController(detailedView, animated: true)
    }
    
    func drawPath(endLocation: CLLocation) {
        let myLocation = mapView.myLocation
        let origin = "\(myLocation!.coordinate.latitude),\(myLocation!.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            if let json = try? JSON(data: response.data!) {
                let routes = json["routes"].arrayValue
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = Theme.PRIMARY_COLOR
                    polyline.map = self.mapView
                    self.currentPolyline.append(polyline)
                    
                    let bounds = GMSCoordinateBounds(coordinate: (myLocation?.coordinate)!, coordinate: endLocation.coordinate)
                    if self.currentActive == false {
                        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(160, 120, 160, 120))
                        self.mapView.animate(with: update)
                    }
                    self.currentActive = true
                }
            }
        }
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
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = Bundle.main.loadNibNamed("ParkingTableViewCell", owner: self, options: nil)?.first as! ParkingTableViewCell
            cell.selectedBackgroundView?.backgroundColor = UIColor.groupTableViewBackground
            cell.cellView.backgroundColor = UIColor.white
            let parking = parkingSpots[indexPath.row]
            cell.parkingSpotImage.loadImageUsingCacheWithUrlString(parking.parkingImageURL!)
            cell.parkingSpotCity.text = parking.parkingCity
            cell.parkingSpotCost.text = parking.parkingCost
            cell.parkingDistance.text = "\(String(describing: parking.parkingDistance!)) miles"
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parkingSpots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailedView = ParkingDetailsViewController()
            let parking = parkingSpots[indexPath.row]
            //        detailedView.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!)
            self.navigationController?.pushViewController(detailedView, animated: true)
            self.optionsTabViewConstraint.constant = -215
            self.topSearch.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.optionsTabAnimations()
            }
    }
    
    
    
}












