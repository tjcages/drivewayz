//
//  MBNavigation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol handleRouteNavigation {
    func checkedIn()
    func closeCurrentBooking()
    func currentMessageRemoved()
    
    func lightContentStatusBar()
    func defaultContentStatusBar()
}

extension MapKitViewController: handleRouteNavigation {
    
    func currentMessageRemoved() {
        if currentBottomController.routeController.isHidden == false {
            currentBookingHeight = phoneHeight - 116 - 512
            UIView.animate(withDuration: animationIn) {
                self.fullBackgroundView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func checkedIn() {
        currentBookingState = .checkedIn
        UIView.animate(withDuration: animationIn) {
            self.mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: 202, right: horizontalPadding)
        }
    }
    
    func startCheckedIn() {
        currentBookingHeight = phoneHeight - 116 - 282
    }
    
    func currentHeightChange() {
        currentBottomHeightAnchor.constant = currentBookingHeight
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
//    func openCurrentParking(bookingId: String) {
//        BookedState = .currentlyBooked
//        removeAllMapOverlays(shouldRefresh: false)
//        delayWithSeconds(animationOut) {
////            self.removeAllMapOverlays(shouldRefresh: false)
//            self.mainViewState = .currentBooking
//            self.locatorButtonPressed(padding: 64)
//            self.defaultContentStatusBar()
//
//            self.view.bringSubviewToFront(self.currentBottomController.view)
//            self.view.bringSubviewToFront(self.currentDurationController.view)
//            delayWithSeconds(animationOut, completion: {
//                self.findCurrentRoute(key: bookingId)
//            })
//        }
//    }
//
//    func observeCurrentParking() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(userID)
//        ref.child("UpcomingReservations").observe(.childAdded) { (snapshot) in
//            BookedState = .reserved
//            UserDefaults.standard.set("reserved", forKey: "userBookingStatus")
//            UserDefaults.standard.synchronize()
//        }
//        ref.child("UpcomingReservations").observe(.childRemoved) { (snapshot) in
//            BookedState = .currentlyBooked
//            UserDefaults.standard.set("none", forKey: "userBookingStatus")
//            UserDefaults.standard.synchronize()
//        }
//        ref.child("CurrentBooking").observe(.childAdded) { (snapshot) in
//            self.mapView.clear()
//            BookedState = .currentlyBooked
//            UserDefaults.standard.set("currentlyBooked", forKey: "userBookingStatus")
//            UserDefaults.standard.synchronize()
//
//            self.view.bringSubviewToFront(self.currentBottomController.view)
//            self.view.bringSubviewToFront(self.currentDurationController.view)
//            let key = snapshot.key
//            self.findCurrentRoute(key: key)
//        }
//        ref.child("CurrentBooking").observe(.childRemoved) { (snapshot) in
//            self.removeAllMapOverlays(shouldRefresh: true)
//            delayWithSeconds(animationOut, completion: {
////                self.bringReviewBooking()
//                self.locatorButtonPressed(padding: nil)
//            })
//            UserDefaults.standard.set("none", forKey: "userBookingStatus")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    func findCurrentRoute(key: String) {
//        let ref = Database.database().reference().child("UserBookings").child(key)
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//                let booking = Bookings(dictionary: dictionary)
//                if let latitude = booking.parkingLat, let longitude = booking.parkingLong, let currentLocation = self.locationManager.location {
//                    let parking = CLLocation(latitude: latitude, longitude: longitude)
//                    if let checkedIn = booking.checkedIn, checkedIn {
//                        self.calculateRoute(fromLocation: currentLocation, toLocation: parking, identifier: .walking)
//                    } else {
//                        self.calculateRoute(fromLocation: currentLocation, toLocation: parking, identifier: .automobile)
//                    }
//                }
//            }
//        }
//    }
//
    @objc func currentViewIsScrolling(sender: UIPanGestureRecognizer) {
        let translation = -sender.translation(in: self.view).y
        let state = sender.state
        let percentage = translation/(phoneHeight/3)
        if state == .changed {
            if percentage >= 0 && percentage <= 1 && previousCurrentPercentage != 1.0 {
                changeScrollAmount(percentage: percentage)
            } else {
                if percentage <= 0.0 && percentage >= -0.3 {
                    changeScrollAmount(percentage: percentage)
                } else if self.currentBookingHeight <= (phoneHeight - 112 - 500) && percentage < -0.3 {
                    currentBookingHeight = phoneHeight - 112 - 282
                    mapView.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: 202, right: horizontalPadding)
                    return
                }
            }
        } else if state == .ended {
            if previousCurrentPercentage >= 0.25 {
                openCurrentBooking()
            } else {
                closeCurrentBooking()
            }
        }
    }

    func changeScrollAmount(percentage: CGFloat) {
        previousCurrentPercentage = percentage

        currentBottomHeightAnchor.constant = currentBookingHeight - currentBookingHeight * percentage
        durationLeftAnchor.constant = 16 - 16 * percentage
        durationRightAnchor.constant = -16 + 16 * percentage
        durationTopAnchor.constant = 8 - (8 + statusHeight) * percentage
        durationController.view.layer.cornerRadius = 4 - 4 * percentage

        fullBackgroundView.alpha = 0 + percentage
//        currentBottomController.detailsController.changeScrollAmount(percentage: percentage)
        self.view.layoutIfNeeded()
    }

    func openCurrentBooking() {
        currentBottomController.scrollView.isScrollEnabled = true
        previousCurrentPercentage = 1.0
        currentBottomHeightAnchor.constant = 0
        durationLeftAnchor.constant = 0
        durationRightAnchor.constant = 0
        durationTopAnchor.constant = -statusHeight

        delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 1
            self.currentDurationController.view.layer.cornerRadius = 0
            self.currentDurationController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        }) { (success) in
            if self.currentDurationController.view.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.currentDurationController.view.alpha = 1
                }
            }
        }
    }

    func closeCurrentBooking() {
        showHamburger = true
        previousCurrentPercentage = 0.0
        currentBottomHeightAnchor.constant = currentBookingHeight
        durationLeftAnchor.constant = 16
        durationRightAnchor.constant = -16
        durationTopAnchor.constant = 8

        delegate?.defaultContentStatusBar()
//        currentBottomController.detailsController.closeCurrentBooking()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.currentDurationController.view.layer.cornerRadius = 4
            if self.currentBookingHeight <= (phoneHeight - 112 - 500) {
                self.currentDurationController.view.alpha = 0
                self.currentDurationController.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.scrollView.isScrollEnabled = false
        }
    }

    @objc func currentDurationTapped() {
        if previousCurrentPercentage == 1.0 {
            closeCurrentBooking()
        } else {
            openCurrentBooking()
        }
    }

    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }

    func defaultContentStatusBar() {
        self.delegate?.defaultContentStatusBar()
//        self.delegate?.bringHamburger()
    }
    
}

