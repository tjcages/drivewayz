//
//  MBNavigation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol HandleCurrent {
    func currentPressed()
    func closeCurrent(parking: Bool)
    func currentBarPanned(sender: UIPanGestureRecognizer)
    func dismissCurrent()
    func restartBookingProcess()
}

var canPanCurrentView: Bool = true

extension MapKitViewController: HandleCurrent {

    @objc func currentBarPanned(sender: UIPanGestureRecognizer) {
        if canPanCurrentView {
            let translation = -sender.translation(in: view).y/1.5
            let percent = translation/120
            let velocity = -sender.velocity(in: view).y
            if sender.state == .changed {
                if velocity >= 1000 {
                    currentPressed()
                } else if translation >= -16 && translation < 120 && velocity > 0 && currentBarHeightAnchor.constant != phoneHeight {
                    currentBarHeightAnchor.constant = currentBarNormalHeight + translation
                    currentBookingController.transitionToSearch(percent: percent/2)
                    changeCurrentPercentage(percent: percent)
                    view.layoutIfNeeded()
                } else if translation <= -16 && translation >= -120 {
                    currentBarHeightAnchor.constant = phoneHeight + translation
                    currentBookingController.transitionToSearch(percent: 1 + percent/2)
                    changeCurrentPercentage(percent: percent)
                    view.layoutIfNeeded()
                } else if translation >= 120 {
                    currentPressed()
                } else if translation <= -120 {
                    closeCurrent(parking: false)
                }
            } else if sender.state == .ended {
                if translation >= 160 || velocity >= 1000 {
                    currentPressed()
                } else {
                    closeCurrent(parking: false)
                }
            }
        }
    }
    
    func changeCurrentPercentage(percent: CGFloat) {
        var percentage = percent
        if percent < 0.6 {
            percentage = percent/0.6
            currentRouteButton.alpha = 1 - percentage
        }
        fullBackgroundView.alpha = 0.4 * percent
    }
    
    @objc func currentPressed() {
        canPanCurrentView = false
        delegate?.hideHamburger()
        currentBarHeightAnchor.constant = phoneHeight
        UIView.animateOut(withDuration: animationOut, animations: {
            self.currentBookingController.transitionToSearch(percent: 1)
            self.currentRouteButton.alpha = 0
            self.fullBackgroundView.alpha = 0.4
            self.view.layoutIfNeeded()
        }) { (success) in
            canPanCurrentView = true
        }
    }
    
    func closeCurrent(parking: Bool) {
        if !parking, let userLocation = self.locationManager.location {
            let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel - 0.5)
            mapView.camera = camera
            CATransaction.begin()
            CATransaction.setValue(0.8, forKey: kCATransactionAnimationDuration)
            let camera2 = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
            mapView.animate(to: camera2)
            CATransaction.commit()
        }
        
        canPanCurrentView = false
        delegate?.bringHamburger()
        currentBarHeightAnchor.constant = currentBarNormalHeight
        UIView.animateOut(withDuration: animationOut, animations: {
            self.currentBookingController.transitionToSearch(percent: 0)
            self.currentRouteButton.alpha = 1
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            canPanCurrentView = true
        }
    }
    
    func dismissCurrent() {
        mainViewState = .none
        delegate?.hideHamburger()
        delegate?.hideProfile()
        
        let controller = ReviewViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
        
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0.4
        }) { (success) in
            //
        }
    }
    
    func restartBookingProcess() {
        mainViewState = .mainBar
        delegate?.bringHamburger()
        delegate?.bringProfile()
    }
    
}

