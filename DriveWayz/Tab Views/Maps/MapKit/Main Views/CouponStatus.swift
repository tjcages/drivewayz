//
//  CouponStatus.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

extension MapKitViewController {
    
    func monitorCoupons() {
        if BookedState != .currentlyBooked {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("CurrentCoupon")
            ref.observe(.childAdded) { (snapshot) in
                if let percent = snapshot.value as? Int {
//                    self.mainBarController.activeCouponController.percentage = percent
                    UIView.animate(withDuration: animationIn, animations: {
                        self.mainBarController.searchController.discountButton.alpha = 1
//                        self.mainBarController.setupCoupon(0, last: false)
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                    })
                }
            }
            ref.observe(.childRemoved) { (snapshot) in
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.childrenCount == 0 {
                        delayWithSeconds(animationOut, completion: {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.mainBarController.searchController.discountButton.alpha = 0
                                self.mainBarController.setupBanner(0, last: false)
                                self.view.layoutIfNeeded()
                            })
                        })
                    } else {
                        if let dictionary = snapshot.value as? [String: Any] {
                            if let coupon = dictionary["coupon"] as? Int {
//                                self.mainBarController.activeCouponController.percentage = coupon
                            } else if let invite = dictionary["invite"] as? Int {
//                                self.mainBarController.activeCouponController.percentage = invite
                            }
                        }
                        UIView.animate(withDuration: animationIn, animations: {
                            self.mainBarController.searchController.discountButton.alpha = 1
//                            self.mainBarController.setupCoupon(0, last: false)
                            self.view.layoutIfNeeded()
                        }, completion: { (success) in
                        })
                    }
                })
            }
        }
    }
    
}
