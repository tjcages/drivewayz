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
            if let route = self.firstParkingRoute, let underPolyline = self.firstPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = firstDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = self.destinationFirstCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
                self.animateSecondPolyline()
                if let region = self.firstMapView, let purchaseRegion = self.firstPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 420, right: 66), animated: true)
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
            if let route = self.secondParkingRoute, let underPolyline = self.secondPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = secondDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = self.destinationSecondCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
                self.animateSecondPolyline()
                if let region = self.secondMapView, let purchaseRegion = self.secondPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 420, right: 66), animated: true)
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
            if let route = self.thirdParkingRoute, let underPolyline = self.thirdPolyline {
                let minute = route.expectedTravelTime / 60
                self.quickDestinationController.distanceLabel.text = "\(Int(minute.rounded())) min"
                if let minute = thirdDriveTime {
                    self.currentSpotController.driveTime = minute
                }
                
                let routeCoordinates = route.coordinates!
                self.parkingCoordinates = routeCoordinates
                
                self.mapView.addAnnotation(underPolyline)
                self.destinationCoordinates = self.destinationThirdCoordinates
                
                self.shouldShowOverlay = true
                self.addPolyline(to: self.mapView.style!, type: "Parking")
                self.addPolyline(to: self.mapView.style!, type: "Destination")
                self.animateFirstPolyline()
                self.animateSecondPolyline()
                if let region = self.thirdMapView, let purchaseRegion = self.thirdPurchaseMapView {
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 420, right: 66), animated: true)
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
