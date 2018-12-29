//
//  MapKitDrawPath.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit

var ParkingRoutePolyLine: [MKOverlay] = []
var DestinationRoutePolyLine = MKPolyline()
var DestinationAnnotation: MKAnnotation?
var ZoomMapView: MKCoordinateRegion?
var IncreasedZoomMapView: MKCoordinateRegion?
var CurrentDestinationLocation: CLLocation?
var ClosestParkingLocation: CLLocation?

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
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: false)
            self.findBestParking(location: location, sourceLocation: sourceLocation, address: address)
            CurrentDestinationLocation = location
        }
    }
    
    func findBestParking(location: CLLocation, sourceLocation: CLLocation, address: String) {
        if let annotation = DestinationAnnotation {
            self.mapView.removeAnnotation(annotation)
        }
        let annotations = self.mapView.visibleAnnotations()
        self.mapView.removeAnnotations(self.mapView.annotations)
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
        let combined = zip(self.visibleAnnotationsDistance, self.visibleAnnotations).sorted {$0.0 < $1.0}
        self.visibleAnnotationsDistance = combined.map {$0.0}
        self.visibleAnnotations = combined.map {$0.1}
        if self.visibleAnnotations.count > 0 {
            self.searchForParking()
            let closestLocation = CLLocation(latitude: self.visibleAnnotations[0].coordinate.latitude, longitude: self.visibleAnnotations[0].coordinate.longitude)
            ClosestParkingLocation = closestLocation
            self.drawCurrentPath(dest: closestLocation, start: sourceLocation, type: "Parking") { (results: Bool) in
                let parking = MKPointAnnotation()
                parking.coordinate = closestLocation.coordinate
                parking.title = "Parking spot"
                self.mapView.addAnnotation(parking)
                self.drawCurrentPath(dest: location, start: closestLocation, type: "Destination") { (results: Bool) in
                    let marker = MKPointAnnotation()
                    marker.coordinate = location.coordinate
                    marker.title = address
                    marker.subtitle = "Destination"
                    DestinationAnnotation = marker
                    self.mapView.addAnnotation(marker)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.findBestLatLong(first: sourceLocation, second: location, third: closestLocation)
                        self.parkingSelected()
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
            
            let region = self.createAnnotationContainer(one: leftMost, two: rightMost)
            ZoomMapView = region
            let mapRegion = self.createAnnotationContainer(one: second, two: third)
            var zoomRegion = mapRegion
            zoomRegion.span = MKCoordinateSpan(latitudeDelta: mapRegion.span.latitudeDelta*1.8, longitudeDelta: mapRegion.span.longitudeDelta*1.4)
            IncreasedZoomMapView = zoomRegion
            self.mapView.setRegion(mapRegion, animated: true)
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
    
    func drawCurrentPath(dest: CLLocation, start: CLLocation, type: String, completion: @escaping(Bool) -> ()) {
        if self.shouldDrawOverlay {
            let sourcePlacemark = MKPlacemark(coordinate: start.coordinate)
            let destPlacemark = MKPlacemark(coordinate: dest.coordinate)
            
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            let destItem = MKMapItem(placemark: destPlacemark)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceItem
            directionRequest.destination = destItem
            if type == "Destination" {
                directionRequest.transportType = .walking
            } else {
                directionRequest.transportType = .automobile
            }
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate(completionHandler: {
                response, error in
                guard let response = response else { return }
                let route = response.routes[0].polyline
                if type == "Parking" && self.shouldDrawOverlay == true {
                    ParkingRoutePolyLine.append(route)
                    let newRoute = ParkingRoutePolyLine[ParkingRoutePolyLine.count-1]
                    self.mapView.addOverlay(newRoute, level: .aboveRoads)
                    self.view.layoutIfNeeded()
                } else if type == "Destination" && self.shouldDrawOverlay == true {
                    DestinationRoutePolyLine = route
                    DestinationRoutePolyLine.title = "Destination Route"
                    self.mapView.addOverlay(DestinationRoutePolyLine, level: .aboveRoads)
                }
                completion(true)
            })
        } else { return }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            if ParkingRoutePolyLine.count > 0 && overlay as? MKPolyline == ParkingRoutePolyLine[ParkingRoutePolyLine.count - 1] as? MKPolyline {
                var gradientColors = [Theme.PURPLE, Theme.PURPLE, Theme.SEA_BLUE, Theme.SEA_BLUE, Theme.SEA_BLUE]
                if self.shouldFlipGradient == true {
                    gradientColors.reverse()
                }
                let polylineRenderer = JLTGradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
                polylineRenderer.lineWidth = 10
                return polylineRenderer
            } else if overlay as? MKPolyline == DestinationRoutePolyLine {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.lineDashPattern = [6,4]
                renderer.strokeColor = Theme.BLACK
                renderer.lineWidth = 4
                renderer.lineCap = CGLineCap.butt
                return renderer
            }
        }
        return MKOverlayRenderer()
    }
    
    func createAnnotationContainer(one: CLLocation, two: CLLocation) -> MKCoordinateRegion {
        let oneLat = abs(one.coordinate.latitude)
        let twoLat = abs(two.coordinate.latitude)
        var bothLat: CLLocationDegrees = 0.0
        var latDifference: CLLocationDegrees = 0.0
        if oneLat > twoLat {
            let difference = oneLat - twoLat
            latDifference = difference
            bothLat = (oneLat + twoLat)/2
        } else {
            let difference = twoLat - oneLat
            latDifference = difference
            bothLat = (oneLat + twoLat)/2
        }
        if one.coordinate.latitude < 0 && two.coordinate.latitude < 0 {
            bothLat = -bothLat
        }
        let oneLong = abs(one.coordinate.longitude)
        let twoLong = abs(two.coordinate.longitude)
        var bothLong: CLLocationDegrees = 0.0
        var longDifference: CLLocationDegrees = 0.0
        if oneLong > twoLong {
            let difference = oneLong - twoLong
            longDifference = difference
            bothLong = (oneLong + twoLong)/2
        } else {
            let difference = twoLong - oneLong
            longDifference = difference
            bothLong = (oneLong + twoLong)/2
        }
        if one.coordinate.longitude < 0 && two.coordinate.longitude < 0 {
            bothLong = -bothLong
        }
        let span = MKCoordinateSpan(latitudeDelta: latDifference*1.4, longitudeDelta: longDifference*1.2)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: bothLat, longitude: bothLong), span: span)
        return region
    }
    

//    func drawRoute(routesArray: [MKRoute]) {
//
//        if (routesArray.count > 0)
//        {
//            let routeDict = routesArray[0]
//            let routeOverviewPolyline = routeDict.polyline
//            let points = routeOverviewPolyline.points()
////            self.path = MKPolyline(points: points, count: .)
//
//            self.polyline.path = path
//            self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//            self.polyline.strokeWidth = 3.0
//            self.polyline.map = self.mapView
//
//            self.polylineTimer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
//        }
//    }
//
//    func animatePolylinePath() {
//        if (self.polylinei < self.path.count()) {
//            self.animationPath.add(self.path.coordinate(at: self.i))
//            self.animationPolyline.path = self.animationPath
//            self.animationPolyline.strokeColor = UIColor.black
//            self.animationPolyline.strokeWidth = 3
//            self.animationPolyline.map = self.mapView
//            self.polylinei += 1
//        }
//        else {
//            self.polylinei = 0
//            self.animationPath = GMSMutablePath()
//            self.animationPolyline.map = nil
//        }
//    }
//    
}
