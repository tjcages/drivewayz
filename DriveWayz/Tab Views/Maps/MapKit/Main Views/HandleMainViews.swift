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
            showDuration()
        case .payment:
            // Show payment options
            showPayment()
        case .currentBooking:
            // Show current booking
            showCurrentBooking()
        }
    }
    
    func showNone() {
        mapView.allowsRotating = false
        mainBarTopAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 420
        durationControllerBottomAnchor.constant = 500
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.currentDurationController.view.alpha = 0
            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.locatorButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showMainBar() {
        mapView.allowsRotating = false
        mainBarController.scrollView.setContentOffset(.zero, animated: true)
        mainBarTopAnchor.constant = self.lowestHeight
        parkingControllerBottomAnchor.constant = 420
        durationControllerBottomAnchor.constant = 500
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 1
            self.locatorButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showParking() {
        mapView.allowsRotating = false
        mainBarTopAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 0
        durationControllerBottomAnchor.constant = 500
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor.isActive = false
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = true
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showDuration() {
        mapView.allowsRotating = false
        mainBarTopAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 420
        durationControllerBottomAnchor.constant = 0
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = phoneHeight
        
        parkingBackButtonBookAnchor.isActive = false
        parkingBackButtonPurchaseAnchor.isActive = true
        parkingBackButtonConfirmAnchor.isActive = false
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = true
        locatorCurrentBottomAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.locatorButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showPayment() {
        mapView.allowsRotating = false
        view.bringSubviewToFront(confirmPaymentController.view)
        mainBarTopAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 420
        durationControllerBottomAnchor.constant = 500
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
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showCurrentBooking() {
        mapView.allowsRotating = true
        removePolylineAnnotations()
        mainBarTopAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 420
        durationControllerBottomAnchor.constant = 500
        confirmControllerBottomAnchor.constant = 380
        currentBottomHeightAnchor.constant = currentBookingHeight
        
        locatorMainBottomAnchor.isActive = false
        locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor.isActive = true
        UIView.animate(withDuration: animationOut, animations: {
            self.locatorButton.alpha = 1
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
        mainBarTopAnchor = mainBarController.view.heightAnchor.constraint(equalToConstant: 0)
            mainBarTopAnchor.isActive = true
        mainBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarIsScrolling(sender:)))
        mainBarController.view.addGestureRecognizer(pan)
        mainBarController.searchController.searchButton.addTarget(self, action: #selector(mainBarWillOpen), for: .touchUpInside)
        mainBarController.searchController.microphoneButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
    }
    
    func setupParking() {
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = parkingController.view.heightAnchor.constraint(equalToConstant: 372)
            parkingControllerHeightAnchor.isActive = true
        parkingController.timeButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.timeLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.mainButton.addTarget(self, action: #selector(bookSpotPressed), for: .touchUpInside)
    }
    
    func setupDuration() {
        self.view.addSubview(durationController.view)
        durationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationControllerBottomAnchor = durationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 500)
            durationControllerBottomAnchor.isActive = true
        switch device {
        case .iphone8:
            durationController.view.heightAnchor.constraint(equalToConstant: 412).isActive = true
        case .iphoneX:
            durationController.view.heightAnchor.constraint(equalToConstant: 440).isActive = true
        }
    }
    
    func setupPayment() {
        self.view.addSubview(confirmPaymentController.view)
        confirmPaymentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        confirmPaymentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        confirmControllerBottomAnchor = confirmPaymentController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 380)
            confirmControllerBottomAnchor.isActive = true
        confirmPaymentController.view.heightAnchor.constraint(equalToConstant: 284).isActive = true
        confirmPaymentController.changeButton.addTarget(self, action: #selector(changeFinalDates), for: .touchUpInside)
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
