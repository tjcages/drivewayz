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

enum CurrentBookingState {
    case walking
    case driving
    case checkedIn
    case none
}

var shouldRefreshCurrentRoute: Bool = true
var shownCheckinMessage: Bool = false

extension MapKitViewController {
    
    func closeToPark() {
        if !shownCheckinMessage {
            currentBottomController.closeToPark()
            currentBookingHeight = phoneHeight - 116 - 572
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseIn, animations: {
                shownCheckinMessage = true
                self.currentBottomController.messageController.isHidden = false
                self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: 382, right: horizontalPadding)
                self.currentDurationController.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.currentDurationController.view.alpha = 0
                self.fullBackgroundView.alpha = 0.4
                self.currentBottomController.stackView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }) { (success) in
                self.currentBottomController.routeController.hideExit()
            }
        }
    }
    
    func monitorBookingState() {
        // Determine what should display on the map based on the current booking state
        switch currentBookingState {
        case .none:
            startCurrent()
        case .walking:
            return
        case .checkedIn:
            startCheckedIn()
        case .driving:
            startCurrentDriving()
        }
    }
    
    func startCurrentBooking() {
        removeAllMapOverlays(shouldRefresh: false)
        
        // Set the state to currently driving
        mainViewState = .currentBooking
        currentBookingState = .driving
        
        mapView.settings.tiltGestures = true
        mapView.settings.rotateGestures = true
        
        if let userLocation = self.locationManager.location {
            // Zoom halfway to user location
            let zoom = mapZoomLevel + (mapTrackingLevel - mapZoomLevel)/1.2
            let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: zoom)
            
            // Animate in to user location
            CATransaction.begin()
            CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
            mapView.animate(to: camera)
            CATransaction.commit()
            
            // Change to now follow the user with a heading
            delayWithSeconds(2) {
                userTracking = .followWithHeading
            }
        }
    }
    
    func startCurrentDriving() {
        if let userLocation = self.locationManager.location {
            drawDrivingRoute(fromLocation: userLocation, toLocation: hostLocation)
            
            if quickDurationView.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.quickDurationView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.quickDurationView.alpha = 1
                }
            }
        }
    }
    
    func drawDrivingRoute(fromLocation: CLLocation, toLocation: CLLocation) {
        if shouldRefreshCurrentRoute {
            // Monitor the refresh rate of the current route -- Currently set to 3 seconds
            shouldRefreshCurrentRoute = false
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(monitorRouteTimer), userInfo: nil, repeats: false)
            
            ZoomStartCoordinate = fromLocation.coordinate
            ZoomEndCoordinate = toLocation.coordinate
        
            let source = CLLocationCoordinate2D(latitude: fromLocation.coordinate.latitude, longitude: fromLocation.coordinate.longitude)
            let destination = CLLocationCoordinate2D(latitude: toLocation.coordinate.latitude, longitude: toLocation.coordinate.longitude)
            
            let request: MKDirections.Request = MKDirections.Request()
            request.source  = MKMapItem(placemark: MKPlacemark(coordinate: source))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                guard let routeResponse = response?.routes, let route = routeResponse.first else { return }
                
                guard let routeResponses = response else { return }
                let polylines = self.googlePolylines(from: routeResponses)
                
                self.removeRouteLine()
                self.showCurrentRoute(polylines: polylines)
                
                let minute = route.expectedTravelTime / 60
                if minute.rounded() <= 0.5 {
                    self.closeToPark()
                }
                self.setupQuickController(minute: minute, identifier: .automobile)
                DrivingTime = minute
                
                if !self.mapView.subviews.contains(self.quickDurationView) {
                    self.mapView.addSubview(self.quickDurationView)
                }
                if !self.mapView.subviews.contains(routeParkingPin) {
                    self.mapView.addSubview(routeParkingPin)
                }
                
                self.layCurrentMarkers()
            }
        }
    }
    
    func layCurrentMarkers() {
        if let startCoor = ZoomStartCoordinate, let endCoor = ZoomEndCoordinate {
            let start = mapView.projection.point(for: startCoor)
            let end = mapView.projection.point(for: endCoor)
            routeStartPin.center = CGPoint(x: start.x, y: start.y)
            routeParkingPin.center = CGPoint(x: end.x, y: end.y - 26)
        }
        followQuickEnd(center: routeParkingPin.center)
    }
    
    func showCurrentRoute(polylines: [GMSPolyline]) {
        if let polyline = polylines.first {
            polyline.strokeColor = Theme.BLACK
            polyline.geodesic = true
            polyline.strokeWidth = 4
            polyline.map = mapView
        }
    }
    
    private func googlePolylines(from response: MKDirections.Response) -> [GMSPolyline] {
        let polylines: [GMSPolyline] = response.routes.map({ route in
            var coordinates = [CLLocationCoordinate2D](
                repeating: kCLLocationCoordinate2DInvalid,
                count: route.polyline.pointCount
            )
            route.polyline.getCoordinates(
                &coordinates,
                range: NSRange(location: 0, length: route.polyline.pointCount)
            )
            let polyline = Polyline(coordinates: coordinates)
            let encodedPolyline: String = polyline.encodedPolyline
            let path = GMSPath(fromEncodedPath: encodedPolyline)
            return GMSPolyline(path: path)
        })
        return polylines
    }
    
    @objc func monitorRouteTimer() {
        timer = nil
        shouldRefreshCurrentRoute = true
    }
    
//    func setupCurrentViews() {
//
//        self.view.addSubview(reviewBookingController.view)
//        reviewBookingTopAnchor = reviewBookingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
//            reviewBookingTopAnchor.isActive = true
//        reviewBookingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        reviewBookingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        reviewBookingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
//
//        reviewBookingController.informationButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
//        reviewBookingController.appButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
//        reviewBookingController.refundButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
//        reviewBookingController.otherButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
//
//    }
    
//    func bringReviewBooking() {
//        reviewBookingController.spotImageView.image = currentBottomController.detailsController.spotIcon.image
//        reviewBookingController.currentParking = currentBottomController.currentParking
//        reviewBookingTopAnchor.constant = 0
////        self.view.bringSubviewToFront(fullBackgroundView)
//        view.bringSubviewToFront(reviewBookingController.view)
//        delegate?.hideHamburger()
//        UIView.animate(withDuration: animationOut) {
//            self.reviewBookingController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            self.reviewBookingController.view.alpha = 1
//            self.fullBackgroundView.alpha = 0.8
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    @objc func reviewOptionsPressed(sender: UIButton) {
//        var contactText = ""
//        if sender == reviewBookingController.informationButton {
//            contactText = "The parking space information was incorrect"
//        } else if sender == reviewBookingController.appButton {
//            contactText = "The app did not work correctly"
//        } else if sender == reviewBookingController.refundButton {
//            contactText = "I need a refund for my recent booking"
//        } else if sender == reviewBookingController.otherButton {
//            contactText = "Other concern"
//        }
//        let controller = UserContactViewController()
//        controller.context = "Review"
//        controller.informationLabel.text = contactText
//        self.present(controller, animated: true, completion: nil)
//    }
//
//    func bringContactController(contactText: String) {
//        let controller = UserContactViewController()
//        controller.context = "Booking"
//        controller.informationLabel.text = contactText
//        self.present(controller, animated: true, completion: nil)
//    }
//
//    @objc func reviewOptionsDismissed() {
//        UIView.animate(withDuration: animationIn, animations: {
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            UIView.animate(withDuration: animationIn, animations: {
//                if self.reviewBookingController.view.alpha == 1 {
//                    self.reviewBookingController.view.alpha = 0
//                    self.reviewBookingController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//                }
//            }, completion: { (success) in
//                self.mainViewState = .mainBar
//                self.view.bringSubviewToFront(self.mainBarController.view)
//                if self.mainBarBottomAnchor.constant == phoneHeight - mainBarNormalHeight {
//                    self.fullBackgroundView.alpha = 0
//                    self.delegate?.bringHamburger()
//                    self.delegate?.defaultContentStatusBar()
//                } else {
//                    self.delegate?.lightContentStatusBar()
//                }
//            })
//        }
//    }
//
//    func openNavigation(success: Bool, booking: Bookings) {
//        let navigation = NavigationMapBox()
//        navigation.currentBooking = booking
//        navigation.delegate = self
//        navigation.modalPresentationStyle = .overFullScreen
//        navigation.modalTransitionStyle = .crossDissolve
//        self.present(navigation, animated: true) {
////            if let image = self.confirmPaymentController.currentParkingImage, let time = self.confirmPaymentController.totalTime, success {
////                navigation.openCurrentBooking(image: image, time: time)
////            }
//            if !success {
//                self.closeCurrentBooking()
//            }
//        }
//    }
//
//    func expandCheckmark(current: Bool, booking: Bookings) {
//        if current {
//            openNavigation(success: true, booking: booking)
//        } else {
//            let controller = SuccessfulPurchaseViewController()
//            if let totalTime = currentTotalTime {
//                controller.changeDates(totalTime: totalTime)
//            }
////            controller.spotIcon.image = self.confirmPaymentController.currentParkingImage
//            controller.loadingActivity.startAnimating()
//            controller.modalTransitionStyle = .crossDissolve
//            controller.modalPresentationStyle = .overFullScreen
//            self.present(controller, animated: true) {
//                controller.animateSuccess()
//                delayWithSeconds(3) {
//                    controller.closeSuccess()
//                    delayWithSeconds(animationIn, completion: {
//                        self.dismiss(animated: true, completion: {
//                            self.parkingHidden(showMainBar: true)
//                        })
//                    })
//                }
//            }
//        }
//    }
    
//    func confirmPurchasePressed(booking: Bookings) {
//        mainViewState = .none
//        self.quickCouponController.view.alpha = 0
//        self.removeAllHostLocations()
//        self.currentUserBooking = booking
//    }
    
//    func hideCurrentParking() {
//        self.removeAllMapOverlays(shouldRefresh: true)
//        mainViewState = .none
//        UIView.animate(withDuration: animationOut, animations: {
//            self.fullBackgroundView.alpha = 0
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            if let userLocation = self.locationManager.location {
//                let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: 12.0)
//                self.mapView.animate(to: camera)
//            }
//        }
//    }
//
//    func setDefaultStatusBar() {
//        self.delegate?.defaultContentStatusBar()
//    }
//
//    func setLightStatusBar() {
//        self.delegate?.lightContentStatusBar()
//    }

}

func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
    let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
    let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

    let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
    let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

    let dLon = lon2 - lon1

    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)

    return radiansToDegrees(radians: radiansBearing)
}
