//
//  MapKitLocator.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import AVFoundation

extension MapKitViewController {
    
    @objc func locatorButtonAction(sender: UIButton) {
        let location: CLLocationCoordinate2D = mapView.userLocation.coordinate
        let camera = MKMapCamera()
        camera.pitch = 40
        camera.centerCoordinate = location
        camera.altitude = 1000
        self.mapView.camera = camera
        self.mapView.userTrackingMode = .followWithHeading
        self.locatorButton.tintColor = Theme.SEA_BLUE
        self.locatorButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.canChangeLocatorButtonTint = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.canChangeLocatorButtonTint = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if self.canChangeLocatorButtonTint == true {
            self.locatorButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.locatorButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func setupLocationManager() {
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        if self.currentActive == false && self.searchedForPlace == false && alreadyLoadedSpots == false {
            self.observeUserParkingSpots()
        }
        self.resultsScrollAnchor.constant = 0
        if self.searchedForPlace == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate
                var region = MKCoordinateRegion()
                region.center = location
                region.span.latitudeDelta = 0.02
                region.span.longitudeDelta = 0.02
                self.mapView.setRegion(region, animated: false)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate
                var region = MKCoordinateRegion()
                region.center = location
                region.span.latitudeDelta = 0.01
                region.span.longitudeDelta = 0.01
                self.mapView.setRegion(region, animated: true)
            }
        } else {
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = Theme.PACIFIC_BLUE
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func getDirections(to primaryRoute: MKRoute) {
        self.mapView.userTrackingMode = .followWithHeading
        self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
        self.navigationSteps = primaryRoute.steps
        for i in 0 ..< primaryRoute.steps.count {
            let step = primaryRoute.steps[i]
            let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20, identifier: "\(i)")
            self.locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: region.center, radius: region.radius)
            self.mapView.addOverlay(circle)
        }
        let firstDistance = self.convertDistance(dist: self.navigationSteps[1].distance, nav: self.navigationSteps[1].instructions)
        let secondDistance = self.convertDistance(dist: self.navigationSteps[2].distance, nav: self.navigationSteps[2].instructions)
        let initialMessage = "In \(firstDistance), then in \(secondDistance)."
        self.speakDirections(message: initialMessage)
        self.stepCounter += 1
    }
    
    func speakDirections(message: String) {
        self.navigationLabel.text = message
        let numLines = (self.navigationLabel.contentSize.height / (self.navigationLabel.font?.lineHeight)!)
        if numLines < 2 {
            self.navigationLabelHeight.constant = 70
        } else if numLines < 3 {
            self.navigationLabelHeight.constant = 90
        } else if numLines < 4 {
            self.navigationLabelHeight.constant = 110
        } else {
            self.navigationLabelHeight.constant = 130
        }
        UIView.animate(withDuration: animationIn) {
            self.navigationLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        let audioSession = AVAudioSession.sharedInstance()
        do { try audioSession.setCategory(.playback, mode: .default, options: .duckOthers) } catch { print("Error playing audio over music") }
        let speechUtterance = AVSpeechUtterance(string: message)
        self.speechSythensizer.speak(speechUtterance)
    }
    
    func convertDistance(dist: Double, nav: String) -> String {
        let first = String(nav.prefix(1)).lowercased()
        let other = String(nav.dropFirst())
        let feetDist = dist * 3.28084
        if feetDist > 500 {
            let mileDist = feetDist/5280
            return "\(mileDist.rounded(toPlaces: 1)) miles \(first+other)"
        } else {
            return "\(Int(round(feetDist/10)*10)) feet \(first+other)"
        }
    }
    
    func hideNavigation() {
        isEditing = false
        self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
        UIView.animate(withDuration: animationIn) {
            self.navigationLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
}
