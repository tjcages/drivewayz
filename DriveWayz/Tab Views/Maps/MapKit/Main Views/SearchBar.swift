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

protocol controlSaveLocation {
    func zoomToSearchLocation(address: String)
    func closeSearch()
}

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
        let touch = UITapGestureRecognizer(target: self, action: #selector(openMainBar))
        quickDestinationController.view.addGestureRecognizer(touch)
        
    }
    
    @objc func searchDurationPressed() {
        openMainBar()
        delayWithSeconds(animationOut + animationIn) {
            self.summaryController.calendarButton.sendActions(for: .touchUpInside)
        }
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
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            self.durationController.modalPresentationStyle = .overCurrentContext
            self.present(self.durationController, animated: true, completion: nil)
        }
    }
    
    @objc func searchBackButtonPressed() {
        view.endEditing(true)
    }
    
    func showCurrentLocation() {
        locationsSearchResults.bringCurrentLocation()
    }
    
    func hideCurrentLocation() {
        locationsSearchResults.hideCurrentLocation()
    }
    
}
