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
        if let title = annotation.title, let parkingID = title {
            if let parking = self.parkingSpotsDictionary[parkingID] {
                if let parkingLat = parking.latitude, let parkingLong = parking.longitude {
                    let parkingCoordinate = CLLocation(latitude: parkingLat, longitude: parkingLong)
                    
                    guard let userLocation = self.mapView.userLocation?.location else { return }
                    
                    var center = parkingCoordinate.coordinate
                    center.latitude = center.latitude - 0.0008
                    let touchLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    
                    DestinationAnnotationLocation = userLocation
                    self.removeMainBar()
                    self.delegate?.hideHamburger()
                    self.parkingSelected()
                    self.checkAnnotationsNearDestination(location: parkingCoordinate.coordinate, checkDistance: false)
                }
            }
        }
    }
    
}
