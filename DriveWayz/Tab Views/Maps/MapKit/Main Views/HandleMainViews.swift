//
//  HandleMainViews.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

enum MainViewState {
    case none
    case mainBar
    case parking
    case duration
    case payment
    case currentBooking
}

var showHamburger: Bool = true
var horizontalPadding: CGFloat = 8

extension MapKitViewController {
    
    func reloadRequestedViews() {
        // Show disabled state
//        showNone()
        
        switch mainViewState {
        case .none:
            // Hide all views
            showNone()
        case .mainBar:
            // Show main bar
            showMainBar()
        case .parking:
            // Show parking options
            showParking()
        case .duration:
            // Show duration options
            showDuration(parkNow: true)
        case .payment:
            // Show payment options
            showPayment()
        case .currentBooking:
            // Show current booking
            showCurrentBooking()
        }
    }
    
    func showNone() {
        mainBarBottomAnchor.constant = phoneHeight
        parkingControllerBottomAnchor.constant = 470
        currentBottomHeightAnchor.constant = phoneHeight
        
        locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut * 2, animations: {
            self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: 0, right: horizontalPadding)
            self.currentDurationController.view.alpha = 0
            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 0
            self.parkingRouteButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showMainBar() {
        showNone()
        if mainBarController.bannerController.view.alpha == 1 {
            if mainBarController.reservationsOpen {
                mainBarController.closeReservations()
                closeMainBanner()
            }
        }
        
        closeMainBar()
        if showHamburger { delegate?.bringHamburger() }
        parkingControllerBottomAnchor.constant = 470
        currentBottomHeightAnchor.constant = phoneHeight
        
        locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: mainBarNormalHeight - 72, right: horizontalPadding)
            self.mainBarController.scrollView.alpha = 1
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showParking() {
        followEnd = true
        mainBarBottomAnchor.constant = phoneHeight
        parkingControllerBottomAnchor.constant = 0
        currentBottomHeightAnchor.constant = phoneHeight
        
        parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor.isActive = false
        
        delegate?.hideHamburger()
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = true
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.mapView.padding = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: parkingNormalHeight - 64, right: horizontalPadding)
            self.parkingBackButton.alpha = 1
            self.parkingRouteButton.alpha = 1
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.parkingController.selectFirstIndex()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showDuration(parkNow: Bool) {
        if parkNow {
            durationController.durationBottomController.buttonPressed(sender: durationController.durationBottomController.parkNowButton)
        } else {
            durationController.durationBottomController.buttonPressed(sender: durationController.durationBottomController.reserveSpotButton)
        }
        let navigation = UINavigationController(rootViewController: durationController)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.4
        }) { (success) in
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func showPayment() {
//        view.bringSubviewToFront(confirmPaymentController.view)
//        mainBarTopAnchor.constant = 0
//        durationControllerBottomAnchor.constant = 500
//        currentBottomHeightAnchork.constant = phoneHeight
        
        parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor.isActive = false
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = true
        locatorCurrentBottomAnchor.isActive = false
        locatorButtonPressed(padding: 32)
        UIView.animate(withDuration: animationOut, animations: {
            self.mapView.padding = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: purchaseNormalHeight - 64, right: horizontalPadding)
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 1
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.hideHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showCurrentBooking() {
        currentBottomHeightAnchor.constant = currentBookingHeight
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: statusHeight, right: horizontalPadding)
            self.currentDurationController.view.alpha = 1
            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.fullBackgroundView.alpha = 0
            self.currentRouteButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func setupMainViews() {
        setupMainBar()
        setupParking()
        setupDuration()
        setupCurrent()
    }
    
    func setupMainBar() {
        self.view.addSubview(mainBarController.view)
        mainBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mainBarController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mainBarBottomAnchor = mainBarController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            mainBarBottomAnchor.isActive = true
        mainBarController.view.heightAnchor.constraint(equalToConstant: phoneHeight - statusHeight).isActive = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarIsScrolling(sender:)))
        mainBarController.view.addGestureRecognizer(pan)
        mainBarController.searchController.searchView.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        mainBarController.searchController.recommendationButton.addTarget(self, action: #selector(recommendButtonPressed), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainBannerPressed))
        mainBarController.bannerController.view.addGestureRecognizer(tap)
        let search = UITapGestureRecognizer(target: self, action: #selector(openSearch))
        mainBarController.bannerController.reservationView.addGestureRecognizer(search)
        
        if device != .iphoneX {
            mainBarNormalHeight = mainBarNormalHeight - 32
        }
    }
    
    func setupParking() {
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 470)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = parkingController.view.heightAnchor.constraint(equalToConstant: parkingNormalHeight)
            parkingControllerHeightAnchor.isActive = true
        parkingController.timeIcon.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.timeValue.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(bookingViewIsScrolling(sender:)))
        parkingController.view.addGestureRecognizer(pan)
        
        view.addSubview(topParkingView)
        topParkingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: gradientHeight - 60)
        
    }
    
    func setupDuration() {
        durationController.delegate = self
        durationController.reservationController.delegate = self
    }
    
    func setupCurrent() {
        view.addSubview(currentBottomController.view)
        view.addSubview(currentDurationController.view)
        
        currentBottomHeightAnchor = currentBottomController.view.topAnchor.constraint(equalTo: currentDurationController.view.bottomAnchor)
            currentBottomHeightAnchor.isActive = true
        currentBottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentBottomController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentBottomController.view.heightAnchor.constraint(equalToConstant: phoneHeight - 116 - statusHeight).isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(currentViewIsScrolling(sender:)))
        currentBottomController.view.addGestureRecognizer(pan)
        
        durationTopAnchor = currentDurationController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            durationTopAnchor.isActive = true
        durationLeftAnchor = currentDurationController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
            durationLeftAnchor.isActive = true
        durationRightAnchor = currentDurationController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
            durationRightAnchor.isActive = true
        currentDurationController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 116).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(currentDurationTapped))
        currentDurationController.view.addGestureRecognizer(tap)
        
    }
    
    
}
