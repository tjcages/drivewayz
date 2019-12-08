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
        showNone()
        
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
        parkingControllerBottomAnchor.constant = 420
//        durationControllerBottomAnchor.constant = 500
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.currentDurationController.view.alpha = 0
            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.locatorButton.alpha = 0
//            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showMainBar() {
        mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: mainBarNormalHeight + 72, right: horizontalPadding)
        if mainBarController.bannerController.view.alpha == 1 {
            if mainBarController.reservationsOpen {
                mainBarController.closeReservations()
                closeMainBanner()
            }
        }
        
        closeMainBar()
        parkingControllerBottomAnchor.constant = 420
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 1
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if showHamburger { self.delegate?.bringHamburger() }
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showParking() {
        mainBarBottomAnchor.constant = phoneHeight
        parkingControllerBottomAnchor.constant = 0
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor.isActive = false
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = true
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 1
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.hideHamburger()
//            if showHamburger { self.delegate?.bringHamburger() }
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
        mainBarBottomAnchor.constant = phoneHeight
        parkingControllerBottomAnchor.constant = 420
//        durationControllerBottomAnchor.constant = 500
        confirmControllerBottomAnchor.constant = 0
        currentBottomHeightAnchor.constant = phoneHeight
        
        parkingBackButtonBookAnchor.isActive = false
        parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor.isActive = true
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = true
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 1
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.hideHamburger()
//            if showHamburger { self.delegate?.bringHamburger() }
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showCurrentBooking() {
        mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: statusHeight, right: horizontalPadding)
        showHamburger = false
        mapView.clear()

        mainBarBottomAnchor.constant = phoneHeight
        parkingControllerBottomAnchor.constant = 420
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = currentBookingHeight
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = true
        UIView.animate(withDuration: animationOut, animations: {
            self.locatorButton.alpha = 1
            self.parkingBackButton.alpha = 0
            self.currentDurationController.view.alpha = 1
            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.hideHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func setupMainViews() {
        setupMainBar()
        setupParking()
        setupDuration()
        setupPayment()
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
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = parkingController.view.heightAnchor.constraint(equalToConstant: parkingNormalHeight)
            parkingControllerHeightAnchor.isActive = true
        parkingController.calendarButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.mainButton.addTarget(self, action: #selector(bookSpotPressed), for: .touchUpInside)
    }
    
    func setupDuration() {
        durationController.delegate = self
        durationController.reservationController.delegate = self
    }
    
    func setupPayment() {
        self.view.addSubview(confirmPaymentController.view)
        confirmPaymentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        confirmPaymentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        confirmControllerBottomAnchor = confirmPaymentController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 380)
            confirmControllerBottomAnchor.isActive = true
        confirmPaymentController.view.heightAnchor.constraint(equalToConstant: paymentNormalHeight).isActive = true
        confirmPaymentController.durationButton.addTarget(self, action: #selector(changeFinalDates), for: .touchUpInside)
    }
    
    func setupCurrent() {
        self.view.addSubview(currentBottomController.view)
        self.view.addSubview(currentDurationController.view)
        self.view.addSubview(endBookingController.view)
        
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
        
        endBookingController.view.bottomAnchor.constraint(equalTo: currentBottomController.view.topAnchor).isActive = true
        endBookingController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        endBookingController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        endBookingController.view.heightAnchor.constraint(equalToConstant: 86).isActive = true
        
    }
    
    
}
