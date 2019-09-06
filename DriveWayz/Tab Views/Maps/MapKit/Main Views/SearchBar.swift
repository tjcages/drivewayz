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
    
    func setupSearch() {
        
        self.view.addSubview(summaryController.view)
        summaryTopAnchor = summaryController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -260)
        summaryTopAnchor.isActive = true
        summaryController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        summaryController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            summaryController.view.heightAnchor.constraint(equalToConstant: 222).isActive = true
        case .iphoneX:
            summaryController.view.heightAnchor.constraint(equalToConstant: 234).isActive = true
        }
        summaryController.calendarButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        summaryController.calendarLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        summaryController.timeButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        summaryController.timeLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        
        self.view.addSubview(searchBarController.view)
        searchBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        searchBarController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        searchBarController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        switch device {
        case .iphone8:
            searchBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            searchBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        let touch = UITapGestureRecognizer(target: self, action: #selector(mainBarWillOpen))
        quickDestinationController.view.addGestureRecognizer(touch)
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        summaryTopAnchor.constant = -260
        mainViewState = .none
        mainBarController.searchController.checkRecentSearches()
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
        self.durationControllerBottomAnchor.constant = 0
        self.fullBackgroundView.alpha = 0
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(durationController.view)
        self.view.bringSubviewToFront(parkingBackButton)
        self.parkingBackButtonPurchaseAnchor.isActive = true
        self.parkingBackButtonBookAnchor.isActive = false
        self.parkingBackButtonConfirmAnchor.isActive = false
        self.delegate?.hideHamburger()
        UIView.animate(withDuration: animationIn) {
            self.parkingBackButton.tintColor = Theme.WHITE
            self.parkingBackButton.alpha = 1
            self.fullBackgroundView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func changeDatesDismissed() {
        self.durationControllerBottomAnchor.constant = 500
        self.parkingBackButtonPurchaseAnchor.isActive = false
        self.parkingBackButtonBookAnchor.isActive = true
        self.parkingBackButtonConfirmAnchor.isActive = false
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.view.bringSubviewToFront(self.mainBarController.view)
            self.view.bringSubviewToFront(self.locationsSearchResults.view)
            self.view.bringSubviewToFront(self.summaryController.view)
            self.view.bringSubviewToFront(self.parkingController.view)
            if self.parkingControllerBottomAnchor.constant != 0 && self.confirmControllerBottomAnchor.constant != 0 && self.summaryTopAnchor.constant != -260 {
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
