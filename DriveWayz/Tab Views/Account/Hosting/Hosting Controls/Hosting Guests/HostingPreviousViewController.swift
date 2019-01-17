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
    
    var delegate: handleGuestScroll?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
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
        view.layer.cornerRadius = 400
        
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
        label.font = Fonts.SSPSemiBoldH0
        label.textAlignment = .center
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 20
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.PURPLE
        view.settings.emptyBorderColor = Theme.OFF_WHITE
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.settings.filledBorderColor = Theme.PURPLE
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
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
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
        label.text = "317-ZFA"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var licenseLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        label.textColor = Theme.SEA_BLUE
        label.font = Fonts.SSPRegularH0
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:30 PM"
        label.textColor = Theme.PURPLE
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
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        label.text = "$15.96"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        scrollView.delegate = self
        
        setupViews()
        checkDayTimeStatus()
        
        setupUser()
        setupVehicle()
        setupDuration()
        setupPrice()
        setupOptions()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 940)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let location = CLLocationCoordinate2D(latitude: 40.0150, longitude: -105.2705)
        var center = location
        center.latitude = center.latitude - 0.0002
        center.longitude = center.longitude + 0.0006
        mapView.setCenter(center, zoomLevel: 16, animated: false)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
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
        whiteCircle.widthAnchor.constraint(equalToConstant: 800).isActive = true
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
        nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
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
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(toTimeLabel)
        toTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(lineView2)
        lineView2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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
        lineView3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lineView3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
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
        lineView4.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lineView4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
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
        lineView5.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView5.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView5.topAnchor.constraint(equalTo: userProfit.bottomAnchor, constant: 30).isActive = true
        lineView5.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(reportUser)
        reportUser.topAnchor.constraint(equalTo: lineView5.bottomAnchor, constant: 12).isActive = true
        reportUser.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        reportUser.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        reportUser.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func checkDayTimeStatus() {
        switch solar {
        case .day:
            let url = URL(string: "mapbox://styles/mapbox/streets-v11")
            self.mapView.styleURL = url
        case .night:
            let url = URL(string: "mapbox://styles/tcagle717/cjqdiaqzof9gp2sr4ulfgug3j")
            self.mapView.styleURL = url
        }
    }

}


extension HostingPreviousViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > self.view.frame.height {
            let translation = scrollView.contentOffset.y
            self.delegate?.animateScroll(translation: translation, active: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.delegate?.animateScroll(translation: translation, active: false)
    }

}
