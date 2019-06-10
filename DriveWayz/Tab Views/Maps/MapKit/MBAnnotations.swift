//
//  MBAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import CoreLocation
import Mapbox

var numberOfTotalParkingSpots: Int = 0

extension MapKitViewController {

    func observeAllParking(location: String) {
        var parkingSpots: [String] = []
        if !isCurrentlyBooked {
            let ref = Database.database().reference().child("ParkingLocations").child(location)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                numberOfTotalParkingSpots = Int(snapshot.childrenCount)
                ref.observe(.childAdded) { (snapshot) in
                    if let key = snapshot.value as? String {
                        parkingSpots.append(key)
                        if parkingSpots.count == numberOfTotalParkingSpots {
                            for parking in parkingSpots {
                                let ref = Database.database().reference().child("ParkingSpots").child(parking)
                                ref.observe(.value, with: { (snapshot) in
                                    if var dictionary = snapshot.value as? [String:AnyObject] {
                                        let parking = ParkingSpots(dictionary: dictionary)
                                        let parkingID = dictionary["parkingID"] as! String
                                        self.parkingSpotsDictionary[parkingID] = parking
                                        self.parkingSpots = Array(self.parkingSpotsDictionary.values)
                    
                                        if self.parkingSpotsDictionary.count == numberOfTotalParkingSpots {
                                            self.placeAllAnnotations()
                                        }
                                    }
                                }) { (error) in
                                    print(error.localizedDescription)
                                }
                            }
                            
                            
//                            DynamicParking.getDynamicParking(parkingIDs: parkingSpots) { (parking) in
//                                self.parkingSpots = parking
//                                self.availableParkingSpots = parking
//                                self.placeAllAnnotations()
//                            }
                        }
                    }
                }
            }
        }
    }
    
    func placeAllAnnotations() {
        for i in 0..<self.parkingSpots.count {
            let parking = self.parkingSpots[i]
            if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let marker = MGLPointAnnotation()
                marker.title = parking.parkingCost
                marker.coordinate = location.coordinate
                marker.subtitle = "\(i)"
                self.mapView.addAnnotation(marker)
//                self.mainBarController.parkingState = .foundParking
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func organizeParkingLocation(searchLocation: CLLocation, shouldDraw: Bool) {
        self.closeParkingSpots = []
        self.cheapestParkingSpots = []
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
        for i in 0..<availableParkingSpots.count {
            let parking = self.availableParkingSpots[i]
            if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                self.closeParkingSpots.append(parking)
                let marker = MGLPointAnnotation()
                marker.title = parking.parkingCost
                marker.coordinate = location.coordinate
                marker.subtitle = "\(i)"
                self.mapView.addAnnotation(marker)
                self.mainBarController.parkingState = .foundParking
            }
        }
        delayWithSeconds(0.3) {
            if self.closeParkingSpots.count > 0 && self.closeParkingSpots.count != self.visibleParkingSpots {
                self.visibleParkingSpots = self.closeParkingSpots.count
                self.mainBarController.parkingState = .foundParking
            } else if self.closeParkingSpots.count == 0 {
                self.visibleParkingSpots = self.closeParkingSpots.count
                self.mainBarController.parkingState = .noParking
            } else if self.closeParkingSpots.count > 0 {
                self.mainBarController.parkingState = .foundParking
            }
        }
        self.closeParkingSpots = self.closeParkingSpots.sorted(by: { $0.parkingDistance! > $1.parkingDistance! })
        self.cheapestParkingSpots = self.closeParkingSpots.sorted(by: { $0.parkingCost! > $1.parkingCost! })
        if shouldDraw == true {
            if let closestSpot = self.closeParkingSpots.last {
                let latitude = closestSpot.latitude
                let longitude = closestSpot.longitude
                let location = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                if let address = closestSpot.overallAddress {
//                    self.mapView.setCenter(location.coordinate, animated: false)
                    if let userLocation = locationManager.location {
                        self.findBestParking(location: location, sourceLocation: userLocation, searchLocation: searchLocation, address: address)
                        delayWithSeconds(1.6) {
                            self.dismissKeyboard()
                        }
                        if let bestPrice = self.cheapestParkingSpots.last {
                            let latitude = bestPrice.latitude
                            let longitude = bestPrice.longitude
                            let bestLocation = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                            if let address = bestPrice.overallAddress {
                                self.drawCurrentPath(dest: searchLocation, start: bestLocation, type: "ParkingBestPrice", address: address) { (results: CLLocationCoordinate2D) in
                                    self.findBestLatLong(first: userLocation, second: bestLocation, third: searchLocation, type: "Second")
                                    self.findBestLatLong(first: bestLocation, second: bestLocation, third: searchLocation, type: "SecondPurchase")
                                    self.drawCurrentPath(dest: bestLocation, start: userLocation, type: "ParkingBestPriceP", address: address) { (results: CLLocationCoordinate2D) in }
                                }
                            }
                        }
                        if let standardSpot = self.closeParkingSpots.dropLast().last {
                            let latitude = standardSpot.latitude
                            let longitude = standardSpot.longitude
                            let standardLocation = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                            if let address = standardSpot.overallAddress {
                                self.drawCurrentPath(dest: searchLocation, start: standardLocation, type: "ParkingStandardSpot", address: address) { (results: CLLocationCoordinate2D) in
                                    self.findBestLatLong(first: userLocation, second: standardLocation, third: searchLocation, type: "Third")
                                    self.findBestLatLong(first: standardLocation, second: standardLocation, third: searchLocation, type: "ThirdPurchase")
                                    self.drawCurrentPath(dest: standardLocation, start: userLocation, type: "ParkingStandardSpotP", address: address) { (results: CLLocationCoordinate2D) in }
                                }
                            }
                        }
                    }
                }
            } else {
                delayWithSeconds(2.4) {
                    self.parkingSelected()
                    self.dismissKeyboard()
//                    self.parkingController.noBookingFound()
                }
            }
        }
    }
    
    func findParkingNearUserLocation() {
        if let userLocation = locationManager.location {
            self.organizeParkingLocation(searchLocation: userLocation, shouldDraw: false)
        }
    }
    
}
