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

protocol handleParkingOptions {
    func drawHostPolyline(fromLocation: CLLocation)
}

var DestinationAnnotationLocation: CLLocation?
var DestinationAnnotationName: String?
//var ZooomRegion: MGLCoordinateBounds?
var WalkingTime: Double?

var quadStartCoordinate: CLLocationCoordinate2D?
var quadEndCoordinate: CLLocationCoordinate2D?

extension MapKitViewController: handleParkingOptions {
    
    func dismissSearch() {
        dismissKeyboard()
        didTapParking = false
        quickParkingController.walkingIcon.alpha = 1
        quickParkingController.carIcon.alpha = 0
        if !mainSearchTextField {
            mainSearchTextField = true
//            summaryController.fromSearchBar.text = address
            summaryController.searchTextField.becomeFirstResponder()
            return
        }
        guard let fromText = summaryController.fromSearchBar.text else { return }
//        summaryController.searchTextField.text = address
        searchBarController.fromLabel.text = fromText
//        searchBarController.toLabel.text = address
        mainViewState = .none
        parkingSelected()
//        DestinationAnnotationName = address

    }
    
    func zoomToSearchLocation(placeId: String) {
        dismissSearch()
        
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
            self.zoomToRecommendedLocation(location: location)
        }
        
        
//        dismissKeyboard()
//        didTapParking = false
//        quickParkingController.walkingIcon.alpha = 1
//        quickParkingController.carIcon.alpha = 0
//        if !mainSearchTextField {
//            mainSearchTextField = true
//            summaryController.fromSearchBar.text = address
//            summaryController.searchTextField.becomeFirstResponder()
//            return
//        }
//        guard let fromText = summaryController.fromSearchBar.text else { return }
//        summaryController.searchTextField.text = address
//        searchBarController.fromLabel.text = fromText
//        searchBarController.toLabel.text = address
//        mainViewState = .none
//        parkingSelected()
//        DestinationAnnotationName = address
//
//        if let location = coordinate {
//            self.delegate?.hideHamburger()
//            DestinationAnnotationLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//            self.checkAnnotationsNearDestination(location: location, checkDistance: true)
//            self.mapView.setCenter(location, animated: true)
//        } else {
//            let geoCoder = CLGeocoder()
//            geoCoder.geocodeAddressString(address) { (placemarks, error) in
//                guard
//                    let placemarks = placemarks,
//                    let location = placemarks.first?.location
//                    else {
//                        print("lookup place id query error: \(error!.localizedDescription)")
//                        delayWithSeconds(2, completion: {
//                            DispatchQueue.main.async {
//                                self.parkingHidden(showMainBar: true)
//                            }
//                        })
//                        return
//                }
//                self.delegate?.hideHamburger()
//                DestinationAnnotationLocation = location
//                self.checkAnnotationsNearDestination(location: location.coordinate, checkDistance: true)
//                self.mapView.setCenter(location.coordinate, animated: true)
//            }
//        }
    }
    
    func zoomToRecommendedLocation(location: CLLocationCoordinate2D) {
        DestinationAnnotationLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        self.checkAnnotationsNearDestination(location: location, checkDistance: true)
        self.mapView.animate(toLocation: location)
        
        self.delegate?.hideHamburger()
    }
    
    func drawHostPolyline(fromLocation: CLLocation) {
        mapView.clear()
        
        if let location = DestinationAnnotationLocation {
            if didTapParking {
                self.drawRoute(fromLocation: fromLocation, toLocation: location, identifier: .automobile)
            } else {
                self.drawRoute(fromLocation: fromLocation, toLocation: location, identifier: .walking)
            }
        }
    }
    
    func drawRoute(fromLocation: CLLocation, toLocation: CLLocation, identifier: MKDirectionsTransportType) {
        removeRouteLine()

//        let region = MGLCoordinateBounds(sw: fromLocation.coordinate, ne: toLocation.coordinate)
//        ZooomRegion = region
        
//        let inset = UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64)
        
//        mapView.addSubview(routeStartPin)
//        mapView.addSubview(routeParkingPin)
        
//        let last = mapView.projection.point(for: toLocation.coordinate)
//        let start = mapView.projection.point(for: fromLocation.coordinate)
//
//        routeStartPin.center = CGPoint(x: last.x + 3, y: last.y + 6)
//        routeParkingPin.center = CGPoint(x: start.x, y: start.y - 26)
        
        quadStartCoordinate = fromLocation.coordinate
        quadEndCoordinate = toLocation.coordinate
        DestinationAnnotationLocation = toLocation
        
        locatorButtonPressed(padding: 80)
        
//        if mainViewState != .currentBooking && BookedState != .currentlyBooked {
//            quadStartCoordinate = fromLocation.coordinate
//            quadEndCoordinate = fromLocation.coordinate
//
//            if let userLocation = locationManager.location?.coordinate {
//                quadEndCoordinate = userLocation
//                quickDestinationController.view.isHidden = false
//                drawCurvedOverlay(startCoordinate: userLocation, endCoordinate: fromLocation.coordinate)
//                placeAvailable()
//            }
//        } else {
//            quickParkingController.carIcon.alpha = 1
//            quickParkingController.walkingIcon.alpha = 0
//            quickDestinationController.view.isHidden = true
//
//            DestinationAnnotationLocation = toLocation
//            quadStartCoordinate = toLocation.coordinate
//            quadEndCoordinate = fromLocation.coordinate
//
//            locatorButtonAction(sender: locatorButton)
//        }
        
//        let directions = Directions.shared
//        let waypoints = [
//            Waypoint(coordinate: CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude), name: "Start"),
//            Waypoint(coordinate: CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude), name: "Destination"),
//        ]
//        let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: identifier)
//        options.includesSteps = true

        let source = CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude)
        let destination = CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude)
        
        let request: MKDirections.Request = MKDirections.Request()
        request.source  = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let routeResponse = response?.routes, let route = routeResponse.first else { return }
            self.mapBoxRoute = route
            
            self.createRouteLine(route: route)
            
            let minute = route.expectedTravelTime / 60
            self.setupQuickController(minute: minute)
            WalkingTime = minute
            
            self.mapView.addSubview(routeStartPin)
            self.mapView.addSubview(routeParkingPin)
            
            self.mapView.layer.insertSublayer(routeUnderLine, below: routeStartPin.layer)
            self.mapView.layer.insertSublayer(routeLine, below: routeStartPin.layer)
            self.animateRouteUnderLine()
            self.animateRouteLine()
        }
            
//        _ = directions.calculate(options) { (waypoints, routes, error) in
//            guard error == nil else {
//                print("Error calculating directions: \(error!)")
//                return
//            }
//            if let route = routes?.first {
////                self.mapBoxRoute = route
//
//                self.createRouteLine(route: route)
//
//                let minute = route.expectedTravelTime / 60
//                self.setupQuickController(minute: minute)
//                WalkingTime = minute
//                if route.coordinateCount > 0 {
//                    self.parkingCoordinates = route.coordinates!
//
//                    self.mapView.layer.insertSublayer(routeUnderLine, below: routeStartPin.layer)
//                    self.mapView.layer.insertSublayer(routeLine, below: routeStartPin.layer)
//                    self.animateRouteUnderLine()
//                    self.animateRouteLine()
//                }
//            }
//        }
    }
    
    func setupQuickController(minute: Double) {
        let time = minute.rounded()
        let distanceTime = String(format: "%.0f min", time)
        self.quickParkingController.distanceLabel.text = distanceTime
        
        if mainViewState != .currentBooking {
            if let address = DestinationAnnotationName {
                let addressArray = address.split(separator: ",")
                if let addressString = addressArray.first {
                    let addy = String(addressString)
                    let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5) + 72
                    self.quickParkingController.parkingLabel.text = addy
                    self.quickParkingWidthAnchor.constant = addressWidth
                }
            }
        } else {
            if let booking = currentUserBooking, let address = booking.parkingName {
                let addressArray = address.split(separator: ",")
                if let addressString = addressArray.first {
                    let addy = String(addressString)
                    let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5) + 72
                    self.quickParkingController.parkingLabel.text = addy
                    self.quickParkingWidthAnchor.constant = addressWidth
                }
            }
        }
        self.view.layoutIfNeeded()
    }
    
}
