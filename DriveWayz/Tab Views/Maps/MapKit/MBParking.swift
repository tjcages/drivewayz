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
    func expandCheckmark(current: Bool, booking: Bookings)
    func setQuickParkingLabel(text: String)
    
    func changeParkingOptionsHeight(fade: CGFloat)
    func bringExpandedBooking()
    func hideExpandedBooking()
}

var currentTotalTime: String?

extension MapKitViewController: handleCheckoutParking {
    
    func setupMapButtons() {

        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        parkingBackButtonBookAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -16)
            parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: durationController.view.topAnchor, constant: -16)
            parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: confirmPaymentController.view.topAnchor, constant: -16)
            parkingBackButtonConfirmAnchor.isActive = false
        parkingBackButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.view.addSubview(quickDestinationController.view)
        quickDestinationRightAnchor = quickDestinationController.view.centerXAnchor.constraint(equalTo: self.view.leftAnchor)
            quickDestinationRightAnchor.isActive = true
        quickDestinationTopAnchor = quickDestinationController.view.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            quickDestinationTopAnchor.isActive = true
        quickDestinationWidthAnchor = quickDestinationController.view.widthAnchor.constraint(equalToConstant: 100)
            quickDestinationWidthAnchor.isActive = true
        quickDestinationController.view.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        quickDestinationController.view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.view.addSubview(quickParkingController.view)
        quickParkingRightAnchor = quickParkingController.view.centerXAnchor.constraint(equalTo: self.view.leftAnchor)
            quickParkingRightAnchor.isActive = true
        quickParkingTopAnchor = quickParkingController.view.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            quickParkingTopAnchor.isActive = true
        quickParkingWidthAnchor = quickParkingController.view.widthAnchor.constraint(equalToConstant: 180)
            quickParkingWidthAnchor.isActive = true
        quickParkingController.view.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
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
    
    @objc func parkingBackButtonPressed() {
        if parkingControllerBottomAnchor.constant == 0 && self.parkingControllerHeightAnchor.constant == 372 {
            parkingHidden(showMainBar: true)
        } else if parkingControllerBottomAnchor.constant == 0 {
            parkingHidden(showMainBar: true)
        } else if confirmControllerBottomAnchor.constant == 0 {
            backToBooking()
        } else {
            if BookedState == .currentlyBooked {
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
        currentTotalTime = totalTime
        self.parkingController.bookingPicker.setContentOffset(.zero, animated: true)
        self.summaryController.changeDates(fromDate: fromDate, totalTime: totalTime)
        self.parkingController.changeDates(fromDate: fromDate, totalTime: totalTime)
        self.confirmPaymentController.changeDates()
    }
    
    func observeAllHosting() {
        mapView.clear()
        observeAllParking()
    }
    
    @objc func bookSpotPressed() {
        mainViewState = .payment
        locatorButtonPressed(padding: 32)
        if let price = self.parkingController.selectedParkingSpot?.dynamicCost, let parking = self.parkingController.selectedParkingSpot {
            confirmPaymentController.setData(price: Double(price), parking: parking)
        }
    }

    func parkingSelected() {
        self.parkingController.bookingPicker.reloadData()
        mainViewState = .parking
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 1
            self.view.layoutIfNeeded()
        }
        checkParkingOpens()
    }
    
    @objc func parkingHidden(showMainBar: Bool) {
        shouldBeSearchingForAnnotations = true
        removeRouteLine()
        removeAllMapOverlays(shouldRefresh: true)
        parkingController.bookingPicker.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.quickParkingController.view.alpha = 0
            self.quickDestinationController.view.alpha = 0
            if bookingTutorialController.view.alpha == 1 {
                bookingTutorialController.view.alpha = 0
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
        }
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

    func setQuickParkingLabel(text: String) {
        quickDestinationController.distanceLabel.text = text
        let width = text.width(withConstrainedHeight: 32, font: Fonts.SSPRegularH5) + 16
        quickDestinationWidthAnchor.constant = width
        if text != "" {
            quickDestinationController.view.isHidden = false
        } else {
            quickDestinationController.view.isHidden = true
        }
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func backToBooking() {
        mainViewState = .parking
        locatorButtonPressed(padding: 80)
    }
    
    @objc func changeFinalDates() {
        self.backToBooking()
        delayWithSeconds(animationIn) {
            self.changeDatesPressed()
        }
    }
    
}


