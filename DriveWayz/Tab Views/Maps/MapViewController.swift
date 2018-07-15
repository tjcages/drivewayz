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

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var tabPull: UIView!
    let pageControl = UIPageControl()
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
    
    var driveWayzLogo: UIImageView!
    var arrow: UIButton!
    var containerView: UIView!
    
    lazy var topWrap: UIView = {
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160))
        containerView.backgroundColor = Theme.SEETHROUGH_PRIMARY
        containerView.alpha = 0.9
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        containerView.layer.shadowOpacity = 0.8
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.7
        containerView.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        arrow = UIButton(type: .custom)
        let arrowImage = UIImage(named: "Expand")
        arrow.setImage(arrowImage, for: .normal)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.tintColor = Theme.PRIMARY_COLOR
        arrow.addTarget(self, action: #selector(minimizeTopView), for: .touchUpInside)
        containerView.addSubview(arrow)

        return containerView
    }()
    
    lazy var bottomTabBarController: UIView = {
        
        let containerBar = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        containerBar.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.9
        containerBar.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true
        
        rightArrow = UIButton(type: .custom)
        let arrowRightImage = UIImage(named: "Expand")
        let tintedRightImage = arrowRightImage?.withRenderingMode(.alwaysTemplate)
        rightArrow.setImage(tintedRightImage, for: .normal)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        rightArrow.tintColor = Theme.PRIMARY_COLOR
        rightArrow.addTarget(self, action: #selector(tabBarRight), for: .touchUpInside)
        containerBar.addSubview(rightArrow)
        
        rightArrow.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -32).isActive = true
        rightArrow.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        rightArrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rightArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        return containerBar
    }()
    
    let mapView: GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 100)
        return view
    }()
    
    let searchBar: UITextField = {
        let search = UITextField()
        search.borderStyle = .roundedRect
        search.backgroundColor = .white
        search.layer.borderColor = UIColor.darkGray.cgColor
        search.placeholder = "Search.."
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    let locatorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setImage(#imageLiteral(resourceName: "my_location"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.tintColor = UIColor.gray
        button.imageView?.tintColor = UIColor.gray
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
    
    lazy var currentParkingController: CurrentParkingViewController = {
        let controller = CurrentParkingViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Current Parking"
        return controller
    }()
    
    var expand: UIView = {
        let expand = UIView()
        expand.translatesAutoresizingMaskIntoConstraints = false
        expand.backgroundColor = Theme.WHITE
        expand.layer.cornerRadius = 10
        expand.alpha = 0
        expand.isUserInteractionEnabled = true
        
        let label = UILabel()
        label.text = "Current parking"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_COLOR
        label.textAlignment = .center
        
        expand.addSubview(label)
        label.centerXAnchor.constraint(equalTo: expand.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: expand.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: expand.heightAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: expand.widthAnchor).isActive = true
        
        return expand
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.isHidden = true
        mapView.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        let logoImage = UIImage(named: "DriveWayz")
        driveWayzLogo = UIImageView(image: logoImage)
        driveWayzLogo.translatesAutoresizingMaskIntoConstraints = false
        driveWayzLogo.contentMode = .scaleAspectFit
        
        locationManager.delegate = self
        parkingTableView.delegate = self
        parkingTableView.dataSource = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()

        fetchUserEmail()
        locationAuthStatus()
        setupViews()
        setupViewController()
        setupBottomTab()
        setupPageControl()
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
                                        self.expand.alpha = 1
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
                        self.mapView.animate(toZoom: 17.0)
                    }
                    UIView.animate(withDuration: 0.5, animations: {
                        self.expand.alpha = 0
                    })
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
                        let myLocation: CLLocation? = self.mapView.myLocation
                        let distanceToParking = (location.distance(from: myLocation!)) / 1609.34 // miles
                        let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                        let formattedDistance = String(format: "%.1f", roundedStepValue)
                        dictionary.updateValue(formattedDistance as AnyObject, forKey: "parkingDistance")
                        
                        let parking = ParkingSpots(dictionary: dictionary)
                        let parkingID = dictionary["parkingID"] as! String
                        self.parkingSpotsDictionary[parkingID] = parking
                        self.reloadOfTable()
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
    var optionsBlurEffectView: UIVisualEffectView!
    var optionsTabViewConstraint: NSLayoutConstraint!
    var buttonHeightConstraint: NSLayoutConstraint!
    var textSearchBarRightAnchor: NSLayoutConstraint!
    var tabPullConstraint: NSLayoutConstraint!
    var driveWayzContraint: NSLayoutConstraint!
    var arrowConstraint: NSLayoutConstraint!
    var mapViewConstraint: NSLayoutConstraint!
    var buttonLocatorConstraint: NSLayoutConstraint!
    var topWapConstraint: NSLayoutConstraint!
    
    func setupViews() {
        
//        parkingPreviewView = ParkingPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 120))
        
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
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive = true
        
        view.addSubview(topWrap)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        topWrap.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topWrap.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topWrap.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -statusBarHeight).isActive = true
        topWrap.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        tabPull = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 90))
        let maskPath = UIBezierPath(roundedRect: tabPull.bounds,
                                    byRoundingCorners: [.topRight, .bottomRight],
                                    cornerRadii: CGSize(width: 15, height: 15))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = Theme.PRIMARY_COLOR.cgColor
        borderLayer.lineWidth = 4
        borderLayer.frame = tabPull.bounds
        tabPull.layer.addSublayer(borderLayer)
        tabPull.layer.mask = shape
        tabPull.translatesAutoresizingMaskIntoConstraints = false
        tabPull.backgroundColor = UIColor.groupTableViewBackground
        tabPull.alpha = 0.8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionsTabGestureTapped))
        tabPull.addGestureRecognizer(tapGesture)
        self.view.insertSubview(tabPull, belowSubview: optionsTabView)
        
        tabPullConstraint = tabPull.leftAnchor.constraint(equalTo: optionsTabView.leftAnchor, constant: 213)
        tabPullConstraint.isActive = true
        tabPull.topAnchor.constraint(equalTo: topWrap.bottomAnchor, constant: 10).isActive = true
        tabPull.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tabPull.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let tabLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tabLabel.text = "Spots"
        tabLabel.translatesAutoresizingMaskIntoConstraints = false
        tabLabel.textColor = Theme.PRIMARY_DARK_COLOR
        tabLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        tabLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        tabPull.addSubview(tabLabel)
        optionsTabView.sendSubview(toBack: tabPull)
        
        tabLabel.leftAnchor.constraint(equalTo: tabPull.leftAnchor, constant: -8).isActive = true
        tabLabel.topAnchor.constraint(equalTo: tabPull.topAnchor, constant: 35).isActive = true

        self.view.addSubview(driveWayzLogo)
        self.view.bringSubview(toFront: driveWayzLogo)
        
        driveWayzLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        driveWayzContraint = driveWayzLogo.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor, constant: 90)
        driveWayzContraint.isActive = true
        driveWayzLogo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        driveWayzLogo.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(searchBar)
        
        searchBar.topAnchor.constraint(equalTo: driveWayzLogo.bottomAnchor, constant: 10).isActive = true
        searchBar.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor, constant: 10).isActive = true
        textSearchBarRightAnchor = searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        textSearchBarRightAnchor.isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        let searchImage = UIImage(named: "map_Pin")
        setupTextField(textField: searchBar, img: searchImage!)
        
        arrow.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32).isActive = true
        arrowConstraint = arrow.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor, constant: 8)
        arrowConstraint.isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(locatorButton)
        
        buttonHeightConstraint = locatorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        buttonHeightConstraint.isActive = true
        buttonLocatorConstraint = locatorButton.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor, constant: 20)
        buttonLocatorConstraint.isActive = true
        locatorButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        locatorButton.heightAnchor.constraint(equalTo: locatorButton.widthAnchor).isActive = true
        
        view.bringSubview(toFront: mapView)
        view.bringSubview(toFront: topWrap)
        view.bringSubview(toFront: tabPull)
        view.bringSubview(toFront: arrow)
        view.bringSubview(toFront: locatorButton)
        view.bringSubview(toFront: searchBar)
        view.bringSubview(toFront: driveWayzLogo)

    }
    
    var currentParkingControllerAnchor: NSLayoutConstraint!
    var expandTopAnchor: NSLayoutConstraint!
    
    func setupViewController() {
        
        self.view.addSubview(expand)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(updateCurrentView))
        expand.addGestureRecognizer(gesture)
        expandTopAnchor = expand.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -95)
        expandTopAnchor.isActive = true
        expand.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        expand.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
        expand.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func updateCurrentView() {
        let currentView = CurrentParkingViewController()
        self.navigationController?.pushViewController(currentView, animated: true)
    }
    
    @objc func optionsTabGestureTapped(_ sender: UITapGestureRecognizer) {
        if optionsTabViewConstraint.constant == -215 {
            self.optionsTabViewConstraint.constant = 0
            self.arrow.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.optionsTabAnimations()
            }
        } else {
            self.optionsTabViewConstraint.constant = -215
            self.arrow.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.optionsTabAnimations()
            }
        }
    }
    
    func optionsTabAnimations() {
        if self.optionsTabViewConstraint.constant == 0 {
            self.textSearchBarRightAnchor.constant = 225
            self.topWrap.frame = CGRect(x: 215, y: 0, width: self.view.frame.width - 215, height: 160)
        } else {
            self.textSearchBarRightAnchor.constant = -10
            self.topWrap.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        }
        UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func setupBottomTab() {
        self.view.addSubview(bottomTabBarController)
        
        bottomTabBarController.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomTabBarController.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomTabBarController.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomTabBarController.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupPageControl() {
        
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_DARK_COLOR
        self.pageControl.pageIndicatorTintColor = Theme.PRIMARY_COLOR
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -200).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
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
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        mapView.camera = camera
        searchBar.text = place.formattedAddress
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
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
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
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
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
            mapView.animate(toZoom: 17.0)
        }
    }
    
    @objc func markerTapped(tag: Int, marker: GMSMarker) {
        let detailedView = ParkingDetailsViewController()
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let parking = parkingSpots[customMarkerView.tag]
        detailedView.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!)
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
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    @objc func minimizeTopView() {
        self.topWrap.frame.size.height = 80
        self.buttonHeightConstraint.constant = -60
        self.optionsTabViewConstraint.constant = -240
        self.driveWayzContraint.constant = 115
        self.arrowConstraint.constant = 33
        self.mapViewConstraint.constant = 0
        self.buttonLocatorConstraint.constant = 45
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.searchBar.alpha = 0
            self.arrow.transform = CGAffineTransform(scaleX: 1, y: -1)
        }) { (success: Bool) in
            self.arrow.removeTarget(self, action: #selector(self.minimizeTopView), for: .touchUpInside)
            self.arrow.addTarget(self, action: #selector(self.maximizeTopView), for: .touchUpInside)
        }
    }
    
    @objc func maximizeTopView() {
        self.topWrap.frame.size.height = 160
        self.buttonHeightConstraint.constant = -60
        self.optionsTabViewConstraint.constant = -215
        self.driveWayzContraint.constant = 90
        self.arrowConstraint.constant = 8
        self.mapViewConstraint.constant = 0
        self.buttonLocatorConstraint.constant = 20
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.searchBar.alpha = 1
            self.arrow.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (success: Bool) in
            self.arrow.removeTarget(self, action: #selector(self.maximizeTopView), for: .touchUpInside)
            self.arrow.addTarget(self, action: #selector(self.minimizeTopView), for: .touchUpInside)
        }
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
        detailedView.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!)
        self.navigationController?.pushViewController(detailedView, animated: true)
        self.optionsTabViewConstraint.constant = -215
        self.arrow.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.optionsTabAnimations()
        }
    }
    
    
    @objc func tabBarRight() {
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.selectedIndex = 1
        }, completion: nil)
    }
    @objc func tabBarLeft() {
        print("Leftmost VC")
    }

}












