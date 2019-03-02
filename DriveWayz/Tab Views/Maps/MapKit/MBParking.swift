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
    func setDurationPressed()
    func durationSet()
    func confirmPurchasePressed()
}

extension MapKitViewController: handleCheckoutParking {
    
    func setupParking() {
        
        self.view.addSubview(purchaseController.view)
        purchaseController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purchaseController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purchaseControllerBottomAnchor = purchaseController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 320)
            purchaseControllerBottomAnchor.isActive = true
        purchaseControllerHeightAnchor = purchaseController.view.heightAnchor.constraint(equalToConstant: 240)
            purchaseControllerHeightAnchor.isActive = true
        
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingController.view.heightAnchor.constraint(equalToConstant: 392).isActive = true
        
        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        parkingBackButtonBookAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -8)
            parkingBackButtonBookAnchor.isActive = true
        parkingBackButtonPurchaseAnchor = parkingBackButton.bottomAnchor.constraint(equalTo: purchaseController.view.topAnchor, constant: -8)
            parkingBackButtonPurchaseAnchor.isActive = false
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
    
    func becomeAHost() {
        self.delegate?.moveToProfile()
        self.delegate?.bringNewHostingController()
    }
    
    func setDurationPressed() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(durationSet), for: .touchUpInside)
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(purchaseController.view)
        self.view.bringSubviewToFront(parkingBackButton)
        self.delegate?.hideHamburger()
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 0.6
            self.purchaseControllerHeightAnchor.constant = 528
            self.parkingBackButton.tintColor = Theme.WHITE
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    @objc func durationSet() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToBook), for: .touchUpInside)
        self.view.bringSubviewToFront(parkingController.view)
        self.delegate?.bringHamburger()
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 0
            self.purchaseControllerHeightAnchor.constant = 240
            self.parkingBackButton.tintColor = Theme.BLACK
            self.purchaseController.confirmPurchaseButton.backgroundColor = Theme.BLACK
            self.purchaseController.confirmPurchaseButton.setTitleColor(Theme.WHITE, for: .normal)
            self.purchaseController.confirmPurchaseButton.layer.borderWidth = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.purchaseController.durationSet()
        }
    }
    
    func bookSpotPressed(amount: Double) {
        UIView.animate(withDuration: 0.1) {
            self.quickDestinationController.view.alpha = 0
        }
        self.purchaseController.parkingCost = amount
        self.purchaseController.bookingPressed()
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToBook), for: .touchUpInside)
        self.purchaseControllerBottomAnchor.constant = 0
        self.view.layoutIfNeeded()
        if let region = ZoomPurchaseMapView {
            self.mapView.userTrackingMode = .none
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 320, right: 66), animated: true)
            if let location = DestinationAnnotationLocation {
                delayWithSeconds(0.5) {
                    self.checkQuickDestination(annotationLocation: location)
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
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 480, right: 66), animated: true)
            if let location = DestinationAnnotationLocation {
                delayWithSeconds(0.5) {
                    self.checkQuickDestination(annotationLocation: location)
                }
            }
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.purchaseControllerBottomAnchor.constant = 320
            self.parkingControllerBottomAnchor.constant = 0
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        })
    }

    func parkingSelected() {
        self.view.bringSubviewToFront(parkingController.view)
        self.view.bringSubviewToFront(parkingBackButton)
        self.parkingController.parkingSelected()
        self.mapView.userTrackingMode = .none
        self.takeAwayEvents()
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 1
            self.parkingControllerBottomAnchor.constant = 0
            self.purchaseControllerBottomAnchor.constant = 320
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingHidden() {
        self.removePolylineAnnotations()
        self.removeAllMapOverlays()
        self.mainBar.isUserInteractionEnabled = true
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, animated: false)
        }
        self.removeAllMapOverlays()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.removeAllMapOverlays()
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
            self.removeAllMapOverlays()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.quickDestinationController.view.alpha = 0
                self.removeAllMapOverlays()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.quickDestinationController.view.alpha = 0
                self.mapView.userTrackingMode = .follow
                self.removeAllMapOverlays()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.quickDestinationController.view.alpha = 0
                self.removeAllMapOverlays()
                self.showPartyMarkers()
            }
            delayWithSeconds(1, completion: {
                self.parkingController.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
                self.parkingController.standardLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            if eventsAreAllowed == true {
                self.eventsControllerHidden()
            }
        }
    }
    
    func removeAllMapOverlays() {
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
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
            self.findParkingNearUserLocation()
        } else {
            self.findParkingNearUserLocation()
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
