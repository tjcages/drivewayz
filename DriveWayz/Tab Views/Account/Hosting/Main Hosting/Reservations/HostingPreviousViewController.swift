//
//  HostingPreviousViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Mapbox
import Cosmos

class HostingPreviousViewController: UIViewController {
    
    var delegate: handlePreviousBookings?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        
        return button
    }()
    
    lazy var mapView: MGLMapView = {
        let view = MGLMapView(frame: self.view.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        view.showsScale = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.logoView.isHidden = true
        view.attributionButton.isHidden = true
        view.isUserInteractionEnabled = false
        view.showsUserLocation = false
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        view.backgroundColor = Theme.WHITE
        view.image = UIImage(named: "background4")
        
        return view
    }()
    
    var whiteCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 500
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var quickDestinationController: HostingQuickViewController = {
        let controller = HostingQuickViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tyler"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 20
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var vehicleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vehicle"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userVehicle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2004 Toyota 4Runner"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var vehicleLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var licenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "License plate"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userLicense: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "312-ZRA"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var licenseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "DURATION"
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sat Jan 12, 2019"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2:15 PM"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH0
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:30 PM"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH0
        label.textAlignment = .right
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH3
        label.textAlignment = .center
        
        return label
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "PAYMENT INFORMATION"
        
        return label
    }()
    
    var totalChargeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total charge"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var userTotalCharge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var bookingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userBookingFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$0.32"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var processingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Processing fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userProcessingFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$1.23"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var drivewayzFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userDrivewayzFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$2.80"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    
    var profitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your profit"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var userProfit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$12.38"
        label.textColor = Theme.GREEN_PIGMENT
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView5: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var reportUser: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Report user", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()
    
    var bottomWhiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    func setData(booking: Bookings, parking: ParkingSpots) {
        if let userName = booking.userName, let userDuration = booking.userDuration, let userProfileURL = booking.userProfileURL, let userRating = booking.userRating, let parkingLong = booking.parkingLong, let parkingLat = booking.parkingLat, let destLong = booking.destinationLong, let destLat = booking.destinationLat, let fromDate = booking.fromDate, let streetAddress = parking.streetAddress, let cityAddress = parking.cityAddress, let stateAddress = parking.stateAddress {
            if let payment = booking.totalCost, let hours = booking.hours, let price = booking.price {
                self.userTotalCharge.text = String(format:"$%.02f", payment)
                let hostProfit = hours * price * 0.75
                let bookingFee = 0.30
                let processingFee = 0.029 * payment
                let drivewayzFee = hours * price * 0.25
                self.userProfit.text = String(format:"$%.02f", hostProfit)
                self.userBookingFee.text = String(format:"-$%.02f", bookingFee)
                self.userProcessingFee.text = String(format:"-$%.02f", processingFee)
                self.userDrivewayzFee.text = String(format:"-$%.02f", drivewayzFee)
            }
            self.stars.rating = userRating
            let nameArray = userName.split(separator: " ")
            self.nameLabel.text = String(nameArray[0])
            
            if userProfileURL == "" {
                self.profileImageView.image = UIImage(named: "background4")
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(userProfileURL)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy"
            let fromDay = Date(timeIntervalSince1970: fromDate)
            let fromString = dateFormatter.string(from: fromDay)
            self.dateLabel.text = fromString
            
            let dates = userDuration.split(separator: "-")
            self.fromTimeLabel.text = String(dates[0])
            self.toTimeLabel.text = String(dates[1])
            
            let location = CLLocationCoordinate2D(latitude: parkingLat, longitude: parkingLong)
            var center = location
            center.latitude = center.latitude + 0.0002
            center.longitude = center.longitude + 0.0006
            mapView.setCenter(center, zoomLevel: 16, animated: false)
            let annotation = MGLPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            
            let parkingLocation = CLLocationCoordinate2D(latitude: parkingLat, longitude: parkingLong)
            let destinationLocation = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
            let distance = parkingLocation.distance(to: destinationLocation)
            let minutes = distance/93.87839463552
            
            self.quickDestinationController.destinationLabel.text = streetAddress
            self.quickDestinationController.destinationSecondaryLabel.text = "\(cityAddress), \(stateAddress)"
            self.quickDestinationController.distanceLabel.text = "\(Int(minutes.rounded())) min"
            self.quickDestinationController.setupData()
            
            if let vehicleID = booking.vehicleID {
                let ref = Database.database().reference().child("UserVehicles").child(vehicleID)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if let vehicleYear = dictionary["vehicleYear"] as? String, let vehicleMake = dictionary["vehicleMake"] as? String, let vehicleModel = dictionary["vehicleModel"] as? String, let licensePlate = dictionary["licensePlate"] as? String {
                            let vehicle = "\(vehicleYear) \(vehicleMake) \(vehicleModel)"
                            self.userVehicle.text = vehicle
                            self.userLicense.text = licensePlate
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        mapView.delegate = self
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        mapView.styleURL = url
        
        setupViews()
        setupUser()
        setupVehicle()
        setupDuration()
        setupPrice()
        setupOptions()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 220 + statusHeight).isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28 + statusHeight).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48 + statusHeight).isActive = true
        }
        
    }
    
    func setupUser() {
        
        scrollView.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        scrollView.addSubview(whiteCircle)
        scrollView.bringSubviewToFront(profileImageView)
        whiteCircle.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -12).isActive = true
        whiteCircle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        whiteCircle.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        whiteCircle.heightAnchor.constraint(equalTo: whiteCircle.widthAnchor).isActive = true
        
        scrollView.addSubview(quickDestinationController.view)
        quickDestinationController.view.leftAnchor.constraint(equalTo: mapView.centerXAnchor, constant: -30).isActive = true
        quickDestinationController.view.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -20).isActive = true
        quickDestinationController.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        quickDestinationController.view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(stars)
        stars.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        stars.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 108).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupVehicle() {
        
        scrollView.addSubview(vehicleLabel)
        vehicleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        vehicleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        vehicleLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 24).isActive = true
        vehicleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userVehicle)
        userVehicle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userVehicle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userVehicle.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 24).isActive = true
        userVehicle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(vehicleLine)
        vehicleLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32 + (vehicleLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH4))!).isActive = true
        vehicleLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32 - (userVehicle.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH4))!).isActive = true
        vehicleLine.bottomAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: -2).isActive = true
        vehicleLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(licenseLabel)
        licenseLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        licenseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        licenseLabel.topAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: 12).isActive = true
        licenseLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userLicense)
        userLicense.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userLicense.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userLicense.topAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: 12).isActive = true
        userLicense.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(licenseLine)
        licenseLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32 + (licenseLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH4))!).isActive = true
        licenseLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32 - (userLicense.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH4))!).isActive = true
        licenseLine.bottomAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: -2).isActive = true
        licenseLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(lineView)
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 30).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func setupDuration() {
        
        scrollView.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        durationLabel.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 48).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        dateLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 12).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        fromTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(toTimeLabel)
        toTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: -6).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(lineView2)
        lineView2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView2.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 30).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func setupPrice() {
        
        scrollView.addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        priceLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 48).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(totalChargeLabel)
        totalChargeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        totalChargeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalChargeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12).isActive = true
        totalChargeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(userTotalCharge)
        userTotalCharge.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userTotalCharge.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userTotalCharge.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12).isActive = true
        userTotalCharge.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(lineView3)
        lineView3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView3.topAnchor.constraint(equalTo: totalChargeLabel.bottomAnchor, constant: 12).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(bookingFeeLabel)
        bookingFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        bookingFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        bookingFeeLabel.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        bookingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userBookingFee)
        userBookingFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userBookingFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userBookingFee.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        userBookingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(processingFeeLabel)
        processingFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        processingFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        processingFeeLabel.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        processingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userProcessingFee)
        userProcessingFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userProcessingFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userProcessingFee.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userProcessingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(drivewayzFeeLabel)
        drivewayzFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        drivewayzFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        drivewayzFeeLabel.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 12).isActive = true
        drivewayzFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(userDrivewayzFee)
        userDrivewayzFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userDrivewayzFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userDrivewayzFee.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userDrivewayzFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(lineView4)
        lineView4.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView4.topAnchor.constraint(equalTo: drivewayzFeeLabel.bottomAnchor, constant: 12).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(profitLabel)
        profitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        profitLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profitLabel.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 12).isActive = true
        profitLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(userProfit)
        userProfit.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userProfit.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userProfit.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 12).isActive = true
        userProfit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setupOptions() {
        
        scrollView.addSubview(lineView5)
        lineView5.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView5.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView5.topAnchor.constraint(equalTo: userProfit.bottomAnchor, constant: 30).isActive = true
        lineView5.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(reportUser)
        reportUser.topAnchor.constraint(equalTo: lineView5.bottomAnchor, constant: 8).isActive = true
        reportUser.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        reportUser.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        reportUser.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(bottomWhiteView)
        bottomWhiteView.topAnchor.constraint(equalTo: reportUser.bottomAnchor).isActive = true
        bottomWhiteView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomWhiteView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomWhiteView.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
    }

}


extension HostingPreviousViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -30.0 {
//            self.backButtonPressed()
        }
    }
    
}


extension HostingPreviousViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // For better performance, always try to reuse existing annotations.
        if let title = annotation.title, title == "Destination" {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "destinationMarkerIcon")
            
            // If there is no reusable annotation image available, initialize a new one.
            if(annotationImage == nil) {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "destinationMarkerIcon")!, reuseIdentifier: "destinationMarkerIcon")
            }
            
            return annotationImage
        } else {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationMapMarker")
            
            // If there is no reusable annotation image available, initialize a new one.
            if(annotationImage == nil) {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationMapMarker")!, reuseIdentifier: "annotationMapMarker")
            }
            
            return annotationImage
        }
    }
    
}
