//
//  WalkingNavigation.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
//import MapboxCoreNavigation

extension NavigationMapBox {
    
//    @objc func userArrivedAtDestination() {
//        navigationService.stop()
//        navigationBottom.navigationStatus = .arrived
//        currentBottomHeightAnchor.constant = lowestHeight
//        closeCurrentBooking()
//        navigationMapController.view.bringSubviewToFront(fullBackgroundView)
//        UIView.animate(withDuration: animationIn, animations: {
//            self.fullBackgroundView.alpha = 1
//            self.navigationMapController.view.layoutIfNeeded()
//        }) { (success) in
//            delayWithSeconds(animationOut, completion: {
//                self.navigationMapController.modalTransitionStyle = .crossDissolve
//                if let booking = self.currentBooking, let bookingId = booking.bookingID {
////                    self.delegate?.openCurrentParking(bookingId: bookingId)
//                }
//                self.dismiss(animated: true, completion: {
//                    self.dismiss(animated: false, completion: nil)
//                })
//            })
//        }
//    }
//    
//    @objc func checkInButtonPressed() {
//        guard let text = navigationBottom.durationController.checkInButton.titleLabel?.text else { return }
//        if text == "Check in" {
//            navigationBottom.navigationStatus = .walking
//            directionsRoute = nil
//            removeLayers()
//            
//            if let route = walkingRoute {
//                navigationMapView.showRoutes([route])
//                navigationMapView.showWaypoints(route)
//                navigationMapController.navigationService.route = route
//                
//                navigationMapView.maneuverArrowColor = .clear
//                navigationMapView.maneuverArrowStrokeColor = .clear
//                
//                navigationMapView.tracksUserCourse = true
//                navigationMapView.defaultAltitude = 600
//                walkingLocatorPressed()
//            }
//            
//            if let booking = currentBooking, let bookingId = booking.bookingID {
//                let ref = Database.database().reference().child("UserBookings").child(bookingId)
//                ref.updateChildValues(["checkedIn": true])
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentBookingCheckedIn"), object: nil)
//            }
//            
//            currentBottomHeightAnchor.constant = lowestHeight
//            closeCurrentBooking()
//            UIView.animate(withDuration: animationOut) {
//                self.navigationInstructions.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//                self.navigationInstructions.view.alpha = 0
//                self.locatorButton.alpha = 0
//                self.voiceButton.alpha = 0
//                self.routeButton.alpha = 0
//                self.fullBackgroundView.alpha = 0
//                self.navigationMapController.view.layoutIfNeeded()
//            }
//        }
//    }
//    
//    @objc func endNavigationPressed(sender: UIButton) {
//        userArrivedAtDestination()
//    }
//    
//    @objc func walkingLocatorPressed() {
//        if navigationBottom.navigationStatus == .walking {
//            navigationMapView.tracksUserCourse = true
//        } else {
//            navigationMapView.userTrackingMode = .follow
//            if let start = walkingRoute?.routeOptions.waypoints.first, let end = walkingRoute?.routeOptions.waypoints.last {
//                let coordinateBounds = MGLCoordinateBounds(sw: start.coordinate, ne: end.coordinate)
//                let insets = UIEdgeInsets(top: statusHeight + 64, left: 72, bottom: lowestHeight + 64, right: 72)
//                let routeCamera = self.navigationMapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
//                self.navigationMapView.setCamera(routeCamera, animated: true)
//            }
//        }
//    }
//    
//    func updateRoute(progress: RouteProgress) {
//        
//    }
//    
//    func removeLayers() {
//        navigationMapView.removeArrow()
//        navigationMapView.removeRoutes()
//        navigationMapView.removeWaypoints()
//    }
//    
//}
//
//
//extension NavigationMapBox {
//    
//    func navigationMapViewDidStopTrackingCourse(_ mapView: NavigationMapView) {
//        if navigationBottom.navigationStatus == .walking || navigationBottom.navigationStatus == .arrived {
//            UIView.animate(withDuration: animationIn) {
//                self.walkingLocatorButton.alpha = 1
//            }
//        }
//    }
//    
//    func navigationMapViewDidStartTrackingCourse(_ mapView: NavigationMapView) {
//        if navigationBottom.navigationStatus == .walking || navigationBottom.navigationStatus == .arrived {
//            UIView.animate(withDuration: animationIn) {
//                self.walkingLocatorButton.alpha = 0
//            }
//        }
//    }
//    
//    func navigationViewController(_ navigationViewController: NavigationViewController, routeStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
//        if navigationBottom.navigationStatus == .walking {
//            let line = MGLLineStyleLayer(identifier: identifier, source: source)
//            line.lineJoin = NSExpression(forConstantValue: "round")
//            line.lineCap = NSExpression(forConstantValue: "round")
//
////            // The line width should gradually increase based on the zoom level.
//            line.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", MBRouteLineWidthByZoomLevel)
//
//            line.lineOpacity = NSExpression(forConditional: NSPredicate(format: "isAlternateRoute == true"),
//                                                  trueExpression: NSExpression(forConstantValue: 1),
//                                                  falseExpression: NSExpression(forConditional: NSPredicate(format: "isCurrentLeg == true"), trueExpression: NSExpression(forConstantValue: 1), falseExpression: NSExpression(forConstantValue: 0.85)))
//            
//            line.lineColor = NSExpression(forConstantValue: trafficUnknownColor)
//
//            // Dash pattern in the format [dash, gap]
//            line.lineDashPattern = NSExpression(forConstantValue: [0, 1.5])
//            
//            return line
//        } else {
//            let line = MGLLineStyleLayer(identifier: identifier, source: source)
//            line.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", MBRouteLineWidthByZoomLevel)
//            line.lineOpacity = NSExpression(forConditional:
//                NSPredicate(format: "isAlternateRoute == true"),
//                                            trueExpression: NSExpression(forConstantValue: 1),
//                                            falseExpression: NSExpression(forConditional: NSPredicate(format: "isCurrentLeg == true"),
//                                                                          trueExpression: NSExpression(forConstantValue: 1),
//                                                                          falseExpression: NSExpression(forConstantValue: 0)))
//            line.lineColor = NSExpression(format: "TERNARY(isAlternateRoute == true, %@, MGL_MATCH(congestion, 'low' , %@, 'moderate', %@, 'heavy', %@, 'severe', %@, %@))", routeAlternateColor, trafficLowColor, trafficModerateColor, trafficHeavyColor, trafficSevereColor, trafficUnknownColor)
//            line.lineJoin = NSExpression(forConstantValue: "round")
//            
//            return line
//        }
//    }
//    
//    func navigationViewController(_ navigationViewController: NavigationViewController, routeCasingStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
//        if navigationBottom.navigationStatus == .walking {
//            let lineCasing = MGLLineStyleLayer(identifier: identifier, source: source)
////            lineCasing.lineDashPattern = NSExpression(forConstantValue: [0, 1.6])
//            
//            // Take the default line width and make it wider for the casing
//            lineCasing.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", MBRouteLineWidthByZoomLevel.multiplied(by: 1.5))
//            
//            lineCasing.lineColor = NSExpression(forConditional: NSPredicate(format: "isAlternateRoute == true"),
//                                                trueExpression: NSExpression(forConstantValue: Theme.GRAY_WHITE_4),
//                                                falseExpression: NSExpression(forConstantValue: Theme.BLUE))
//            
//            lineCasing.lineCap = NSExpression(forConstantValue: "round")
//            lineCasing.lineJoin = NSExpression(forConstantValue: "round")
//            
//            lineCasing.lineOpacity = NSExpression(forConditional: NSPredicate(format: "isAlternateRoute == true"),
//                                                  trueExpression: NSExpression(forConstantValue: 1),
//                                                  falseExpression: NSExpression(forConditional: NSPredicate(format: "isCurrentLeg == true"), trueExpression: NSExpression(forConstantValue: 1), falseExpression: NSExpression(forConstantValue: 0.85)))
//            
//            return lineCasing
//        } else {
//            let lineCasing = MGLLineStyleLayer(identifier: identifier, source: source)
//            
//            // Take the default line width and make it wider for the casing
//            lineCasing.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", MBRouteLineWidthByZoomLevel.multiplied(by: 1.5))
//            
//            lineCasing.lineColor = NSExpression(forConditional: NSPredicate(format: "isAlternateRoute == true"),
//                                                trueExpression: NSExpression(forConstantValue: Theme.LightBlue),
//                                                falseExpression: NSExpression(forConstantValue: Theme.BLUE))
//            
//            lineCasing.lineCap = NSExpression(forConstantValue: "round")
//            lineCasing.lineJoin = NSExpression(forConstantValue: "round")
//            
//            lineCasing.lineOpacity = NSExpression(forConditional: NSPredicate(format: "isAlternateRoute == true"),
//                                                  trueExpression: NSExpression(forConstantValue: 1),
//                                                  falseExpression: NSExpression(forConditional: NSPredicate(format: "isCurrentLeg == true"), trueExpression: NSExpression(forConstantValue: 1), falseExpression: NSExpression(forConstantValue: 0.85)))
//            
//            return lineCasing
//        }
//    }
    
}

//public var trafficUnknownColor: UIColor = .trafficUnknown
//public var trafficLowColor: UIColor = .trafficLow
//public var trafficModerateColor: UIColor = .trafficModerate
//public var trafficHeavyColor: UIColor = .trafficHeavy
//public var trafficSevereColor: UIColor = .trafficSevere
//public var routeCasingColor: UIColor = .defaultRouteCasing
//public var routeAlternateColor: UIColor = .defaultAlternateLine
