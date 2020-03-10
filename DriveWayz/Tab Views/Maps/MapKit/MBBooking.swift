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
    func presentPublicController(spotType: SpotType)
    
    func drawHostPolyline(hostLocation: CLLocation)
    func bookParkingPressed(parking: ParkingSpots, type: SpotType)
}

extension MapKitViewController: HandleMapBooking {
    
    @objc func readjustBookingHeight() {
        parkingControllerHeightAnchor.constant = parkingNormalHeight
        UIView.animate(withDuration: animationIn) {
            self.mapView.padding = UIEdgeInsets(top: -20, left: horizontalPadding, bottom: parkingNormalHeight - 96, right: horizontalPadding)
            self.view.layoutIfNeeded()
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
    
    func bookParkingPressed(parking: ParkingSpots, type: SpotType) {
        mainViewState = .payment
        if type == .Private {
            parkingControllerHeightAnchor.constant = purchaseNormalHeight
        } else if type == .Free {
            parkingControllerHeightAnchor.constant = publicNormalHeight
        } else {
            parkingControllerHeightAnchor.constant = publicNormalHeight
        }
        UIView.animate(withDuration: animationIn * 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func dismissPurchaseController() {
        mainViewState = .parking
        locatorButtonPressed(padding: 64)
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
            
            delayWithSeconds(animationIn) {
                self.zoomToBounds(sender: self.parkingRouteButton)
            }
//            delayWithSeconds(animationOut) {
//                self.locatorButtonPressed(padding: 64)
//            }
        } else {
            delayWithSeconds(animationIn) {
                self.zoomToBounds(sender: self.parkingRouteButton)
            }
//            locatorButtonPressed(padding: 64)
        }
    }
    
    @objc func bookingViewIsScrolling(sender: UIPanGestureRecognizer) {
//        if !parkingController.isPurchasing {
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
//        }
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
