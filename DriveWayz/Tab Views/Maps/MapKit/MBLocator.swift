//
//  MapKitLocator.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import GoogleMaps

protocol handleLocatorButton {
    func locatorButtonPressed(padding: CGFloat?)
}

enum UserTracking {
    case follow
    case followWithHeading
    case none
}

var userTracking: UserTracking = .follow {
    didSet {
        print(userTracking)
    }
}
var userCurrentLocation: CLLocation?

var snapshotReady: Bool = false
var showLocatorButton: Bool = true
var showRouteButton: Bool = true

extension MapKitViewController: CLLocationManagerDelegate, GMSMapViewDelegate, handleLocatorButton {
    
    @objc func locatorButtonAction(sender: UIButton) {
        changeUserInteraction()
        
        if sender != parkingRouteButton && sender != currentRouteButton {
            locatorButtonPressed(padding: nil)
        } else if sender == currentRouteButton {
            if sender.backgroundColor == Theme.BLACK {
                if let userLocation = self.locationManager.location {
                    let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
                    mapView.animate(to: camera)
                    userTracking = .followWithHeading
                    
                    UIView.animate(withDuration: animationIn) {
                        self.currentRouteButton.backgroundColor = Theme.WHITE
                        self.currentRouteButton.tintColor = Theme.BLACK
                    }
                }
            } else {
                userTracking = .none
                zoomToBounds(sender: sender)
            }
        } else {
            if sender.backgroundColor == Theme.BLACK {
                locatorButtonPressed(padding: 100)
            } else {
                zoomToBounds(sender: sender)
            }
        }
    }
    
    func zoomToBounds(sender: UIButton) {
        guard let fromLocation = ZoomStartCoordinate, let toLocation = mapView.myLocation?.coordinate else { return }
        showRouteButton = false
        showLocatorButton = true
        
        let bounds = GMSCoordinateBounds(coordinate: fromLocation, coordinate: toLocation)
        let pad: CGFloat = 64
        let camera = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: pad, left: pad, bottom: pad + 32, right: pad))
        mapView.animate(with: camera)
        
        UIView.animate(withDuration: animationIn) {
            sender.backgroundColor = Theme.BLACK
            sender.tintColor = Theme.WHITE
        }
    }
    
    func locatorButtonPressed(padding: CGFloat?) {
        showRouteButton = true
        showLocatorButton = false
        
        if let fromLocation = ZoomStartCoordinate, let toLocation = ZoomEndCoordinate {
            let bounds = GMSCoordinateBounds(coordinate: fromLocation, coordinate: toLocation)
            if let pad = padding {
                let camera = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: pad, left: pad, bottom: pad + 32, right: pad))
                mapView.animate(with: camera)
            } else {
                let pad: CGFloat = 64
                let camera = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: pad, left: pad, bottom: pad + 32, right: pad))
                mapView.animate(with: camera)
            }
        } else {
            if let userLocation = self.locationManager.location {
                let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
                mapView.animate(to: camera)
            }
        }
        UIView.animate(withDuration: animationIn) {
            self.locatorButton.alpha = 0
            self.parkingRouteButton.backgroundColor = Theme.WHITE
            self.parkingRouteButton.tintColor = Theme.BLACK
            self.currentRouteButton.backgroundColor = Theme.WHITE
            self.currentRouteButton.tintColor = Theme.BLACK
        }
    }
    
    func setupLocationManager() {
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.startUpdatingLocation()
        
        delayWithSeconds(1) {
            guard let location = self.locationManager.location else {
                return
            }
            self.locatorButtonPressed(padding: nil)
            self.determineCity(location: location)
        }
    }
    
    func determineCity(location: CLLocation) {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let placemark = placemarks as? [CLPlacemark] else {
                return
            }
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                
                self.observeParking(placemark: placemark)
                self.mainBarController.determineCity(placemark: placemark)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        if userTracking != .none {
            if mainViewState == .mainBar || mainViewState == .startup {
                var zoom = mapZoomLevel
                if mainViewState == .currentBooking {
                    zoom = 15.5
                }
                let camera = GMSCameraPosition(target: location.coordinate, zoom: zoom)
                mapView.animate(to: camera)
            } else if mainViewState == .currentBooking, let destinationCoor = ZoomStartCoordinate, let destinationPlacemark = searchingPlacemark, let lot = selectedParkingLot {
                let destination = CLLocation(latitude: destinationCoor.latitude, longitude: destinationCoor.longitude)
                calculateWalkingRoute(fromLocation: location, toLocation: destination) { (route) in
                    // Remove all previous polylines or markers
                    self.removeRouteLine()
                    
                    self.placeWalkingRoute(lot: lot, destinationPlacemark: destinationPlacemark)
                }
            }
        }
    }
    
    func monitorLocationUpdates() {
        if let userLocation = self.locationManager.location {
//            drawDrivingRoute(fromLocation: userLocation, toLocation: hostLocation)
            
            if userTracking == .followWithHeading {
                if let heading = mapView.myLocation?.course {
                    let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapTrackingLevel, bearing: heading, viewingAngle: 0.0)
                    mapView.animate(to: camera)
                }
            }
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
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        // Remove map backgroundImageView
        showRouteButton = true
        showLocatorButton = true
        snapshotReady = true
        
//        delayWithSeconds(2) {
//            if self.backgroundImageView.alpha == 1 {
//                UIView.animateOut(withDuration: 2, animations: {
//                    self.backgroundImageView.alpha = 0
//                }, completion: { (success) in
//                    //
//                })
//            }
//        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // Update necessary MapViews depending on state
        switch mainViewState {
        case .parking:
            monitorRouteLines()
        case .payment:
            monitorRouteLines()
        case .currentBooking:
            monitorRouteLines()
//            layCurrentMarkers()
        case .none:
//            layCurrentMarkers()
            monitorRouteLines()
        default:
            return
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            userTracking = .none
            
            // Invalidate locator timer because user panned
            changeUserInteractionTimer?.invalidate()
            changeUserInteractionTimer = nil
            changeUserInteractionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeUserInteraction), userInfo: nil, repeats: false)
            
            if locatorButton.alpha == 0 && (mainViewState == .mainBar || mainViewState == .startup) {
                UIView.animate(withDuration: animationIn) {
                    self.locatorButton.alpha = 1
                }
            }
        }
    }
    
    @objc func changeUserInteraction() {
        // Revert UserTrackingMode to follow
        changeUserInteractionTimer?.invalidate()
        changeUserInteractionTimer = nil
        if mainViewState == .currentBooking {
            userTracking = .followWithHeading
        } else {
            userTracking = .follow
        }
    }

}
