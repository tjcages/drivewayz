//
//  NavigationBottomView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxDirections
import MapboxCoreNavigation

class NavigationBottomView: UIViewController {

    var delegate: handleCurrentNavView?
    var shouldShowDestination: Bool = false
    var currentBooking: Bookings? {
        didSet {
            if let booking = self.currentBooking {
                if let parkingSpot = booking.parkingID {
                    self.observeHostInformation(parkingId: parkingSpot)
                }
                if var destinationName = booking.destinationName {
                    if let dotRange = destinationName.range(of: ",") {
                        destinationName.removeSubrange(dotRange.lowerBound..<destinationName.endIndex)
                    }
                    if destinationName == "" { destinationName = "Current location" }
                    self.durationController.destinationOption.text = destinationName
                    self.durationController.destinationAddress = destinationName
                    self.shouldShowDestination = true
                }
            }
        }
    }
    
    var currentParking: ParkingSpots? {
        didSet {
            if let parking = self.currentParking {
                self.informationController.imageViews.setData(hosting: parking)
                if let numberSpots = parking.numberSpots, let mainType = parking.mainType, let secondaryType = parking.secondaryType {
                    self.durationController.mainLabel.text = "\(numberSpots)-Car \(secondaryType.capitalizingFirstLetter())"
                    self.durationController.parkingOption.text = mainType.capitalizingFirstLetter()
                }
                if let streetAddress = parking.streetAddress {
                    let addressArray = streetAddress.split(separator: " ")
                    let newArray = addressArray.dropFirst()
                    let streetString = newArray.joined(separator: " ")
                    self.durationController.arrivalTimeLabel.text = streetString
                    self.delegate?.setFinalDestination(address: streetAddress)
                }
                if let message = parking.hostMessage {
                    self.informationController.messageLabel.text = message
                }
                if let timestamp = parking.timestamp {
                    let date = Date(timeIntervalSince1970: timestamp)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let dateString = dateFormatter.string(from: date)
                    self.informationController.listedLabel.text = "Listed on \(dateString)"
                }
                if let spotNumber = parking.parkingNumber, spotNumber != "" {
                    self.informationController.spotNumberValue.text = "\(spotNumber)"
                } else {
                    self.informationController.spotNumberValue.text = "N/A"
                }
                if let gateNumber = parking.gateNumber, gateNumber != "" {
                    self.informationController.gateCodeValue.text = "\(gateNumber)"
                    self.informationController.haveGateCode()
                } else {
                    self.informationController.noGateCode()
                }
            }
        }
    }
    
    // Navigation enum to determine layouts and possible options
    enum NavigationStatus {
        case begun // Just started navigation
        case nearParking // Within a couple minutes of reaching parking spot
        case parked // User reached destination
        case walking // User is now walking
        case arrived // User made it to their final destination
    }
    
    var navigationStatus: NavigationStatus = .begun {
        didSet {
            switch navigationStatus {
            case .begun:
                self.navigationBegan()
            case .nearParking:
                self.navigationNearParking()
            case .parked:
                self.navigationParked()
            case .walking:
                self.navigationWalking()
            case .arrived:
                self.navigationArrived()
            }
        }
    }
    
    let textDistanceFormatter = DistanceFormatter(approximate: true)
    var routeProgress: RouteProgress? {
        didSet {
            self.durationController.routeProgress = self.routeProgress
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = Theme.DARK_GRAY
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var durationController: NavigationDurationView = {
        let controller = NavigationDurationView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    var informationController: NavigationInformationView = {
        let controller = NavigationInformationView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
        setupControllers()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 980)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }
    
    var durationHeightAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(durationController.view)
        durationController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        durationController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        durationHeightAnchor = durationController.view.heightAnchor.constraint(equalToConstant: 368)
            durationHeightAnchor.isActive = true
        
        scrollView.addSubview(informationController.view)
        informationController.view.topAnchor.constraint(equalTo: durationController.view.bottomAnchor, constant: 3).isActive = true
        informationController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        informationController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        informationController.view.heightAnchor.constraint(equalToConstant: 520).isActive = true
        
    }
    
    func observeHostInformation(parkingId: String) {
        let ref = Database.database().reference().child("ParkingSpots").child(parkingId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let parking = ParkingSpots(dictionary: dictionary)
                self.currentParking = parking
            }
        }
    }
    
    func navigationBegan() {
        
    }
    
    func navigationNearParking() {
        scrollView.contentSize = CGSize(width: phoneWidth, height: 912)
        durationController.navigationNearParking()
        durationHeightAnchor.constant = 300
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func navigationParked() {
        scrollView.contentSize = CGSize(width: phoneWidth, height: 776)
        durationController.navigationParked()
        durationHeightAnchor.constant = 164
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func navigationWalking() {
        scrollView.contentSize = CGSize(width: phoneWidth, height: 776)
        durationController.navigationParked()
        durationController.navigationWalking()
        durationHeightAnchor.constant = 164
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }

    func navigationArrived() {
        scrollView.contentSize = CGSize(width: phoneWidth, height: 912)
        durationController.navigationWalking()
        durationController.navigationArrived()
        durationHeightAnchor.constant = 272
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}


extension NavigationBottomView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        shouldDragMainBar = true
        let translation = scrollView.contentOffset.y
        if translation < 0 {
            scrollView.contentOffset.y = 0.0
            scrollView.isScrollEnabled = false
            self.delegate?.closeCurrentBooking()
        }
    }
    
}
