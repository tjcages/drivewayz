//
//  MBRemoveAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox

extension MapKitViewController {

    func removeAllMapOverlays(shouldRefresh: Bool) {
        DestinationAnnotationLocation = nil
        TappedDestinationAnnotationLocation = nil
        surgeCheckedCity = nil
        surgeCheckedLocation = nil
        shouldShowOverlay = false
        quickDestinationController.view.alpha = 0
        quickParkingController.view.alpha = 0
        
        quadStartCoordinate = nil
        quadEndCoordinate = nil
        shouldShowOverlay = false
        quickDestinationController.view.alpha = 0
        quickParkingController.view.alpha = 0
        
        quickDestinationController.view.alpha = 0
        quickParkingController.view.alpha = 0
        quickDestinationController.view.isUserInteractionEnabled = true
        quickParkingController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        quickDestinationController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        removeRouteLine()
        
        if let line = quadPolyline, let shadowLine = quadPolylineShadow {
            line.removeFromSuperlayer()
            shadowLine.removeFromSuperlayer()
        }
        
        if shouldRefresh == true {
            observeAllParking()
            locatorButtonPressed(padding: nil)
        } else {
            mapView.clear()
        }
    }
    
}
