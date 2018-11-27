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
import UserNotifications

struct Parking {
    var name: String
    var lattitude: Double
    var longitude: Double
}

var userEmail: String?
var couponActive: Int?

var currentButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = Theme.HARMONY_RED
    button.layer.shadowColor = Theme.DARK_GRAY.cgColor
    button.layer.shadowOffset = CGSize(width: 1, height: 1)
    button.layer.shadowRadius = 1
    button.layer.shadowOpacity = 0.8
    button.layer.cornerRadius = 5
    button.alpha = 0
    button.setTitle("Current Parking", for: .normal)
    button.titleLabel?.font = Fonts.SSPSemiBoldH5
    button.titleLabel?.textColor = Theme.WHITE
    
    return button
}()

protocol removePurchaseView {
    func currentParkingSender()
    func currentParkingDisappear()
    func purchaseButtonSwipedDown()
    func sendAvailability(availability: Bool)
    func setupLeaveAReview(parkingID: String)
    func removeLeaveAReview()
    func showPurchaseStatus(status: Bool)
    func addAVehicleReminder()
    func openMessages()
}

protocol controlHoursButton {
    func openHoursButton()
    func closeHoursButton()
    func drawCurrentPath(dest: CLLocation, navigation: Bool)
    func currentParkingDisappear()
    func hideNavigation()
}

protocol controlNewHosts {
    func sendNewHost()
}

class MapViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, GMSMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UIScrollViewDelegate {

//    let cellId = "cellId"
//    var currentActive: Bool = false
//    var delegate: moveControllers?
//    var vehicleDelegate: controlsNewParking?
//
//    let currentLocationMarker = GMSMarker()
//    var locationManager = CLLocationManager()
//    var places: Parking?
//    var currentPolyline = [GMSPolyline]()
//
//    var parkingSpots = [ParkingSpots]()
//    var parkingSpotsDictionary = [String: ParkingSpots]()
//    var parkingAvailability = [ParkingSpots]()
//    var parkingAvailabilityDictionary = [String: String]()
//    var destination: CLLocation?
//
//    let customMarkerWidth: Int = 50
//    let customMarkerHeight: Int = 70
//
//    enum CurrentData {
//        case notReserved
//        case yesReserved
//    }
//    var currentData: CurrentData = CurrentData.notReserved
//
//    var topSearch: UIButton = {
//        let search = UIButton(type: .custom)
//        let image = UIImage(named: "Search")
//        search.setImage(image, for: .normal)
//        search.translatesAutoresizingMaskIntoConstraints = false
//        search.addTarget(self, action: #selector(animateSearchBar(sender:)), for: .touchUpInside)
//
//        return search
//    }()
//
//    var tabFeed: UIButton = {
//        let button = UIButton(type: .custom)
//        let image = UIImage(named: "feed")
//        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
//        button.setImage(tintedImage, for: .normal)
//        button.tintColor = Theme.WHITE
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionsTabGestureTapped))
//        button.addTarget(self, action: #selector(optionsTabGestureTapped(sender:)), for: .touchUpInside)
//        button.backgroundColor = Theme.SEA_BLUE
//        button.layer.cornerRadius = 20
//        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        button.layer.shadowOffset = CGSize(width: 1, height: 1)
//        button.layer.shadowRadius = 1
//        button.layer.shadowOpacity = 0.8
//        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
//        button.alpha = 0.9
//
//        return button
//    }()
//
//    let mapView: GMSMapView = {
//        let view = GMSMapView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 100)
//
//        return view
//    }()
//
//    let searchBar: UITextField = {
//        let search = UITextField()
//        search.layer.cornerRadius = 20
//        search.backgroundColor = Theme.SEA_BLUE
//        search.textColor = Theme.WHITE
//        search.alpha = 0.9
//        search.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        search.layer.shadowOffset = CGSize(width: 1, height: 1)
//        search.layer.shadowRadius = 1
//        search.layer.shadowOpacity = 0.8
//        search.attributedPlaceholder = NSAttributedString(string: "",
//                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        search.translatesAutoresizingMaskIntoConstraints = false
//        return search
//    }()
//
//    let locatorButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = Theme.SEA_BLUE
//        let image = UIImage(named: "my_location")
//        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
//        button.setImage(tintedImage, for: .normal)
//        button.tintColor = Theme.WHITE
//        button.layer.cornerRadius = 20
//        button.alpha = 0.9
//        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        button.layer.shadowOffset = CGSize(width: 1, height: 1)
//        button.layer.shadowRadius = 1
//        button.layer.shadowOpacity = 0.8
//        button.addTarget(self, action: #selector(locatorButtonAction), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    var parkingTableView: UITableView = {
//       let parking = UITableView()
//        parking.translatesAutoresizingMaskIntoConstraints = false
//        return parking
//    }()
//
//    lazy var purchaseViewController: SelectPurchaseViewController = {
//        let controller = SelectPurchaseViewController()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        controller.title = "Purchase Controller"
////        controller.delegate = self
////        controller.removeDelegate = self
////        controller.hoursDelegate = self
//
//        return controller
//    }()
//
//    lazy var informationViewController: InformationViewController = {
//        let controller = InformationViewController()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        controller.title = "Information Controller"
////        controller.delegate = self
////        controller.hostDelegate = self
//
//        return controller
//    }()
//
//    lazy var reviewsViewController: LeaveReviewViewController = {
//        let controller = LeaveReviewViewController()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        controller.title = "Reviews Controller"
//        controller.view.alpha = 0
////        controller.delegate = self
//
//        return controller
//    }()
//
//    lazy var fullBlurView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.alpha = 0
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//
//        return blurEffectView
//    }()
//
//    var purchaseStaus: UIButton = {
//        let view = UIButton()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setTitle("", for: .normal)
//        view.titleLabel?.textColor = Theme.WHITE
//        view.titleLabel?.font = Fonts.SSPSemiBoldH5
//        view.titleLabel?.textAlignment = .center
//        view.titleLabel?.numberOfLines = 2
//        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
//        view.alpha = 0
//        view.layer.cornerRadius = 10
//        view.isUserInteractionEnabled = false
//
//        return view
//    }()
//
//    var couponStaus: UIButton = {
//        let view = UIButton()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setTitle("", for: .normal)
//        view.titleLabel?.textColor = Theme.WHITE
//        view.titleLabel?.font = Fonts.SSPSemiBoldH5
//        view.titleLabel?.textAlignment = .center
//        view.titleLabel?.numberOfLines = 2
//        view.backgroundColor = Theme.PACIFIC_BLUE
//        view.alpha = 0
//        view.layer.cornerRadius = 10
//        view.isUserInteractionEnabled = false
//
//        return view
//    }()
//
//    lazy var swipeTutorial: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        let background = CAGradientLayer().lightBlurColor()
//        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
//        view.layer.insertSublayer(background, at: 0)
//        view.alpha = 0
//
//        return view
//    }()
//
//    var swipeLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Swipe up for more info, down to dismiss"
//        label.textColor = Theme.WHITE
//        label.textAlignment = .center
//        label.font = Fonts.SSPSemiBoldH5
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.alpha = 0
//
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
//        mapView.delegate = self
//
//        self.tabBarController?.tabBar.isHidden = true
//
//        locationManager.delegate = self
//        parkingTableView.delegate = self
//        parkingTableView.dataSource = self
//        searchBar.delegate = self
//
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
//
//        setupViews()
//        fetchUserEmail()
//        locationAuthStatus()
//        checkCurrentParking()
//        observeUserParkingSpots()
//        setupViewController()
//        checkForCoupons()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        self.checkCurrentParking()
//    }
//
//    func locationAuthStatus() {
//
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            self.mapView.isMyLocationEnabled = true
//            self.locationManager.startUpdatingLocation()
//            self.locationManager.startMonitoringSignificantLocationChanges()
//            observeUserParkingSpots()
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//
//    func checkCurrentParking() {
//        var avgRating: Double = 5
//        if let userID = Auth.auth().currentUser?.uid {
//            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
//                currentRef.observe(.childAdded, with: { (snapshot) in
////                    CurrentParkingViewController().checkCurrentParking()
//                    if let dictionary = snapshot.value as? [String:AnyObject] {
//                        let parkingID = dictionary["parkingID"] as? String
//                        let parkingRef = Database.database().reference().child("parking").child(parkingID!)
//                        parkingRef.observeSingleEvent(of: .value, with: { (pull) in
//                            if var pullRef = pull.value as? [String:AnyObject] {
//                                let parkingCity = pullRef["parkingCity"] as? String
//                                let parkingImageURL = pullRef["parkingImageURL"] as? String
//                                let parkingCost = pullRef["parkingCost"] as? String
//                                let timestamp = pullRef["timestamp"] as? NSNumber
//                                let id = pullRef["id"] as? String
//                                let parkingID = pullRef["parkingID"] as? String
//                                let parkingAddress = pullRef["parkingAddress"] as? String
//                                let message = pullRef["message"] as? String
//
//                                let geoCoder = CLGeocoder()
//                                geoCoder.geocodeAddressString(parkingAddress!) { (placemarks, error) in
//                                    guard
//                                        let placemarks = placemarks,
//                                        let location = placemarks.first?.location
//                                        else {
//                                            // handle no location found
//                                            return
//                                    }
//                                    DispatchQueue.main.async(execute: {
//                                        if let myLocation: CLLocation = self.mapView.myLocation {
//                                            let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
//                                            let roundedStepValue = Double(round(10 * distanceToParking) / 10)
//                                            let formattedDistance = String(format: "%.1f", roundedStepValue)
//
//                                            self.destination = location
//                                            self.currentData = .yesReserved
//                                            self.drawPath(endLocation: location)
//
//                                            if let rating = pullRef["rating"] as? Double {
//                                                let reviewsRef = parkingRef.child("Reviews")
//                                                reviewsRef.observeSingleEvent(of: .value, with: { (count) in
//                                                    let counting = count.childrenCount
//                                                    if counting == 0 {
//                                                        avgRating = rating
//                                                    } else {
//                                                        avgRating = rating / Double(counting)
//                                                    }
//                                                    self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
//                                                    self.purchaseViewController.setData(parkingCost: parkingCost!, parkingID: parkingID!, id: parkingID!)
//                                                    UIView.animate(withDuration: 0.5, animations: {
//                                                        currentButton.alpha = 1
//                                                        self.swipeTutorial.alpha = 0
//                                                    })
//                                                })
//                                            } else {
//                                                self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
//                                                self.purchaseViewController.setData(parkingCost: parkingCost!, parkingID: parkingID!, id: parkingID!)
//                                                UIView.animate(withDuration: 0.5, animations: {
//                                                    currentButton.alpha = 1
//                                                    self.swipeTutorial.alpha = 0
//                                                    self.purchaseViewController.view.alpha = 0
//                                                    self.view.layoutIfNeeded()
//                                                })
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        })
//                    }
//                }, withCancel: nil)
//                currentRef.observe(.childRemoved, with: { (snapshot) in
//                    for poly in (0..<self.currentPolyline.count) {
//                        self.currentPolyline[poly].map = nil
//                    }
//                    let location: CLLocation? = self.mapView.myLocation
//                    if location != nil {
//                        self.mapView.animate(toLocation: (location?.coordinate)!)
//                        self.mapView.animate(toZoom: 15.0)
//                    }
//                    UIView.animate(withDuration: 0.5, animations: {
//                        currentButton.alpha = 0
//                        self.purchaseViewController.view.alpha = 1
//                        self.view.layoutIfNeeded()
//                    })
//                    self.currentData = .notReserved
//                    self.currentParkingDisappear()
////                    CurrentParkingViewController().stopTimerTest()
//                }, withCancel: nil)
//            } else {
//                return
//            }
//    }
//
//    func observeUserParkingSpots() {
//        let ref = Database.database().reference().child("user-parking")
//        ref.observe(.childAdded, with: { (snapshot) in
//            let parkingID = [snapshot.key]
//            self.fetchParking(parkingID: parkingID)
//        }, withCancel: nil)
//        ref.observe(.childRemoved, with: { (snapshot) in
//            self.parkingSpotsDictionary.removeValue(forKey: snapshot.key)
//            self.reloadOfTable()
//        }, withCancel: nil)
//    }
//
//    func fetchUserEmail() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String:AnyObject] {
//                userEmail = dictionary["email"] as? String
//            }
//        }, withCancel: nil)
//        return
//    }
//
//    private func fetchParking(parkingID: [String]) {
//        for parking in parkingID {
//            var avgRating: Double = 5
//            let messageRef = Database.database().reference().child("parking").child(parking)
//            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                if var dictionary = snapshot.value as? [String:AnyObject] {
//
//                    let parkingAddress = dictionary["parkingAddress"] as! String
//                    let geoCoder = CLGeocoder()
//                    geoCoder.geocodeAddressString(parkingAddress) { (placemarks, error) in
//                        guard
//                            let placemarks = placemarks,
//                            let location = placemarks.first?.location
//                            else {
//                                // handle no location found
//                                return
//                        }
//                        DispatchQueue.main.async(execute: {
//                            if let myLocation: CLLocation = self.mapView.myLocation {
//                                let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
//                                let roundedStepValue = Double(round(10 * distanceToParking) / 10)
//                                let formattedDistance = String(format: "%.1f", roundedStepValue)
//                                dictionary.updateValue(formattedDistance as AnyObject, forKey: "parkingDistance")
//
//                                if let rating = dictionary["rating"] as? Double {
//                                    let reviewsRef = messageRef.child("Reviews")
//                                    reviewsRef.observeSingleEvent(of: .value, with: { (count) in
//                                        let counting = count.childrenCount
//                                        if counting == 0 {
//                                            avgRating = rating
//                                        } else {
//                                            avgRating = rating / Double(counting)
//                                        }
//
//                                        dictionary.updateValue(avgRating as AnyObject, forKey: "rating")
//
//                                        let parking = ParkingSpots(dictionary: dictionary)
//                                        let parkingID = dictionary["parkingID"] as! String
//                                        self.parkingSpotsDictionary[parkingID] = parking
//                                        DispatchQueue.main.async(execute: {
//                                            self.reloadOfTable()
//                                        })
//                                    })
//                                } else {
//                                    dictionary.updateValue(avgRating as AnyObject, forKey: "rating")
//
//                                    let parking = ParkingSpots(dictionary: dictionary)
//                                    let parkingID = dictionary["parkingID"] as! String
//                                    self.parkingSpotsDictionary[parkingID] = parking
//                                    DispatchQueue.main.async(execute: {
//                                        self.reloadOfTable()
//                                    })
//                                }
//                            }
//                        })
//                    }
//                }
//            }, withCancel: nil)
//        }
//    }
//
//    private func reloadOfTable() {
//        self.timer?.invalidate()
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//
//    }
//
//    var timer: Timer?
//
//    @objc func handleReloadTable() {
//        self.parkingSpots = Array(self.parkingSpotsDictionary.values)
//        self.parkingSpots.sort(by: { (message1, message2) -> Bool in
//            return ((message1.parkingDistance! as NSString).intValue) < ((message2.parkingDistance! as NSString).intValue)
//        })
//
//        DispatchQueue.main.async(execute: {
//            self.parkingTableView.reloadData()
//            self.showPartyMarkers()
//        })
//    }
//
//    var optionsTabView: UIView!
//    var optionsTabViewConstraint: NSLayoutConstraint!
//    var textSearchBarFarRightAnchor: NSLayoutConstraint!
//    var textSearchBarCloseRightAnchor: NSLayoutConstraint!
//    var mapViewConstraint: NSLayoutConstraint!
//    var tabPullWidthShort: NSLayoutConstraint!
//    var tabPullWidthLong: NSLayoutConstraint!
//    var containerHeightAnchor: NSLayoutConstraint!
//    var purchaseStatusWidthAnchor: NSLayoutConstraint!
//    var purchaseStatusHeightAnchor: NSLayoutConstraint!
//
//    func setupViews() {
//
//        optionsTabView = UIView()
//        optionsTabView.translatesAutoresizingMaskIntoConstraints = false
//        optionsTabView.backgroundColor = UIColor.groupTableViewBackground
//        self.view.addSubview(optionsTabView)
//
//        optionsTabViewConstraint = optionsTabView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -215)
//        optionsTabViewConstraint.isActive = true
//        optionsTabView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        optionsTabView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        optionsTabView.widthAnchor.constraint(equalToConstant: 215).isActive = true
//
//        let parkingView = UIView()
//        parkingView.backgroundColor = Theme.SEA_BLUE
//        parkingView.alpha = 0.8
//        parkingView.translatesAutoresizingMaskIntoConstraints = false
//        parkingView.layer.borderColor = Theme.DARK_GRAY.cgColor
//        parkingView.layer.borderWidth = 3
//        parkingView.clipsToBounds = false
//        optionsTabView.addSubview(parkingView)
//
//        parkingView.leftAnchor.constraint(equalTo: optionsTabView.leftAnchor).isActive = true
//        parkingView.rightAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
//        parkingView.topAnchor.constraint(equalTo: optionsTabView.topAnchor).isActive = true
//        parkingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        let parkingLabel = UILabel()
//        parkingLabel.text = "Parking:"
//        parkingLabel.textColor = UIColor.white
//        parkingLabel.font = Fonts.SSPBoldH2
//        parkingLabel.translatesAutoresizingMaskIntoConstraints = false
//        parkingLabel.textAlignment = .center
//        parkingView.addSubview(parkingLabel)
//
//        parkingLabel.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
//        parkingLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        parkingLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        switch device {
//        case .iphone8:
//            parkingLabel.centerYAnchor.constraint(equalTo: parkingView.centerYAnchor, constant: 10).isActive = true
//        case .iphoneX:
//            parkingLabel.centerYAnchor.constraint(equalTo: parkingView.centerYAnchor, constant: 25).isActive = true
//        }
//
//        self.view.addSubview(parkingTableView)
//        parkingTableView.leftAnchor.constraint(equalTo: optionsTabView.leftAnchor).isActive = true
//        parkingTableView.rightAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
//        parkingTableView.bottomAnchor.constraint(equalTo: optionsTabView.bottomAnchor).isActive = true
//        parkingTableView.topAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
//
//        let shadow = UIImageView()
//        shadow.backgroundColor = UIColor.darkGray
//        shadow.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        shadow.layer.shadowRadius = 5
//        shadow.layer.shadowOpacity = 0.8
//        shadow.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.addSubview(shadow)
//
//        shadow.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
//        shadow.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        shadow.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        shadow.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//        mapView.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        mapView.layer.shadowOpacity = 0.8
//        mapView.layer.shadowRadius = 5
//        mapView.isUserInteractionEnabled = true
//
//        self.view.addSubview(mapView)
//        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        mapView.leftAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
//        mapViewConstraint = mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
//        mapViewConstraint.isActive = true
//        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        view.addSubview(topSearch)
//        topSearch.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
//        topSearch.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        topSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        switch device {
//        case .iphone8:
//            topSearch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
//        case .iphoneX:
//            topSearch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
//        }
//
//        self.view.addSubview(searchBar)
//        searchBar.centerYAnchor.constraint(equalTo: topSearch.centerYAnchor).isActive = true
//        searchBar.leftAnchor.constraint(equalTo: topSearch.leftAnchor).isActive = true
//        textSearchBarFarRightAnchor = searchBar.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
//        textSearchBarFarRightAnchor.isActive = false
//        textSearchBarCloseRightAnchor = searchBar.rightAnchor.constraint(equalTo: topSearch.rightAnchor)
//        textSearchBarCloseRightAnchor.isActive = true
//        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        setupTextField(textField: searchBar)
//        self.view.bringSubviewToFront(topSearch)
//
//        self.view.addSubview(tabFeed)
//        tabFeed.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        tabFeed.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        tabFeed.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15).isActive = true
//        tabFeed.centerXAnchor.constraint(equalTo: topSearch.centerXAnchor).isActive = true
//
////        self.view.addSubview(currentButton)
////        currentButton.addTarget(self, action: #selector(currentParkingPressed(sender:)), for: .touchUpInside)
////        currentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
////        currentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
////        currentButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
////        currentButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
//
////        self.view.addSubview(purchaseStaus)
////        purchaseStaus.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
////        purchaseStaus.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
////        purchaseStatusWidthAnchor = purchaseStaus.widthAnchor.constraint(equalToConstant: 120)
////            purchaseStatusWidthAnchor.isActive = true
////        purchaseStatusHeightAnchor = purchaseStaus.heightAnchor.constraint(equalToConstant: 40)
////            purchaseStatusHeightAnchor.isActive = true
////
////        self.view.addSubview(swipeTutorial)
////        swipeTutorial.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
////        swipeTutorial.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
////        swipeTutorial.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
////        swipeTutorial.heightAnchor.constraint(equalToConstant: 160).isActive = true
////
////        view.addSubview(swipeLabel)
////        swipeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        swipeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
////        swipeLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
////        swipeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
//
//    }
//
//    func setupLeaveAReview(parkingID: String) {
//
//        self.view.addSubview(reviewsViewController.view)
//        self.addChild(reviewsViewController)
//        reviewsViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        reviewsViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        reviewsViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        reviewsViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//        reviewsViewController.setData(parkingID: parkingID)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.reviewsViewController.view.alpha = 1
//        }) { (success) in
//            //
//        }
//    }
//
//    func removeLeaveAReview() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.reviewsViewController.view.alpha = 0
//        }) { (success) in
//            self.willMove(toParent: nil)
//            self.reviewsViewController.view.removeFromSuperview()
//            self.reviewsViewController.removeFromParent()
//        }
//    }
//
//    var purchaseViewAnchor: NSLayoutConstraint!
//    var informationViewAnchor: NSLayoutConstraint!
//    var hoursButtonAnchor: NSLayoutConstraint!
//
//    func setupViewController() {
//
//        self.view.addSubview(fullBlurView)
//        fullBlurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        fullBlurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        fullBlurView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        fullBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//        self.view.addSubview(purchaseViewController.view)
//        self.addChild(purchaseViewController)
//        purchaseViewController.didMove(toParent: self)
//        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwiped))
//        gestureRecognizer.direction = .up
//        purchaseViewController.view.addGestureRecognizer(gestureRecognizer)
//        let gestureRecognizer2 = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwipedDownSender))
//        gestureRecognizer2.direction = .down
//        purchaseViewController.view.addGestureRecognizer(gestureRecognizer2)
//        purchaseViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        purchaseViewAnchor = purchaseViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 160)
//            purchaseViewAnchor.isActive = true
//        purchaseViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
//        hoursButtonAnchor = purchaseViewController.view.heightAnchor.constraint(equalToConstant: 140)
//            hoursButtonAnchor.isActive = true
//
//        self.view.addSubview(informationViewController.view)
//        self.addChild(informationViewController)
//        informationViewController.didMove(toParent: self)
//        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(informationButtonSwiped))
//        gesture.direction = .down
//        informationViewController.view.addGestureRecognizer(gesture)
//        informationViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        informationViewController.view.topAnchor.constraint(equalTo: purchaseViewController.view.bottomAnchor, constant: 35).isActive = true
//        informationViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10).isActive = true
//        informationViewController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height - 30).isActive = true
//
//        self.view.addSubview(couponStaus)
//        couponStaus.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
//        couponStaus.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -110).isActive = true
//        couponStaus.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        couponStaus.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//    }
//
//    @objc func purchaseButtonSwiped() {
//        self.delegate?.hideTabController()
//        UIView.animate(withDuration: 0.5, animations: {
//            self.purchaseViewAnchor.constant = -self.view.frame.height
//            self.fullBlurView.alpha = 0.9
//            self.swipeTutorial.alpha = 0
//            self.swipeLabel.alpha = 0
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            informationScrollView.isScrollEnabled = true
//        }
//        UserDefaults.standard.set(true, forKey: "swipeTutorialCompleted")
//        UserDefaults.standard.synchronize()
//    }
//
//    @objc func purchaseButtonSwipedDownSender() {
//        self.purchaseButtonSwipedDown()
//    }
//
//    func purchaseButtonSwipedDown() {
//        purchaseViewController.minimizeHours()
//        purchaseViewController.currentSender()
//        purchaseViewController.checkButtonSender()
//        UserDefaults.standard.set(true, forKey: "swipeTutorialCompleted")
//        UserDefaults.standard.synchronize()
//        UIView.animate(withDuration: 0.3, animations: {
//            self.purchaseViewAnchor.constant = 160
//            self.swipeTutorial.alpha = 0
//            self.fullBlurView.alpha = 0
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            informationScrollView.isScrollEnabled = false
//
//            let oldMarker = self.currentMarker
//            guard let customMarkerView = oldMarker?.iconView as? CustomMarkerView else { return }
//            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: self.customMarkerWidth, height: self.customMarkerHeight), borderColor: Theme.PACIFIC_BLUE, tag: customMarkerView.tag)
//            oldMarker?.iconView = customMarker
//            self.currentMarker = nil
//        }
//    }
//
//    @objc func informationButtonSwiped() {
//        self.delegate?.showTabController()
//        UIView.animate(withDuration: 0.5, animations: {
//            self.purchaseViewAnchor.constant = 0
//            self.fullBlurView.alpha = 0
//            if self.purchaseViewController.view.alpha == 1 {
//                self.swipeTutorial.alpha = 1
//            }
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            informationScrollView.isScrollEnabled = false
//        }
//    }
//
//    func currentParkingSender() {
//        self.delegate?.hideTabController()
//        UIView.animate(withDuration: 0.5, animations: {
//            self.purchaseViewAnchor.constant = -self.view.frame.height
//            self.fullBlurView.alpha = 1
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            informationScrollView.isScrollEnabled = true
//            self.purchaseViewController.view.alpha = 0
//        }
//    }
//
//    func currentParkingDisappear() {
//        self.delegate?.showTabController()
//        self.purchaseViewController.view.alpha = 0
//        UIView.animate(withDuration: 0.3, animations: {
//            self.purchaseViewAnchor.constant = 0
//            self.fullBlurView.alpha = 0
//        }) { (success) in
//            self.purchaseViewController.view.alpha = 0
//        }
//    }
//
//    func openHoursButton() {
//        self.hoursButtonAnchor.constant = 315
//        UIView.animate(withDuration: 0.2) {
//            self.fullBlurView.alpha = 0.6
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func closeHoursButton() {
//        self.hoursButtonAnchor.constant = 140
//        UIView.animate(withDuration: 0.2) {
//            self.fullBlurView.alpha = 0
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func sendAvailability(availability: Bool) {
//        purchaseViewController.setAvailability(available: availability)
//    }
//
//    @objc func currentParkingPressed(sender: UIButton) {
//        currentParkingSender()
//    }
//
//    @objc func optionsTabGestureTapped(sender: UIButton) {
//        optionsTabGesture()
//    }
//
//    @objc func optionsTabGestureSwiped(sender: UITapGestureRecognizer) {
//        optionsTabGesture()
//    }
//
//    @objc func optionsTabGesture() {
//        self.purchaseButtonSwipedDown()
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(optionsTabGesture))
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(optionsTabGesture))
//        swipeGesture.direction = .left
//        if optionsTabViewConstraint.constant == -215 {
//            self.optionsTabViewConstraint.constant = 0
//            self.topSearch.isUserInteractionEnabled = false
//            self.mapView.addGestureRecognizer(gesture)
//            self.mapView.addGestureRecognizer(swipeGesture)
//            self.mapView.settings.tiltGestures = false
//            self.mapView.settings.rotateGestures = false
//            self.mapView.settings.zoomGestures = false
//            self.mapView.settings.scrollGestures = false
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//                self.optionsTabAnimations()
//            }
//        } else {
//            self.optionsTabViewConstraint.constant = -215
//            self.topSearch.isUserInteractionEnabled = true
//            self.mapView.removeGestureRecognizer(gesture)
//            self.mapView.removeGestureRecognizer(swipeGesture)
//            self.mapView.settings.tiltGestures = true
//            self.mapView.settings.rotateGestures = true
//            self.mapView.settings.zoomGestures = true
//            self.mapView.settings.scrollGestures = true
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//                self.optionsTabAnimations()
//            }
//        }
//    }
//
//    func optionsTabAnimations() {
//        if self.optionsTabViewConstraint.constant == 0 {
//            self.textSearchBarFarRightAnchor.constant = 225
//        } else {
//            self.textSearchBarFarRightAnchor.constant = -10
//        }
//        UIView.animate(withDuration: 0.3, animations: {
//        self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//    func checkForCoupons() {
//        guard let currentUser = Auth.auth().currentUser?.uid else {return}
//        let ref = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
//        ref.observe(.childAdded) { (snapshot) in
//            let percent = snapshot.value as? Int
//            self.couponStaus.setTitle("\(percent!)% off!", for: .normal)
//            self.couponStaus.alpha = 0.8
//            couponActive = percent!
//        }
//        ref.observe(.childRemoved) { (snapshot) in
//            self.couponStaus.setTitle("", for: .normal)
//            self.couponStaus.alpha = 0
//        }
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        let autoCompleteController = GMSAutocompleteViewController()
//        autoCompleteController.delegate = self
//
//        let filter = GMSAutocompleteFilter()
//        autoCompleteController.autocompleteFilter = filter
//
//        self.locationManager.startUpdatingLocation()
//        self.present(autoCompleteController, animated: true, completion: nil)
//        return false
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        let lat = place.coordinate.latitude
//        let long = place.coordinate.longitude
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
//        mapView.camera = camera
//        searchBar.text = place.formattedAddress
//
//        UIView.animate(withDuration: 0.3) {
//            self.textSearchBarFarRightAnchor.constant = self.view.frame.width * 1/4
//            self.view.layoutIfNeeded()
//        }
//
//        places = Parking(name: place.formattedAddress!, lattitude: lat, longitude: long)
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        marker.title = "\(place.name)"
//        marker.snippet = "\(place.formattedAddress!)"
//        marker.map = mapView
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print("ERROR AUTO COMPLETE \(error)")
//    }
//
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    // MARK: CLLocation Manager Delegate
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error while getting location \(error)")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        locationManager.delegate = nil
//        let location = locations.last
//        let lat = (location?.coordinate.latitude)!
//        let long = (location?.coordinate.longitude)!
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
//
//        self.mapView.animate(to: camera)
//        self.locationManager.stopUpdatingLocation()
//    }
//
//    var currentMarker: GMSMarker? = nil
//
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        if currentParking == false && marker != self.currentMarker {
//            self.swipeTutorialCheck()
//            guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
//            let parking = parkingSpots[customMarkerView.tag]
//            self.informationViewController.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!, rating: parking.rating!, message: parking.message!)
//            self.purchaseViewController.setData(parkingCost: parking.parkingCost!, parkingID: parking.parkingID!, id: parking.id!)
//
//            self.purchaseViewController.view.alpha = 1
//            UIView.animate(withDuration: 0.3, animations: {
//                //
//            }) { (success) in
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.purchaseViewAnchor.constant = 0
//                    self.swipeTutorial.alpha = 1
//                    self.view.layoutIfNeeded()
//                }) { (success) in
//                    //
//                }
//            }
//
////            let center = UNUserNotificationCenter.current()
////            center.delegate = self
////            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
////                if granted {
////                    DispatchQueue.main.async { // Correct
////                        UIApplication.shared.registerForRemoteNotifications()
////                    }
////                }
////            }
//
//            guard let newMarkerView = marker.iconView as? CustomMarkerView else { return false }
//            let newMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: Theme.WHITE, tag: newMarkerView.tag)
//            marker.iconView = newMarker
//
//            if currentMarker != nil {
//                let oldMarker = currentMarker
//                guard let oldMarkerView = oldMarker?.iconView as? CustomMarkerView else { return false }
//                let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: Theme.PACIFIC_BLUE, tag: oldMarkerView.tag)
//                oldMarker?.iconView = customMarker
//            }
//            self.currentMarker = marker
//        }
//         return false
//    }
//
//    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: Theme.PACIFIC_BLUE, tag: customMarkerView.tag)
//        marker.iconView = customMarker
//    }
//
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = manager.location {
//            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
//            mapView.animate(to: camera)
//
//            if let currentDestination = self.destination {
//                let direction = getBearingBetweenTwoPoints1(point1 : mapView.myLocation!, point2 : currentDestination)
//                let heading = GMSOrientation.init(heading: direction, pitch: 0.0)
////                    .maps.geometry.spherical.computeHeading(mapView.myLocation,currentDestination)
//                mapView.animate(toBearing: heading.heading)
//            }
//        }
//    }
//
//    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
//    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
//
//    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
//
//        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
//        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
//
//        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
//        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
//
//        let dLon = lon2 - lon1
//
//        let y = sin(dLon) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
//        let radiansBearing = atan2(y, x)
//
//        return radiansToDegrees(radians: radiansBearing)
//    }
//
//    func showPartyMarkers() {
//        mapView.clear()
//        for number in 0...(parkingSpots.count - 1) {
//            let marker = GMSMarker()
//            let parking = parkingSpots[number]
//
//            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: Theme.PACIFIC_BLUE, tag: number)
//            marker.iconView = customMarker
//
//            let geoCoder = CLGeocoder()
//            geoCoder.geocodeAddressString(parking.parkingAddress!) { (placemarks, error) in
//                guard let placemarks = placemarks, let location = placemarks.first?.location else {
//                    return
//                }
//                marker.position = location.coordinate
//            }
//            marker.map = self.mapView
//        }
//    }
//
//    @objc func locatorButtonAction() {
////        locationAuthStatus()
//        let location: CLLocation? = mapView.myLocation
//        if location != nil {
//            mapView.animate(toLocation: (location?.coordinate)!)
//            mapView.animate(toZoom: 15.0)
//        }
//    }
//
//    func drawPath(endLocation: CLLocation) {
//        let myLocation = mapView.myLocation
//        let origin = "\(myLocation!.coordinate.latitude),\(myLocation!.coordinate.longitude)"
//        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
//
//        Alamofire.request(url).responseJSON { response in
//            if let json = try? JSON(data: response.data!) {
//                let routes = json["routes"].arrayValue
//                for route in routes {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//                    let polyline = GMSPolyline.init(path: path)
//                    polyline.strokeWidth = 4
//                    polyline.strokeColor = Theme.PACIFIC_BLUE
//                    polyline.map = self.mapView
//                    self.currentPolyline.append(polyline)
//
//                    let bounds = GMSCoordinateBounds(coordinate: (myLocation?.coordinate)!, coordinate: endLocation.coordinate)
//                    if self.currentActive == false {
//                        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 160, left: 120, bottom: 160, right: 120))
//                        self.mapView.animate(with: update)
//                    }
//                    self.currentActive = true
//                }
//            }
//        }
//    }
//
//    @objc func animateSearchBar(sender: UIButton) {
//        if self.textSearchBarCloseRightAnchor.isActive == true {
//            searchBar.attributedPlaceholder = NSAttributedString(string: "Search..",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//            UIView.animate(withDuration: 0.3, animations: {
//                self.textSearchBarFarRightAnchor.isActive = true
//                self.textSearchBarCloseRightAnchor.isActive = false
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            searchBar.attributedPlaceholder = NSAttributedString(string: "",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//            UIView.animate(withDuration: 0.3, animations: {
//                self.textSearchBarFarRightAnchor.isActive = false
//                self.textSearchBarCloseRightAnchor.isActive = true
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
//
//    func setupTextField(textField: UITextField){
//        textField.leftViewMode = UITextField.ViewMode.always
//        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 60, height: 30))
//        textField.leftView = paddingView
//    }
//
//    // MARK: - Table view data source
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = Bundle.main.loadNibNamed("ParkingTableViewCell", owner: self, options: nil)?.first as! ParkingTableViewCell
//            cell.selectedBackgroundView?.backgroundColor = UIColor.groupTableViewBackground
//            cell.cellView.backgroundColor = UIColor.white
//            let parking = parkingSpots[indexPath.row]
//            cell.parkingSpotImage.loadImageUsingCacheWithUrlString(parking.parkingImageURL!)
//            cell.parkingSpotCity.text = parking.parkingCity
//            cell.parkingSpotCost.text = parking.parkingCost
//            cell.parkingDistance.text = "\(String(describing: parking.parkingDistance!)) miles"
//
//            return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return parkingSpots.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 137
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let parking = parkingSpots[indexPath.row]
//
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(parking.parkingAddress!) { (placemarks, error) in
//            guard
//                let placemarks = placemarks,
//                let location = placemarks.first?.location
//                else {
//                    print("No location selected", error?.localizedDescription as Any)
//                    return
//            }
//            let locationCamera: CLLocation? = location
//            if locationCamera != nil {
//                self.optionsTabGesture()
//                self.mapView.animate(toLocation: (locationCamera?.coordinate)!)
//                self.mapView.animate(toZoom: 15.0)
//            }
//        }
//    }
//
//    func showPurchaseStatus(status: Bool) {
//        if status == true {
//            UIView.animate(withDuration: 0.2) {
//                self.purchaseStatusWidthAnchor.constant = 120
//                self.purchaseStatusHeightAnchor.constant = 40
//                self.purchaseStaus.setTitle("Success!", for: .normal)
//                self.purchaseStaus.alpha = 0.9
//                self.view.layoutIfNeeded()
//            }
//        } else {
//            UIView.animate(withDuration: 0.2) {
//                self.purchaseStatusWidthAnchor.constant = 220
//                self.purchaseStatusHeightAnchor.constant = 60
//                self.purchaseStaus.setTitle("The charge could not be made", for: .normal)
//                self.purchaseStaus.alpha = 0.9
//                self.view.layoutIfNeeded()
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            UIView.animate(withDuration: 0.2) {
//                self.purchaseStatusWidthAnchor.constant = 120
//                self.purchaseStatusHeightAnchor.constant = 40
//                self.purchaseStaus.setTitle("", for: .normal)
//                self.purchaseStaus.alpha = 0
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//
//    func addAVehicleReminder() {
//        self.vehicleDelegate?.bringNewVehicleController(vehicleStatus: .noVehicle)
//    }
//
//    func swipeTutorialCheck() {
//        if UserDefaults.standard.bool(forKey: "swipeTutorialCompleted") == false {
//            UIView.animate(withDuration: 0.3) {
//                self.swipeTutorial.alpha = 1
//                self.swipeLabel.alpha = 1
//            }
//        }
//        else {
//            self.swipeLabel.removeFromSuperview()
//        }
//    }
//
//    func sendNewHost() {
//        self.vehicleDelegate?.setupNewParking(parkingImage: .noImage)
//    }
//
}












