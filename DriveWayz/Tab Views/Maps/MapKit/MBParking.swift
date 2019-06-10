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
}

extension MapKitViewController: handleCheckoutParking {
    
    func setupParking() {
        
        self.view.addSubview(purchaseController.view)
        purchaseController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purchaseController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purchaseControllerBottomAnchor = purchaseController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 500)
            purchaseControllerBottomAnchor.isActive = true
        switch device {
        case .iphone8:
            purchaseController.view.heightAnchor.constraint(equalToConstant: 412).isActive = true
        case .iphoneX:
            purchaseController.view.heightAnchor.constraint(equalToConstant: 440).isActive = true
        }
        
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingController.view.heightAnchor.constraint(equalToConstant: 372).isActive = true
        parkingController.timeButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.timeLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.mainButton.addTarget(self, action: #selector(bookSpotPressed), for: .touchUpInside)
        
        self.view.addSubview(expandedSpotController.view)
        expandedSpotController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        expandedSpotController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        expandedSpotBottomAnchor = expandedSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: phoneHeight)
            expandedSpotBottomAnchor.isActive = true
        expandedSpotController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        self.view.addSubview(confirmPaymentController.view)
        confirmPaymentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        confirmPaymentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        confirmControllerBottomAnchor = confirmPaymentController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 380)
            confirmControllerBottomAnchor.isActive = true
        confirmPaymentController.view.heightAnchor.constraint(equalToConstant: 328).isActive = true
        confirmPaymentController.monitorCurrentParking()
        confirmPaymentController.changeButton.addTarget(self, action: #selector(changeFinalDates), for: .touchUpInside)
        
        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        parkingBackButtonBookAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -8)
            parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: purchaseController.view.topAnchor, constant: -8)
            parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: confirmPaymentController.view.topAnchor, constant: -8)
            parkingBackButtonConfirmAnchor.isActive = false
        parkingBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(quickDestinationController.view)
        quickDestinationRightAnchor = quickDestinationController.view.rightAnchor.constraint(equalTo: self.view.leftAnchor)
            quickDestinationRightAnchor.isActive = true
        quickDestinationTopAnchor = quickDestinationController.view.bottomAnchor.constraint(equalTo: self.view.topAnchor)
            quickDestinationTopAnchor.isActive = true
        quickDestinationController.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        quickDestinationController.view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(polyRouteLocatorButton)
        polyRouteLocatorButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        polyRouteLocatorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        polyRouteLocatorButton.widthAnchor.constraint(equalTo: polyRouteLocatorButton.heightAnchor).isActive = true
        polyRouteLocatorButton.bottomAnchor.constraint(equalTo: parkingBackButton.bottomAnchor).isActive = true
        
    }
    
    @objc func parkingBackButtonPressed() {
        if purchaseControllerBottomAnchor.constant == 0 {
            self.changeDatesDismissed()
        } else if parkingControllerBottomAnchor.constant == 0 {
            self.parkingHidden()
        } else if confirmControllerBottomAnchor.constant == 0 {
            self.backToBooking()
        }
    }
    
    func becomeAHost() {
        self.delegate?.moveToProfile()
        self.delegate?.bringNewHostingController()
    }
    
    func setDurationPressed(fromDate: Date, totalTime: String) {
        self.changeDatesDismissed()
        self.summaryController.changeDates(fromDate: fromDate, totalTime: totalTime)
        self.parkingController.changeDates(fromDate: fromDate, totalTime: totalTime)
        self.confirmPaymentController.changeDates(fromDate: fromDate, totalTime: totalTime)
    }
    
    @objc func bookSpotPressed() {
        self.purchaseController.saveDates()
        self.view.bringSubviewToFront(confirmPaymentController.view)
        self.confirmControllerBottomAnchor.constant = 0
        self.parkingControllerBottomAnchor.constant = 420
        self.parkingBackButtonBookAnchor.isActive = false
        self.parkingBackButtonPurchaseAnchor.isActive = false
        self.parkingBackButtonConfirmAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }

    func parkingSelected() {
        self.parkingController.bookingPicker.reloadData()
        self.purchaseController.saveDates()
        self.view.bringSubviewToFront(parkingController.view)
        self.view.bringSubviewToFront(parkingBackButton)
//        self.parkingController.bookingFound()
//        self.summaryController.shouldBeLoading = false
        self.parkingControllerBottomAnchor.constant = 0
        self.purchaseControllerBottomAnchor.constant = 500
        self.parkingBackButtonBookAnchor.isActive = true
        self.parkingBackButtonPurchaseAnchor.isActive = false
        self.parkingBackButtonConfirmAnchor.isActive = false
        self.locatorMainBottomAnchor.isActive = false
        self.locatorParkingBottomAnchor.isActive = true
        self.mapViewBottomAnchor.constant = -300
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingHidden() {
        self.shouldBeSearchingForAnnotations = true
        self.removePolylineAnnotations()
        self.parkingControllerBottomAnchor.constant = 420
        self.searchBarController.closeSearchBar()
        self.locatorMainBottomAnchor.isActive = true
        self.locatorParkingBottomAnchor.isActive = false
        self.mapViewBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.bringMainBar()
            self.removeAllMapOverlays(shouldRefresh: true)
            self.delegate?.bringHamburger()
        }
    }
    
    func backToBooking() {
        self.view.bringSubviewToFront(parkingController.view)
        self.confirmControllerBottomAnchor.constant = 380
        self.parkingControllerBottomAnchor.constant = 0
        self.parkingBackButtonBookAnchor.isActive = true
        self.parkingBackButtonPurchaseAnchor.isActive = false
        self.parkingBackButtonConfirmAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func changeFinalDates() {
        self.backToBooking()
        delayWithSeconds(animationIn) {
            self.changeDatesPressed()
        }
    }
    
    func removeAllHostLocations() {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
    }
    
    func removeAllMapOverlays(shouldRefresh: Bool) {
        ParkingRoutePolyLine = []
        ZoomMapView = nil
        CurrentDestinationLocation = nil
        ClosestParkingLocation = nil
        DestinationAnnotationLocation = nil
        self.shouldShowOverlay = false
        self.quickDestinationController.view.alpha = 0
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, zoomLevel: 14, animated: true)
            self.mapView.userTrackingMode = .follow
        }
        self.removePolylineAnnotations()
        if shouldRefresh == true {
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
                self.placeAllAnnotations()
            } else {
                self.placeAllAnnotations()
            }
        } else {
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
            }
        }
    }
    
    func removePolylineAnnotations() {
        self.shouldShowOverlay = false
        self.quickDestinationController.view.alpha = 0
        if self.polylineSecondTimer != nil { self.polylineSecondTimer!.invalidate() }
        if self.polylineFirstTimer != nil { self.polylineFirstTimer!.invalidate() }
        if let layers = self.mapView.style?.layers {
            for layer in layers {
                if self.polylineLayer != nil && layer == self.polylineLayer {
                    self.mapView.style?.removeLayer(layer)
                    self.polylineLayer = nil
                }
                if self.polylineSecondLayer != nil && layer == self.polylineSecondLayer {
                    self.mapView.style?.removeLayer(layer)
                    self.polylineSecondLayer = nil
                }
                if let lastAnnotation = self.mapView.annotations?.last, lastAnnotation.title == "ParkingUnder" {
                    self.mapView.removeAnnotation(lastAnnotation)
                }
                if let annotations = self.mapView.annotations {
                    for annotation in annotations {
                        if annotation.title == "ParkingUnder" {
                            self.mapView.removeAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
}
