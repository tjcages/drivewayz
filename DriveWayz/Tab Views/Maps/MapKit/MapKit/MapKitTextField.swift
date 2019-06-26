//
//  MapKitTextField.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Mapbox
import GooglePlaces

extension MapKitViewController: UITextFieldDelegate, UITextViewDelegate {
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.summaryTopAnchor.constant = -260
        self.mainBarController.checkRecentSearches()
        UIView.animate(withDuration: animationOut, animations: {
            self.locationResultsHeightAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.fullBackgroundView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.mainBarHighest = false
                self.delegate?.defaultContentStatusBar()
            })
        }
    }
    
    @objc func changeDatesPressed() {
        self.view.endEditing(true)
        self.purchaseControllerBottomAnchor.constant = 0
        self.fullBackgroundView.alpha = 0
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(purchaseController.view)
        self.view.bringSubviewToFront(parkingBackButton)
        self.parkingBackButtonPurchaseAnchor.isActive = true
        self.parkingBackButtonBookAnchor.isActive = false
        self.parkingBackButtonConfirmAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.tintColor = Theme.WHITE
            self.parkingBackButton.alpha = 1
            self.fullBackgroundView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func changeDatesDismissed() {
        self.purchaseControllerBottomAnchor.constant = 500
        self.parkingBackButtonPurchaseAnchor.isActive = false
        self.parkingBackButtonBookAnchor.isActive = true
        self.parkingBackButtonConfirmAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.view.bringSubviewToFront(self.mainBarController.view)
            self.view.bringSubviewToFront(self.locationsSearchResults.view)
            self.view.bringSubviewToFront(self.summaryController.view)
            self.view.bringSubviewToFront(self.parkingController.view)
            if self.parkingControllerBottomAnchor.constant != 0 && self.confirmControllerBottomAnchor.constant != 0 {
                self.summaryController.searchTextField.becomeFirstResponder()
            }
            UIView.animate(withDuration: animationIn, animations: {
                self.parkingBackButton.tintColor = Theme.DARK_GRAY
            })
        }
    }
    
    @objc func searchBackButtonPressed() {
        self.view.endEditing(true)
    }
    
    func showCurrentLocation() {
        self.locationsSearchResults.bringCurrentLocation()
    }
    
    func hideCurrentLocation() {
        self.locationsSearchResults.hideCurrentLocation()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
