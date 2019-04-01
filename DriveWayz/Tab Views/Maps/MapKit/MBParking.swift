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
    func bookSpotPressed(amount: Double)
    func becomeAHost()
    func confirmPurchasePressed()
    func setDurationPressed()
    func didTapParking(parking: ParkingSpots, price: String)
    func didHideExpandedParking()
}

extension MapKitViewController: handleCheckoutParking {
    
    func setupParking() {
        
        self.view.addSubview(purchaseController.view)
        purchaseController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purchaseController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purchaseControllerBottomAnchor = purchaseController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 500)
            purchaseControllerBottomAnchor.isActive = true
        purchaseController.view.heightAnchor.constraint(equalToConstant: 468).isActive = true
        
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingController.view.heightAnchor.constraint(equalToConstant: 332).isActive = true
        
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
        confirmPaymentController.view.heightAnchor.constraint(equalToConstant: 308).isActive = true
        
        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        parkingBackButtonBookAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -8)
            parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: purchaseController.view.topAnchor, constant: -8)
            parkingBackButtonPurchaseAnchor.isActive = false
        parkingBackButtonConfirmAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: confirmPaymentController.view.topAnchor, constant: -8)
            parkingBackButtonConfirmAnchor.isActive = false
        parkingBackButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
    
    func didTapParking(parking: ParkingSpots, price: String) {
        self.delegate?.hideHamburger()
        self.delegate?.lightContentStatusBar()
        self.view.bringSubviewToFront(expandedSpotController.view)
        self.expandedSpotController.openExpand(parking: parking, price: price)
        UIView.animate(withDuration: animationOut) {
            self.fullBackgroundView.alpha = 0.4
            self.parkingControllerBottomAnchor.constant = 420
            self.expandedSpotBottomAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func didHideExpandedParking() {
        self.delegate?.bringHamburger()
        self.delegate?.defaultContentStatusBar()
        self.view.bringSubviewToFront(parkingController.view)
        UIView.animate(withDuration: animationOut) {
            self.fullBackgroundView.alpha = 0
            self.parkingControllerBottomAnchor.constant = 0
            self.expandedSpotBottomAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func becomeAHost() {
        self.delegate?.moveToProfile()
        self.delegate?.bringNewHostingController()
    }
    
    func setDurationPressed() {
        self.confirmPaymentController.setData(price: self.parkingController.selectedPrice * self.purchaseController.totalSelectedTime,
                                              fromDate: self.purchaseController.fromDate, toDate: self.purchaseController.toDate)
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToSetDuration), for: .touchUpInside)
        UIView.animate(withDuration: animationIn) {
            self.purchaseControllerBottomAnchor.constant = 500
            self.confirmControllerBottomAnchor.constant = 0
            self.parkingBackButtonConfirmAnchor.isActive = true
            self.parkingBackButtonBookAnchor.isActive = false
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backToSetDuration() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToBook), for: .touchUpInside)
        UIView.animate(withDuration: animationIn, animations: {
            self.purchaseControllerBottomAnchor.constant = 0
            self.confirmControllerBottomAnchor.constant = 380
            self.parkingBackButtonConfirmAnchor.isActive = false
            self.parkingBackButtonBookAnchor.isActive = false
            self.parkingBackButtonPurchaseAnchor.isActive = true
            self.view.layoutIfNeeded()
        }) { (success) in
            self.purchaseController.resetDurationTimes()
        }
    }
    
    func bookSpotPressed(amount: Double) {
        self.purchaseController.initializeTime()
        UIView.animate(withDuration: 0.1) {
            self.quickDestinationController.view.alpha = 0
        }
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToBook), for: .touchUpInside)
        self.view.bringSubviewToFront(purchaseController.view)
        UIView.animate(withDuration: animationOut) {
            self.purchaseControllerBottomAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
        if let region = ZoomPurchaseMapView {
            if self.quickDestinationController.distanceLabel.text != "0 min" {
                self.mapView.userTrackingMode = .none
                self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 520, right: 66), animated: true)
                if let location = DestinationAnnotationLocation {
                    delayWithSeconds(0.5) {
                        self.checkQuickDestination(annotationLocation: location)
                    }
                }
            }
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingControllerBottomAnchor.constant = 420
            self.parkingBackButtonBookAnchor.isActive = false
            self.parkingBackButtonPurchaseAnchor.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func backToBook() {
        UIView.animate(withDuration: 0.1) {
            self.quickDestinationController.view.alpha = 0
        }
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        if let region = ZoomMapView {
            self.mapView.userTrackingMode = .none
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 420, right: 66), animated: true)
            if let location = DestinationAnnotationLocation {
                delayWithSeconds(0.5) {
                    self.checkQuickDestination(annotationLocation: location)
                }
            }
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.purchaseControllerBottomAnchor.constant = 500
            self.parkingControllerBottomAnchor.constant = 0
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        })
    }

    func parkingSelected() {
        self.view.bringSubviewToFront(parkingController.view)
        self.view.bringSubviewToFront(parkingBackButton)
        self.parkingController.bookingFound()
        self.mapView.userTrackingMode = .none
        self.takeAwayEvents()
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 1
            self.parkingControllerBottomAnchor.constant = 0
            self.purchaseControllerBottomAnchor.constant = 500
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingHidden() {
        eventsAreAllowed = true
        self.shouldBeSearchingForAnnotations = true
        self.removePolylineAnnotations()
        self.removeAllMapOverlays(shouldRefresh: true)
        self.mainBar.isUserInteractionEnabled = true
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, animated: false)
        }
        self.removeAllMapOverlays(shouldRefresh: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.removeAllMapOverlays(shouldRefresh: true)
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.quickDestinationController.view.alpha = 0
            switch device {
            case .iphone8:
                self.mainBarTopAnchor.constant = 100
            case .iphoneX:
                self.mainBarTopAnchor.constant = 120
            }
            self.parkingControllerBottomAnchor.constant = 420
            self.mapViewBottomAnchor.constant = 0
            self.mapViewTopAnchor.constant = 0
            self.parkingBackButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.removeAllMapOverlays(shouldRefresh: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.quickDestinationController.view.alpha = 0
                self.removeAllMapOverlays(shouldRefresh: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.quickDestinationController.view.alpha = 0
                self.mapView.userTrackingMode = .follow
                self.removeAllMapOverlays(shouldRefresh: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.quickDestinationController.view.alpha = 0
                self.removeAllMapOverlays(shouldRefresh: true)
                self.showPartyMarkers()
            }
            if eventsAreAllowed == true {
                self.eventsControllerHidden()
            }
        }
    }
    
    func removeAllMapOverlays(shouldRefresh: Bool) {
        ParkingRoutePolyLine = []
        ZoomMapView = nil
        CurrentDestinationLocation = nil
        ClosestParkingLocation = nil
        DestinationAnnotationLocation = nil
        self.shouldShowOverlay = false
        self.searchBar.isUserInteractionEnabled = true
        self.fromSearchBar.isUserInteractionEnabled = true
        self.quickDestinationController.view.alpha = 0
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, zoomLevel: 14, animated: true)
            self.mapView.userTrackingMode = .follow
        }
        self.removePolylineAnnotations()
        if shouldRefresh == true {
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
                self.findParkingNearUserLocation()
            } else {
                self.findParkingNearUserLocation()
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
