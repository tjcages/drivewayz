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
    
    func bringRecentView() {
        self.resultsScrollView.contentSize = CGSize.zero
        self.resultsScrollAnchor.constant = 110
        UIView.animate(withDuration: animationOut) {
            self.locationRecentHeightAnchor.constant = 110
            self.locationRecentResults.view.layer.cornerRadius = 10
            self.view.layoutIfNeeded()
        }
    }
    
    func hideRecentView() {
        self.resultsScrollView.contentSize = CGSize(width: self.view.frame.width, height: 400)
        switch device {
        case .iphone8:
            self.resultsScrollAnchor.constant = 250
        case .iphoneX:
            self.resultsScrollAnchor.constant = 300
        }
        UIView.animate(withDuration: animationOut) {
            self.locationRecentHeightAnchor.constant = 10
            self.locationRecentResults.view.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }
    }
    
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
        self.mapView.setCenter(coordinate, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.bringSubviewToFront(resultsScrollView)
        self.view.bringSubviewToFront(mainBar)
        self.view.bringSubviewToFront(speechSearchResults.view)
        self.locationRecentResults.checkRecentSearches()
        self.resultsScrollAnchor.constant = 0
        self.eventsControllerHidden()
        self.searchBar.text = ""
        UIView.animate(withDuration: animationIn, animations: {
            self.locationRecentResults.view.alpha = 1
            self.clearView.alpha = 1
            self.microphoneButton.alpha = 1
            self.mainBar.layer.cornerRadius = 0
//            self.diamondTopAnchor.constant = 30
            self.mainBarTopAnchor.constant = 0
            self.mainBarWidthAnchor.constant = 0
            self.microphoneRightAnchor.constant = 30
            switch device {
            case .iphone8:
                self.mainBarHeightAnchor.constant = 122
            case .iphoneX:
                self.mainBarHeightAnchor.constant = 142
            }
            hamburgerButton.alpha = 0
            self.locatorButton.alpha = 0
            self.darkBlurView.alpha = 0.4
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.searchLabel.alpha = 1
                self.resultsScrollAnchor.constant = 110
                self.view.layoutIfNeeded()
            })
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bringRecentView()
        UIView.animate(withDuration: 0.1, animations: {
            self.searchLabel.alpha = 0
            self.locationRecentResults.view.alpha = 0
            self.clearView.alpha = 0
            self.resultsScrollAnchor.constant = 0
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.microphoneButton.alpha = 0
                self.mainBar.layer.cornerRadius = 5
                self.mainBarHeightAnchor.constant = 60
                self.mainBarWidthAnchor.constant = -72
                self.microphoneRightAnchor.constant = 4
                if self.mainBarTopAnchor.constant != -100 {
                    switch device {
                    case .iphone8:
                        self.mainBarTopAnchor.constant = 100
                    case .iphoneX:
                        self.mainBarTopAnchor.constant = 120
                    }
                }
//                self.diamondTopAnchor.constant = 0
                hamburgerButton.alpha = 1
                self.locatorButton.alpha = 1
                self.darkBlurView.alpha = 0
                self.locationsSearchResults.view.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.searchBar.text = "Where are you parking?"
                self.view.bringSubviewToFront(self.darkBlurView)
            })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
