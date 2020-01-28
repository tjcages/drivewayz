//
//  MKParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps
//import Mapbox

let bookingTutorialController = BookingTutorialView()

protocol handleCheckoutParking {
    func becomeAHost()
    func setDurationPressed(fromDate: Date, totalTime: String)
    func observeAllHosting()
}

var currentTotalTime: String?

extension MapKitViewController: handleCheckoutParking {
    
    func setupMapButtons() {

        mapView.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        parkingBackButtonBookAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -16)
            parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: durationController.view.topAnchor, constant: -16)
            parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapView.addSubview(quickDurationView)
        quickDestinationRightAnchor = quickDurationView.centerXAnchor.constraint(equalTo: self.view.leftAnchor)
            quickDestinationRightAnchor.isActive = true
        quickDestinationTopAnchor = quickDurationView.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            quickDestinationTopAnchor.isActive = true
        quickDestinationWidthAnchor = quickDurationView.widthAnchor.constraint(equalToConstant: 212)
            quickDestinationWidthAnchor.isActive = true
        quickDurationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapView.addSubview(quickParkingView)
        quickParkingRightAnchor = quickParkingView.centerXAnchor.constraint(equalTo: self.view.leftAnchor)
            quickParkingRightAnchor.isActive = true
        quickParkingTopAnchor = quickParkingView.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            quickParkingTopAnchor.isActive = true
        quickParkingWidthAnchor = quickParkingView.widthAnchor.constraint(equalToConstant: 164)
            quickParkingWidthAnchor.isActive = true
        quickParkingView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    @objc func parkingBackButtonPressed() {
        if parkingControllerBottomAnchor.constant == 0 && self.parkingControllerHeightAnchor.constant != parkingNormalHeight && mainViewState != .payment {
            closeBooking()
        } else if parkingControllerBottomAnchor.constant == 0 {
            if mainViewState == .payment {
                if parkingController.bannerExpanded {
                    parkingController.expandBanner()
                } else {
                    dismissPurchaseController()
                }
            } else {
                parkingHidden(showMainBar: true)
            }
        } else {
            if BookedState == .currentlyBooked {
                mainViewState = .currentBooking
            } else {
                mainViewState = .mainBar
            }
        }
    }
    
    @objc func parkingHidden(showMainBar: Bool) {
        shouldBeSearchingForAnnotations = true
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.quickParkingView.alpha = 0
            self.quickDurationView.alpha = 0
            if bookingTutorialController.view.alpha == 1 {
                bookingTutorialController.view.alpha = 0
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
        }
        if showMainBar {
            self.mainViewState = .mainBar
            self.removeAllMapOverlays(shouldRefresh: true)
            delayWithSeconds(1, completion: {
                UIView.animate(withDuration: animationIn, animations: {
                    self.quickParkingView.alpha = 0
                    self.quickDurationView.alpha = 0
                })
            })
        }
    }
    
    func becomeAHost() {
        self.delegate?.moveToProfile()
        self.delegate?.bringNewHostingController()
    }
    
    func setDurationPressed(fromDate: Date, totalTime: String) {
        currentTotalTime = totalTime
//        self.parkingController.bookingPicker.setContentOffset(.zero, animated: true)
        self.summaryController.changeDates(fromDate: fromDate, totalTime: totalTime)
//        self.parkingController.changeDates(fromDate: fromDate, totalTime: totalTime)
//        self.confirmPaymentController.changeDates()
    }
    
    func observeAllHosting() {
        mapView.clear()
        observeAllParking()
    }
    
}


