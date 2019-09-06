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
                let minute = route.expectedTravelTime / 60
                self.setupQuickController(minute: minute)
                WalkingTime = minute
                if route.coordinateCount > 0 {
//                    firstWalkingRoute = route
                    // Convert the route’s coordinates into a polyline.
                    
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    routeLine.title = "ParkingDestUnder"
                    
//                    let ne = routeLine.overlayBounds.ne
//                    let sw = routeLine.overlayBounds.sw
//                    let region = MGLCoordinateBounds(sw: sw, ne: ne)
                    let region = MGLCoordinateBounds(sw: fromLocation.coordinate, ne: toLocation.coordinate)
                    ZooomRegion = region
                    self.mapView.addAnnotation(routeLine)
                    
                    self.parkingCoordinates = route.coordinates!
                    self.addPolyline(to: self.mapView.style!, isCurrentDriving: false)
                    self.animateFirstPolyline()

                    delayWithSeconds(animationOut, completion: {
                        let marker = MGLPointAnnotation()
                        marker.coordinate = toLocation.coordinate
                        if self.mainViewState != .currentBooking {
                            marker.title = "Destination"
                        }
                        self.mapView.addAnnotation(marker)
                    })
                    
                    if self.mainViewState != .currentBooking && BookedState != .currentlyBooked {
                        delayWithSeconds(animationIn, completion: {
                            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64), animated: true, completionHandler: nil)
                            quadStartCoordinate = fromLocation.coordinate
                            if let userLocation = self.locationManager.location?.coordinate {
                                quadEndCoordinate = userLocation
                                self.quickDestinationController.view.isHidden = false
                                self.drawCurvedOverlay(startCoordinate: userLocation, endCoordinate: fromLocation.coordinate)
                                self.placeAvailable()
                            }
                        })
                    } else {
                        self.quickParkingController.carIcon.alpha = 1
                        self.quickParkingController.walkingIcon.alpha = 0
                        self.quickDestinationController.view.isHidden = true
                        
                        delayWithSeconds(1.2, completion: {
                            DestinationAnnotationLocation = toLocation
                            quadStartCoordinate = toLocation.coordinate
                            quadEndCoordinate = fromLocation.coordinate
                            
                            self.locatorButtonAction(sender: self.locatorButton)
                        })
                    }
                }
            }
        }
    }
    
    func setupQuickController(minute: Double) {
        let time = minute.rounded(toPlaces: 0)
        let distanceTime = String(format: "%.0f min", time)
        let distanceWidth = distanceTime.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3) + 94
        self.quickParkingController.distanceLabel.text = distanceTime
        self.quickParkingWidthAnchor.constant = distanceWidth
        
        if let address = self.searchBarController.toLabel.text {
            let addressArray = address.split(separator: ",")
            if let addressString = addressArray.first {
                let addy = String(addressString)
                let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH4) + 32
                self.quickDestinationController.distanceLabel.text = addy
                self.quickDestinationWidthAnchor.constant = addressWidth
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
}
