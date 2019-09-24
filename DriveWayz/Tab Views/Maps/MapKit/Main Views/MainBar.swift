//
//  MapKitMainBar.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import AVFoundation
import Mapbox

//var headingImageView: UIImageView?
//var userHeading: CLLocationDirection?
var userMostRecentLocation: CLLocationCoordinate2D?

var shouldDragMainBar: Bool = true

protocol mainBarSearchDelegate {
    func openNavigation(success: Bool, booking: Bookings)
    func showEndBookingView()
    func hideEndBookingView()
    
    func openMainBar()
    func closeMainBar()
    func closeSearch()
//    func expandedMainBar()
    
    func closeCurrentBooking()
    func showCurrentLocation()
    func hideCurrentLocation()
    func zoomToSearchLocation(address: String)
    func becomeANewHost()
}

//var ParkingRoutePolyLine: [MKOverlay] = []
//var DestinationRoutePolyLine = MKPolyline()
//var DestinationAnnotation: MKAnnotation?
var ZoomMapView: MGLCoordinateBounds?
var ZoomPurchaseMapView: MGLCoordinateBounds?
var IncreasedZoomMapView: CLLocationCoordinate2D?
var CurrentDestinationLocation: CLLocation?
var ClosestParkingLocation: CLLocation?

extension MapKitViewController: mainBarSearchDelegate {
    
    func setupLocator() {

        view.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        locatorMainBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: mainBarController.view.topAnchor, constant: -16)
            locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: parkingBackButton.bottomAnchor, constant: -4)
            locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: currentBottomController.view.topAnchor, constant: -16)
            locatorCurrentBottomAnchor.isActive = false
        
        self.view.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: summaryController.view.bottomAnchor, constant: -10).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: summaryController.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: summaryController.view.rightAnchor).isActive = true
        locationResultsHeightAnchor = locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 0)
            locationResultsHeightAnchor.isActive = true
        
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(mainBarController.view)
        self.view.bringSubviewToFront(parkingController.view)
        self.view.bringSubviewToFront(durationController.view)
        self.view.bringSubviewToFront(confirmPaymentController.view)
        self.view.bringSubviewToFront(endBookingController.view)
        self.view.bringSubviewToFront(currentBottomController.view)
        self.view.bringSubviewToFront(currentDurationController.view)
        
    }
    
    
    @objc func searchReservationsPressed() {
        if mainBarController.reservationsOpen {
            closeMainReservation()
        } else {
            expandMainReservation()
        }
    }
    
    func expandMainReservation() {
        mainBarController.expandReservations()
        mainBarBottomAnchor.constant -= 100
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0.4
            self.view.layoutIfNeeded()
        }
    }
    
    func closeMainReservation() {
        mainBarController.closeReservations()
        mainBarBottomAnchor.constant += 100
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func recommendButtonPressed() {
        if let city = mainBarController.searchController.recommendationButton.titleLabel?.text {
            zoomToSearchLocation(address: city)
        }
    }
    
    // Open search results and bring search summary controller down
    @objc func openSearch() {
        mainViewState = .mainBar
        showHamburger = false
        openMainBar()
        delegate?.hideHamburger()
        
        view.bringSubviewToFront(locationsSearchResults.view)
        view.bringSubviewToFront(summaryController.view)
        
        mainBarBottomAnchor.constant = 0
        summaryTopAnchor.constant = 0
        summaryController.searchTextField.text = ""
        locationsSearchResults.checkRecentSearches()
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.summaryController.searchTextField.becomeFirstResponder() 
            self.locationResultsHeightAnchor.constant = phoneHeight - 100
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func closeSearch() {
        view.endEditing(true)
        showHamburger = true
        closeMainBar()
        
        view.bringSubviewToFront(self.mainBarController.view)
        locationResultsHeightAnchor.constant = 0
        summaryTopAnchor.constant = -260
        UIView.animate(withDuration: animationIn, animations: {
            self.mainBarController.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
//    @objc func mainBarWillOpen() {
//        if fullBackgroundView.alpha <= 0.85 {
//            if let currentLocation = locationManager.location?.coordinate {
//                userMostRecentLocation = currentLocation
//            }
//            closeMainReservation()
//            summaryTopAnchor.constant = 0
//            parkingControllerBottomAnchor.constant = 400
//            confirmControllerBottomAnchor.constant = 360
//            mainBarTopAnchor.constant = phoneHeight
//            delegate?.hideHamburger()
//            delegate?.defaultContentStatusBar()
//            view.bringSubviewToFront(locationsSearchResults.view)
//            view.bringSubviewToFront(summaryController.view)
//            summaryController.searchTextField.text = ""
//            UIView.animate(withDuration: animationOut, animations: {
//                self.mainBarController.scrollView.alpha = 0
//                self.fullBackgroundView.alpha = 0.4
//                self.view.layoutIfNeeded()
//            }) { (success) in
//                self.mainBarController.scrollView.isScrollEnabled = true
//                self.mainBarController.scrollView.setContentOffset(.zero, animated: false)
//                UIView.animate(withDuration: animationIn, animations: {
//                    self.locationsSearchResults.checkRecentSearches()
//                    self.locationResultsHeightAnchor.constant = self.view.frame.height - 100
//                    self.view.layoutIfNeeded()
//                }) { (success) in
//                    self.summaryController.searchTextField.becomeFirstResponder()
//                    self.mainBarController.scrollView.isScrollEnabled = false
//                }
//            }
//        } else {
//            mainBarTopAnchor.constant = phoneHeight - 150
//            delegate?.lightContentStatusBar()
//            delegate?.hideHamburger()
//            UIView.animate(withDuration: animationIn, animations: {
//                self.fullBackgroundView.alpha = 0.7
//                self.locatorButton.alpha = 0
//                self.view.layoutIfNeeded()
//            }) { (success) in
//                self.mainBarController.scrollView.isScrollEnabled = false
//                self.mainBarHighest = true
//                self.mainBarWillOpen()
//            }
//        }
//    }
//
//    func mainBarWillClose() {
//        closeMainReservation()
//        view.endEditing(true)
//        summaryTopAnchor.constant = -260
//        mainBarTopAnchor.constant = lowestHeight
//        UIView.animate(withDuration: animationOut, animations: {
//            self.locationResultsHeightAnchor.constant = 0
//            self.mainBarController.scrollView.alpha = 1
//            self.fullBackgroundView.alpha = 0
//            self.view.layoutIfNeeded()
//        }) { (success) in
//            self.view.bringSubviewToFront(self.mainBarController.view)
//            UIView.animate(withDuration: animationIn, animations: {
//                self.view.layoutIfNeeded()
//            }, completion: { (success) in
//                self.mainBarHighest = false
//                self.delegate?.bringHamburger()
//                self.delegate?.defaultContentStatusBar()
//            })
//        }
//    }

    
    @objc func mainBarIsScrolling(sender: UIPanGestureRecognizer) {
        let translation = -sender.translation(in: self.view).y
        let state = sender.state
        let percentage = translation/(phoneHeight/3)
        if state == .changed {
            if percentage >= 0 && percentage <= 1 && previousMainBarPercentage != 1.0 {
                changeMainScrollAmount(percentage: percentage)
            }
        } else if state == .ended {
            if previousMainBarPercentage >= 0.25 {
                openMainBar()
            } else {
                closeMainBar()
            }
        }
    }
    
    func changeMainScrollAmount(percentage: CGFloat) {
        previousMainBarPercentage = percentage
        
        if percentage >= 0.2 {
            delegate?.hideHamburger()
            delegate?.lightContentStatusBar()
            if mainBarController.reservationsOpen {
                closeMainReservation()
            }
        }
        
        mainBarBottomAnchor.constant = currentMainBarHeight - currentMainBarHeight * percentage
        fullBackgroundView.alpha = 0 + percentage
        view.layoutIfNeeded()
    }
    
    @objc func openMainBar() {
        mainBarController.scrollView.isScrollEnabled = true
        previousMainBarPercentage = 1.0
        mainBarBottomAnchor.constant = 0
        
        delegate?.hideHamburger()
        delegate?.lightContentStatusBar()
        if mainBarController.reservationsOpen {
            closeMainReservation()
        }
        
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func closeMainBar() {
        previousMainBarPercentage = 0.0
        mainBarBottomAnchor.constant = currentMainBarHeight
        
        delegate?.bringHamburger()
        delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainBarController.scrollView.isScrollEnabled = false
        }
    }
    
    func becomeANewHost() {
        delegate?.bringNewHostingController()
    }
    
}
