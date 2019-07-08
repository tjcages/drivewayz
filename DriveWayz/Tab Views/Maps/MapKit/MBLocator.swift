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
            if self.parkingControllerBottomAnchor.constant == 0 {
                self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64), animated: true)
            } else {
                self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 32, bottom: 320, right: 32), animated: true)
            }
        } else {
            if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
                self.mapView.allowsRotating = true
                self.mapView.isRotateEnabled = true
                self.mapView.resetNorth()
                let camera = MGLMapCamera(lookingAtCenter: location, altitude: CLLocationDistance(exactly: 7200)!, pitch: 0, heading: CLLocationDirection(0))
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
        
        self.observeAllParking()
        if self.searchedForPlace == false {
            if let userLocation = locationManager.location {
//                self.removeAllMapOverlays(shouldRefresh: true)
                self.mapView.setCenter(userLocation.coordinate, zoomLevel: 15, animated: false)
                let camera = MGLMapCamera(lookingAtCenter: userLocation.coordinate, altitude: CLLocationDistance(exactly: 7200)!, pitch: 0, heading: CLLocationDirection(0))
                self.mapView.setCamera(camera, withDuration: animationOut * 2, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight*3/4 - 60, right: phoneWidth/2), completionHandler: nil)
                
                delayWithSeconds(1) {
                    self.mapView.userTrackingMode = .follow
                }
//                if self.currentActive == false && self.searchedForPlace == false && alreadyLoadedSpots == false {
//                    let geocoder = CLGeocoder()
//                    geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//                        // Process Response
//                        self.processResponse(withPlacemarks: placemarks, error: error, completion: { (city) in
//                            delayWithSeconds(1, completion: {
//                                self.monitorCoupons()
//                            })
//                        })
//                    }
//                }
            }
        } else {
            return
        }
    }
    
    func mapViewUserLocationAnchorPoint(_ mapView: MGLMapView) -> CGPoint {
        return CGPoint(x: phoneWidth/2, y: phoneHeight/4)
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
                } else if isCurrentlyBooked {
                    self.currentSearchLocation.alpha = 1
                    self.currentSearchRegion.alpha = 1
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
