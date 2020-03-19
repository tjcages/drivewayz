//
//  HandleMainViews.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps

enum MainViewState {
    case none
    case startup
    case mainBar
    case parking
    case payment
    case currentBooking
    case navigation
}

var showHamburger: Bool = true
var horizontalPadding: CGFloat = 8

extension MapKitViewController {
    
    func reloadRequestedViews() {
        switch mainViewState {
        case .none:
            // Hide all views
            showNone()
        case .startup:
            showStartup(duration: 1)
        case .mainBar:
            // Show main bar
            showStartup(duration: animationOut)
        case .parking:
            // Show parking options
            showParking()
        case .payment:
            // Show payment options
            print("payment")
        case .currentBooking:
            // Show current booking
            showCurrentBooking()
        case .navigation:
            print("navigation")
        }
    }
    
    func showNone() {
        shouldShowLots = true
        mainBarBottomAnchor.constant = phoneHeight
        parkingControllerBottomAnchor.constant = 470
        currentBarBottomAnchor.constant = currentBarNormalHeight + 64
        
        UIView.animate(withDuration: animationOut * 2, animations: {
//            self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: 0, right: horizontalPadding)
//            self.currentDurationController.view.alpha = 0
//            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 0
            self.parkingRouteButton.alpha = 0
            self.currentRouteButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showStartup(duration: Double) {
        shouldShowLots = true
        mainBarBottomAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 470
        currentBarBottomAnchor.constant = currentBarNormalHeight + 64
        
        UIView.animateInOut(withDuration: duration, animations: {
            self.mainBarController.view.alpha = 1
            self.mapView.padding = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: mainBarNormalHeight - 32, right: horizontalPadding)
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.locatorButtonPressed(padding: nil)
            if duration != 1 { self.showWelcomeBanner() }
            self.delegate?.defaultContentStatusBar()
            self.delegate?.bringProfile()
        }
    }
    
    func showParking() {
        shouldShowLots = false
        followEnd = true
        hideWelcomeBanner()
        
        mainBarBottomAnchor.constant = mainBarNormalHeight + 64
        parkingControllerBottomAnchor.constant = 0
        currentBarBottomAnchor.constant = currentBarNormalHeight + 64
        
        delegate?.hideHamburger()
        delegate?.hideProfile()
        UIView.animate(withDuration: animationOut, animations: {
            self.mapView.padding = UIEdgeInsets(top: -20, left: horizontalPadding, bottom: parkingNormalHeight - 64, right: horizontalPadding)
            self.parkingBackButton.alpha = 1
            self.parkingRouteButton.alpha = 1
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func showCurrentBooking() {
        shouldShowLots = false
        currentBarBottomAnchor.constant = 0
        parkingControllerBottomAnchor.constant = 470
        
        UIView.animateInOut(withDuration: animationOut, animations: {
            self.mainBarController.view.alpha = 1
            self.mapView.padding = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: currentBarNormalHeight - 32, right: horizontalPadding)
            self.locatorButton.alpha = 0
            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBookingController.updateRatio(ratio: 0.9, duration: animationOut * 2, true)
            self.delegate?.defaultContentStatusBar()
            self.delegate?.bringProfile()
        }
    }
    
    func setupMainViews() {
        setupMainBar()
        setupParking()
        setupCurrent()
    }
    
    func setupMainBar() {
        if device != .iphoneX {
            mainBarNormalHeight = mainBarNormalHeight - 32
        }
        
        view.addSubview(mainBarController.view)
        mainBarController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainBarController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainBarHeightAnchor = mainBarController.view.heightAnchor.constraint(equalToConstant: mainBarNormalHeight)
            mainBarHeightAnchor.isActive = true
        mainBarBottomAnchor = mainBarController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: mainBarNormalHeight + 64)
            mainBarBottomAnchor.isActive = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarPanned(sender:)))
        mainBarController.view.addGestureRecognizer(pan)
        mainBarController.searchView.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(readjustMainBar), name: NSNotification.Name(rawValue: "readjustMainBar"), object: nil)
    }
    
    func setupParking() {
        self.view.addSubview(bookingController.view)
        bookingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = bookingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 470)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = bookingController.view.heightAnchor.constraint(equalToConstant: parkingNormalHeight)
            parkingControllerHeightAnchor.isActive = true

//        let pan = UIPanGestureRecognizer(target: self, action: #selector(bookingViewIsScrolling(sender:)))
//        bookingController.view.addGestureRecognizer(pan)
        
        view.addSubview(topParkingView)
        topParkingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: gradientHeight - 60)
        
        NotificationCenter.default.addObserver(self, selector: #selector(readjustBookingHeight), name: NSNotification.Name(rawValue: "readjustBookingHeight"), object: nil)
        
    }
    
    func setupCurrent() {
        view.addSubview(currentBookingController.view)
        currentBookingController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        currentBookingController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        currentBarHeightAnchor = currentBookingController.view.heightAnchor.constraint(equalToConstant: currentBarNormalHeight)
            currentBarHeightAnchor.isActive = true
        currentBarBottomAnchor = currentBookingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: currentBarNormalHeight + 64)
            currentBarBottomAnchor.isActive = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(currentBarPanned(sender:)))
        currentBookingController.view.addGestureRecognizer(pan)
    }
    
    
}
