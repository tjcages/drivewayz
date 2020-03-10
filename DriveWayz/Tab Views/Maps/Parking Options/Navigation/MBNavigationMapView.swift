//
//  MBNavigationMapView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/21/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import Mapbox
import CoreLocation
import AVFoundation
import MapboxDirections
import Turf

extension MBNavigationViewController: NavigationMapViewDelegate {
    
    func handleMapCamera(routeProgress: RouteProgress, location: CLLocation) {
        let distanceToGo = routeProgress.currentLegProgress.currentStepProgress.distanceRemaining
        let fractionTraveled = distanceToGo/pitchTransitionDistance
        
        if distanceToGo <= pitchTransitionDistance && distanceToGo >= 0 && tracksUserCourse {
            // Begin pan out to view from above
            var altitude = defaultLowAltitude + (defaultHighAltitude - defaultLowAltitude) * fractionTraveled
            if let nextStep = routeProgress.upcomingStep, nextStep.isMotorway {
                altitude = defaultHighAltitude + (zoomedOutMotorwayAltitude - defaultHighAltitude) * fractionTraveled
            }
            
            let shiftedCenter = shiftMapCamera(routeProgress: routeProgress, location: location)
            let newCamera = MGLMapCamera(lookingAtCenter: shiftedCenter, altitude: altitude, pitch: defaultLowPitch, heading: location.course)
            mapView.updateCourseTracking(location: location, camera: newCamera, animated: true)
        } else if tracksUserCourse {
            if routeProgress.currentLegProgress.currentStep.isMotorway {
                // Different altitude on motorways
                let newCamera = MGLMapCamera(lookingAtCenter: location.coordinate, altitude: zoomedOutMotorwayAltitude, pitch: defaultHighPitch, heading: location.course)
                mapView.updateCourseTracking(location: location, camera: newCamera, animated: true)
            } else {
                // Default altitude on regular highways
                let newCamera = MGLMapCamera(lookingAtCenter: location.coordinate, altitude: defaultAltitude, pitch: defaultHighPitch, heading: location.course)
                mapView.updateCourseTracking(location: location, camera: newCamera, animated: true)
            }
            if tracksUserCourse {
                animateUserCourse(point: userAnchorPoint, animated: true)
                userCourseView.update(location: location, pitch: defaultHighPitch, direction: location.course, animated: true, tracksUserCourse: true)
            }
        }
    }
    
    func shiftMapCamera(routeProgress: RouteProgress, location: CLLocation) -> CLLocationCoordinate2D {
        var xDisplacement: CGFloat = 0
        var yDisplacement: CGFloat = 0
        guard let type = routeProgress.currentLegProgress.upcomingStep?.maneuverType else {
            userCourseView.update(location: location, pitch: defaultLowPitch, direction: location.course, animated: true, tracksUserCourse: true)
            animateUserCourse(point: userAnchorPoint, animated: true)
            return location.coordinate
        }
        if type == .turn {
            guard let side = routeProgress.currentLegProgress.upcomingStep?.maneuverDirection else {
                animateUserCourse(point: userAnchorPoint, animated: true)
                userCourseView.update(location: location, pitch: defaultLowPitch, direction: location.course, animated: true, tracksUserCourse: true)
                return location.coordinate
            }

            let distanceToGo = routeProgress.currentLegProgress.currentStepProgress.distanceRemaining
            if distanceToGo <= pitchTransitionDistance {
                
                // Begin anchor shift to the opposite of the driver side
                let fractionTraveled = distanceToGo/pitchTransitionDistance
                xDisplacement = defaultMaxXInset - (defaultMaxXInset - defaultXInset) * CGFloat(fractionTraveled)
                yDisplacement = defaultMaxYInset - (defaultMaxYInset - defaultYInset) * CGFloat(fractionTraveled)
                
                if fractionTraveled == 0.0 && distanceToGo > pitchTransitionDistance {
                    animateUserCourse(point: userAnchorPoint, animated: true)
                    userCourseView.update(location: location, pitch: defaultLowPitch, direction: location.course, animated: true, tracksUserCourse: true)
                    return location.coordinate
                }
                
                var userPoint = mapView.convert(location.coordinate, toPointTo: mapView)
                userPoint.y += yDisplacement
                
                if side == .left {
                    userPoint.x -= xDisplacement
                    userPoint.y += yDisplacement
                    let puckPoint = CGPoint(x: userAnchorPoint.x + xDisplacement/2, y: userAnchorPoint.y - yDisplacement)
                    animateUserCourse(point: puckPoint, animated: true)
                } else if side == .right {
                    userPoint.x += xDisplacement
                    userPoint.y += yDisplacement
                    let puckPoint = CGPoint(x: userAnchorPoint.x - xDisplacement/2, y: userAnchorPoint.y - yDisplacement)
                    animateUserCourse(point: puckPoint, animated: true)
                } else {
                    animateUserCourse(point: userAnchorPoint, animated: true)
                }
                
                let coordinate = mapView.convert(userPoint, toCoordinateFrom: mapView)
                let center = middlePointOfListMarkers(listCoords: [location.coordinate, coordinate])
                return center
            } else {
                animateUserCourse(point: userAnchorPoint, animated: true)
                userCourseView.update(location: location, pitch: defaultLowPitch, direction: location.course, animated: true, tracksUserCourse: true)
            }
        } else {
            animateUserCourse(point: userAnchorPoint, animated: true)
            userCourseView.update(location: location, pitch: defaultLowPitch, direction: location.course, animated: true, tracksUserCourse: true)
        }
        
        return location.coordinate
    }
    
    func animateUserCourse(point: CGPoint, animated: Bool) {
        let duration: TimeInterval = animated ? 1 : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.userCourseView.center = point
        }) { (success) in
            //
        }
    }
    
    func middlePointOfListMarkers(listCoords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat

        for coordinate in listCoords{
            let lat:CGFloat = degreeToRadian(angle: coordinate.latitude)
            let lon:CGFloat = degreeToRadian(angle: coordinate.longitude)
            x = x + cos(lat) * cos(lon)
            y = y + cos(lat) * sin(lon)
            z = z + sin(lat)
        }

        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)

        let resultLon: CGFloat = atan2(y, x)
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        let resultLat:CGFloat = atan2(z, resultHyp)

        let newLat = radianToDegree(radian: resultLat)
        let newLon = radianToDegree(radian: resultLon)
        let result: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
        
        return result
    }
    
    func mapViewUserLocationAnchorPoint(_ mapView: MGLMapView) -> CGPoint {
        return userAnchorPoint
    }

    func navigationMapView(_ mapView: NavigationMapView, routeCasingStyleLayerWithIdentifier identifier: String, source: MGLSource) -> MGLStyleLayer? {
        let layer = MGLLineStyleLayer(identifier: identifier, source: source)
        layer.lineColor = NSExpression(forConstantValue: Theme.BLUE)
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", MBRouteLineWidthByZoomLevel.multiplied(by: 1.4))
        layer.lineJoin = NSExpression(forConstantValue: "round")
        
        return layer
    }
    
    func degreeToRadian(angle:CLLocationDegrees) -> CGFloat {
        return (  (CGFloat(angle)) / 180.0 * CGFloat.pi  )
    }
    
    func radianToDegree(radian:CGFloat) -> CLLocationDegrees {
        return CLLocationDegrees(  radian * CGFloat(180.0 / CGFloat.pi)  )
    }
    
}


