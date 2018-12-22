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
            self.locationRecentHeightAnchor.constant = 120
            self.locationRecentResults.view.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get data
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        // Create Annotation
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        annotation.title = "\(place.name)"
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        searchBar.text = place.formattedAddress
        
        // Zoom in on coordinate
        let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.bringSubviewToFront(resultsScrollView)
        self.view.bringSubviewToFront(mainBar)
        self.view.bringSubviewToFront(speechSearchResults.view)
        self.locationRecentResults.checkRecentSearches()
        self.resultsScrollAnchor.constant = 0
        self.eventsControllerHidden()
        UIView.animate(withDuration: animationIn, animations: {
            self.locationRecentResults.view.alpha = 1
            self.clearView.alpha = 1
            self.microphoneButton.alpha = 1
            self.mainBar.layer.cornerRadius = 0
            self.diamondTopAnchor.constant = 30
            self.mainBarTopAnchor.constant = 0
            self.mainBarWidthAnchor.constant = 0
            self.microphoneRightAnchor.constant = 30
            switch device {
            case .iphone8:
                self.mainBarHeightAnchor.constant = 122
            case .iphoneX:
                self.mainBarHeightAnchor.constant = 142
            }
            self.hamburgerButton.alpha = 0
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
                switch device {
                case .iphone8:
                    self.mainBarTopAnchor.constant = 100
                case .iphoneX:
                    self.mainBarTopAnchor.constant = 120
                }
                self.diamondTopAnchor.constant = 0
                self.hamburgerButton.alpha = 1
                self.locatorButton.alpha = 1
                self.darkBlurView.alpha = 0
                self.locationsSearchResults.view.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.view.bringSubviewToFront(self.darkBlurView)
            })
        }
    }
    
    func zoomToSearchLocation(address: String) {
        self.searchBar.text = address
        self.dismissKeyboard()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print(error?.localizedDescription as Any)
                    return
            }
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
