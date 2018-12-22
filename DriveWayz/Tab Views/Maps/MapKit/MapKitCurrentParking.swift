//
//  MapKitCurrentParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit

extension MapKitViewController {
    
    func checkCurrentParking() {
        var avgRating: Double = 5
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded, with: { (snapshot) in
                //                CurrentParkingViewController().checkCurrentParking()
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let parkingID = dictionary["parkingID"] as? String
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    parkingRef.observeSingleEvent(of: .value, with: { (pull) in
                        if var pullRef = pull.value as? [String:AnyObject] {
                            let parkingCity = pullRef["parkingCity"] as? String
                            let parkingImageURL = pullRef["parkingImageURL"] as? String
                            let parkingCost = pullRef["parkingCost"] as? String
                            let timestamp = pullRef["timestamp"] as? NSNumber
                            let id = pullRef["id"] as? String
                            let parkingID = pullRef["parkingID"] as? String
                            let parkingAddress = pullRef["parkingAddress"] as? String
                            let message = pullRef["message"] as? String
                            self.destinationString = parkingAddress!
                            
                            let geoCoder = CLGeocoder()
                            geoCoder.geocodeAddressString(parkingAddress!) { (placemarks, error) in
                                guard
                                    let placemarks = placemarks,
                                    let location = placemarks.first?.location
                                    else {
                                        print("MapKit can't find location")
                                        return
                                }
                                self.informationViewController.parkingLocation = location
                                DispatchQueue.main.async(execute: {
                                    if let myLocation: CLLocation = self.mapView.userLocation.location {
                                        let distanceToParking = (location.distance(from: myLocation)) / 1609.34 // miles
                                        let roundedStepValue = Double(round(10 * distanceToParking) / 10)
                                        let formattedDistance = String(format: "%.1f", roundedStepValue)
                                        
                                        self.destination = location
                                        self.currentData = .yesReserved
                                        self.drawCurrentPath(dest: location, navigation: false)
                                        
                                        if let rating = pullRef["rating"] as? Double {
                                            let reviewsRef = parkingRef.child("Reviews")
                                            reviewsRef.observeSingleEvent(of: .value, with: { (count) in
                                                let counting = count.childrenCount
                                                if counting == 0 {
                                                    avgRating = rating
                                                } else {
                                                    avgRating = rating / Double(counting)
                                                }
                                                self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
                                                UIView.animate(withDuration: 0.5, animations: {
                                                    currentButton.alpha = 1
                                                })
                                            })
                                        } else {
                                            self.informationViewController.setData(cityAddress: parkingCity!, imageURL: parkingImageURL!, parkingCost: parkingCost!, formattedAddress: parkingAddress!, timestamp: timestamp!, id: id!, parkingID: parkingID!, parkingDistance: formattedDistance, rating: avgRating, message: message!)
                                            UIView.animate(withDuration: 0.5, animations: {
                                                currentButton.alpha = 1
                                                self.purchaseViewController.view.alpha = 0
                                                self.view.layoutIfNeeded()
                                            })
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }, withCancel: nil)
            currentRef.observe(.childRemoved, with: { (snapshot) in
                self.parkingSpots = []
                self.parkingSpotsDictionary = [:]
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                alreadyLoadedSpots = false
                self.searchedForPlace = false
                self.currentActive = false
                
                let mapOverlays = self.mapView.overlays
                self.mapView.removeOverlays(mapOverlays)
                let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate
                var region = MKCoordinateRegion()
                region.center = location
                region.span.latitudeDelta = 0.01
                region.span.longitudeDelta = 0.01
                self.mapView.setRegion(region, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    currentButton.alpha = 0
                    self.purchaseViewController.view.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.currentData = .notReserved
                self.currentParkingDisappear()
                self.currentParkingController.stopTimerTest()
                DispatchQueue.main.async {
                    self.observeUserParkingSpots()
                }
            }, withCancel: nil)
        } else {
            return
        }
    }
    
}
