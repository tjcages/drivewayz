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

protocol handleCheckoutParking {
    func parkingMaximized()
    func startNavigation()
    func startBooking()
    func restartBookingProcess()
    func openBookings()
}

var searchingPlacemark: CLPlacemark?

extension MapKitViewController: handleCheckoutParking {
    
    func setupMapButtons() {

        view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        parkingBackButton.bottomAnchor.constraint(equalTo: bookingController.view.topAnchor, constant: -16).isActive = true
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
    
    func monitorZipChange() {
        guard let search = searchingPlacemark, let searchZip = search.postalCode, let observed = observedZip else { return }
        if searchZip != observed {
            observeParking(placemark: search)
        } else {
            zipParkingLots.removeAll()
            for lot in zipSortedParkingLots {
                zipTimer?.invalidate()
                zipTimer = nil
                
                if var dictionary = lot.dictionary, let searchLat = searchingPlacemark?.location?.coordinate.latitude, let searchLong = searchingPlacemark?.location?.coordinate.longitude {
                    dictionary["destinationLat"] = searchLat
                    dictionary["destinationLong"] = searchLong
                    
                    let parkingLot = ParkingLot(dictionary: dictionary)
                    
                    if let distance = parkingLot.destinationDistance {
                        zipParkingLots[parkingLot] = distance
                    }
                }
                zipTimer = Timer.scheduledTimer(timeInterval: animationOut, target: self, selector: #selector(self.finishedObservingParking), userInfo: nil, repeats: false)
            }
        }
    }
    
    func openBookings() {
        shouldShowLots = false
        
        dimTabView(0) {}
        monitorZipChange()
        hideWelcomeBanner()
        closeSearch(parking: true)
        
        removeAllMapOverlays(shouldRefresh: false)
        delayWithSeconds(animationOut) {
            self.mainViewState = .parking
        }
    }
    
    @objc func parkingBackButtonPressed() {
        if parkingControllerBottomAnchor.constant == 0 && self.parkingControllerHeightAnchor.constant != parkingNormalHeight && mainViewState != .payment {
            closeBooking()
        } else if parkingControllerBottomAnchor.constant == 0 {
            if mainViewState == .payment {
                dismissPurchaseController()
            } else {
                bookingController.unselectFirstIndex()
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
    
    func parkingMaximized() {
        parkingControllerBottomAnchor.constant = 0
        UIView.animateOut(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 1
            self.parkingRouteButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            defaultContentStatusBar()
        }
    }
    
    func parkingMinimized() {
        parkingControllerBottomAnchor.constant = parkingNormalHeight
        UIView.animateOut(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.parkingRouteButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    @objc func parkingHidden(showMainBar: Bool) {
//        shouldBeSearchingForAnnotations = true
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.quickParkingView.alpha = 0
            self.quickDurationView.alpha = 0
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
    
    func presentPublicController(spotType: SpotType) {
        parkingMinimized()
        
        let controller = PurchasePublicView()
        controller.spotType = spotType
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
        
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0.4
        }) { (success) in
            //
        }
    }
    
}


