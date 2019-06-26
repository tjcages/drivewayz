//
//  MBRemoveAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

extension MapKitViewController {
    
    func removeAllHostLocations() {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
    }
    
    func removeAllMapOverlays(shouldRefresh: Bool) {
        ParkingRoutePolyLine = []
        ZoomMapView = nil
        CurrentDestinationLocation = nil
        ClosestParkingLocation = nil
        DestinationAnnotationLocation = nil
        self.shouldShowOverlay = false
        self.quickDestinationController.view.alpha = 0
        self.quickParkingController.view.alpha = 0
        if self.polylineFirstTimer != nil { self.polylineFirstTimer!.invalidate() }
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            self.mapView.setCenter(location, zoomLevel: 14, animated: true)
            self.mapView.userTrackingMode = .follow
        }
        if let line = quadPolyline, let shadowLine = quadPolylineShadow {
            line.removeFromSuperlayer()
            shadowLine.removeFromSuperlayer()
            quadStartCoordinate = nil
            quadEndCoordinate = nil
        }
        self.removePolylineAnnotations()
        self.quickDestinationController.view.alpha = 0
        self.quickParkingController.view.alpha = 0
        if shouldRefresh == true {
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
                self.observeAllParking()
            } else {
                self.observeAllParking()
            }
        } else {
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
            }
        }
    }
    
    func removePolylineAnnotations() {
        self.shouldShowOverlay = false
        self.quickDestinationController.view.alpha = 0
        self.quickParkingController.view.alpha = 0
        if self.polylineSecondTimer != nil { self.polylineSecondTimer!.invalidate() }
        if self.polylineFirstTimer != nil { self.polylineFirstTimer!.invalidate() }
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
        if let layers = self.mapView.style?.layers {
            for layer in layers {
                if layer.identifier == "walkingRoute" || layer.identifier == "currentDrivingRoute" {
                    self.mapView.style?.removeLayer(layer)
                }
                if self.polylineLayer != nil && (layer.identifier == "walkingRoute" || layer.identifier == "currentDrivingRoute") {
                    self.mapView.style?.removeLayer(layer)
                    self.polylineLayer = nil
                }
                if let lastAnnotation = self.mapView.annotations?.last, lastAnnotation.title == "ParkingUnder" {
                    self.mapView.removeAnnotation(lastAnnotation)
                }
                if let annotations = self.mapView.annotations {
                    for annotation in annotations {
                        if annotation.title == "ParkingUnder" {
                            self.mapView.removeAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
}
