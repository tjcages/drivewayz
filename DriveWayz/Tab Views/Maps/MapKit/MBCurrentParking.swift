//
//  MBCurrentParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox

protocol handleMinimizingFullController {
    func minimizeFullController()
    func setDefaultStatusBar()
    func setLightStatusBar()
}

extension MapKitViewController: handleMinimizingFullController {
    
    func setupCurrent() {
        
        self.view.addSubview(currentSpotController.view)
        currentTopAnchor = currentSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            currentTopAnchor.isActive = true
        currentSpotController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentSpotController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentHeightAnchor = currentSpotController.view.heightAnchor.constraint(equalToConstant: 320)
            currentHeightAnchor.isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(currentlyScrolling(sender:)))
        currentSpotController.view.addGestureRecognizer(panGesture)
        
    }
    
    func confirmPurchasePressed(booking: Bookings) {
        self.removeAllMapOverlays(shouldRefresh: false)
        self.currentTopController.setData(booking: booking)
        self.removeAllMapOverlays(shouldRefresh: false)
        self.currentBottomController.setData(booking: booking)
        self.removeAllMapOverlays(shouldRefresh: false)
        self.userHasCurrentParking()
        self.removeAllMapOverlays(shouldRefresh: false)
        delayWithSeconds(0.1) {
            self.removeAllMapOverlays(shouldRefresh: false)
            delayWithSeconds(0.1, completion: {
                self.removeAllMapOverlays(shouldRefresh: false)
                delayWithSeconds(0.1, completion: {
                    self.removeAllMapOverlays(shouldRefresh: false)
                })
            })
        }
    }
    
    func userHasCurrentParking() {
        self.removeAllMapOverlays(shouldRefresh: false)
        DispatchQueue.main.async {
            if let minute = finalDriveTime {
                self.currentSpotController.driveTime = minute
            }
            delayWithSeconds(animationOut, completion: {
                self.mapView.setZoomLevel(15, animated: true)
            })
        }
        self.openCurrentInformation()
    }
    
    func hideCurrentParking() {
        
    }
    
    @objc func currentlyScrolling(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view).y
        if sender.state == .changed {
            self.currentSpotController.didTranslate(translation: self.currentHeightAnchor.constant)
            if translation < -260 {
                self.currentSpotController.topController()
                let percent = translation / 260
                UIView.animate(withDuration: animationOut) {
                    self.fullBackgroundView.alpha = 0.3 * percent
                    self.currentHeightAnchor.constant = self.view.frame.height
                    self.view.layoutIfNeeded()
                }
                return
            } else if translation > 120 && self.currentHeightAnchor.constant <= 300 {
                self.currentSpotController.bottomController()
                UIView.animate(withDuration: animationOut) {
                    self.currentHeightAnchor.constant = 160
                    self.view.layoutIfNeeded()
                }
                return
            } else if translation > 120 {
                self.currentSpotController.middleController()
                UIView.animate(withDuration: animationOut) {
                    self.currentHeightAnchor.constant = 320
                    self.view.layoutIfNeeded()
                }
                return
            } else {
                self.currentHeightAnchor.constant = self.previousHeightAnchor - translation
                self.view.layoutIfNeeded()
            }
        } else if sender.state == .ended {
            if self.currentHeightAnchor.constant >= 420 {
                self.delegate?.hideHamburger()
                self.removePolylineAnnotations()
                self.currentSpotController.topController()
                self.view.bringSubviewToFront(self.currentSpotController.view)
                UIView.animate(withDuration: animationOut, animations: {
                    self.currentHeightAnchor.constant = self.view.frame.height
                    self.previousHeightAnchor = self.view.frame.height
                    self.fullBackgroundView.alpha = 0.1
                    self.quickDestinationController.view.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                    if let pickup = finalPickupCoordinate, let destination = finalDestinationCoordinate {
                        self.quickDestinationController.view.alpha = 0
                        self.zoomToCurve(first: pickup, second: destination)
                        delayWithSeconds(animationOut, completion: {
                            self.view.bringSubviewToFront(self.currentSpotController.view)
                        })
                    }
                }
            } else if self.currentHeightAnchor.constant <= 120 {
                self.delegate?.bringHamburger()
                self.currentSpotController.bottomController()
                UIView.animate(withDuration: animationOut, animations: {
                    self.currentHeightAnchor.constant = 160
                    self.previousHeightAnchor = 160
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.delegate?.defaultContentStatusBar()
                }
            } else {
                self.delegate?.bringHamburger()
                self.currentSpotController.middleController()
                UIView.animate(withDuration: animationOut, animations: {
                    self.currentHeightAnchor.constant = 320
                    self.previousHeightAnchor = 320
                    self.fullBackgroundView.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                    if let line = quadPolyline, let shadowLine = quadPolylineShadow {
                        line.removeFromSuperlayer()
                        shadowLine.removeFromSuperlayer()
                    }
//                    self.applyFinalPolyline()
                    self.delegate?.defaultContentStatusBar()
                    delayWithSeconds(animationIn, completion: {
                        UIView.animate(withDuration: animationOut, animations: {
                        })
                    })
                }
            }
        }
    }
    
    func minimizeFullController() {
        self.delegate?.bringHamburger()
        self.currentSpotController.middleController()
        UIView.animate(withDuration: animationOut, animations: {
            self.currentHeightAnchor.constant = 320
            self.previousHeightAnchor = 320
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if let line = quadPolyline, let shadowLine = quadPolylineShadow {
                line.removeFromSuperlayer()
                shadowLine.removeFromSuperlayer()
            }
//            self.applyFinalPolyline()
            self.delegate?.defaultContentStatusBar()
            delayWithSeconds(animationIn, completion: {
                UIView.animate(withDuration: animationOut, animations: {
                })
            })
        }
    }
    
    func setDefaultStatusBar() {
        self.delegate?.defaultContentStatusBar()
    }
    
    func setLightStatusBar() {
        self.delegate?.lightContentStatusBar()
    }

}
