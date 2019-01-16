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
    func bookSpotPressed()
}

extension MapKitViewController: handleCheckoutParking {
    
    func setupParking() {
        
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = parkingController.view.heightAnchor.constraint(equalToConstant: 345)
            parkingControllerHeightAnchor.isActive = true
        
        self.view.addSubview(parkingLocatorButton)
        parkingLocatorButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        parkingLocatorButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -12).isActive = true
        parkingLocatorButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        parkingLocatorButton.widthAnchor.constraint(equalTo: parkingLocatorButton.heightAnchor).isActive = true
        
        self.view.addSubview(parkingBackButton)
        parkingBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        parkingBackButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -8).isActive = true
        parkingBackButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        parkingBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(quickDestinationController.view)
        quickDestinationRightAnchor = quickDestinationController.view.rightAnchor.constraint(equalTo: self.view.leftAnchor)
            quickDestinationRightAnchor.isActive = true
        quickDestinationTopAnchor = quickDestinationController.view.bottomAnchor.constraint(equalTo: self.view.topAnchor)
            quickDestinationTopAnchor.isActive = true
        quickDestinationController.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        quickDestinationController.view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    func bookSpotPressed() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToBook), for: .touchUpInside)
        self.parkingControllerHeightAnchor.constant = 380
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backToBook() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        self.parkingControllerHeightAnchor.constant = 345
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
        self.parkingController.backToBook()
    }

    func parkingSelected() {
        self.view.bringSubviewToFront(parkingController.view)
        self.parkingController.parkingSelected()
        self.mapView.userTrackingMode = .none
        self.shouldDrawOverlay = true
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.alpha = 1
            self.mainBarTopAnchor.constant = -100
            self.parkingControllerBottomAnchor.constant = 0
            self.mapViewBottomAnchor.constant = -330
            self.parkingControllerHeightAnchor.constant = 345
            self.view.layoutIfNeeded()
        }
    }
    
    func searchForParking() {
        self.parkingBackButton.alpha = 0
        self.parkingController.bringUpSearch()
        self.shouldDrawOverlay = true
        self.takeAwayEvents()
        self.mainBar.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationIn) {
            self.parkingControllerBottomAnchor.constant = 0
            self.parkingControllerHeightAnchor.constant = 130
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingHidden() {
        self.shouldDrawOverlay = false
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
            if eventsAreAllowed == true {
                self.eventsControllerHidden()
            }
        }
    }
    
    func removeAllMapOverlays() {
        if self.polylineFirstTimer != nil { self.polylineFirstTimer!.invalidate() }
        if self.polylineSecondTimer != nil { self.polylineSecondTimer!.invalidate() }
        
        ParkingRoutePolyLine = []
        ZoomMapView = nil
        CurrentDestinationLocation = nil
        ClosestParkingLocation = nil
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
                if self.polylineCircleLayer != nil && layer == self.polylineCircleLayer {
                    self.mapView.style?.removeLayer(layer)
                    self.polylineSecondLayer = nil
                }
                if let lastAnnotation = self.mapView.annotations?.last, lastAnnotation.title == "ParkingUnder" {
                    self.mapView.removeAnnotation(lastAnnotation)
                }
            }
        }
//        if let last = self.mapView.style?.layers.last, let nextLast = self.mapView.style?.layers.last {
//            if self.polylineLayer != nil && last == self.polylineLayer {
//                self.mapView.style?.removeLayer(last)
//                self.polylineLayer = nil
//            }
//            if self.polylineSecondLayer != nil && nextLast == self.polylineSecondLayer {
//                self.mapView.style?.removeLayer(nextLast)
//                self.polylineSecondLayer = nil
//            }
//            if self.polylineCircleLayer != nil && last == self.polylineCircleLayer {
//                self.mapView.style?.removeLayer(nextLast)
//                self.polylineSecondLayer = nil
//            }
//            if let lastAnnotation = self.mapView.annotations?.last, lastAnnotation.title == "ParkingUnder" {
//                self.mapView.removeAnnotation(lastAnnotation)
//            }
//        }
    }
    
}
