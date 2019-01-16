//
//  MapKitLocator.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

extension MapKitViewController: CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @objc func locatorButtonAction(sender: UIButton) {
        if let region = ZoomMapView {
            self.mapView.userTrackingMode = .none
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 40, left: 36, bottom: 40, right: 36), animated: true)
        } else {
            if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
                self.mapView.setCenter(location, zoomLevel: 14, animated: true)
                self.mapView.userTrackingMode = .follow
            }
        }
        self.locatorButton.tintColor = Theme.SEA_BLUE
        self.locatorButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: animationIn) {
            self.parkingLocatorButton.alpha = 0
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let sourceLocation = self.locationManager.location else { return }
        if let currentPark = ClosestParkingLocation, self.shouldDrawOverlay == true {
            self.drawCurrentPath(dest: currentPark, start: sourceLocation, type: "Parking", address: "") { (results: Bool) in
                var overlays = self.mapView.overlays
                if overlays.count > 0 {
                    overlays.remove(at: overlays.count - 1)
                    if overlays.count > 0 {
                        for i in 0...overlays.count - 1 {
                            if overlays.count > i && overlays[i].title == "Destination Route" {
                                overlays.remove(at: i)
                            }
                        }
                    }
                }
                self.mapView.removeOverlays(overlays)
                if let currentDest = CurrentDestinationLocation, let closestLoc = ClosestParkingLocation, self.mapChangedFromUserInteraction == false && self.changeLocationCounter > 20 {
                    self.findBestLatLong(first: sourceLocation, second: currentDest, third: closestLoc)
                    self.changeLocationCounter = 0
                } else {
                    self.changeLocationCounter += 1
                }
            }
        }
    }
    
    func setupLocationManager() {
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.startUpdatingLocation()
        
        if self.currentActive == false && self.searchedForPlace == false && alreadyLoadedSpots == false {
//            self.observeUserParkingSpots()
            self.observeAllParking()
        }
        self.resultsScrollAnchor.constant = 0
        if self.searchedForPlace == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let location: CLLocationCoordinate2D = self.mapView.userLocation?.coordinate {
                    self.mapView.setCenter(location, zoomLevel: 13, animated: false)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let location: CLLocationCoordinate2D = self.mapView.userLocation?.coordinate {
                    self.mapView.setCenter(location, zoomLevel: 14, animated: true)
                }
            }
        } else {
            return
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionIsChangingWith reason: MGLCameraChangeReason) {
        self.view.layoutIfNeeded()
        let value = reason.rawValue
        if value == 4 {
            self.mapChangedFromUserInteraction = true
            self.changeUserInteractionTimer.invalidate()
            self.changeUserInteractionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeFromUserInteraction), userInfo: nil, repeats: false)
            
            self.locatorButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.locatorButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: animationOut) {
                self.parkingLocatorButton.alpha = 1
            }
        } else {
            self.mapChangedFromUserInteraction = false
        }
    }
    
    @objc func changeFromUserInteraction() {
        self.mapChangedFromUserInteraction = false
    }
    
    @objc func mapDragged(sender: UIPanGestureRecognizer) {
        self.checkQuickDestination()
    }
    
    func checkQuickDestination() {
        if let annotations = self.mapView.visibleAnnotations, self.shouldDrawOverlay == true {
            for annontation in annotations {
                if annontation.subtitle == "Destination" {
                    self.quickDestinationController.view.alpha = 1
                    let position = self.mapView.convert(annontation.coordinate, toPointTo: self.view)
                    let xDisplacement = position.x
                    let yDisplacement = position.y
                    let previousX: CGFloat = self.quickDestinationRightAnchor.constant
                    let previousY: CGFloat = self.quickDestinationTopAnchor.constant
                    if xDisplacement > self.mapView.frame.width/2 {
                        self.quickDestinationRightAnchor.constant = xDisplacement + 40
                    } else {
                        self.quickDestinationRightAnchor.constant = xDisplacement + self.quickDestinationController.containerWidthAnchor.constant + 40
                    }
                    if (previousX > self.view.frame.width && self.quickDestinationRightAnchor.constant < self.view.frame.width) || (previousX < self.view.frame.width && self.quickDestinationRightAnchor.constant > self.view.frame.width) {
                        UIView.animate(withDuration: animationIn) {
                            self.view.layoutIfNeeded()
                        }
                    }
                    if yDisplacement > self.mapView.frame.height/2 {
                        self.quickDestinationTopAnchor.constant = yDisplacement - 20
                    } else {
                        self.quickDestinationTopAnchor.constant = yDisplacement + 60
                    }
                    if (previousY < self.mapView.frame.height/2 && self.quickDestinationTopAnchor.constant > self.mapView.frame.height/2) || (previousY > self.mapView.frame.height/2 && self.quickDestinationTopAnchor.constant < self.mapView.frame.height/2) {
                        UIView.animate(withDuration: animationIn) {
                            self.view.layoutIfNeeded()
                        }
                    }
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            self.quickDestinationController.view.alpha = 0
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        self.view.layoutIfNeeded()
        if let annotations = self.mapView.visibleAnnotations, self.shouldDrawOverlay == true {
            for annontation in annotations {
                if annontation.subtitle == "Destination" {
                    self.quickDestinationController.view.alpha = 1
                    let position = self.mapView.convert(annontation.coordinate, toPointTo: self.view)
                    let xDisplacement = position.x
                    let yDisplacement = position.y
                    let previousX: CGFloat = self.quickDestinationRightAnchor.constant
                    let previousY: CGFloat = self.quickDestinationTopAnchor.constant
                    if xDisplacement > self.mapView.frame.width/2 {
                        self.quickDestinationRightAnchor.constant = xDisplacement + 40
                    } else {
                        self.quickDestinationRightAnchor.constant = xDisplacement + self.quickDestinationController.containerWidthAnchor.constant + 40
                    }
                    if (previousX > self.view.frame.width && self.quickDestinationRightAnchor.constant < self.view.frame.width) || (previousX < self.view.frame.width && self.quickDestinationRightAnchor.constant > self.view.frame.width) {
                        UIView.animate(withDuration: animationIn) {
                            self.view.layoutIfNeeded()
                        }
                    }
                    if yDisplacement > self.mapView.frame.height/2 {
                        self.quickDestinationTopAnchor.constant = yDisplacement - 20
                    } else {
                        self.quickDestinationTopAnchor.constant = yDisplacement + 60
                    }
                    if (previousY < self.mapView.frame.height/2 && self.quickDestinationTopAnchor.constant > self.mapView.frame.height/2) || (previousY > self.mapView.frame.height/2 && self.quickDestinationTopAnchor.constant < self.mapView.frame.height/2) {
                        UIView.animate(withDuration: animationIn) {
                            self.view.layoutIfNeeded()
                        }
                    }
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            self.quickDestinationController.view.alpha = 0
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
