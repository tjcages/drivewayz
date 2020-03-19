//
//  MBCurrentParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps
import Polyline

import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

protocol NavigationProtocol {
    func pushCheckController()
    func startBooking()
}

var shouldRefreshCurrentRoute: Bool = true
var shownCheckinMessage: Bool = false

extension MapKitViewController: NavigationProtocol {
    
    // Handle route navigation
    func startNavigation() {
        dimTabView(0.8) {
            if self.mainViewState == .parking { self.mainViewState = .none }
            startLoadingAnimation()
        }
        
        let controller = MBNavigationViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
//        controller.simulateLocation = true // SIMULATING NAVIGATION FOR TESTING PURPOSES
        present(controller, animated: false, completion: nil)
        
        guard let userLocation = locationManager.location, let lotLocation = ZoomEndCoordinate else { return }
    
        let origin = Waypoint(coordinate: userLocation.coordinate, name: "Current location")
        let destination = Waypoint(coordinate: lotLocation, name: "Parking")

        let options = NavigationRouteOptions(waypoints: [origin, destination])
        options.roadClassesToAvoid = .toll // NEED TO ADD OPTIONS FOR USER
 
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            
            controller.startLocation = userLocation

            controller.userRoute = route
            controller.instructionsBannerView.finalWaypoint = destination

            let destination = MGLPointAnnotation()
            destination.coordinate = route.shape!.coordinates.last!
            controller.destination = destination
            
            lightContentStatusBar()
        }
    }
    
    func pushCheckController() {
        let controller = AvailableCheckController()
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = self
        
        dimTabView {
            if let lot = selectedParkingLot, let duration = lot.walkingDuration {
                controller.subLabel.text = "Pay at kiosk • \(String(Int(duration))) min walk"
            }
            
            endLoadingAnimation()
            defaultContentStatusBar()
            self.delegate?.hideHamburger()
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func dimTabView(_ alpha: CGFloat = 0.4, completion: @escaping() -> ()) {
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = alpha
        }) { (success) in
            completion()
        }
    }
    
    func startBooking() {
        removeRouteLine()
        dimTabView(0) {}
        endLoadingAnimation()
        mainViewState = .currentBooking
        removeRouteLine()
        locatorButtonPressed(padding: nil)
        delegate?.bringHamburger()
        
        guard let location = locationManager.location else { return }
        if mainViewState == .currentBooking, let destinationCoor = ZoomStartCoordinate, let destinationPlacemark = searchingPlacemark, let lot = selectedParkingLot {
            let destination = CLLocation(latitude: destinationCoor.latitude, longitude: destinationCoor.longitude)
            calculateWalkingRoute(fromLocation: location, toLocation: destination) { (route) in
                // Remove all previous polylines or markers
                self.removeRouteLine()
                
                self.placeWalkingRoute(lot: lot, destinationPlacemark: destinationPlacemark)
                self.quickParkingView.isHidden = true
            }
        }
    }

}
