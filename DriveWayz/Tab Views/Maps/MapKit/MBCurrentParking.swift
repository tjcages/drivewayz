//
//  MBCurrentParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation

extension MapKitViewController {
    
    func setupCurrent() {
        
        self.view.addSubview(currentSpotController.view)
        currentTopAnchor = currentSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            currentTopAnchor.isActive = true
        currentSpotController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentSpotController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentHeightAnchor = currentSpotController.view.heightAnchor.constraint(equalToConstant: 380)
            currentHeightAnchor.isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(currentlyScrolling(sender:)))
        currentSpotController.view.addGestureRecognizer(panGesture)
        
    }
    
    func confirmPurchasePressed() {
//        self.beginRouteNavigation()
        self.userHasCurrentParking()
    }
    
    func userHasCurrentParking() {
        if let region = ZoomMapView {
            self.takeAwayEvents()
            UIView.animate(withDuration: animationOut, animations: {
                self.parkingControllerBottomAnchor.constant = 420
                self.purchaseControllerBottomAnchor.constant = 320
                self.currentTopAnchor.constant = 0
                self.parkingBackButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.mapView.userTrackingMode = .none
                self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 80, left: 66, bottom: 480, right: 66), animated: true)
                if let location = DestinationAnnotationLocation {
                    delayWithSeconds(0.5) {
                        self.checkQuickDestination(annotationLocation: location)
                        UIView.animate(withDuration: animationIn, animations: {
                            self.currentTopAnchor.constant = 0
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
        }
    }
    
    func hideCurrentParking() {
        
    }
    
    @objc func currentlyScrolling(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view).y
        if sender.state == .changed {
            self.currentSpotController.didTranslate(translation: self.currentHeightAnchor.constant)
            if translation < -260 {
                self.currentSpotController.topController()
                UIView.animate(withDuration: animationOut) {
                    self.currentHeightAnchor.constant = self.view.frame.height
                    self.view.layoutIfNeeded()
                }
                return
            } else if translation > 120 && self.currentHeightAnchor.constant <= 360 {
                self.currentSpotController.bottomController()
                UIView.animate(withDuration: animationOut) {
                    self.currentHeightAnchor.constant = 160
                    self.view.layoutIfNeeded()
                }
                return
            } else if translation > 120 {
                self.currentSpotController.middleController()
                UIView.animate(withDuration: animationOut) {
                    self.currentHeightAnchor.constant = 380
                    self.view.layoutIfNeeded()
                }
                return
            } else {
                self.currentHeightAnchor.constant = self.previousHeightAnchor - translation
                self.view.layoutIfNeeded()
            }
        } else if sender.state == .ended {
            if self.currentHeightAnchor.constant >= 460 {
                self.delegate?.hideHamburger()
                self.currentSpotController.topController()
                UIView.animate(withDuration: animationOut, animations: {
                    self.currentHeightAnchor.constant = self.view.frame.height
                    self.previousHeightAnchor = self.view.frame.height
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.delegate?.lightContentStatusBar()
                }
            } else if self.currentHeightAnchor.constant <= 200 {
                self.delegate?.bringHamburger()
                self.currentSpotController.bottomController()
                UIView.animate(withDuration: animationOut, animations: {
                    self.currentHeightAnchor.constant = 200
                    self.previousHeightAnchor = 200
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.delegate?.defaultContentStatusBar()
                }
            } else {
                self.delegate?.bringHamburger()
                self.currentSpotController.middleController()
                UIView.animate(withDuration: animationOut, animations: {
                    self.currentHeightAnchor.constant = 380
                    self.previousHeightAnchor = 380
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.delegate?.defaultContentStatusBar()
                }
            }
        }
    }

}
