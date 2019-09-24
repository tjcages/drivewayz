//
//  MBGetRoute.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import Mapbox
import MapboxDirections
//import MapboxNavigation
import MapboxCoreNavigation

protocol handleParkingOptions {
    func drawHostPolyline(fromLocation: CLLocation)
}

var DestinationAnnotationLocation: CLLocation?
var DestinationAnnotationName: String?
var ZooomRegion: MGLCoordinateBounds?
var WalkingTime: Double?

var quadStartCoordinate: CLLocationCoordinate2D?
var quadEndCoordinate: CLLocationCoordinate2D?

extension MapKitViewController: handleParkingOptions {
    
    func zoomToSearchLocation(address: String) {
        dismissKeyboard()
        didTapParking = false
        self.quickParkingController.walkingIcon.alpha = 1
        self.quickParkingController.carIcon.alpha = 0
        if !mainSearchTextField {
            mainSearchTextField = true
            self.summaryController.fromSearchBar.text = address
            self.summaryController.searchTextField.becomeFirstResponder()
            return
        }
        guard let fromText = self.summaryController.fromSearchBar.text else { return }
        self.summaryController.searchTextField.text = address
        self.searchBarController.fromLabel.text = fromText
        self.searchBarController.toLabel.text = address
        self.mainViewState = .none
        DestinationAnnotationName = address
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("lookup place id query error: \(error!.localizedDescription)")
                    delayWithSeconds(2, completion: {
                        DispatchQueue.main.async {
                            self.parkingHidden(showMainBar: true)
                        }
                    })
                    return
            }
            self.delegate?.hideHamburger()
            DestinationAnnotationLocation = location
            self.checkAnnotationsNearDestination(location: location.coordinate, checkDistance: true)
            self.parkingSelected()
            self.mapView.setCenter(location.coordinate, animated: true)
        }
    }
    
    func drawHostPolyline(fromLocation: CLLocation) {
//        self.removeAllHostLocations()
        self.removePolylineAnnotations()
        if let location = DestinationAnnotationLocation {
            if didTapParking {
                self.drawRoute(fromLocation: fromLocation, toLocation: location, identifier: .automobileAvoidingTraffic)
            } else {
                self.drawRoute(fromLocation: fromLocation, toLocation: location, identifier: .walking)
            }
//            self.placeAvailableParking(location: location.coordinate)
        }
    }
    
    func drawRoute(fromLocation: CLLocation, toLocation: CLLocation, identifier: MBDirectionsProfileIdentifier) {
        removeRouteLine()
        let region = MGLCoordinateBounds(sw: fromLocation.coordinate, ne: toLocation.coordinate)
        ZooomRegion = region
        
        let inset = UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64)
        mapView.setVisibleCoordinateBounds(region, edgePadding: inset, animated: true) {
            self.mapView.addSubview(routeStartPin)
            self.mapView.addSubview(routeParkingPin)
            
            let last = self.mapView.convert(toLocation.coordinate, toPointTo: self.mapView)
            let start = self.mapView.convert(fromLocation.coordinate, toPointTo: self.mapView)
            
            routeStartPin.center = CGPoint(x: last.x + 3, y: last.y + 6)
            routeParkingPin.center = CGPoint(x: start.x, y: start.y - 26)
        }
        
        if mainViewState != .currentBooking && BookedState != .currentlyBooked {
            quadStartCoordinate = fromLocation.coordinate
            
            if let userLocation = locationManager.location?.coordinate {
                quadEndCoordinate = userLocation
                quickDestinationController.view.isHidden = false
                drawCurvedOverlay(startCoordinate: userLocation, endCoordinate: fromLocation.coordinate)
                placeAvailable()
            }
        } else {
            quickParkingController.carIcon.alpha = 1
            quickParkingController.walkingIcon.alpha = 0
            quickDestinationController.view.isHidden = true
            
            DestinationAnnotationLocation = toLocation
            quadStartCoordinate = toLocation.coordinate
            quadEndCoordinate = fromLocation.coordinate
            
            locatorButtonAction(sender: locatorButton)
        }
        
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude), name: "Start"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude), name: "Destination"),
        ]
        let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: identifier)
        options.includesSteps = true
            
        _ = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            if let route = routes?.first {
                self.mapBoxRoute = route
                self.createRouteLine(route: route)
                
                let minute = route.expectedTravelTime / 60
                self.setupQuickController(minute: minute)
                WalkingTime = minute
                if route.coordinateCount > 0 {
                    self.parkingCoordinates = route.coordinates!
                    
                    self.mapView.layer.insertSublayer(routeUnderLine, below: routeStartPin.layer)
                    self.mapView.layer.insertSublayer(routeLine, below: routeStartPin.layer)
                    self.animateRouteUnderLine()
                    self.animateRouteLine()
                }
            }
        }
    }
    
    func setupQuickController(minute: Double) {
        let time = minute.rounded(toPlaces: 0)
        let distanceTime = String(format: "%.0f min", time)
        self.quickParkingController.distanceLabel.text = distanceTime
        
        if let address = self.searchBarController.toLabel.text {
            let addressArray = address.split(separator: ",")
            if let addressString = addressArray.first {
                let addy = String(addressString)
                let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5) + 72
                self.quickParkingController.parkingLabel.text = addy
                self.quickParkingWidthAnchor.constant = addressWidth
            }
        }
        self.view.layoutIfNeeded()
    }
    
}
