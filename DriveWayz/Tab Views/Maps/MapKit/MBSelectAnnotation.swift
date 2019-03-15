//
//  MBSelectAnnotation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox

extension MapKitViewController {

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if let searchLocation = DestinationAnnotationLocation {
            self.removePolylineAnnotations()
            for i in 0..<parkingSpots.count {
                let parking = self.parkingSpots[i]
                if annotation.subtitle == "\(i)" {
                    self.closeParkingSpots = [parking]
                    self.hideSearchBar(regular: false)
                    self.takeAwayEvents()
                    let latitude = parking.latitude
                    let longitude = parking.longitude
                    let location = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    if let address = parking.overallAddress {
                        self.mapView.setCenter(location.coordinate, animated: true)
                        if let userLocation = locationManager.location {
                            let search = CLLocation(latitude: searchLocation.latitude, longitude: searchLocation.longitude)
                            self.findBestParking(location: location, sourceLocation: userLocation, searchLocation: search, address: address)
                            delayWithSeconds(1.6) {
                                self.hideSearchBar(regular: false)
                            }
                        }
                    }
                }
            }
        } else {
            self.removeAllMapOverlays()
            for i in 0..<parkingSpots.count {
                let parking = self.parkingSpots[i]
                if annotation.subtitle == "\(i)" {
                    self.closeParkingSpots = [parking]
                    self.hideSearchBar(regular: false)
                    self.takeAwayEvents()
                    let latitude = parking.latitude
                    let longitude = parking.longitude
                    let location = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    if let address = parking.overallAddress {
                        self.mapView.setCenter(location.coordinate, animated: true)
                        if let userLocation = locationManager.location {
                            self.organizeParkingLocation(searchLocation: location, shouldDraw: true)
//                            self.findBestParking(location: location, sourceLocation: userLocation, searchLocation: userLocation, address: address)
                            delayWithSeconds(1.6) {
                                self.hideSearchBar(regular: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
