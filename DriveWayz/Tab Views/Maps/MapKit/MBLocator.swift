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

protocol handleLocatorButton {
    func locatorButtonPressed()
}

extension MapKitViewController: CLLocationManagerDelegate, UIGestureRecognizerDelegate, handleLocatorButton {
    
    func mapView(_ mapView: MGLMapView, regionWillChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        print(reason)
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return Theme.LIGHT_PURPLE
    }
    
    @objc func locatorButtonAction(sender: UIButton) {
        if let region = ZoomMapView {
            self.mapView.userTrackingMode = .none
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 420, right: 66), animated: true)
            if let location = DestinationAnnotationLocation {
                delayWithSeconds(0.5) {
                    self.checkQuickDestination(annotationLocation: location)
                }
            }
        } else {
            if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
                self.mapView.setCenter(location, zoomLevel: 14, animated: true)
                self.mapView.userTrackingMode = .follow
            }
        }
        UIView.animate(withDuration: animationIn) {
            self.locatorButton.alpha = 0
            self.polyRouteLocatorButton.alpha = 0
        }
    }
    
    func locatorButtonPressed() {
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, zoomLevel: 14, animated: true)
            self.mapView.userTrackingMode = .follow
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
        if self.searchedForPlace == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let userLocation = self.mapView.userLocation else { return }
                let location: CLLocationCoordinate2D = userLocation.coordinate
                self.mapView.setCenter(location, zoomLevel: 12, animated: false)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                guard let userLocation = self.mapView.userLocation else { return }
                let location: CLLocationCoordinate2D = userLocation.coordinate
                self.mapView.setCenter(location, zoomLevel: 14, animated: true)
                delayWithSeconds(1, completion: {
                    self.mapView.userTrackingMode = .follow
                })
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
            UIView.animate(withDuration: animationOut) {
                if ZoomMapView != nil {
                    self.polyRouteLocatorButton.alpha = 1
                } else {
                    self.locatorButton.alpha = 1
                }
            }
        } else {
            self.mapChangedFromUserInteraction = false
        }
    }
    
    @objc func changeFromUserInteraction() {
        self.mapChangedFromUserInteraction = false
    }
    
    @objc func mapDragged(sender: UIPanGestureRecognizer) {
        if let location = DestinationAnnotationLocation {
            self.checkQuickDestination(annotationLocation: location)
        }
    }
    
    func checkQuickDestination(annotationLocation: CLLocationCoordinate2D) {
        let position = self.mapView.convert(annotationLocation, toPointTo: self.view)
        let xDisplacement = position.x
        let yDisplacement = position.y
        let previousX: CGFloat = self.quickDestinationRightAnchor.constant
        let previousY: CGFloat = self.quickDestinationTopAnchor.constant
        if xDisplacement > self.mapView.frame.width/2 {
            self.quickDestinationRightAnchor.constant = xDisplacement + 20
        } else {
            self.quickDestinationRightAnchor.constant = xDisplacement + self.quickDestinationController.containerWidthAnchor.constant + 20
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
        if (previousY < self.mapView.frame.height/4 && self.quickDestinationTopAnchor.constant > self.mapView.frame.height/4) || (previousY > self.mapView.frame.height/4 && self.quickDestinationTopAnchor.constant < self.mapView.frame.height/4) {
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        }
        if DestinationAnnotationLocation != nil {
            delayWithSeconds(0.5) {
                UIView.animate(withDuration: animationIn, animations: {
                    self.quickDestinationController.view.alpha = 1
                })
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        self.view.layoutIfNeeded()
        if let annotations = self.mapView.visibleAnnotations {
            for annontation in annotations {
                if annontation.subtitle == "Destination" {
                    let position = self.mapView.convert(annontation.coordinate, toPointTo: self.view)
                    let xDisplacement = position.x
                    let yDisplacement = position.y
                    let previousX: CGFloat = self.quickDestinationRightAnchor.constant
                    let previousY: CGFloat = self.quickDestinationTopAnchor.constant
                    if xDisplacement > self.mapView.frame.width/2 {
                        self.quickDestinationRightAnchor.constant = xDisplacement + 20
                    } else {
                        self.quickDestinationRightAnchor.constant = xDisplacement + self.quickDestinationController.containerWidthAnchor.constant + 20
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
                    if (previousY < self.mapView.frame.height/4 && self.quickDestinationTopAnchor.constant > self.mapView.frame.height/4) || (previousY > self.mapView.frame.height/4 && self.quickDestinationTopAnchor.constant < self.mapView.frame.height/4) {
                        UIView.animate(withDuration: animationIn) {
                            self.view.layoutIfNeeded()
                        }
                    }
//                    if DestinationAnnotationLocation != nil {
//                        delayWithSeconds(0.5) {
//                            UIView.animate(withDuration: animationIn, animations: {
//                                self.quickDestinationController.view.alpha = 1
//                            })
//                        }
//                    }
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