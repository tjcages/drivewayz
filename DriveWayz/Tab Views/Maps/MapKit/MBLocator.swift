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

var showLocatorButton: Bool = true
var showRouteButton: Bool = true

extension MapKitViewController: CLLocationManagerDelegate, GMSMapViewDelegate, handleLocatorButton {
    
    @objc func locatorButtonAction(sender: UIButton) {
        changeUserInteraction()
        
        if sender != parkingRouteButton && sender != currentRouteButton {
            locatorButtonPressed(padding: nil)
        } else if sender == currentRouteButton {
            if sender.backgroundColor == Theme.DARK_GRAY {
                if let userLocation = self.locationManager.location {
                    let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
                    mapView.animate(to: camera)
                    userTracking = .followWithHeading
                    
                    UIView.animate(withDuration: animationIn) {
                        self.currentRouteButton.backgroundColor = Theme.WHITE
                        self.currentRouteButton.tintColor = Theme.DARK_GRAY
                    }
                }
            } else {
                userTracking = .none
                zoomToBounds(sender: sender)
            }
        } else {
            if sender.backgroundColor == Theme.DARK_GRAY {
                locatorButtonPressed(padding: nil)
            } else {
                zoomToBounds(sender: sender)
            }
        }
    }
    
    func zoomToBounds(sender: UIButton) {
        var fromLocation = mapView.projection.coordinate(for: routeEndPin.center)
        if mainViewState == .currentBooking {
            fromLocation = mapView.projection.coordinate(for: routeParkingPin.center)
        }
        guard let toLocation = mapView.myLocation?.coordinate else { return }
        showRouteButton = false
        showLocatorButton = true
        
        let bounds = GMSCoordinateBounds(coordinate: fromLocation, coordinate: toLocation)
        let camera = GMSCameraUpdate.fit(bounds, withPadding: 64)
        mapView.animate(with: camera)
        
        UIView.animate(withDuration: animationIn) {
            sender.backgroundColor = Theme.DARK_GRAY
            sender.tintColor = Theme.WHITE
        }
    }
    
    func locatorButtonPressed(padding: CGFloat?) {
        showRouteButton = true
        showLocatorButton = false
        
        if let fromLocation = ZoomStartCoordinate, let toLocation = ZoomEndCoordinate {
            let bounds = GMSCoordinateBounds(coordinate: fromLocation, coordinate: toLocation)
            if let pad = padding {
                let camera = GMSCameraUpdate.fit(bounds, withPadding: pad)
                mapView.animate(with: camera)
            } else {
                let camera = GMSCameraUpdate.fit(bounds, withPadding: 64)
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
            self.parkingRouteButton.tintColor = Theme.DARK_GRAY
            self.currentRouteButton.backgroundColor = Theme.WHITE
            self.currentRouteButton.tintColor = Theme.DARK_GRAY
        }
    }
    
    func setupLocationManager() {
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.startUpdatingLocation()
        
        observeAllParking()
        delayWithSeconds(1) {
            guard let location = self.locationManager.location else {
                return
            }
            self.mainBarController.searchController.determineCity(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        
        delayWithSeconds(1) {
            guard let location = self.locationManager.location else {
                return
            }
            self.mainBarController.searchController.determineCity(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        if userTracking != .none {
            if mainViewState == .mainBar {
                var zoom = mapZoomLevel
                if mainViewState == .currentBooking {
                    zoom = 15.5
                }
                let camera = GMSCameraPosition(target: location.coordinate, zoom: zoom)
                mapView.animate(to: camera)
            } else if mainViewState == .currentBooking {
                switch currentBookingState {
                case .none:
                    return
                case .walking:
                    monitorLocationUpdates()
                case .driving:
                    monitorLocationUpdates()
                case .checkedIn:
                    monitorLocationUpdates()
                }
            }
        }
    }
    
    func monitorLocationUpdates() {
        if let userLocation = self.locationManager.location {
            drawDrivingRoute(fromLocation: userLocation, toLocation: hostLocation)
            
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
        
        if self.backgroundImageView.alpha == 1 {
            UIView.animate(withDuration: 0.4) {
                self.backgroundImageView.alpha = 0
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // Update necessary MapViews depending on state
        switch mainViewState {
        case .parking:
            monitorRouteLines()
        case .payment:
            monitorRouteLines()
        case .currentBooking:
            layCurrentMarkers()
        case .none:
            layCurrentMarkers()
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
            
            if locatorButton.alpha == 0 && mainViewState == .mainBar {
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
