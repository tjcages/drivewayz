//
//  MBGetRoute.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import MapKit

var DestinationAnnotationName: String?

var ZoomStartCoordinate: CLLocationCoordinate2D?
var ZoomEndCoordinate: CLLocationCoordinate2D?
var quadStartCoordinate: CLLocationCoordinate2D?
var quadEndCoordinate: CLLocationCoordinate2D?

extension MapKitViewController {
    
    func calculateRoute(fromLocation: CLLocation, toLocation: CLLocation, identifier: MKDirectionsTransportType) {
        quadStartCoordinate = fromLocation.coordinate
        quadEndCoordinate = toLocation.coordinate

        let source = CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude)
        let destination = CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude)
        
        let request: MKDirections.Request = MKDirections.Request()
        request.source  = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = identifier
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let routeResponse = response?.routes, let route = routeResponse.first else { return }
            self.mapBoxRoute = route
            
            self.createRouteLine(route: route, driving: true)
            
            let minute = route.expectedTravelTime / 60
            if !self.userEnteredDestination {
                self.setupQuickController(minute: minute, identifier: identifier)
            }
            
            // Add start pin and driving route lines
            self.mapView.layer.addSublayer(routeUnderLine)
            self.mapView.layer.addSublayer(routeLine)
            self.mapView.addSubview(routeStartPin)
            
            self.animateRouteUnderLine()
            self.animateRouteLine()
            
            self.rearrangeMapSubviews()
        }
    }
    
    func rearrangeMapSubviews() {
        self.mapView.bringSubviewToFront(routeStartPin)
        self.mapView.bringSubviewToFront(routeEndPin)
        
        rearrangeSpotViews(checkSelect: false)
        
        self.mapView.bringSubviewToFront(quickParkingView)
        self.mapView.bringSubviewToFront(quickDurationView)
        self.mapView.bringSubviewToFront(parkingRouteButton)
        self.mapView.bringSubviewToFront(parkingBackButton)
        self.mapView.bringSubviewToFront(parkingRouteButton)
    }
    
    func setupQuickController(minute: Double, identifier: MKDirectionsTransportType) {
        let time = minute.rounded()
        let distanceTime = String(format: "%.0f", time)
        self.quickDurationView.distanceLabel.text = distanceTime
        
        if identifier == .automobile {
            self.quickDurationView.subLabel.text = "Drive to"
        } else if identifier == .walking {
            self.quickDurationView.subLabel.text = "Walk to"
        }
        
        if let address = DestinationAnnotationName {
            let addressArray = address.split(separator: ",")
            if let addressString = addressArray.first {
                let addy = String(addressString)
                let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5) + 102
                self.quickDurationView.parkingLabel.text = addy
                self.quickDestinationWidthAnchor.constant = addressWidth
            }
        }
        self.view.layoutIfNeeded()
    }
    
}
