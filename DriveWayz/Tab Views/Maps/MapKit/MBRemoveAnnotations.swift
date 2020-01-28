//
//  MBRemoveAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

extension MapKitViewController {
    
    func removeRouteLine() {
        mapView.clear()
        mapBoxRoute = nil
        mapBoxWalkingRoute = nil
        routeUnderLine.path = nil
        routeLine.path = nil
        routeWalkingLine.path = nil
        routeWalkingUnderLine.path = nil
        
        routeUnderLine.removeFromSuperlayer()
        routeLine.removeFromSuperlayer()
        routeWalkingUnderLine.removeFromSuperlayer()
        routeWalkingLine.removeFromSuperlayer()
        routeStartPin.removeFromSuperview()
        routeParkingPin.removeFromSuperview()
        routeEndPin.removeFromSuperview()
    }

    func removeAllMapOverlays(shouldRefresh: Bool) {
        DestinationAnnotationLocation = nil
        TappedDestinationAnnotationLocation = nil
        surgeCheckedCity = nil
        surgeCheckedLocation = nil
        shouldShowOverlay = false
        
        quadStartCoordinate = nil
        quadEndCoordinate = nil
        ZoomStartCoordinate = nil
        ZoomEndCoordinate = nil
        
        shouldShowOverlay = false
        quickDurationView.alpha = 0
        quickParkingView.alpha = 0
        
        quickDurationView.isUserInteractionEnabled = true
        quickParkingView.isUserInteractionEnabled = true
        quickParkingView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        quickDurationView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        removeRouteLine()
        
        if let line = quadPolyline, let shadowLine = quadPolylineShadow {
            line.removeFromSuperlayer()
            shadowLine.removeFromSuperlayer()
        }
        
        if shouldRefresh == true {
            observeAllParking()
            if let userLocation = self.locationManager.location {
                let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
                mapView.camera = camera
            }
        } else {
            mapView.clear()
        }
    }
    
}
