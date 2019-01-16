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
import MapboxNavigation
import MapboxCoreNavigation

extension MapKitViewController {
    
    func zoomToSearchLocation(address: String) {
        self.dismissKeyboard()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print(error?.localizedDescription as Any)
                    return
            }
            guard let sourceLocation = self.locationManager.location else { return }
            self.mapView.setCenter(location.coordinate, zoomLevel: 10, direction: CLLocationDirection(exactly: 0)!, animated: false, completionHandler: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.findBestParking(location: location, sourceLocation: sourceLocation, address: address)
                }
            })
//            CurrentDestinationLocation = location
        }
    }
    
    func findBestParking(location: CLLocation, sourceLocation: CLLocation, address: String) {
        if let annotations = self.mapView.visibleAnnotations as? [MGLPointAnnotation] {
            self.visibleAnnotationsDistance = []
            self.visibleAnnotations = []
            self.removeAllMapOverlays()
            for annotation in annotations {
                let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let distance = self.distanceBetweenCoordinates(from: location, to: annotationLocation)
                if annotation.title != "My Location" {
                    self.visibleAnnotationsDistance.append(distance)
                    self.visibleAnnotations.append(annotation)
                }
            }
        }
        if let currentAnnotations = self.mapView.annotations {
            self.mapView.removeAnnotations(currentAnnotations)
        }
        let combined = zip(self.visibleAnnotationsDistance, self.visibleAnnotations).sorted {$0.0 < $1.0}
        self.visibleAnnotationsDistance = combined.map {$0.0}
        self.visibleAnnotations = combined.map {$0.1}
        if self.visibleAnnotations.count > 0 {
            self.searchForParking()
            let closestLocation = CLLocation(latitude: self.visibleAnnotations[0].coordinate.latitude, longitude: self.visibleAnnotations[0].coordinate.longitude)
//            ClosestParkingLocation = closestLocation
            self.drawCurrentPath(dest: closestLocation, start: sourceLocation, type: "Parking", address: address) { (results: Bool) in
                self.drawCurrentPath(dest: location, start: closestLocation, type: "Destination", address: address) { (results: Bool) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.findBestLatLong(first: location, second: location, third: closestLocation)
                        self.findBestLatLong(first: sourceLocation, second: location, third: closestLocation)
                        self.parkingSelected()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.checkQuickDestination()
                            })
                        }
                    }
                }
            }
        }
    }
    
    func findBestLatLong(first: CLLocation, second: CLLocation, third: CLLocation) {
        let long = [first.coordinate.longitude, second.coordinate.longitude, third.coordinate.longitude].sorted()
        let lat = [first.coordinate.latitude, second.coordinate.latitude, third.coordinate.latitude].sorted()
        if let leftLast = lat.last, let leftFirst = long.first, let rightFirst = lat.first, let rightLast = long.last {
            let leftMost = CLLocation(latitude: leftLast, longitude: leftFirst)
            let rightMost = CLLocation(latitude: rightFirst, longitude: rightLast)
            
            let region = MGLCoordinateBounds(sw: leftMost.coordinate, ne: rightMost.coordinate)
            if first != second {
                ZoomMapView = region
            } else {
                self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 240, left: 66, bottom: 240, right: 66), animated: true)
            }
            self.parkingLocatorButton.alpha = 0
        }
        if abs(first.coordinate.longitude) > abs(second.coordinate.longitude) {
            self.shouldFlipGradient = true
        } else {
            self.shouldFlipGradient = false
        }
    }
    
    func distanceBetweenCoordinates(from: CLLocation, to: CLLocation) -> Double {
        let distanceInMeters = to.distance(from: from)
        return distanceInMeters
    }
    
    func drawCurrentPath(dest: CLLocation, start: CLLocation, type: String, address: String, completion: @escaping(Bool) -> ()) {
        if self.shouldDrawOverlay {
            let directions = Directions.shared
            let waypoints = [
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude), name: "Start"),
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: dest.coordinate.latitude, longitude: dest.coordinate.longitude), name: "Destination"),
                ]
            let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    if route.coordinateCount > 0 {
                        // Convert the route’s coordinates into a polyline.
                        if type == "Destination" {
                            let marker = MGLPointAnnotation()
                            marker.coordinate = dest.coordinate
                            marker.title = address
                            marker.subtitle = "Destination"
                            self.mapView.addAnnotation(marker)
                            
                            self.parkingCoordinates = route.coordinates!
                            self.addPolyline(to: self.mapView.style!, type: type)
                            self.animateSecondPolyline()
                            self.animateFirstPolyline()
                            completion(true)
                        } else if type == "Parking" {
                            self.firstParkingRoute = route
                            var routeCoordinates = route.coordinates!
                            let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                            routeLine.title = "ParkingUnder"

                            self.mapView.addAnnotation(routeLine)
                            self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                            
                            let parking = MGLPointAnnotation()
                            parking.coordinate = dest.coordinate
                            parking.title = "Parking spot"
                            self.mapView.addAnnotation(parking)
                
                            self.destinationCoordinates = route.coordinates!
                            self.addPolyline(to: self.mapView.style!, type: type)
                            completion(true)
                        }
                    }
                }
            }
        }
    }

    func createAnnotationContainer(one: CLLocation, two: CLLocation) -> CLLocationCoordinate2D {
        let oneLat = abs(one.coordinate.latitude)
        let twoLat = abs(two.coordinate.latitude)
        var bothLat: CLLocationDegrees = 0.0
        if oneLat > twoLat {
            bothLat = (oneLat + twoLat)/2
        } else {
            bothLat = (oneLat + twoLat)/2
        }
        if one.coordinate.latitude < 0 && two.coordinate.latitude < 0 {
            bothLat = -bothLat
        }
        let oneLong = abs(one.coordinate.longitude)
        let twoLong = abs(two.coordinate.longitude)
        var bothLong: CLLocationDegrees = 0.0
        if oneLong > twoLong {
            bothLong = (oneLong + twoLong)/2
        } else {
            bothLong = (oneLong + twoLong)/2
        }
        if one.coordinate.longitude < 0 && two.coordinate.longitude < 0 {
            bothLong = -bothLong
        }
        let location = CLLocationCoordinate2D(latitude: bothLat, longitude: bothLong)

        return location
    }
    
}
