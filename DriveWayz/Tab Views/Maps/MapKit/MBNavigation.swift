//
//  MBNavigation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

protocol handleRouteNavigation {
    func beginRouteNavigation()
    func userHasCurrentParking()
    func checkDismissStatusBar()
    func closeCurrentBooking()
    func lightContentStatusBar()
    func defaultContentStatusBar()
}

protocol handleCurrentNavigationViews {
    func minimizeBottomView()
    func beginRouteNavigation()
    func closeCurrentBooking()
}

var isCurrentlyBooked: Bool = false
var destinationRoute: Route?

var currentSpotController: CurrentSpotViewController = {
    let controller = CurrentSpotViewController()
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    //        controller.delegate = self
    
    return controller
}()

var navigationControllerView: NavigationViewController?

extension MapKitViewController: NavigationViewControllerDelegate, handleRouteNavigation, handleCurrentNavigationViews {
    
    func setupNavigationControllers() {
        
        self.view.addSubview(currentSearchLocation)
        self.view.addSubview(currentTopController.view)
        currentTopTopAnchor = currentTopController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -200)
            currentTopTopAnchor.isActive = true
        currentTopController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentTopController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentTopController.view.heightAnchor.constraint(equalToConstant: 172).isActive = true
        
        self.view.addSubview(currentBottomController.view)
        currentBottomBottomAnchor = currentBottomController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
            currentBottomBottomAnchor.isActive = true
        currentBottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentBottomController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentBottomHeightAnchor = currentBottomController.view.heightAnchor.constraint(equalToConstant: 130)
            currentBottomHeightAnchor.isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(bottomPanned(sender:)))
        currentBottomController.view.addGestureRecognizer(pan)
        
        currentSearchLocation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        currentSearchLocation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentSearchLocation.widthAnchor.constraint(equalTo: currentSearchLocation.heightAnchor).isActive = true
        currentSearchLocation.bottomAnchor.constraint(equalTo: currentBottomController.view.topAnchor, constant: -16).isActive = true
        
        holdNavController.delegate = self
        mapView.addSubview(holdNavController.view)
        holdNavController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        holdNavController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        holdNavController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        holdNavController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func drawCurrentParkingPolyline() {
        self.removeAllMapOverlays(shouldRefresh: false)
        for index in 0...1 {
            if let finalDestination = finalDestinationCoordinate, let finalParking = FinalAnnotationLocation, let currentLocation = self.locationManager.location?.coordinate {
                if index == 0 {
                    let directions = Directions.shared
                    let waypoints = [
                        Waypoint(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude), name: "Start"),
                        Waypoint(coordinate: CLLocationCoordinate2D(latitude: finalParking.latitude, longitude: finalParking.longitude), name: "Destination"),
                    ]
                    let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
                    options.includesSteps = true
                    
                    _ = directions.calculate(options) { (waypoints, routes, error) in
                        guard error == nil else {
                            print("Error calculating directions: \(error!)")
                            return
                        }
                        if let route = routes?.first {
                            //                    let minute = route.expectedTravelTime / 60
                            self.holdNavController.view.alpha = 1
                            self.holdNavController.setupNavigation(route: route)
                        }
                    }
                } else if index == 1 {
                    let directions = Directions.shared
                    let waypoints = [
                        Waypoint(coordinate: CLLocationCoordinate2D(latitude: finalParking.latitude, longitude: finalParking.longitude), name: "Start"),
                        Waypoint(coordinate: CLLocationCoordinate2D(latitude: finalDestination.latitude, longitude: finalDestination.longitude), name: "Destination"),
                    ]
                    let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
                    options.includesSteps = true
                    
                    _ = directions.calculate(options) { (waypoints, routes, error) in
                        guard error == nil else {
                            print("Error calculating directions: \(error!)")
                            return
                        }
                        if let route = routes?.first {
                            destinationRoute = route
                        }
                    }
                }
            }
        }
    }
    
    @objc func bottomPanned(sender: UIPanGestureRecognizer) {
        let position = -sender.translation(in: self.view).y
        let highestPosition = phoneHeight - 162
        if sender.state == .changed {
            if (self.currentBottomHeightAnchor.constant < (phoneHeight - 142) && position != 0 && self.currentBottomController.scrollView.isScrollEnabled == false) && self.currentBottomHeightAnchor.constant >= 120 {
                if position >= -(highestPosition - 200) && position <= (highestPosition - 300) {
                    if self.currentBottomHeightAnchor.constant >= 120 && self.currentBottomHeightAnchor.constant <= phoneHeight - 172 {
                        let percent = position/(highestPosition - 200)
                        UIView.animate(withDuration: 0.05) {
                            self.currentBottomHeightAnchor.constant = self.previousAnchor + highestPosition * percent
                            self.view.layoutIfNeeded()
                        }
                    } else {
                        self.previousAnchor = 130
                        UIView.animate(withDuration: animationIn) {
                            self.currentBottomHeightAnchor.constant = 130
                            self.view.layoutIfNeeded()
                        }
                        return
                    }
                }
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: animationOut) {
                if self.currentBottomHeightAnchor.constant >= highestPosition - 240 && self.currentBottomHeightAnchor.constant <= phoneHeight - 142 {
                    self.previousAnchor = highestPosition
                    self.currentBottomHeightAnchor.constant = highestPosition
                    self.currentBottomController.scrollView.isScrollEnabled = true
                } else if self.currentBottomHeightAnchor.constant >= phoneHeight - 200 {
                    
                } else {
                    if self.currentBottomController.scrollView.isScrollEnabled == false {
                        self.previousAnchor = 130
                        self.currentBottomHeightAnchor.constant = 130
                    }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func closeCurrentBooking() {
        holdNavController.endNavigation()
        holdNavController.view.alpha = 0
        
        self.currentBottomController.scrollView.setContentOffset(.zero, animated: true)
        self.minimizeBottomView()
        self.parkingBackButton.removeTarget(nil, action: nil, for: .allEvents)
        self.parkingBackButton.addTarget(self, action: #selector(parkingHidden), for: .touchUpInside)
        UIView.animate(withDuration: animationOut, animations: {
            self.currentBottomBottomAnchor.constant = 200
            self.currentTopTopAnchor.constant = -200
            self.parkingBackButtonConfirmAnchor.isActive = false
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
            self.delegate?.bringHamburger()
            self.eventsControllerHidden()
            UIView.animate(withDuration: animationOut, animations: {
                self.view.layoutIfNeeded()
            })
            self.parkingHidden()
            self.mapView.resetNorth()
            delayWithSeconds(animationOut, completion: {
                self.removeAllMapOverlays(shouldRefresh: true)
//                self.mainBarController.shouldRefresh = true
                self.mapView.allowsRotating = false
            })
        }
    }
    
    func openCurrentInformation() {
        self.removeAllMapOverlays(shouldRefresh: false)
        self.mapView.userTrackingMode = .followWithHeading
        self.mapView.allowsRotating = true
        UIView.animate(withDuration: animationOut, animations: {
            self.confirmControllerBottomAnchor.constant = 380
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.currentSearchLocation.alpha = 1
                self.currentBottomBottomAnchor.constant = 0
                self.currentTopTopAnchor.constant = 0
                self.previousAnchor = 130
                self.currentBottomHeightAnchor.constant = 130
                self.view.layoutIfNeeded()
            }) { (success) in
                delayWithSeconds(0.2, completion: {
                    self.delegate?.hideHamburger()
                    self.delegate?.lightContentStatusBar()
                    self.takeAwayEvents()
                    self.drawCurrentParkingPolyline()
                })
                self.currentBottomController.scrollView.isScrollEnabled = false
            }
        }
    }
    
    func minimizeBottomView() {
        UIView.animate(withDuration: animationOut, animations: {
            self.previousAnchor = 130
            self.currentBottomHeightAnchor.constant = 130
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.scrollView.isScrollEnabled = false
        }
    }
    
    func beginRouteNavigation() {
        if let route = destinationRoute {
            self.holdNavController.setupNavigation(route: route)
        }
        UIView.animate(withDuration: animationIn) {
            self.holdNavController.view.alpha = 1
        }
//        if let route = finalParkingRoute {
//            holdNavController.delegate = self
//            mapView.addSubview(holdNavController.view)
//            holdNavController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//            holdNavController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//            holdNavController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//            holdNavController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//            holdNavController.setupNavigation(route: route)
//            self.delegate?.lightContentStatusBar()
//        }
    }
    
    @objc func currentLocatorButtonPressed() {
        self.mapView.userTrackingMode = .followWithCourse
        delayWithSeconds(animationOut * 2, completion: {
            self.mapView.setZoomLevel(15, animated: true)
        })
    }
    
    func checkDismissStatusBar() {
        switch solar {
        case .day:
            self.delegate?.defaultContentStatusBar()
        case .night:
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    func defaultContentStatusBar() {
        self.delegate?.defaultContentStatusBar()
    }
    
}

class HoldNavViewController: UIViewController {
    
    private var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    var delegate: handleRouteNavigation?
    var didCancel: Bool = false
    
    func setupNavigation(route: Route) {
//        let controller = NavigationViewController(for: route, styles: [CustomDayStyle(), CustomNightStyle()])
        let controller = NavigationViewController(for: route, styles: [CustomDayStyle()])
        controller.showsReportFeedback = false
        controller.showsEndOfRouteFeedback = false
        detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.automaticallyAdjustsStyleForTimeOfDay = false
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        controller.delegate = self
        
        navigationControllerView = controller
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        navigationController?.pushViewController(controller, animated: true)
//        present(navigationControllerView!, animated: true) {
//
//        }
    }
    
}

extension HoldNavViewController: NavigationViewControllerDelegate {
    
    func navigationViewController(_ navigationViewController: NavigationViewController, willArriveAt waypoint: Waypoint, after remainingTimeInterval: TimeInterval, distance: CLLocationDistance) {
        if distance <= 36 {
            print("time: \(remainingTimeInterval)")
            print("distance: \(distance)")
            if self.didCancel == false {
                if let controller = navigationControllerView {
                    controller.navigationService.endNavigation(feedback: .none)
                    self.didCancel = true
                }
            }
        }
    }
    
    func endNavigation() {
        UIView.animate(withDuration: animationOut, animations: {
            self.view.alpha = 0
        }) { (success) in
            if let controller = navigationControllerView {
                controller.navigationService.endNavigation(feedback: .none)
                self.navigationController?.popViewController(animated: true)
                controller.willMove(toParent: nil)
                controller.view.removeFromSuperview()
                controller.removeFromParent()
                self.didCancel = false
            }
        }
    }
    
    func beginWalkingDestination() {
        ////
    }
    
}
