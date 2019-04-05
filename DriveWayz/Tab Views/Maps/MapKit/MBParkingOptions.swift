//
//  MBParkingOptions.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox

extension MapKitViewController {
    
    func applyFirstPolyline() {
        self.removePolylineAnnotations()
        DispatchQueue.main.async {
            if let route = firstWalkingRoute, let underPolyline = firstPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = firstDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = destinationFirstCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
                self.animateSecondPolyline()
                if let region = firstMapView, let purchaseRegion = firstPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 100, left: 66, bottom: 420, right: 66), animated: true)
                    ZoomMapView = region
                    ZoomPurchaseMapView = purchaseRegion
                    if let location = DestinationAnnotationLocation {
                        delayWithSeconds(0.5) {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.checkQuickDestination(annotationLocation: location)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func applySecondPolyline() {
        self.removePolylineAnnotations()
        DispatchQueue.main.async {
            if let route = secondWalkingRoute, let underPolyline = secondPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = secondDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = destinationSecondCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
                self.animateSecondPolyline()
                if let region = secondMapView, let purchaseRegion = secondPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 100, left: 66, bottom: 420, right: 66), animated: true)
                    ZoomMapView = region
                    ZoomPurchaseMapView = purchaseRegion
                    if let location = DestinationAnnotationLocation {
                        delayWithSeconds(0.5) {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.checkQuickDestination(annotationLocation: location)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func applyThirdPolyline() {
        self.removePolylineAnnotations()
        DispatchQueue.main.async {
            if let route = thirdWalkingRoute, let underPolyline = thirdPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = thirdDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = destinationThirdCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
                self.animateSecondPolyline()
                if let region = thirdMapView, let purchaseRegion = thirdPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 100, left: 66, bottom: 420, right: 66), animated: true)
                    ZoomMapView = region
                    ZoomPurchaseMapView = purchaseRegion
                    if let location = DestinationAnnotationLocation {
                        delayWithSeconds(0.5) {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.checkQuickDestination(annotationLocation: location)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func applyFinalPolyline() {
        self.removePolylineAnnotations()
        DispatchQueue.main.async {
            if let route = finalWalkingRoute, let underPolyline = finalPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = finalDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = destinationFinalCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
//                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
//                self.animateSecondPolyline()
                if let region = finalMapView, let purchaseRegion = finalPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 100, left: 66, bottom: 420, right: 66), animated: true)
                    ZoomMapView = region
                    ZoomPurchaseMapView = purchaseRegion
                    if let location = DestinationAnnotationLocation {
                        delayWithSeconds(0.5) {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.checkQuickDestination(annotationLocation: location)
                            })
                        }
                    }
                }
            }
        }
    }
    
}
