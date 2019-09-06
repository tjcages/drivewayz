//
//  MBSelectAnnotation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox
import MapboxDirections
//import MapboxNavigation
import MapboxCoreNavigation

var didTapParking: Bool = false
var TappedDestinationAnnotationLocation: CLLocation?

extension MapKitViewController {
    
    func mapViewDidSelectAnnotation(didSelect annotation: MGLAnnotation) {
        didTapParking = true
        self.quickParkingController.walkingIcon.alpha = 0
        self.quickParkingController.carIcon.alpha = 1
        if let title = annotation.title, let parkingID = title {
            self.searchBarController.toLabel.text = "Current location "
            if let parking = self.parkingSpotsDictionary[parkingID] {
                if let parkingLat = parking.latitude, let parkingLong = parking.longitude {
                    let parkingCoordinate = CLLocation(latitude: parkingLat, longitude: parkingLong)
                    guard let userLocation = self.mapView.userLocation?.location else { return }
                    self.delegate?.hideHamburger()
                    DestinationAnnotationLocation = userLocation
                    TappedDestinationAnnotationLocation = parkingCoordinate
                    
                    self.parkingSelected()
                    self.checkAnnotationsNearDestination(location: parkingCoordinate.coordinate, checkDistance: false)
                    self.mapView.setCenter(parkingCoordinate.coordinate, animated: true)
                    
//                    self.checkAnnotationsNearDestination(location: userLocation.coordinate, checkDistance: true)

//                    DestinationAnnotationLocation = parkingCoordinate
//                    self.drawRouteForTapped(fromLocation: userLocation, toLocation: parkingCoordinate)
//
//                    self.removeMainBar()
//                    self.delegate?.hideHamburger()
//                    self.parkingSelected()
                }
            }
        }
    }
    
    func drawRouteForTapped(fromLocation: CLLocation, toLocation: CLLocation) {
//        self.removeAllMapOverlays(shouldRefresh: true)
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude), name: "Start"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude), name: "Destination"),
        ]
        let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
        options.includesSteps = true
        
        _ = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            if let route = routes?.first {
                let minute = route.expectedTravelTime / 60
//                self.setupQuickController(minute: minute)
//                WalkingTime = minute
                if route.coordinateCount > 0 {
                    //                    firstWalkingRoute = route
                    // Convert the route’s coordinates into a polyline.
                    
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    let view = UIView(frame: routeLine.accessibilityFrame)
                    view.backgroundColor = .red
                    self.view.addSubview(view)
                    let ne = routeLine.overlayBounds.ne
                    let sw = routeLine.overlayBounds.sw
                    let region = MGLCoordinateBounds(sw: sw, ne: ne)
                    ZooomRegion = region
                    
                    self.parkingCoordinates = route.coordinates!
                    self.addPolyline(to: self.mapView.style!, isCurrentDriving: true)
                    self.animateFirstPolyline()
                    
                    delayWithSeconds(animationIn, completion: {
                        self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 64, bottom: 430, right: 64), animated: true)
                        quadStartCoordinate = fromLocation.coordinate
                        if let userLocation = self.locationManager.location?.coordinate {
                            quadEndCoordinate = userLocation
                            self.drawCurvedOverlay(startCoordinate: userLocation, endCoordinate: fromLocation.coordinate)
//                            self.placeAvailable()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Feature interaction
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Try matching the exact point
            let point = sender.location(in: sender.view!)
            let touchCoordinate = mapView.convert(point, toCoordinateFrom: sender.view!)
            
            if self.mapView.zoomLevel >= 11 {
                let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
                
                guard var possibleFeatures = mapView.visibleAnnotations(in: sender.view!.bounds) else { return }
                for features in possibleFeatures {
                    let position = mapView.convert(features.coordinate, toPointTo: sender.view)
                    let distance = CGPointDistance(from: position, to: point)
                    if distance > 20 {
                        possibleFeatures = possibleFeatures.filter { $0 !== features }
                    }
                }
                
                // Select the closest feature to the touch center.
                let closestFeatures = possibleFeatures.sorted(by: {
                    return CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: touchLocation) < CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: touchLocation)
                })
                if let feature = closestFeatures.first {
                    let closestFeature = feature
                    self.mapViewDidSelectAnnotation(didSelect: closestFeature)
                    return
                }
                
                // If no features were found, deselect the selected annotation, if any.
                mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
            } else {
                let altitude = self.mapView.camera.altitude - 32000
                
//                self.mapView.setCenter(touchCoordinate, zoomLevel: zoom, animated: true)
                let camera = MGLMapCamera(lookingAtCenter: touchCoordinate, altitude: CLLocationDistance(exactly: altitude)!, pitch: 0, heading: CLLocationDirection(0))
                self.mapView.setCamera(camera, withDuration: animationOut, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight * 3/4 - 60, right: phoneWidth/2), completionHandler: nil)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if self.mapView.zoomLevel >= 11 {
            self.mapViewDidSelectAnnotation(didSelect: annotation)
            
            // If no features were found, deselect the selected annotation, if any.
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        } else {
            let altitude = self.mapView.camera.altitude - 16000
            
            //                self.mapView.setCenter(touchCoordinate, zoomLevel: zoom, animated: true)
            let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, altitude: CLLocationDistance(exactly: altitude)!, pitch: 0, heading: CLLocationDirection(0))
            self.mapView.setCamera(camera, withDuration: animationOut, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight * 3/4 - 60, right: phoneWidth/2), completionHandler: nil)
        }
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
}
