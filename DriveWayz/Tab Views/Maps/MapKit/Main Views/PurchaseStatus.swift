//
//  MapKitPurchaseStatus.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation

extension MapKitViewController {
    
    func setupPurchaseStatus() {
        
        self.view.addSubview(purchaseStaus)
        purchaseStaus.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        purchaseStaus.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        purchaseStatusWidthAnchor = purchaseStaus.widthAnchor.constraint(equalToConstant: 120)
        purchaseStatusWidthAnchor.isActive = true
        purchaseStatusHeightAnchor = purchaseStaus.heightAnchor.constraint(equalToConstant: 40)
        purchaseStatusHeightAnchor.isActive = true
        
    }
    
    func showPurchaseStatus(status: Bool) {
        if status == true {
            UIView.animate(withDuration: animationIn) {
                self.purchaseStatusWidthAnchor.constant = 120
                self.purchaseStatusHeightAnchor.constant = 40
                self.purchaseStaus.setTitle("Success!", for: .normal)
                self.purchaseStaus.alpha = 0.9
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.purchaseStatusWidthAnchor.constant = 220
                self.purchaseStatusHeightAnchor.constant = 60
                self.purchaseStaus.setTitle("The charge could not be made", for: .normal)
                self.purchaseStaus.alpha = 0.9
                self.view.layoutIfNeeded()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: animationIn) {
                self.purchaseStatusWidthAnchor.constant = 120
                self.purchaseStatusHeightAnchor.constant = 40
                self.purchaseStaus.setTitle("", for: .normal)
                self.purchaseStaus.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
