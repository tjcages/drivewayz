//
//  MKParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

protocol handleCheckoutParking {
    func becomeAHost()
    func setDurationPressed(fromDate: Date, totalTime: String)
    func observeAllHosting()
    func confirmPurchasePressed(booking: Bookings)
    func expandCheckmark(current: Bool)
    func setupReviewBooking(parkingID: String)
    
    func changeParkingOptionsHeight(fade: CGFloat)
    func bringExpandedBooking()
    func hideExpandedBooking()
}

extension MapKitViewController: handleCheckoutParking {
    
    func setupMapButtons() {
        
//        self.view.addSubview(expandedSpotController.view)
//        expandedSpotController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        expandedSpotController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        expandedSpotBottomAnchor = expandedSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: phoneHeight)
//            expandedSpotBottomAnchor.isActive = true
//        expandedSpotController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        parkingBackButtonBookAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -8)
            parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: durationController.view.topAnchor, constant: -8)
            parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: confirmPaymentController.view.topAnchor, constant: -8)
            parkingBackButtonConfirmAnchor.isActive = false
        parkingBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(quickDestinationController.view)
        quickDestinationRightAnchor = quickDestinationController.view.centerXAnchor.constraint(equalTo: self.view.leftAnchor)
            quickDestinationRightAnchor.isActive = true
        quickDestinationTopAnchor = quickDestinationController.view.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            quickDestinationTopAnchor.isActive = true
        quickDestinationWidthAnchor = quickDestinationController.view.widthAnchor.constraint(equalToConstant: 100)
            quickDestinationWidthAnchor.isActive = true
        quickDestinationController.view.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        quickDestinationController.view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(quickParkingController.view)
        quickParkingRightAnchor = quickParkingController.view.centerXAnchor.constraint(equalTo: self.view.leftAnchor)
            quickParkingRightAnchor.isActive = true
        quickParkingTopAnchor = quickParkingController.view.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            quickParkingTopAnchor.isActive = true
        quickParkingWidthAnchor = quickParkingController.view.widthAnchor.constraint(equalToConstant: 100)
            quickParkingWidthAnchor.isActive = true
        quickParkingController.view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mapView.addSubview(polyRouteLocatorButton)
        polyRouteLocatorButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        polyRouteLocatorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        polyRouteLocatorButton.widthAnchor.constraint(equalTo: polyRouteLocatorButton.heightAnchor).isActive = true
        polyRouteLocatorButton.bottomAnchor.constraint(equalTo: parkingBackButton.bottomAnchor).isActive = true
        
    }
    
    func bringExpandedBooking() {
        self.parkingControllerHeightAnchor.constant = 492 - 30
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideExpandedBooking() {
        self.parkingControllerHeightAnchor.constant = 372
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeParkingOptionsHeight(fade: CGFloat) {
        self.fullBackgroundView.alpha = fade
    }
    
    func setupReviewBooking(parkingID: String) {
        self.reviewBookingController.selectedParking = parkingID
    }
    
    @objc func parkingBackButtonPressed() {
        if durationControllerBottomAnchor.constant == 0 {
            self.changeDatesDismissed()
        } else if parkingControllerBottomAnchor.constant == 0 && self.parkingControllerHeightAnchor.constant == 372 {
            self.parkingHidden(showMainBar: true)
        } else if parkingControllerBottomAnchor.constant == 0 {
            self.parkingController.minimizeBookingPressed()
            mainViewState = .parking
        } else if confirmControllerBottomAnchor.constant == 0 {
            self.backToBooking()
        } else {
            if isCurrentlyBooked {
                mainViewState = .currentBooking
            } else {
                mainViewState = .mainBar
            }
        }
    }
    
    func becomeAHost() {
        self.delegate?.moveToProfile()
        self.delegate?.bringNewHostingController()
    }
    
    func setDurationPressed(fromDate: Date, totalTime: String) {
        self.changeDatesDismissed()
        self.parkingController.bookingPicker.setContentOffset(.zero, animated: true)
        self.summaryController.changeDates(fromDate: fromDate, totalTime: totalTime)
        self.parkingController.changeDates(fromDate: fromDate, totalTime: totalTime)
        self.confirmPaymentController.changeDates(fromDate: fromDate, totalTime: totalTime)
//        self.successfulPurchaseController.changeDates(totalTime: totalTime)
    }
    
    func observeAllHosting() {
        self.removeAllHostLocations()
        self.observeAllParking()
    }
    
    @objc func bookSpotPressed() {
        mainViewState = .payment
        self.quickCouponController.minimizeController()
        if let price = self.parkingController.selectedParkingSpot?.dynamicCost, let parking = self.parkingController.selectedParkingSpot {
            let hours = self.durationController.totalSelectedTime
            self.confirmPaymentController.setData(price: Double(price), hours: hours, parking: parking)
        }
        if let region = ZooomRegion {
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 32, bottom: 320, right: 32), animated: true)
        }
    }

    func parkingSelected() {
        self.durationController.setData(isToday: true)
        self.quickCouponController.minimizeController()
        self.parkingController.bookingPicker.reloadData()
        self.durationController.saveDates()
        mainViewState = .parking
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingHidden(showMainBar: Bool) {
        ZooomRegion = nil
        self.shouldBeSearchingForAnnotations = true
        self.removeAllMapOverlays(shouldRefresh: true)
        mainViewState = .none
        self.parkingController.bookingPicker.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            if showMainBar {
                self.mainViewState = .mainBar
                delayWithSeconds(1, completion: {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.quickParkingController.view.alpha = 0
                        self.quickDestinationController.view.alpha = 0
                    })
                })
            }
        }
    }

    func backToBooking() {
        mainViewState = .parking
        if let region = ZooomRegion {
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64), animated: true)
        }
    }
    
    @objc func changeFinalDates() {
        self.backToBooking()
        delayWithSeconds(animationIn) {
            self.changeDatesPressed()
        }
    }
    
}
