//
//  MBBooking.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol HandleMapBooking {
    func changeBookingScroll(percentage: CGFloat)
    func closeBooking()
    func openBooking()
    
    func expandPurchaseBanner()
    func minimizePurchaseBanner()
    
    func drawHostPolyline(hostLocation: CLLocation)
    func bookParkingPressed(parking: ParkingSpots)
    func bookingConfirmed()
    
    func startCurrentBooking()
}

extension MapKitViewController: HandleMapBooking {
    
    func bookingConfirmed() {
        shownCheckinMessage = false
        removeAllMapOverlays(shouldRefresh: false)
        
        currentBookingState = .none
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0.7
        }) { (success) in
            self.mainViewState = .none
            delayWithSeconds(0.6) {
                delayWithSeconds(0.4) {
                    self.parkingController.dismissPurchaseController()
                    
                    let controller = ConfirmBookingController()
                    controller.delegate = self
                    controller.modalPresentationStyle = .overFullScreen
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func startCurrent() {
        if let userLocation = self.locationManager.location {
            followEnd = false
            exactRouteLine = true
            quadEndCoordinate = userLocation.coordinate
            quadStartCoordinate = hostLocation.coordinate
            ZoomStartCoordinate = quadStartCoordinate
            ZoomEndCoordinate = quadEndCoordinate
            
            let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
            mapView.camera = camera
        }
        delayWithSeconds(animationOut + animationIn) {
            if let start = quadStartCoordinate, let end = quadEndCoordinate {
                let startCoor = CLLocation(latitude: start.latitude, longitude: start.longitude)
                let endCoor = CLLocation(latitude: end.latitude, longitude: end.longitude)
                
                self.calculateRoute(fromLocation: startCoor, toLocation: endCoor, identifier: .automobile)
                
                // Show the overall route
                delayWithSeconds(0.5) {
                    UIView.animate(withDuration: 1, animations: {
                        self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: confirmNormalHeight - 40, right: horizontalPadding)
                        self.fullBackgroundView.alpha = 0
                    }, completion: nil)
                    
                    let bounds = GMSCoordinateBounds(coordinate: startCoor.coordinate, coordinate: endCoor.coordinate)
                    let camera = GMSCameraUpdate.fit(bounds, withPadding: 48)
                    // Slow the MapView animation
                    CATransaction.begin()
                    CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
                    self.mapView.animate(with: camera)
                    CATransaction.commit()
                    
                    // Slow zoom in
                    delayWithSeconds(2) {
                        let update = GMSCameraUpdate.fit(bounds, withPadding: 32)
                        CATransaction.begin()
                        CATransaction.setValue(Int(6), forKey: kCATransactionAnimationDuration)
                        self.mapView.animate(with: update)
                        CATransaction.commit()
                    }
                }
            }
        }
    }
    
    func expandPurchaseBanner() {
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 0.4
        }
    }
    
    func minimizePurchaseBanner() {
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.parkingBackButton.alpha = 1
            }
        }
    }
    
    func bookParkingPressed(parking: ParkingSpots) {
        mainViewState = .payment
        parkingControllerHeightAnchor.constant = purchaseNormalHeight
        UIView.animate(withDuration: animationIn * 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func dismissPurchaseController() {
        mainViewState = .parking
        locatorButtonPressed(padding: 64)
        parkingController.dismissPurchaseController()
        parkingControllerHeightAnchor.constant = parkingNormalHeight
        UIView.animate(withDuration: animationIn * 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func drawHostPolyline(hostLocation: CLLocation) {
        mapView.clear()
        removeRouteLine()
        
        guard let currentLocation = locationManager.location else { return }
        
        ZoomStartCoordinate = hostLocation.coordinate
        ZoomEndCoordinate = currentLocation.coordinate
        
        if exactRouteLine {
            followEnd = false
            calculateRoute(fromLocation: hostLocation, toLocation: currentLocation, identifier: .automobile)
        } else {
            drawCurvedOverlay(startCoordinate: hostLocation, endCoordinate: currentLocation)
            animateInRouteLine()
            
            delayWithSeconds(animationIn) {
                self.animateRouteUnderLine()
                self.animateRouteLine()
                self.animateWalkingLine()
            }
        }
        
        if userEnteredDestination {
            followEnd = true

            ZoomStartCoordinate = testDestination.coordinate
            ZoomEndCoordinate = hostLocation.coordinate
            
            calculateRoute(fromLocation: testDestination, toLocation: hostLocation, identifier: .walking)
            
            delayWithSeconds(animationOut) {
                self.locatorButtonPressed(padding: 64)
            }
        } else {
            locatorButtonPressed(padding: 64)
        }
    }
    
    @objc func bookingViewIsScrolling(sender: UIPanGestureRecognizer) {
        if !parkingController.isPurchasing {
            let translation = -sender.translation(in: self.view).y
            let state = sender.state
            let percentage = translation/(phoneHeight/3)
            if state == .changed {
                if percentage >= 0 && percentage <= 1 && previousBookingPercentage != 1.0 {
                    changeBookingScrollAmount(percentage: percentage)
                }
            } else if state == .ended {
                if previousBookingPercentage >= 0.25 {
                    openBooking()
                } else {
                    closeBooking()
                }
            }
        }
    }
    
    func changeBookingScrollAmount(percentage: CGFloat) {
        previousBookingPercentage = percentage
        
        parkingControllerHeightAnchor.constant = parkingNormalHeight + (phoneHeight - parkingNormalHeight - (gradientHeight - 60)) * percentage
        
        fullBackgroundView.alpha = 0 + percentage
        parkingBackButton.alpha = 1 - (percentage * 1.2)
        
        parkingController.changeBookingScrollAmount(percentage: percentage)
        view.layoutIfNeeded()
    }
    
    func changeBookingScroll(percentage: CGFloat) {
        topParkingView.alpha = 1 - percentage
    }
    
    func openBooking() {
        parkingController.openBooking()
        parkingController.bookingTableView.isScrollEnabled = true
        previousBookingPercentage = 1.0
        parkingControllerHeightAnchor.constant = phoneHeight - (gradientHeight - 60)
        
        delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.fullBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.topParkingView.alpha = 1
            self.topParkingView.setMainLabel(text: "Select a spot")
        }
    }
    
    func closeBooking() {
        parkingController.closeBooking()
        showHamburger = true
        previousBookingPercentage = 0.0
        parkingControllerHeightAnchor.constant = parkingNormalHeight
        
        delegate?.defaultContentStatusBar()
        topParkingView.alpha = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.parkingBackButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.topParkingView.reset()
        }
    }
    
}
