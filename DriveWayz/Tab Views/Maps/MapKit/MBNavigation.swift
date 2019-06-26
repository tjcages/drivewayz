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
    func checkDismissStatusBar()
    func closeCurrentBooking()
    func lightContentStatusBar()
    func defaultContentStatusBar()
}

protocol handleCurrentNavigationViews {
    func maximizeBottomView()
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
        
        self.view.addSubview(currentBottomController.view)
        currentBottomController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        currentBottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentBottomController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentBottomHeightAnchor = currentBottomController.view.heightAnchor.constraint(equalToConstant: 0)
            currentBottomHeightAnchor.isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(bottomPanned(sender:)))
        currentBottomController.view.addGestureRecognizer(pan)
        
        self.view.addSubview(currentSearchLocation)
        currentSearchLocation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        currentSearchLocation.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        if let booking = self.currentUserBooking, let parkingLat = booking.parkingLat, let parkingLong = booking.parkingLong, let destinationLat = booking.destinationLat, let destinationLong = booking.destinationLong {
            let parkingCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(parkingLat), longitude: CLLocationDegrees(parkingLong))
            let destinationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(destinationLat), longitude: CLLocationDegrees(destinationLong))
            if let currentLocation = self.locationManager.location?.coordinate {
                let directions = Directions.shared
                let waypoints = [
                    Waypoint(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude), name: "Start"),
                    Waypoint(coordinate: CLLocationCoordinate2D(latitude: parkingCoordinate.latitude, longitude: parkingCoordinate.longitude), name: "Destination"),
                ]
                let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
                options.includesSteps = true
                
                _ = directions.calculate(options) { (waypoints, routes, error) in
                    guard error == nil else {
                        print("Error calculating directions: \(error!)")
                        return
                    }
                    if let route = routes?.first {
                        
                        var routeCoordinates = route.coordinates!
                        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                        routeLine.title = "ParkingUnder"
                        self.mapView.addAnnotation(routeLine)
//                        let routeLine2 = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
//                        routeLine2.title = "ParkingOver"
//                        self.mapView.addAnnotation(routeLine2)
                        self.parkingCoordinates = route.coordinates!
                        self.addPolyline(to: self.mapView.style!)
                        self.mapView.userTrackingMode = .followWithCourse
                        
                        let annotation = MGLPointAnnotation()
                        annotation.coordinate = parkingCoordinate
                        self.mapView.addAnnotation(annotation)
                        
                        self.currentBottomHeightAnchor.constant = 354
                        UIView.animate(withDuration: animationOut, animations: {
                            self.view.layoutIfNeeded()
                        })
                        //                    let minute = route.expectedTravelTime / 60
                        //                            self.holdNavController.view.alpha = 1
                        //                            self.holdNavController.setupNavigation(route: route)
                    }
                }
            }
        }
    }
    
    @objc func bottomPanned(sender: UIPanGestureRecognizer) {
        let position = -sender.translation(in: self.view).y
        let highestHeight = phoneHeight - 150
        let lowestHeight: CGFloat = 354
        if sender.state == .changed {
            if (self.currentBottomHeightAnchor.constant >= lowestHeight - 40 && self.currentBottomHeightAnchor.constant <= highestHeight + 40) || (self.mainBarHighest == true && self.currentBottomHeightAnchor.constant <= 772) {
                let difference = position - self.mainBarPreviousPosition
                self.currentBottomHeightAnchor.constant = self.currentBottomHeightAnchor.constant + difference
                let percent = (self.currentBottomHeightAnchor.constant - lowestHeight)/highestHeight
                self.fullBackgroundView.alpha = 1.2 * percent
                if percent >= 0.2 {
                    self.currentSearchLocation.alpha = 0
                    self.delegate?.lightContentStatusBar()
                    self.delegate?.hideHamburger()
                } else {
                    self.delegate?.defaultContentStatusBar()
                }
            }
        } else if sender.state == .ended {
            let difference = position - self.mainBarPreviousPosition
            if (self.currentBottomHeightAnchor.constant < highestHeight && self.mainBarHighest == false) || self.currentBottomHeightAnchor.constant <= highestHeight {
                if self.currentBottomHeightAnchor.constant >= phoneHeight/3 && difference < 0 && self.currentBottomHeightAnchor.constant <= phoneHeight * 2/3 {
                    self.currentBottomHeightAnchor.constant = lowestHeight
                    UIView.animate(withDuration: animationOut, animations: {
                        self.fullBackgroundView.alpha = 0
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        self.mainBarHighest = false
                        self.delegate?.bringHamburger()
                        self.delegate?.defaultContentStatusBar()
                    }
                } else if self.currentBottomHeightAnchor.constant >= phoneHeight/3 && difference >= 0 {
                    if self.mainBarHighest == true && self.currentBottomHeightAnchor.constant < highestHeight - 40 {
                        self.currentBottomHeightAnchor.constant = lowestHeight
                        UIView.animate(withDuration: animationIn, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                        }
                    } else {
                        self.currentBottomHeightAnchor.constant = highestHeight
                        self.delegate?.lightContentStatusBar()
                        self.delegate?.hideHamburger()
                        UIView.animate(withDuration: animationIn, animations: {
                            self.fullBackgroundView.alpha = 0.7
                            self.currentSearchLocation.alpha = 0
                            self.currentSearchLocation.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.currentBottomController.scrollView.isScrollEnabled = false
                            self.mainBarHighest = true
                        }
                    }
                } else {
                    self.currentBottomHeightAnchor.constant = lowestHeight
                    UIView.animate(withDuration: animationOut, animations: {
                        self.fullBackgroundView.alpha = 0
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        self.mainBarHighest = false
                        self.delegate?.bringHamburger()
                        self.delegate?.defaultContentStatusBar()
                    }
                }
            } else {
                self.currentBottomHeightAnchor.constant = phoneHeight - statusHeight
                UIView.animate(withDuration: animationIn, animations: {
                    self.fullBackgroundView.alpha = 0.9
                    self.currentSearchLocation.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.currentBottomController.scrollView.isScrollEnabled = true
                }
            }
        }
        self.mainBarPreviousPosition = position
    }
    
    func closeCurrentBooking() {
        holdNavController.endNavigation()
        holdNavController.view.alpha = 0
        
        self.mapView.resetNorth()
        self.hideCurrentParking()
        self.currentBottomController.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationOut, animations: {
            self.parkingBackButtonConfirmAnchor.isActive = false
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
//            self.delegate?.bringHamburger()
            self.bringReviewBooking()
            self.removeAllMapOverlays(shouldRefresh: true)
            delayWithSeconds(2, completion: {
                self.removeAllMapOverlays(shouldRefresh: true)
            })
        }
    }
    
    func openCurrentInformation() {
        self.removeAllMapOverlays(shouldRefresh: false)
        self.mapView.userTrackingMode = .followWithHeading
        self.mapView.allowsRotating = true
        UIView.animate(withDuration: animationOut, animations: {
            self.currentSearchLocation.alpha = 1
            self.previousAnchor = 354
            self.currentBottomHeightAnchor.constant = 354
            self.mainBarTopAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.scrollView.isScrollEnabled = false
            delayWithSeconds(animationOut * 3, completion: {
                self.drawCurrentParkingPolyline()
            })
        }
    }
    
    func maximizeBottomView() {
        let highestHeight = phoneHeight - 150
        self.currentBottomHeightAnchor.constant = highestHeight
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideHamburger()
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 0.7
            self.currentSearchLocation.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.scrollView.isScrollEnabled = false
            self.mainBarHighest = true
        }
    }
    
    func minimizeBottomView() {
        UIView.animate(withDuration: animationOut, animations: {
            self.previousAnchor = 354
            self.currentBottomHeightAnchor.constant = 354
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
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
        self.currentSearchLocation.alpha = 0
        if let location: CLLocationCoordinate2D = mapView.userLocation?.coordinate {
            let camera = MGLMapCamera(lookingAtCenter: location, altitude: CLLocationDistance(exactly: 7200)!, pitch: 0, heading: CLLocationDirection(0))
            self.mapView.setCamera(camera, withDuration: animationOut * 2, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight*3/4 - 60, right: phoneWidth/2), completionHandler: nil)
            delayWithSeconds(animationOut * 2) {
                self.mapView.userTrackingMode = .followWithCourse
            }
        }
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
        let controller = NavigationViewController(for: route)
//        let controller = NavigationViewController(for: route, styles: [CustomDayStyle()])
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
