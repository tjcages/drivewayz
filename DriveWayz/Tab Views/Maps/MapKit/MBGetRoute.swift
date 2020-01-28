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

var DestinationAnnotationLocation: CLLocation?
var DestinationAnnotationName: String?

var DrivingTime: Double?
var WalkingTime: Double?

var ZoomStartCoordinate: CLLocationCoordinate2D?
var ZoomEndCoordinate: CLLocationCoordinate2D?
var quadStartCoordinate: CLLocationCoordinate2D?
var quadEndCoordinate: CLLocationCoordinate2D?

extension MapKitViewController {
    
    func dismissSearch() {
        dismissKeyboard()

        if !mainSearchTextField {
            mainSearchTextField = true
            summaryController.searchTextField.becomeFirstResponder()
            return
        }
        guard let fromText = summaryController.fromSearchBar.text else { return }
        searchBarController.fromLabel.text = fromText
        mainViewState = .parking
    }
    
    func zoomToSearchLocation(placeId: String) {
        dismissSearch()
        userEnteredDestination = true
        
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeId) { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            guard let place = place else {
                print("No place details for \(placeId)")
                return
            }
            let location = place.coordinate
            let name = place.name
            
            DestinationAnnotationName = name
            self.mapView.animate(toZoom: self.mapView.camera.zoom - 2)
            self.zoomToRecommendedLocation(location: location)
        }
    }
    
    func zoomToRecommendedLocation(location: CLLocationCoordinate2D) {
        DestinationAnnotationLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        checkAnnotationsNearDestination(location: location, checkDistance: true)
        mapView.animate(toZoom: mapView.camera.zoom - 2)
        mapView.animate(toLocation: location)
        
        delegate?.hideHamburger()
    }
    
    func calculateRoute(fromLocation: CLLocation, toLocation: CLLocation, identifier: MKDirectionsTransportType) {
        delayWithSeconds(animationOut) {
            let start = self.mapView.projection.point(for: fromLocation.coordinate)
            let last = self.mapView.projection.point(for: toLocation.coordinate)
            
            if identifier != .walking {
                quadStartCoordinate = fromLocation.coordinate
                quadEndCoordinate = toLocation.coordinate
                
                routeStartPin.center = CGPoint(x: last.x, y: last.y)
                routeParkingPin.center = CGPoint(x: start.x, y: start.y - 26)
            } else {
                routeEndPin.center = CGPoint(x: start.x, y: start.y)
                routeParkingPin.center = CGPoint(x: last.x, y: last.y - 26)
            }
        }

        let source = CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude)
        let destination = CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude)
        
        let request: MKDirections.Request = MKDirections.Request()
        request.source  = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = identifier
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if identifier != .walking {
                guard let routeResponse = response?.routes, let route = routeResponse.first else { return }
                self.mapBoxRoute = route
                
                self.createRouteLine(route: route, driving: true)
                
                let minute = route.expectedTravelTime / 60
                if !userEnteredDestination {
                    self.setupQuickController(minute: minute, identifier: identifier)
                }
                DrivingTime = minute
                
                self.mapView.addSubview(routeStartPin)
                if !self.mapView.subviews.contains(routeParkingPin) {
                    self.mapView.addSubview(routeParkingPin)
                }
                
                self.mapView.layer.insertSublayer(routeUnderLine, below: routeParkingPin.layer)
                self.mapView.layer.insertSublayer(routeLine, below: routeParkingPin.layer)
                
                self.animateRouteUnderLine()
                self.animateRouteLine()
            } else {
                guard let routeResponse = response?.routes, let route = routeResponse.first else { return }
                self.mapBoxWalkingRoute = route
                
                self.createRouteLine(route: route, driving: false)
                self.locatorButtonPressed(padding: 100)
                
                let minute = route.expectedTravelTime / 60
                self.setupQuickController(minute: minute, identifier: identifier)
                WalkingTime = minute
                
                if !self.mapView.subviews.contains(routeParkingPin) {
                    self.mapView.addSubview(routeParkingPin)
                }
                self.mapView.addSubview(routeEndPin)
                
                self.mapView.layer.insertSublayer(routeWalkingUnderLine, below: routeEndPin.layer)
                self.mapView.layer.insertSublayer(routeWalkingLine, below: routeEndPin.layer)
                
                self.animateWalkingLine()
            }
            
            self.mapView.bringSubviewToFront(routeStartPin)
            self.mapView.bringSubviewToFront(routeParkingPin)
            self.mapView.bringSubviewToFront(routeEndPin)
            self.mapView.bringSubviewToFront(self.quickParkingView)
            self.mapView.bringSubviewToFront(self.quickDurationView)
            self.mapView.bringSubviewToFront(self.parkingRouteButton)
        }
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
        
        if mainViewState != .currentBooking {
            if let address = DestinationAnnotationName {
                let addressArray = address.split(separator: ",")
                if let addressString = addressArray.first {
                    let addy = String(addressString)
                    let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5) + 102
                    self.quickDurationView.parkingLabel.text = addy
                    self.quickDestinationWidthAnchor.constant = addressWidth
                }
            }
        } else {
            if let booking = currentUserBooking, let address = booking.parkingName {
                let addressArray = address.split(separator: ",")
                if let addressString = addressArray.first {
                    let addy = String(addressString)
                    let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5) + 102
                    self.quickDurationView.parkingLabel.text = addy
                    self.quickDestinationWidthAnchor.constant = addressWidth
                }
            }
        }
        self.view.layoutIfNeeded()
    }
    
}
