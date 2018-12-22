//
//  MapKitDrawPath.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit

extension MapKitViewController {
    
    func drawCurrentPath(dest: CLLocation, navigation: Bool) {
        let mapOverlays = self.mapView.overlays
        self.mapView.removeOverlays(mapOverlays)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            self.currentActive = true
            
            let marker = MKPointAnnotation()
            marker.title = "Destination"
            marker.coordinate = dest.coordinate
            self.mapView.addAnnotation(marker)
        }
        let sourceCoordinates = self.locationManager.location?.coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: dest.coordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
            self.navigationLabel.alpha = 0
            self.view.layoutIfNeeded()
            if navigation == true {
                self.getDirections(to: route)
            }
        })
    }
    
}
