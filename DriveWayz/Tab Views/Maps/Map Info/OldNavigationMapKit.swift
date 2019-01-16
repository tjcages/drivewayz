//
//  OldNavigationMapKit.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation

//    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
//        UIView.animate(withDuration: animationOut, animations: {
//            self.navigationRouteController!.view.alpha = 0
//            self.navigationTopAnchor.constant = self.view.frame.height
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            self.delegate?.defaultContentStatusBar()
//            self.locationManager.allowsBackgroundLocationUpdates = false
//            self.locationManager.stopUpdatingHeading()
//            self.locationManager.stopUpdatingLocation()
//            self.locationManager.stopMonitoringSignificantLocationChanges()
//            self.locationManager.stopMonitoringVisits()
//            self.navigationRouteController!.mapView?.locationManager.stopUpdatingHeading()
//            self.navigationRouteController!.mapView?.locationManager.stopUpdatingLocation()
//            self.navigationRouteController!.removeFromParent()
//            self.navigationRouteController!.view.removeFromSuperview()
//        }
//    }

//    func getDirections(to primaryRoute: Route) {
//        self.mapView.userTrackingMode = .followWithHeading
//        self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
//        self.navigationSteps = primaryRoute.coordinates!
//        if let steps = primaryRoute.coordinates {
//            var i = 0
//            for step in steps {
//                let region = CLCircularRegion(center: step, radius: 20, identifier: "\(i)")
//                self.locationManager.startMonitoring(for: region)
//                self.addPolyline(to: self.mapView.style!, type: "Circle")
////                    MKCircle(center: region.center, radius: region.radius)
////                self.mapView.addOverlay(circle)
//                i += 1
//            }
////            let firstDistance = self.convertDistance(dist: self.navigationSteps[1].distance, nav: self.navigationSteps[1].instructions)
////            let secondDistance = self.convertDistance(dist: self.navigationSteps[2].distance, nav: self.navigationSteps[2].instructions)
////            let initialMessage = "In \(firstDistance), then in \(secondDistance)."
////            self.speakDirections(message: initialMessage)
////            self.stepCounter += 1
//        }
//    }
//
//    func speakDirections(message: String) {
//        self.navigationLabel.text = message
//        let numLines = (self.navigationLabel.contentSize.height / (self.navigationLabel.font?.lineHeight)!)
//        if numLines < 2 {
//            self.navigationLabelHeight.constant = 70
//        } else if numLines < 3 {
//            self.navigationLabelHeight.constant = 90
//        } else if numLines < 4 {
//            self.navigationLabelHeight.constant = 110
//        } else {
//            self.navigationLabelHeight.constant = 130
//        }
//        UIView.animate(withDuration: animationIn) {
//            self.navigationLabel.alpha = 1
//            self.view.layoutIfNeeded()
//        }
//        let audioSession = AVAudioSession.sharedInstance()
//        do { try audioSession.setCategory(.playback, mode: .default, options: .duckOthers) } catch { print("Error playing audio over music") }
//        let speechUtterance = AVSpeechUtterance(string: message)
//        self.speechSythensizer.speak(speechUtterance)
//    }
//
//    func convertDistance(dist: Double, nav: String) -> String {
//        let first = String(nav.prefix(1)).lowercased()
//        let other = String(nav.dropFirst())
//        let feetDist = dist * 3.28084
//        if feetDist > 500 {
//            let mileDist = feetDist/5280
//            return "\(mileDist.rounded(toPlaces: 1)) miles \(first+other)"
//        } else {
//            return "\(Int(round(feetDist/10)*10)) feet \(first+other)"
//        }
//    }
//
//    func hideNavigation() {
//        isEditing = false
//        self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
//        UIView.animate(withDuration: animationIn) {
//            self.navigationLabel.alpha = 0
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
//
//        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
//        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
//
//        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
//        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
//
//        let dLon = lon2 - lon1
//
//        let y = sin(dLon) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
//        let radiansBearing = atan2(y, x)
//
//        return radiansToDegrees(radians: radiansBearing)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
////        self.stepCounter += 1
////        if self.stepCounter < self.navigationSteps.count {
////            let currentStep = self.navigationSteps[stepCounter]
////            let nextMessage = "In \(currentStep.distance) meters \(currentStep.instructions)."
////            self.speakDirections(message: nextMessage)
////        } else {
////            let message = self.destinationString
////            self.speakDirections(message: message)
////            self.stepCounter = 0
////            self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
////        }
//    }
