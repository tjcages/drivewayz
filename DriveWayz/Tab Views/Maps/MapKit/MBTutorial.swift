//
//  MBTutorial.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleAdditionalSteps {
    func openAdditionalStep()
    func confirmBookingStep()
}

var addStepController = AddStepView()

extension MapKitViewController: handleAdditionalSteps {
    
    func checkParkingOpens() {
        var opens = UserDefaults.standard.integer(forKey: "numberOfOpensBooking")
        if opens <= 1 {
            opens += 1
            UserDefaults.standard.set(opens, forKey: "numberOfOpensBooking")
            UserDefaults.standard.synchronize()
            
            bookingTutorialController.view.alpha = 0
            delayWithSeconds(0.6) {
                self.view.insertSubview(bookingTutorialController.view, belowSubview: self.parkingController.view)
                UIView.animate(withDuration: animationIn, animations: {
                    bookingTutorialController.view.alpha = 1
                }, completion: { (success) in
                    bookingTutorialController.showView()
                })
            }
        }
    }
    
    func openAdditionalStep() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.8
        }) { (success) in
            addStepController.delegate = self
            addStepController.currentPaymentMethod = self.confirmPaymentController.currentPaymentMethod
            addStepController.currentVehicleMethod = self.confirmPaymentController.currentVehicleMethod
            let navigation = UINavigationController(rootViewController: addStepController)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func confirmBookingStep() {
        confirmPaymentController.mainButton.sendActions(for: .touchUpInside)
    }
    
}
