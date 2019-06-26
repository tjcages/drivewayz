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
    func reviewOptionsDismissed()
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
        
        self.view.addSubview(reviewBookingController.view)
        reviewBookingTopAnchor = reviewBookingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            reviewBookingTopAnchor.isActive = true
        reviewBookingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewBookingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewBookingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(contactDrivewayzController.view)
        contactDrivewayzTopAnchor = contactDrivewayzController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            contactDrivewayzTopAnchor.isActive = true
        contactDrivewayzController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contactDrivewayzController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contactDrivewayzController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        reviewBookingController.informationButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        reviewBookingController.appButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        reviewBookingController.refundButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        reviewBookingController.otherButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        contactDrivewayzController.backButton.addTarget(self, action: #selector(reviewOptionsDismissed), for: .touchUpInside)
        
        delayWithSeconds(2) {
            self.view.bringSubviewToFront(self.reviewBookingController.view)
        }
        
        setupSuccess()
    }
    
    func setupSuccess() {
        
        self.view.addSubview(successContainer)
        successContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        successContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        successContainer.widthAnchor.constraint(equalToConstant: phoneWidth * 3/4).isActive = true
        successContainer.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        successContainer.addSubview(checkmark)
        checkmark.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: successContainer.centerYAnchor, constant: -30).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 120).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
        successContainer.addSubview(successLabel)
        successLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        successLabel.topAnchor.constraint(equalTo: checkmark.bottomAnchor, constant: 32).isActive = true
        successLabel.sizeToFit()
        
    }
    
    func bringReviewBooking() {
        self.reviewBookingTopAnchor.constant = 0
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(reviewBookingController.view)
        self.delegate?.hideHamburger()
        UIView.animate(withDuration: animationOut) {
            self.reviewBookingController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.reviewBookingController.view.alpha = 1
            self.fullBackgroundView.alpha = 0.8
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func reviewOptionsPressed(sender: UIButton) {
        if sender == reviewBookingController.informationButton {
            self.contactDrivewayzController.contactDrivewayzController.informationLabel.text = "The parking space information was incorrect"
        } else if sender == reviewBookingController.appButton {
            self.contactDrivewayzController.contactDrivewayzController.informationLabel.text = "The app did not work correctly"
        } else if sender == reviewBookingController.refundButton {
            self.contactDrivewayzController.contactDrivewayzController.informationLabel.text = "I need a refund for my recent booking"
        } else if sender == reviewBookingController.otherButton {
            self.contactDrivewayzController.contactDrivewayzController.informationLabel.text = "Other concern"
        }
        self.contactDrivewayzTopAnchor.constant = 0
        self.view.bringSubviewToFront(contactDrivewayzController.view)
        self.delegate?.hideHamburger()
        UIView.animate(withDuration: animationIn, animations: {
            self.reviewBookingController.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.lightContentStatusBar()
        }
    }
    
    @objc func reviewOptionsDismissed() {
        self.contactDrivewayzTopAnchor.constant = phoneHeight
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.reviewBookingController.view.alpha = 0
                self.reviewBookingController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.fullBackgroundView.alpha = 0
            }, completion: { (success) in
                self.view.bringSubviewToFront(self.mainBarController.view)
                self.delegate?.bringHamburger()
                self.delegate?.defaultContentStatusBar()
            })
        }
    }
    
    func expandCheckmark() {
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(successContainer)
        UIView.animate(withDuration: animationOut, animations: {
            self.successContainer.alpha = 1
            self.fullBackgroundView.alpha = 0.8
            self.checkmark.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (success) in
            delayWithSeconds(1.4, completion: {
                UIView.animate(withDuration: animationOut, animations: {
                    self.successContainer.alpha = 0
                    self.checkmark.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: { (success) in
                    self.removeAllMapOverlays(shouldRefresh: false)
                    self.openCurrentInformation()
                    UIView.animate(withDuration: animationIn, animations: {
                        self.fullBackgroundView.alpha = 0
                    }, completion: { (success) in
                        self.view.bringSubviewToFront(self.currentBottomController.view)
                    })
                })
            })
        }
    }
    
    func confirmPurchasePressed(booking: Bookings) {
        self.quickCouponController.view.alpha = 0
        self.hideConfirmController()
        self.parkingHidden(showMainBar: false)
        self.currentUserBooking = booking
        self.removeAllMapOverlays(shouldRefresh: false)
        self.openCurrentInformation()
    }
    
    func hideCurrentParking() {
        self.view.bringSubviewToFront(mainBarController.view)
        self.removeAllMapOverlays(shouldRefresh: true)
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.currentBottomHeightAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.mainBarTopAnchor.constant = 354
                self.view.layoutIfNeeded()
            })
            self.mapView.resetNorth()
            self.mapView.allowsRotating = true
            self.mapView.isRotateEnabled = true
            delayWithSeconds(animationOut * 2) {
                self.mapView.isRotateEnabled = false
                self.mapView.allowsRotating = false
            }
        }
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
