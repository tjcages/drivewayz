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
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get data
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        // Create Annotation
        let annotation = MGLPointAnnotation()
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        annotation.title = "\(place.name)"
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        searchBar.text = place.formattedAddress
        
        // Zoom in on coordinate
//        self.mapView.setCenter(coordinate, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fromSearchBar && fromSearchBar.text == "Current location" {
            self.fromSearchBar.text = ""
            self.fromSearchBar.textColor = Theme.BLACK
            return true
        } else if textField == searchBar && self.mainBarHeightAnchor.constant != 60 && self.locationResultsHeightAnchor.constant != 0 {
            return true
        } else {
            expandSearchBar()
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fromSearchBar && fromSearchBar.text == "" {
            self.fromSearchBar.text = "Current location"
            self.fromSearchBar.textColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.8)
        } else if textField == searchBar && self.mainBarHeightAnchor.constant != 60 {
            self.hideSearchBar(regular: true)
        }
    }
    
    func expandSearchBar() {
        self.takeAwayEvents()
        self.delegate?.hideHamburger()
        self.searchBar.text = ""
        self.shouldBeLoading = false
        self.mainBarWidthAnchor.constant = self.view.frame.width + 6
        switch device {
        case .iphone8:
            self.mainBarHeightAnchor.constant = 190
        case .iphoneX:
            self.mainBarHeightAnchor.constant = 210
        }
        self.mainBarTopAnchor.constant = 0
        self.searchBarBottomAnchor.constant = -35
        self.searchBarLeftAnchor.constant = (self.view.frame.width - 300)/2
        self.fromSeachTopAnchor.constant = -10
        self.searchBar.font = Fonts.SSPRegularH4
        UIView.animate(withDuration: animationIn, animations: {
            self.searchBackButton.alpha = 1
            self.fromSearchBar.alpha = 1
            self.searchLocation.alpha = 0.1
            self.couponView.view.alpha = 0
            self.fromSearchLocation.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
            self.locationsSearchResults.checkRecentSearches()
            self.locationResultsHeightAnchor.constant = self.view.frame.height - self.mainBarHeightAnchor.constant + 80
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.searchBar.becomeFirstResponder()
                self.locationResultsHeightAnchor.constant = self.view.frame.height - self.mainBarHeightAnchor.constant - 220
                UIView.animate(withDuration: animationOut, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func hideSearchBar(regular: Bool) {
        if eventsAreAllowed == true {
            self.eventsControllerHidden()
        }
        self.shouldBeLoading = false
        self.locationResultsHeightAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainBarHeightAnchor.constant = 60
            if regular == true {
                self.mainBarWidthAnchor.constant = 300
                switch device {
                case .iphone8:
                    self.mainBarTopAnchor.constant = 100
                case .iphoneX:
                    self.mainBarTopAnchor.constant = 120
                }
            } else {
                self.mainBarTopAnchor.constant = -130
            }
            self.searchBarBottomAnchor.constant = -30
            self.searchBarLeftAnchor.constant = 16
            self.searchBar.font = Fonts.SSPRegularH3
            UIView.animate(withDuration: animationIn, animations: {
                self.fromSearchBar.alpha = 0
                self.searchLocation.alpha = 0
                self.couponView.view.alpha = 1
                self.fromSearchLocation.alpha = 0
                self.loadingParkingLine.alpha = 0
                self.searchBackButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.bringHamburger()
                self.searchBar.text = "Where are you headed?"
                self.fromSearchBar.text = "Current location"
                self.fromSearchBar.textColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.8)
                switch solar {
                case .day:
                    self.delegate?.defaultContentStatusBar()
                case .night:
                    self.delegate?.defaultContentStatusBar()
//                    self.delegate?.lightContentStatusBar()
                }
            }
        }
    }
    
    func beginSearchingForParking() {
        self.takeAwayEvents()
        self.shouldBeLoading = true
        self.locationResultsHeightAnchor.constant = 0
        self.mainBarWidthAnchor.constant = 300
        self.mainBarHeightAnchor.constant = 120
        switch device {
        case .iphone8:
            self.mainBarTopAnchor.constant = 80
        case .iphoneX:
            self.mainBarTopAnchor.constant = 100
        }
        self.searchBarBottomAnchor.constant = -30
        self.searchBarLeftAnchor.constant = 16
        self.fromSeachTopAnchor.constant = -10
//        self.searchBar.font = Fonts.SSPRegularH3
        UIView.animate(withDuration: animationIn, animations: {
            self.fromSearchBar.alpha = 1
            self.searchLocation.alpha = 0
            self.fromSearchLocation.alpha = 0
            self.couponView.view.alpha = 0
            self.loadingParkingLine.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.loadingParking(caseB: true)
            switch solar {
            case .day:
                hamburgerView1.backgroundColor = Theme.BLACK
                hamburgerView2.backgroundColor = Theme.BLACK
                hamburgerView3.backgroundColor = Theme.BLACK
                self.delegate?.defaultContentStatusBar()
            case .night:
                hamburgerView1.backgroundColor = Theme.BLACK
                hamburgerView2.backgroundColor = Theme.BLACK
                hamburgerView3.backgroundColor = Theme.BLACK
                self.delegate?.defaultContentStatusBar()
//                hamburgerView1.backgroundColor = Theme.WHITE
//                hamburgerView2.backgroundColor = Theme.WHITE
//                hamburgerView3.backgroundColor = Theme.WHITE
//                self.delegate?.lightContentStatusBar()
            }
        }
    }
    
    func loadingParking(caseB: Bool) {
        if shouldBeLoading == true {
            self.loadingParkingWidthAnchor.constant = 100
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.loadingParkingLeftAnchor.isActive = false
                self.loadingParkingRightAnchor.isActive = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    self.loadingParkingWidthAnchor.constant = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        self.loadingParkingLeftAnchor.isActive = true
                        self.loadingParkingRightAnchor.isActive = false
                        self.view.layoutIfNeeded()
                        self.loadingParking(caseB: true)
                    })
                })
            }
        }
    }
    
    @objc func searchBackButtonPressed() {
        self.view.endEditing(true)
        self.hideSearchBar(regular: true)
        self.findParkingNearUserLocation()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
