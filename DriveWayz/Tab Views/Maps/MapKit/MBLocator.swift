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

var userCurrentLocation: CLLocation?

extension MapKitViewController: CLLocationManagerDelegate, GMSMapViewDelegate, handleLocatorButton {
    
    @objc func locatorButtonAction(sender: UIButton) {
        locatorButtonPressed(padding: nil)
    }
    
    func locatorButtonPressed(padding: CGFloat?) {
        canShowLocatorButton = false
        if let fromLocation = quadStartCoordinate, let toLocation = quadEndCoordinate {
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
        
        if locatorButton.alpha == 0 && (mainViewState == .mainBar || mainViewState == .currentBooking) {
            canShowLocatorButton = false
            var zoom = mapZoomLevel
            if mainViewState == .currentBooking {
                zoom = 15.5
            }
            let camera = GMSCameraPosition(target: location.coordinate, zoom: zoom)
            mapView.animate(to: camera)
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
        if self.backgroundImageView.alpha == 1 {
            UIView.animate(withDuration: 0.8) {
                self.backgroundImageView.alpha = 0
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if locatorButton.alpha == 0 && canShowLocatorButton {
            UIView.animate(withDuration: animationOut) {
                self.locatorButton.alpha = 1
            }
        }
        if DestinationAnnotationLocation != nil, let from = quadStartCoordinate, let to = quadEndCoordinate {
            self.drawCurvedOverlay(startCoordinate: from, endCoordinate: to)
        }
        if let route = mapBoxRoute {
            createRouteLine(route: route)
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        canShowLocatorButton = true
    }

}
