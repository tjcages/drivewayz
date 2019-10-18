//
//  MBSelectAnnotation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps

var didTapParking: Bool = false
var TappedDestinationAnnotationLocation: CLLocation?

extension MapKitViewController {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        didTapParking = true
        self.quickParkingController.walkingIcon.alpha = 0
        self.quickParkingController.carIcon.alpha = 1
        if let parkingID = marker.title {
            if let parking = self.parkingSpotsDictionary[parkingID] {
                if let parkingLat = parking.latitude, let parkingLong = parking.longitude {
                    let parkingCoordinate = CLLocation(latitude: parkingLat, longitude: parkingLong)
                    guard let userLocation = self.mapView.myLocation else { return false }
                    self.delegate?.hideHamburger()
                    DestinationAnnotationName = "Current location"
                    DestinationAnnotationLocation = userLocation
                    TappedDestinationAnnotationLocation = parkingCoordinate
                    
                    self.parkingSelected()
                    self.checkAnnotationsNearDestination(location: parkingCoordinate.coordinate, checkDistance: false)
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
}

