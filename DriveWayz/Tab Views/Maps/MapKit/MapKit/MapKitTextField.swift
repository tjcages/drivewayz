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
        
        // Zoom in on coordinate
//        self.mapView.setCenter(coordinate, animated: true)
    }
    
    func expandSearchBar() {
        self.mainBarController.searchLabel.text = ""
        self.mainBarController.searchLabel.font = Fonts.SSPRegularH4
        UIView.animate(withDuration: animationIn, animations: {
            self.locationsSearchResults.checkRecentSearches()
            self.locationResultsHeightAnchor.constant = self.view.frame.height - self.mainBarHeightAnchor.constant + 80
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainBarController.searchLabel.becomeFirstResponder()
        }
    }
    
    func hideSearchBar(regular: Bool) {
        if eventsAreAllowed == true {
            self.eventsControllerHidden()
        }
        self.locationResultsHeightAnchor.constant = 0
        self.mainBarController.searchLabel.font = Fonts.SSPRegularH3
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func beginSearchingForParking() {
        self.takeAwayEvents()
        self.locationResultsHeightAnchor.constant = 0
//        self.searchBar.font = Fonts.SSPRegularH3
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
           
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
