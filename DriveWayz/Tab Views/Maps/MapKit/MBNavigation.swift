//
//  MBCurrentParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import GoogleMaps

protocol handleMinimizingFullController {
    func setDefaultStatusBar()
    func setLightStatusBar()
    func reviewOptionsDismissed()
}

var currentActive: Bool = false

extension MapKitViewController: handleMinimizingFullController {
    
    func setupCurrentViews() {
    
        self.view.addSubview(reviewBookingController.view)
        reviewBookingTopAnchor = reviewBookingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            reviewBookingTopAnchor.isActive = true
        reviewBookingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewBookingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewBookingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        reviewBookingController.informationButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        reviewBookingController.appButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        reviewBookingController.refundButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)
        reviewBookingController.otherButton.addTarget(self, action: #selector(reviewOptionsPressed(sender:)), for: .touchUpInside)

    }
    
    func bringReviewBooking() {
        reviewBookingController.spotImageView.image = currentBottomController.detailsController.spotIcon.image
        reviewBookingController.currentParking = currentBottomController.currentParking
        reviewBookingTopAnchor.constant = 0
//        self.view.bringSubviewToFront(fullBackgroundView)
        view.bringSubviewToFront(reviewBookingController.view)
        delegate?.hideHamburger()
        UIView.animate(withDuration: animationOut) {
            self.reviewBookingController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.reviewBookingController.view.alpha = 1
            self.fullBackgroundView.alpha = 0.8
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func reviewOptionsPressed(sender: UIButton) {
        var contactText = ""
        if sender == reviewBookingController.informationButton {
            contactText = "The parking space information was incorrect"
        } else if sender == reviewBookingController.appButton {
            contactText = "The app did not work correctly"
        } else if sender == reviewBookingController.refundButton {
            contactText = "I need a refund for my recent booking"
        } else if sender == reviewBookingController.otherButton {
            contactText = "Other concern"
        }
        let controller = UserContactViewController()
        controller.context = "Review"
        controller.informationLabel.text = contactText
        self.present(controller, animated: true, completion: nil)
    }
    
    func bringContactController(contactText: String) {
        let controller = UserContactViewController()
        controller.context = "Booking"
        controller.informationLabel.text = contactText
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func reviewOptionsDismissed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                if self.reviewBookingController.view.alpha == 1 {
                    self.reviewBookingController.view.alpha = 0
                    self.reviewBookingController.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                }
            }, completion: { (success) in
                self.mainViewState = .mainBar
                self.view.bringSubviewToFront(self.mainBarController.view)
                if self.mainBarBottomAnchor.constant == phoneHeight - mainBarNormalHeight {
                    self.fullBackgroundView.alpha = 0
                    self.delegate?.bringHamburger()
                    self.delegate?.defaultContentStatusBar()
                } else {
                    self.delegate?.lightContentStatusBar()
                }
            })
        }
    }
    
    func openNavigation(success: Bool, booking: Bookings) {
        let navigation = NavigationMapBox()
        navigation.currentBooking = booking
        navigation.delegate = self
        navigation.modalPresentationStyle = .overFullScreen
        navigation.modalTransitionStyle = .crossDissolve
        self.present(navigation, animated: true) {
            if let image = self.confirmPaymentController.currentParkingImage, let time = self.confirmPaymentController.totalTime, success {
                navigation.openCurrentBooking(image: image, time: time)
            }
            if !success {
                self.closeCurrentBooking()
            }
        }
    }
    
    func expandCheckmark(current: Bool, booking: Bookings) {
        if current {
            openNavigation(success: true, booking: booking)
        } else {
            let controller = SuccessfulPurchaseViewController()
            if let totalTime = currentTotalTime {
                controller.changeDates(totalTime: totalTime)
            }
            controller.spotIcon.image = self.confirmPaymentController.currentParkingImage
            controller.loadingActivity.startAnimating()
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true) {
                controller.animateSuccess()
                delayWithSeconds(3) {
                    controller.closeSuccess()
                    delayWithSeconds(animationIn, completion: {
                        self.dismiss(animated: true, completion: {
                            self.parkingHidden(showMainBar: true)
                        })
                    })
                }
            }
        }
    }
    
//    func confirmPurchasePressed(booking: Bookings) {
//        mainViewState = .none
//        self.quickCouponController.view.alpha = 0
//        self.removeAllHostLocations()
//        self.currentUserBooking = booking
//    }
    
    func hideCurrentParking() {
        self.removeAllMapOverlays(shouldRefresh: true)
        mainViewState = .none
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if let userLocation = self.locationManager.location {
                let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: 12.0)
                self.mapView.animate(to: camera)
            }
        }
    }
    
    func setDefaultStatusBar() {
        self.delegate?.defaultContentStatusBar()
    }
    
    func setLightStatusBar() {
        self.delegate?.lightContentStatusBar()
    }

}
