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
        mapBoxRoute = nil
        mapBoxWalkingRoute = nil
        routeUnderLine.path = nil
        routeLine.path = nil
        routeWalkingLine.path = nil
        routeWalkingUnderLine.path = nil
        
        quadStartCoordinate = nil
        quadEndCoordinate = nil
        
        routeUnderLine.removeFromSuperlayer()
        routeLine.removeFromSuperlayer()
        routeWalkingUnderLine.removeFromSuperlayer()
        routeWalkingLine.removeFromSuperlayer()
        routeStartPin.removeFromSuperview()
        routeEndPin.removeFromSuperview()
    }

    func removeAllMapOverlays(shouldRefresh: Bool) {
        firstSpotView?.removeFromSuperview()
        secondSpotView?.removeFromSuperview()
        thirdSpotView?.removeFromSuperview()
        
        firstSpotView = nil
        secondSpotView = nil
        thirdSpotView = nil
        
        firstLocation = nil
        secondLocation = nil
        thirdLocation = nil
        
        ZoomStartCoordinate = nil
        ZoomEndCoordinate = nil
        
        userEnteredDestination = true
        quickDurationView.alpha = 0
        quickParkingView.alpha = 0
        
        quickDurationView.isUserInteractionEnabled = true
        quickParkingView.isUserInteractionEnabled = true
        quickParkingView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        quickDurationView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        quickParkingView.isHidden = false
        
        removeRouteLine()
        
        if let line = quadPolyline, let shadowLine = quadPolylineShadow {
            line.removeFromSuperlayer()
            shadowLine.removeFromSuperlayer()
        }
        
        if shouldRefresh == true {
            searchingPlacemark = nil
            shouldShowLots = true
            
            guard let location = self.locationManager.location else {
                return
            }
            self.determineCity(location: location)
            
            if let userLocation = self.locationManager.location {
                let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
                mapView.camera = camera
            }
        } else {
            mapView.clear()
        }
    }
    
}
