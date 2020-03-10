//
//  MBNavigationFinalViews.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/25/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import Mapbox
import CoreLocation
import MapboxDirections

extension MBNavigationViewController: NavigationServiceDelegate {
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        if let destination = instructionsBannerView.finalWaypoint {
            let point = mapView.convert(destination.coordinate, toPointTo: mapView)
            
            UIView.animateOut(withDuration: animationOut, animations: {
                self.routeParkingPin.center = CGPoint(x: point.x, y: point.y - 32)
                self.followQuickEnd(center: self.routeParkingPin.center)
                
                if self.routeParkingPin.alpha != 1 {
                    self.routeParkingPin.alpha = 1
                }
                if self.instructionsBannerView.isFinalDestination, self.navigationView.alpha != 1 {
                    self.navigationView.alpha = 1
                }
            }) { (success) in
                //
            }
        } else {
            if navigationView.alpha != 0 {
                UIView.animateOut(withDuration: animationOut, animations: {
                    self.navigationView.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    func followQuickEnd(center: CGPoint) {
        var point: CGPoint = center
        
        if center.x >= phoneWidth/2 {
            point.x -= navigationView.bounds.width/2 + 32
        } else {
            point.x += navigationView.bounds.width/2 + 32
        }
        let height = (phoneHeight - parkingNormalHeight)/2
        if center.y >= height {
            point.y -= 72
        } else {
            point.y += 72
        }
        
        self.navigationView.center = point
    }
    
    @objc func pushCheckController() {
        showDestinationCheck = true
        instructionsBannerView.hideInstructionBanner()
        bottomView.hideContainer()
        modalTransitionStyle = .crossDissolve
        
        UIView.animateOut(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.4
        }) { (success) in
            defaultContentStatusBar()
            self.delegate?.pushCheckController()
            self.cancelButtonPressed()
        }
    }
    
    func navigationService(_ service: NavigationService, willArriveAt waypoint: Waypoint, after remainingTimeInterval: TimeInterval, distance: CLLocationDistance) {
        if distance <= 35 { // Guess at how far we should still assume that they found the parking lot
            if destinationTimer == nil {
                showTripView()
                destinationTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(pushCheckController), userInfo: nil, repeats: false)
            }
        } else {
            destinationTimer?.invalidate()
            destinationTimer = nil
        }
    }
    
}
