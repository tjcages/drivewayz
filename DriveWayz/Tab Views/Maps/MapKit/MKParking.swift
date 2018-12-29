//
//  MKParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit

protocol handleCheckoutParking {
    func parkingHidden()
    func setTimesPressed()
    func setTimesDismissed()
    func saveDurationPressed()
    func confirmPurchaseDismissed()
}

extension MapKitViewController: handleCheckoutParking {
    
    @objc func parkingControllerPanned(sender: UIPanGestureRecognizer) {
        let translation = -sender.translation(in: self.view).y
        let percentage = translation / 60
        if sender.state == .changed {
            if translation < 60 && translation > 0 {
                self.parkingControllerHeightAnchor.constant = 360 + translation
                self.fullBackgroundView.alpha = percentage * 0.4
                self.view.layoutIfNeeded()
            } else if translation > 60 {
                UIView.animate(withDuration: animationIn) {
                    self.parkingControllerHeightAnchor.constant = self.view.frame.height
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: animationIn) {
                    self.fullBackgroundView.alpha = 0
                    self.parkingControllerHeightAnchor.constant = 360
                    self.view.layoutIfNeeded()
                }
            }
        } else if sender.state == .ended {
            if self.parkingControllerHeightAnchor.constant > 420 {
                UIView.animate(withDuration: animationIn) {
                    self.parkingControllerHeightAnchor.constant = self.view.frame.height
                    self.fullBackgroundView.alpha = 1
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: animationIn) {
                    self.parkingControllerHeightAnchor.constant = 360
                    self.fullBackgroundView.alpha = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func setupParking() {
        
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = parkingController.view.heightAnchor.constraint(equalToConstant: 360)
            parkingControllerHeightAnchor.isActive = true
        let panParking = UIPanGestureRecognizer(target: self, action: #selector(parkingControllerPanned(sender:)))
        parkingController.view.addGestureRecognizer(panParking)
        
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
    }
    
    func setTimesPressed() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(setTimesDismissedPressed(sender:)), for: .touchUpInside)
        self.view.bringSubviewToFront(self.parkingController.view)
        self.view.bringSubviewToFront(self.parkingBackButton)
        UIView.animate(withDuration: animationIn) {
            self.parkingController.durationView.alpha = 1
            self.fullBackgroundView.alpha = 0.7
            self.hamburgerButton.alpha = 0
            self.parkingLocatorButton.alpha = 0
            self.parkingControllerHeightAnchor.constant = 490
            self.parkingBackButton.tintColor = Theme.WHITE
            self.view.layoutIfNeeded()
        }
        self.parkingController.setTimesButton.setTitle("SAVE DURATION", for: .normal)
    }
    
    @objc func setTimesDismissedPressed(sender: UIButton) {
        self.parkingController.regularViewTapped()
    }
    
    func setTimesDismissed() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        UIView.animate(withDuration: animationIn) {
            self.parkingController.durationView.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.hamburgerButton.alpha = 1
            self.parkingLocatorButton.alpha = 1
            self.parkingControllerHeightAnchor.constant = 360
            self.parkingBackButton.tintColor = Theme.BLACK
            self.view.layoutIfNeeded()
        }
        self.parkingController.setTimesButton.setTitle("SET TIME", for: .normal)
    }
    
    func saveDurationPressed() {
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(backToDurationPressed), for: .touchUpInside)
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0
            self.hamburgerButton.alpha = 1
            self.parkingControllerHeightAnchor.constant = 440
            self.parkingBackButton.tintColor = Theme.BLACK
            self.view.layoutIfNeeded()
        }
        self.mapViewBottomAnchor.constant = -420
        self.view.layoutIfNeeded()
        if let zoomRegion = IncreasedZoomMapView {
            self.mapView.setRegion(zoomRegion, animated: true)
        }
    }
    
    func confirmPurchaseDismissed() {
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0.7
            self.hamburgerButton.alpha = 0
            self.parkingLocatorButton.alpha = 0
            self.parkingControllerHeightAnchor.constant = 490
            self.mapViewBottomAnchor.constant = -340
            self.parkingBackButton.tintColor = Theme.WHITE
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backToDurationPressed() {
        self.parkingController.regularViewTapped()
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
            self.mapViewBottomAnchor.constant = -340
            self.parkingControllerHeightAnchor.constant = 360
            self.view.layoutIfNeeded()
        }
    }
    
    func searchForParking() {
        self.parkingBackButton.alpha = 0
        self.parkingController.bringUpSearch()
        self.shouldDrawOverlay = true
        self.takeAwayEvents()
        UIView.animate(withDuration: animationIn) {
            self.parkingControllerBottomAnchor.constant = 0
            self.parkingControllerHeightAnchor.constant = 130
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingHidden() {
        self.shouldDrawOverlay = false
        let location: CLLocationCoordinate2D = mapView.userLocation.coordinate
        let camera = MKMapCamera()
        camera.centerCoordinate = location
        camera.altitude = 1000
        self.mapView.setCamera(camera, animated: false)
        self.removeAllMapOverlays()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.removeAllMapOverlays()
        }
        UIView.animate(withDuration: animationOut, animations: {
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
                self.removeAllMapOverlays()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.mapView.userTrackingMode = .follow
                self.removeAllMapOverlays()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.removeAllMapOverlays()
                self.showPartyMarkers()
            }
            if eventsAreAllowed == true {
                self.eventsControllerHidden()
            }
        }
    }
    
    func removeAllMapOverlays() {
        if self.polylineTimer != nil { self.polylineTimer.invalidate() }
        if let annotation = DestinationAnnotation {
            self.mapView.removeAnnotation(annotation)
        }
        ParkingRoutePolyLine = []
        ZoomMapView = nil
        CurrentDestinationLocation = nil
        ClosestParkingLocation = nil
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
    }
    
}
