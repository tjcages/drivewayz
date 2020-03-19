//
//  MBSortingFunctions.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/11/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension MapKitViewController {
    
    @objc func updateParkingLots() {
        // Send top parking lots to booking controller
        bookingController.sortedBookingLots = zipSortedParkingLots
        
        var numberOfLots = bookingController.sortedBookingLots.count // MOVE TO SEPARATE FUNCTION
        if numberOfLots > 3 { numberOfLots = 3 }
        
        // Calculate walking route for the 3 routes shown
        for i in 0..<numberOfLots {
            let lot = bookingController.sortedBookingLots[i]
            if let latitude = lot.latitude, let longitude = lot.longitude, let searchLocation = searchingPlacemark?.location {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                
                // Determine the walking route from the lot to the searched destination
                calculateWalkingRoute(fromLocation: location, toLocation: searchLocation) { (route) in
                    lot.walkingRoute = route
                    
                    self.bookingController.sortedBookingLots[i] = lot
                    if i == 0 { self.bookingController.selectFirstIndex() }
                }
            }
        }
    }
    
    func calculateWalkingRoute(fromLocation: CLLocation, toLocation: CLLocation, completionHandler: @escaping (MKRoute) -> Void ) {
        let source = CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude)
        let destination = CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude)
        
        let request: MKDirections.Request = MKDirections.Request()
        request.source  = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
            
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let routeResponse = response?.routes, let route = routeResponse.first else { return }
            
            completionHandler(route)
        }
    }
    
}
