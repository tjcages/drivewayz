//
//  MapKitMainBar.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

var shouldDragMainBar: Bool = true

protocol mainBarSearchDelegate {
    func openNavigation(success: Bool, booking: Bookings)
    func showEndBookingView()
    func hideEndBookingView()
    
    func showDuration(parkNow: Bool)
    
    func openMainBar()
    func closeMainBar()
    func closeSearch()
//    func expandedMainBar()
    
    func closeCurrentBooking()
    func showCurrentLocation()
    func hideCurrentLocation()
    func zoomToSearchLocation(placeId: String)
    
    func quickNewHost()
    func quickHelp()
    func quickAccount()
}

extension MapKitViewController: mainBarSearchDelegate {
    
    func setupLocator() {

        view.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        locatorMainBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: mainBarController.view.topAnchor, constant: -16)
            locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: parkingBackButton.bottomAnchor, constant: 0)
            locatorParkingBottomAnchor.isActive = false
        locatorCurrentBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: currentBottomController.view.topAnchor, constant: -16)
            locatorCurrentBottomAnchor.isActive = false
        
        view.addSubview(locationsSearchResults.view)
        locationResultsHeightAnchor = locationsSearchResults.view.topAnchor.constraint(equalTo: summaryController.view.bottomAnchor, constant: phoneHeight * 1.5)
            locationResultsHeightAnchor.isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: summaryController.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: summaryController.view.rightAnchor).isActive = true
        locationsSearchResults.view.heightAnchor.constraint(equalToConstant: phoneHeight - 100).isActive = true
        
        view.bringSubviewToFront(fullBackgroundView)
        view.bringSubviewToFront(mainBarController.view)
        view.bringSubviewToFront(parkingController.view)
        view.bringSubviewToFront(durationController.view)
        view.bringSubviewToFront(confirmPaymentController.view)
        view.bringSubviewToFront(endBookingController.view)
        view.bringSubviewToFront(currentBottomController.view)
        view.bringSubviewToFront(currentDurationController.view)
        view.bringSubviewToFront(parkingBackButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(readjustMainBar), name: NSNotification.Name(rawValue: "readjustMainBar"), object: nil)
        
    }
    
    @objc func readjustMainBar() {
        mainBarBottomAnchor.constant = phoneHeight - mainBarNormalHeight
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func mainBarIsScrolling(sender: UIPanGestureRecognizer) {
        let state = sender.state
        if canScrollMainView || state == .ended {
            let translation = -sender.translation(in: self.view).y
            let percentage = translation/(phoneHeight/3)
            if state == .changed {
                if percentage >= 0 && percentage <= 1 && previousMainBarPercentage != 1.0 {
                    changeMainScrollAmount(percentage: percentage, direction: true)
                } else if mainBarBottomAnchor.constant <= (phoneHeight - mainBarNormalHeight) && percentage <= 1 {
                    changeMainScrollAmount(percentage: previousMainBarPercentage + percentage, direction: false)
                }
            } else {
                canScrollMainView = true
                if previousMainBarPercentage >= 0.25 {
                    if previousMainBarPercentage != 1.0 {
                        openMainBar()
                    }
                } else {
                    closeMainBar()
                }
            }
        }
    }
    
    func changeMainScrollAmount(percentage: CGFloat, direction: Bool) {
        if percentage >= 0.2 && percentage < 0.7 {
            if showHamburger {
                showHamburger = false
                delegate?.hideHamburger()
                delegate?.lightContentStatusBar()
            }
        } else if percentage >= 0.7 && previousMainBarPercentage != 1.0 && direction {
            canScrollMainView = false
            openMainBar()
            return
        }
        previousMainBarPercentage = percentage
        
        mainBarBottomAnchor.constant = phoneHeight - mainBarNormalHeight - (mainBarHighestHeight - mainBarNormalHeight) * percentage
        fullBackgroundView.alpha = 0 + 0.4 * percentage
        view.layoutIfNeeded()
    }
    
    @objc func openMainBar() {
        previousMainBarPercentage = 1.0
        mainBarBottomAnchor.constant = phoneHeight - mainBarHighestHeight
        mainBarController.searchHeightAnchor.constant = 164
        
        delegate?.hideHamburger()
        delegate?.lightContentStatusBar()

        mainBarController.showQuickOptions()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0.4
            self.view.layoutIfNeeded()
        }) { (success) in

        }
    }
    
    func closeMainBar() {
        previousMainBarPercentage = 0.0
        mainBarBottomAnchor.constant = phoneHeight - mainBarNormalHeight
        mainBarController.searchHeightAnchor.constant = 232
        
        showHamburger = true
        delegate?.bringHamburger()
        delegate?.defaultContentStatusBar()
        
        self.mainBarController.hideQuickOptions()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if self.mainBarController.reservationsOpen {
                self.mainBarController.closeReservations()
                self.closeMainBanner()
            }
        }
    }
    
    @objc func mainBannerPressed() {
        if mainBarController.reservationsOpen {
            mainBarController.closeReservations()
            closeMainBanner()
        } else {
            mainBarController.expandReservations()
            expandMainBanner()
        }
    }
    
    func expandMainBanner() {
        mainBarBottomAnchor.constant -= 100
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0.4
            self.view.layoutIfNeeded()
        }
    }
    
    func closeMainBanner() {
        mainBarBottomAnchor.constant += 100
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func quickNewHost() {
        closeMainBar()
        delegate?.bringNewHostingController()
    }
    
    func quickHelp() {
        closeMainBar()
        accountDelegate?.bringHelpController()
    }
    
    func quickAccount() {
        closeMainBar()
        accountDelegate?.bringSettingsController()
    }
    
}
