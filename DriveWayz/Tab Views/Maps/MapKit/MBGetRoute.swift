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
    func drawHostPolyline(fromLocation: CLLocation)
}

var DestinationAnnotationLocation: CLLocation?
var ZooomRegion: MGLCoordinateBounds?

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

var quadStartCoordinate: CLLocationCoordinate2D?
var quadEndCoordinate: CLLocationCoordinate2D?

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
            self.checkAnnotationsNearDestination(location: location.coordinate)
            self.parkingSelected()
            self.mapView.setCenter(location.coordinate, animated: true)
        }
    }
    
    func drawHostPolyline(fromLocation: CLLocation) {
//        self.removeAllHostLocations()
        self.removePolylineAnnotations()
        if let location = DestinationAnnotationLocation {
            self.drawRoute(fromLocation: fromLocation, toLocation: location)
//            self.placeAvailableParking(location: location.coordinate)
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
                self.setupQuickController(minute: minute)
                if route.coordinateCount > 0 {
//                    firstWalkingRoute = route
                    // Convert the route’s coordinates into a polyline.
                    
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    routeLine.title = "ParkingDestUnder"
                    let ne = routeLine.overlayBounds.ne
                    let sw = routeLine.overlayBounds.sw
                    let region = MGLCoordinateBounds(sw: sw, ne: ne)
                    ZooomRegion = region
                    self.mapView.addAnnotation(routeLine)
                    
                    self.parkingCoordinates = route.coordinates!
                    self.addPolyline(to: self.mapView.style!)
                    self.animateFirstPolyline()

                    delayWithSeconds(animationOut, completion: {
                        let marker = MGLPointAnnotation()
                        marker.coordinate = toLocation.coordinate
                        marker.title = "Destination"
                        self.mapView.addAnnotation(marker)
                    })
                    delayWithSeconds(animationIn, completion: {
//                        self.mapView.setZoomLevel(14, animated: true)
                        
                        self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64), animated: true)
                        quadStartCoordinate = fromLocation.coordinate
                        if let userLocation = self.locationManager.location?.coordinate {
                            quadEndCoordinate = userLocation
                            self.drawCurvedOverlay(startCoordinate: userLocation, endCoordinate: fromLocation.coordinate)
                            self.placeAvailable()
                        }
                    })
                }
            }
        }
    }
    
    func setupQuickController(minute: Double) {
        let time = minute.rounded(toPlaces: 0)
        let distanceTime = String(format: "%.0f min", time)
        let distanceWidth = distanceTime.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH4) + 44
        self.quickParkingController.distanceLabel.text = distanceTime
        self.quickParkingWidthAnchor.constant = distanceWidth
        
        if let address = self.searchBarController.toLabel.text {
            let addressArray = address.split(separator: ",")
            if let addressString = addressArray.first {
                let addy = String(addressString)
                let addressWidth = addy.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH4) + 24
                self.quickDestinationController.distanceLabel.text = addy
                self.quickDestinationWidthAnchor.constant = addressWidth
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
}
