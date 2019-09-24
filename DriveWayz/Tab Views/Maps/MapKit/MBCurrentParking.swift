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
    func openCurrentParking(bookingId: String)
    func lightContentStatusBar()
    func defaultContentStatusBar()
}

extension MapKitViewController: handleRouteNavigation {
    
    func openCurrentParking(bookingId: String) {
        BookedState = .currentlyBooked
        removeAllMapOverlays(shouldRefresh: false)
        delayWithSeconds(animationOut) {
//            self.removeAllMapOverlays(shouldRefresh: false)
            self.mainViewState = .currentBooking
            self.locatorButtonPressed()
            self.defaultContentStatusBar()
            
            self.view.bringSubviewToFront(self.endBookingController.view)
            self.view.bringSubviewToFront(self.currentBottomController.view)
            self.view.bringSubviewToFront(self.currentDurationController.view)
            delayWithSeconds(animationOut, completion: {
                self.findCurrentRoute(key: bookingId)
            })
        }
    }
    
    func observeCurrentParking() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.child("UpcomingReservations").observe(.childAdded) { (snapshot) in
            BookedState = .reserved
            UserDefaults.standard.set("reserved", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
        ref.child("UpcomingReservations").observe(.childRemoved) { (snapshot) in
            BookedState = .currentlyBooked
            UserDefaults.standard.set("none", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
        ref.child("CurrentBooking").observe(.childAdded) { (snapshot) in
            self.removePolylineAnnotations()
            BookedState = .currentlyBooked
            UserDefaults.standard.set("currentlyBooked", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
            
            self.view.bringSubviewToFront(self.endBookingController.view)
            self.view.bringSubviewToFront(self.currentBottomController.view)
            self.view.bringSubviewToFront(self.currentDurationController.view)
            let key = snapshot.key
            self.findCurrentRoute(key: key)
        }
        ref.child("CurrentBooking").observe(.childRemoved) { (snapshot) in
            self.hideEndBookingView()
            self.removeAllMapOverlays(shouldRefresh: true)
            delayWithSeconds(animationOut, completion: {
                self.bringReviewBooking()
                self.locatorButtonPressed()
            })
            UserDefaults.standard.set("none", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
    }
    
    func findCurrentRoute(key: String) {
        let ref = Database.database().reference().child("UserBookings").child(key)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let booking = Bookings(dictionary: dictionary)
                if let latitude = booking.parkingLat, let longitude = booking.parkingLong, let currentLocation = self.locationManager.location {
                    let parking = CLLocation(latitude: latitude, longitude: longitude)
                    if let checkedIn = booking.checkedIn, checkedIn {
                        self.drawRoute(fromLocation: currentLocation, toLocation: parking, identifier: .walking)
                    } else {
                        self.drawRoute(fromLocation: currentLocation, toLocation: parking, identifier: .automobileAvoidingTraffic)
                    }
                }
            }
        }
    }
    
    @objc func currentViewIsScrolling(sender: UIPanGestureRecognizer) {
        let translation = -sender.translation(in: self.view).y
        let state = sender.state
        let percentage = translation/(phoneHeight/3)
        if state == .changed {
            if percentage >= 0 && percentage <= 1 && previousBookingPercentage != 1.0 {
                changeScrollAmount(percentage: percentage)
            }
        } else if state == .ended {
            if previousBookingPercentage >= 0.25 {
                openCurrentBooking()
            } else {
                closeCurrentBooking()
            }
        }
    }
    
    func changeScrollAmount(percentage: CGFloat) {
        previousBookingPercentage = percentage
        
        currentBottomHeightAnchor.constant = currentBookingHeight - currentBookingHeight * percentage
        durationLeftAnchor.constant = 16 - 16 * percentage
        durationRightAnchor.constant = -16 + 16 * percentage
        durationTopAnchor.constant = 8 - (8 + statusHeight) * percentage
        durationController.view.layer.cornerRadius = 4 - 4 * percentage
        
        fullBackgroundView.alpha = 0 + percentage
        currentBottomController.detailsController.changeScrollAmount(percentage: percentage)
        self.view.layoutIfNeeded()
    }
    
    func openCurrentBooking() {
        currentBottomController.scrollView.isScrollEnabled = true
        previousBookingPercentage = 1.0
        currentBottomHeightAnchor.constant = 0
        durationLeftAnchor.constant = 0
        durationRightAnchor.constant = 0
        durationTopAnchor.constant = -statusHeight
        
        delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 1
            self.currentDurationController.view.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.detailsController.openCurrentBooking()
        }
    }
    
    func closeCurrentBooking() {
        showHamburger = true
        previousBookingPercentage = 0.0
        currentBottomHeightAnchor.constant = currentBookingHeight
        durationLeftAnchor.constant = 16
        durationRightAnchor.constant = -16
        durationTopAnchor.constant = 8
        
        delegate?.defaultContentStatusBar()
        currentBottomController.detailsController.closeCurrentBooking()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.currentDurationController.view.layer.cornerRadius = 4
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.scrollView.isScrollEnabled = false
        }
    }
    
    func showEndBookingView() {
        locatorCurrentBottomAnchor.constant = -91
        UIView.animate(withDuration: animationIn) {
            self.endBookingController.view.alpha = 1
            self.endBookingController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        }
    }
    
    func hideEndBookingView() {
        locatorCurrentBottomAnchor.constant = -16
        UIView.animate(withDuration: animationIn) {
            self.endBookingController.view.alpha = 0
            self.endBookingController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func currentDurationTapped() {
        if previousBookingPercentage == 1.0 {
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

