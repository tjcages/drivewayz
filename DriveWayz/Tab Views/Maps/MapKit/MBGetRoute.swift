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

protocol handleParkingOptions {
//    func applyFirstPolyline()
//    func applySecondPolyline()
//    func applyThirdPolyline()
}

var DestinationAnnotationLocation: CLLocationCoordinate2D?
var FinalAnnotationLocation: CLLocationCoordinate2D?
var FirstAnnotationLocation: CLLocationCoordinate2D?
var SecondAnnotationLocation: CLLocationCoordinate2D?
var ThirdAnnotationLocation: CLLocationCoordinate2D?

var finalDriveTime: Double?
var firstDriveTime: Double?
var secondDriveTime: Double?
var thirdDriveTime: Double?

var finalPickupCoordinate: CLLocationCoordinate2D?
var finalDestinationCoordinate: CLLocationCoordinate2D?
var firstPickupCoordinate: CLLocationCoordinate2D?
var firstDestinationCoordinate: CLLocationCoordinate2D?
var secondPickupCoordinate: CLLocationCoordinate2D?
var secondDestinationCoordinate: CLLocationCoordinate2D?
var thirdPickupCoordinate: CLLocationCoordinate2D?
var thirdDestinationCoordinate: CLLocationCoordinate2D?

extension MapKitViewController: handleParkingOptions {
    
    func zoomToSearchLocation(address: String) {
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
        self.removeMainBar()
        delayWithSeconds(animationIn) {
            self.searchBarController.openSearchBar()
        }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("lookup place id query error: \(error!.localizedDescription)")
                    delayWithSeconds(2, completion: {
                        DispatchQueue.main.async {
                            self.parkingHidden()
                        }
                    })
                    return
            }
            self.parkingSelected()
            self.mapView.setCenter(location.coordinate, animated: true)
            self.removeAllHostLocations()
            self.quickDestinationController.setupData()
            
            
            if let userLocation = self.mapView.userLocation?.location {
                self.drawRoute(fromLocation: userLocation, toLocation: location)
            }
        }
    }
    
    func drawRoute(fromLocation: CLLocation, toLocation: CLLocation) {
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude), name: "Start"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude), name: "Destination"),
        ]
        let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
        options.includesSteps = true
            
        _ = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            if let route = routes?.first {
                let minute = route.expectedTravelTime / 60
//                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
//                self.quickDestinationController.setupData()
                if route.coordinateCount > 0 {
//                    firstWalkingRoute = route
                    // Convert the route’s coordinates into a polyline.
                    
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    routeLine.title = "ParkingUnder"
                    let ne = routeLine.overlayBounds.ne
                    let sw = routeLine.overlayBounds.sw
                    let region = MGLCoordinateBounds(sw: sw, ne: ne)
                    self.mapView.addAnnotation(routeLine)
                    
                    self.parkingCoordinates = route.coordinates!
                    self.addPolyline(to: self.mapView.style!)
                    self.animateFirstPolyline()

                    let marker = MGLPointAnnotation()
                    marker.coordinate = toLocation.coordinate
                    marker.subtitle = "Destination"
                    self.mapView.addAnnotation(marker)
                    delayWithSeconds(animationIn, completion: {
                        self.mapView.setZoomLevel(14, animated: true)
                        self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 100, left: 64, bottom: 40, right: 64), animated: true)
                        delayWithSeconds(1.2, completion: {
                            self.drawCurvedOverlay(startCoordinate: fromLocation.coordinate, endCoordinate: toLocation.coordinate)
                        })
                    })
//                    DestinationAnnotationLocation = dest.coordinate
                }
            }
        }
    }
    
    
    
    
    
    
    func findBestParking(location: CLLocation, sourceLocation: CLLocation, searchLocation: CLLocation, address: String) {
        parkingController.setData(closestParking: self.closeParkingSpots, cheapestParking: self.cheapestParkingSpots, overallDestination: searchLocation.coordinate)
        self.drawCurrentPath(dest: location, start: sourceLocation, type: "Parking", address: address) { (results: CLLocationCoordinate2D) in
            if sourceLocation != searchLocation {
                self.drawCurrentPath(dest: searchLocation, start: location, type: "Destination", address: address) { (result: CLLocationCoordinate2D) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.findBestLatLong(first: location, second: sourceLocation, third: searchLocation, type: "First")
                        self.findBestLatLong(first: location, second: location, third: searchLocation, type: "FirstPurchase")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.parkingSelected()
                            UIView.animate(withDuration: animationIn, animations: {
                                self.checkQuickDestination(annotationLocation: result)
                            })
//                        }
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.findBestLatLong(first: location, second: location, third: searchLocation, type: "First")
                    self.parkingSelected()
//                    self.parkingController.bookingFound()
                }
            }
        }
    }
    
    func findBestLatLong(first: CLLocation, second: CLLocation, third: CLLocation, type: String) {
        let long = [first.coordinate.longitude, second.coordinate.longitude, third.coordinate.longitude].sorted()
        let lat = [first.coordinate.latitude, second.coordinate.latitude, third.coordinate.latitude].sorted()
        if let leftLast = lat.last, let leftFirst = long.first, let rightFirst = lat.first, let rightLast = long.last {
            let leftMost = CLLocation(latitude: leftLast, longitude: leftFirst)
            let rightMost = CLLocation(latitude: rightFirst, longitude: rightLast)
            
            let region = MGLCoordinateBounds(sw: leftMost.coordinate, ne: rightMost.coordinate)
            if type == "First" {
                firstPickupCoordinate = second.coordinate
                firstDestinationCoordinate = first.coordinate
                ZoomMapView = region
                firstMapView = region
//                delayWithSeconds(1.2) {
                    if let region = ZoomMapView {
                        self.mapView.userTrackingMode = .none
                        self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 100, left: 36, bottom: 420, right: 36), animated: true)
                        if let location = DestinationAnnotationLocation {
                            delayWithSeconds(0.5) {
                                self.checkQuickDestination(annotationLocation: location)
                            }
                        }
                    }
//                }
            } else if type == "FirstPurchase" {
                ZoomPurchaseMapView = region
                firstPurchaseMapView = region
            } else if type == "Second" {
                secondPickupCoordinate = second.coordinate
                secondDestinationCoordinate = first.coordinate
                secondMapView = region
            } else if type == "SecondPurchase" {
                secondPurchaseMapView = region
            } else if type == "Third" {
                thirdPickupCoordinate = second.coordinate
                thirdDestinationCoordinate = first.coordinate
                thirdMapView = region
            } else if type == "ThirdPurchase" {
                thirdPurchaseMapView = region
            }
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
    
    func drawCurrentPath(dest: CLLocation, start: CLLocation, type: String, address: String, completion: @escaping(CLLocationCoordinate2D) -> ()) {
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude), name: "Start"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: dest.coordinate.latitude, longitude: dest.coordinate.longitude), name: "Destination"),
            ]
        if type == "Destination" {
            let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    let minute = route.expectedTravelTime / 60
                    self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                    self.quickDestinationController.setupData()
                    if route.coordinateCount > 0 {
                        firstWalkingRoute = route
                        // Convert the route’s coordinates into a polyline.
                        let marker = MGLPointAnnotation()
                        marker.coordinate = dest.coordinate
                        marker.title = address
                        marker.subtitle = "Destination"
                        self.mapView.addAnnotation(marker)
                        
                        self.parkingCoordinates = route.coordinates!
//                        self.addPolyline(to: self.mapView.style!, type: type)
//                        self.animateSecondPolyline()
                        self.animateFirstPolyline()
                        DestinationAnnotationLocation = dest.coordinate
                        
                        completion(marker.coordinate)
                    }
                }
            }
        } else if type == "Parking" {
            let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    let minute = route.expectedTravelTime / 60
                    self.currentSpotController.driveTime = minute
                    firstDriveTime = minute
                    if route.coordinateCount > 0 {
                        firstParkingRoute = route
                        // Convert the route’s coordinates into a polyline.
                        var routeCoordinates = route.coordinates!
                        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                        routeLine.title = "ParkingUnder"
                        
                        self.mapView.addAnnotation(routeLine)
                        firstPolyline = routeLine
                        
                        let parking = MGLPointAnnotation()
                        parking.coordinate = dest.coordinate
                        parking.title = "Parking spot"
                        self.mapView.addAnnotation(parking)
                        FirstAnnotationLocation = dest.coordinate
                        
                        destinationFirstCoordinates = route.coordinates!
                        self.destinationCoordinates = route.coordinates!
//                        self.addPolyline(to: self.mapView.style!, type: type)
                        
                        completion(parking.coordinate)
                    }
                }
            }
        } else if type == "ParkingBestPrice" {
            let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    if route.coordinateCount > 0 {
                        // Convert the route’s coordinates into a polyline.
                        secondWalkingRoute = route
                        
                        let parking = MGLPointAnnotation()
                        parking.coordinate = dest.coordinate
                        completion(parking.coordinate)
                    }
                }
            }
            
        } else if type == "ParkingBestPriceP" {
            let parkingOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
            parkingOptions.includesSteps = true
            
            _ = directions.calculate(parkingOptions) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    let minute = route.expectedTravelTime / 60
                    secondDriveTime = minute
                    if route.coordinateCount > 0 {
                        secondParkingRoute = route
                        // Convert the route’s coordinates into a polyline.
                        var routeCoordinates = route.coordinates!
                        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                        routeLine.title = "ParkingUnder"
                        secondPolyline = routeLine
                        SecondAnnotationLocation = dest.coordinate
                        
                        destinationSecondCoordinates = route.coordinates!
                        completion(dest.coordinate)
                    }
                }
            }
        } else if type == "ParkingStandardSpot" {
            let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    if route.coordinateCount > 0 {
                        // Convert the route’s coordinates into a polyline.
                        thirdWalkingRoute = route
                        
                        let parking = MGLPointAnnotation()
                        parking.coordinate = dest.coordinate
                        completion(parking.coordinate)
                    }
                }
            }
        } else if type == "ParkingStandardSpotP" {
            let parkingOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
            parkingOptions.includesSteps = true
            
            _ = directions.calculate(parkingOptions) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                if let route = routes?.first {
                    let minute = route.expectedTravelTime / 60
                    thirdDriveTime = minute
                    if route.coordinateCount > 0 {
                        thirdParkingRoute = route
                        // Convert the route’s coordinates into a polyline.
                        var routeCoordinates = route.coordinates!
                        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                        routeLine.title = "ParkingUnder"
                        thirdPolyline = routeLine
                        ThirdAnnotationLocation = dest.coordinate
                        
                        destinationThirdCoordinates = route.coordinates!
                        completion(dest.coordinate)
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
