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
    func startNavigation()
    
    func expandPurchaseBanner()
    func minimizePurchaseBanner()
    func presentPublicController(spotType: SpotType)
    
    func drawHostPolyline(lot: ParkingLot, index: Int)
    func bookParkingPressed(parking: ParkingSpots, type: SpotType)
}

var selectedSpotIndex: Int?
var selectedParkingLot: ParkingLot?

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
//        if type == .Private {
//            parkingControllerHeightAnchor.constant = purchaseNormalHeight
//        } else if type == .Free {
//            parkingControllerHeightAnchor.constant = publicNormalHeight
//        } else {
//            parkingControllerHeightAnchor.constant = publicNormalHeight
//        }
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
    
    func drawHostPolyline(lot: ParkingLot, index: Int) {
        // Remove all previous polylines or markers
        removeRouteLine()
        
        // Rearrange the spot markers and choose which to highlight
        selectedSpotIndex = index
        selectedParkingLot = lot
        rearrangeSpotViews(checkSelect: true)
        
        guard let currentLocation = locationManager.location, let lotLocation = lot.location else { return }
        
        if exactRouteLine {
            followEnd = false
            calculateRoute(fromLocation: lotLocation, toLocation: currentLocation, identifier: .automobile)
        } else {
            drawCurvedOverlay(startCoordinate: lotLocation, endCoordinate: currentLocation)
            animateInRouteLine()
            
            delayWithSeconds(animationIn) {
                self.animateRouteUnderLine()
                self.animateRouteLine()
                self.animateWalkingLine()
            }
        }
        
        if userEnteredDestination, let destinationPlacemark = searchingPlacemark {
            placeWalkingRoute(lot: lot, destinationPlacemark: destinationPlacemark)
        } else {
            delayWithSeconds(animationIn) {
                self.zoomToBounds(sender: self.parkingRouteButton)
            }
        }
    }
    
    func rearrangeSpotViews(checkSelect: Bool) {
        guard let index = selectedSpotIndex else { return }
        
        // Determine which spot view should be selected depending on the index
        if checkSelect {
            firstSpotView?.spotSelected = index == 0
            secondSpotView?.spotSelected = index == 1
            thirdSpotView?.spotSelected = index == 2
        }
        if index == 0, firstSpotView != nil { mapView.bringSubviewToFront(firstSpotView!) }
        else if index == 1, secondSpotView != nil { mapView.bringSubviewToFront(secondSpotView!) }
        else if index == 2, thirdSpotView != nil { mapView.bringSubviewToFront(thirdSpotView!) }
        mapView.bringSubviewToFront(routeEndPin)
    }
    
    func placeWalkingRoute(lot: ParkingLot, destinationPlacemark: CLPlacemark) {
        followEnd = true

        guard let searchLocation = destinationPlacemark.location, let lotLocation = lot.location, let route = lot.walkingRoute else { return }
        // Save walking zoom bounds
        ZoomStartCoordinate = searchLocation.coordinate
        ZoomEndCoordinate = lotLocation.coordinate
        
        // Save the most recent walking route
        mapBoxWalkingRoute = route
        
        // Draw the animating routes on the map
        createRouteLine(route: route, driving: false)

        // Determine walking time
        let minute = route.expectedTravelTime / 60
        setupQuickController(minute: minute, identifier: .walking)
                        
        // Add the destination pins
        mapView.addSubview(routeEndPin)
        
        // Add the walking route lines
        mapView.layer.insertSublayer(routeWalkingUnderLine, below: routeEndPin.layer)
        mapView.layer.insertSublayer(routeWalkingLine, below: routeEndPin.layer)
        
        // Animate the walking dotted line
        animateWalkingLine()
        
        // Zoom in on the walking bounds
        locatorButtonPressed(padding: 120)
        
        // Ensure map subview order is correct
        rearrangeMapSubviews()
    }
    
    @objc func bookingViewIsScrolling(sender: UIPanGestureRecognizer) {
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
    
    func changeBookingScrollAmount(percentage: CGFloat) {
        previousBookingPercentage = percentage
        
        parkingControllerHeightAnchor.constant = parkingNormalHeight + (phoneHeight - parkingNormalHeight - (gradientHeight - 60)) * percentage
        
        fullBackgroundView.alpha = 0 + percentage
        parkingBackButton.alpha = 1 - (percentage * 1.2)
        
        bookingController.changeBookingScrollAmount(percentage: percentage)
        view.layoutIfNeeded()
    }
    
    func changeBookingScroll(percentage: CGFloat) {
        topParkingView.alpha = 1 - percentage
    }
    
    func openBooking() {
        bookingController.bookingTableView.isScrollEnabled = true
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
        bookingController.closeBooking()
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
