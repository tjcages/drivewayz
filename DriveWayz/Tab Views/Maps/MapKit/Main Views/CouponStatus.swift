//
//  CouponStatus.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit


extension MapKitViewController {
    
    func setupCoupons() {
        self.view.addSubview(quickCouponController.view)
        quickCouponController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        quickCouponController.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        quickCouponController.view.widthAnchor.constraint(equalToConstant: 228).isActive = true
        switch device {
        case .iphone8:
            quickCouponController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            quickCouponController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        monitorCoupons()
    }
    
    func monitorCoupons() {
        if BookedState != .currentlyBooked {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("CurrentCoupon")
            ref.observe(.childAdded) { (snapshot) in
                if let percent = snapshot.value as? Int {
                    self.quickCouponController.percentage = percent
                    self.newMessageTopAnchor.constant = self.newMessageTopAnchor.constant + 62
                    UIView.animate(withDuration: animationIn, animations: {
                        self.quickCouponController.view.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        self.quickCouponController.maximizeController()
                    })
                }
            }
            ref.observe(.childRemoved) { (snapshot) in
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.childrenCount == 0 {
                        self.quickCouponController.closeController()
                        delayWithSeconds(animationOut, completion: {
                            self.newMessageTopAnchor.constant = self.newMessageTopAnchor.constant - 62
                            UIView.animate(withDuration: animationIn, animations: {
                                self.quickCouponController.view.alpha = 0
                                self.view.layoutIfNeeded()
                            })
                        })
                    } else {
                        if let dictionary = snapshot.value as? [String: Any] {
                            if let coupon = dictionary["coupon"] as? Int {
                                self.quickCouponController.percentage = coupon
                            } else if let invite = dictionary["invite"] as? Int {
                                self.quickCouponController.percentage = invite
                            }
                        }
                        self.newMessageTopAnchor.constant = self.newMessageTopAnchor.constant + 62
                        UIView.animate(withDuration: animationIn, animations: {
                            self.quickCouponController.view.alpha = 1
                            self.view.layoutIfNeeded()
                        }, completion: { (success) in
                            self.quickCouponController.maximizeController()
                        })
                    }
                })
            }
        }
    }
    
}
