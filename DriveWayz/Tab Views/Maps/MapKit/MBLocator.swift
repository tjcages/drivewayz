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

var userCity: String = ""

extension MapKitViewController: CLLocationManagerDelegate, UIGestureRecognizerDelegate, handleLocatorButton {
    
    @objc func locatorButtonAction(sender: UIButton) {
        if let region = ZooomRegion {
            self.mapView.userTrackingMode = .none
            if self.parkingControllerBottomAnchor?.constant == 0 {
                let insets = UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64)
                self.mapView.setVisibleCoordinateBounds(region, edgePadding: insets, animated: true, completionHandler: nil)
            } else {
                if self.mainViewState != .currentBooking {
                    let insets = UIEdgeInsets(top: statusHeight + 40, left: 32, bottom: 320, right: 32)
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: insets, animated: true, completionHandler: nil)
                } else {
                    let insets = UIEdgeInsets(top: statusHeight + 156, left: 64, bottom: 320, right: 64)
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: insets, animated: true, completionHandler: nil)
                }
            }
        } else {
            if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
                self.mapView.allowsRotating = true
                self.mapView.isRotateEnabled = true
                self.mapView.resetNorth()
                let camera = MGLMapCamera(lookingAtCenter: location, altitude: CLLocationDistance(exactly: 18000)!, pitch: 0, heading: CLLocationDirection(0))
                self.mapView.setCamera(camera, withDuration: animationOut * 2, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight*3/4 - 60, right: phoneWidth/2), completionHandler: nil)
                delayWithSeconds(animationOut * 2) {
                    self.mapView.isRotateEnabled = false
                    self.mapView.allowsRotating = false
                    self.mapView.userTrackingMode = .follow
                }
            }
        }
        UIView.animate(withDuration: animationIn) {
            self.locatorButton.alpha = 0
            self.polyRouteLocatorButton.alpha = 0
        }
    }
    
    func locatorButtonPressed() {
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, zoomLevel: 13, animated: true)
            delayWithSeconds(animationOut * 2) {
                self.mapView.userTrackingMode = .follow
            }
        }
    }
    
    func setupLocationManager() {
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.startUpdatingLocation()
        
        if self.searchedForPlace == false {
            if let userLocation = locationManager.location {
                self.mapView.userTrackingMode = .follow
//                self.removeAllMapOverlays(shouldRefresh: true)
                self.mapView.setCenter(userLocation.coordinate, zoomLevel: 12, animated: true)
                
                let camera = MGLMapCamera(lookingAtCenter: userLocation.coordinate, altitude: CLLocationDistance(exactly: 18000)!, pitch: 0, heading: CLLocationDirection(0))
                self.mapView.setCamera(camera, withDuration: animationOut * 2, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight * 3/4 - 60, right: phoneWidth/2), completionHandler: nil)
                
                delayWithSeconds(0.6) {
                    self.mapView.userTrackingMode = .follow
                }
            }
        } else {
            return
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        if self.backgroundImageView.alpha == 1 {
            UIView.animate(withDuration: 0.8) {
                self.backgroundImageView.alpha = 0
            }
        }
    }
    
    func mapViewUserLocationAnchorPoint(_ mapView: MGLMapView) -> CGPoint {
        if BookedState == .currentlyBooked {
            return CGPoint(x: phoneWidth/2, y: phoneHeight/3)
        } else {
            return CGPoint(x: phoneWidth/2, y: phoneHeight/4)
        }
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, completion: @escaping(String) -> ()) {
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                if let city = placemark.locality {
                    completion(city)
                }
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionIsChangingWith reason: MGLCameraChangeReason) {
        self.view.layoutIfNeeded()
        let value = reason.rawValue
        self.userInteractionChange(value: value)
        self.checkMapForAnnotations()
        if DestinationAnnotationLocation != nil, let from = quadStartCoordinate, let to = quadEndCoordinate {
            self.drawCurvedOverlay(startCoordinate: from, endCoordinate: to)
        }
    }
    
    func userInteractionChange(value: UInt) {
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
