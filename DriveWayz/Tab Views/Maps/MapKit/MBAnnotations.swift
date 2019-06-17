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
    
    func placeAllAnnotations() {
        for parking in self.parkingSpots {
            if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let marker = MGLPointAnnotation()
                marker.title = parking.overallAddress
                marker.coordinate = location.coordinate
                self.mapView.addAnnotation(marker)
                //                self.mainBarController.parkingState = .foundParking
            }
        }
    }

    func observeAllParking(location: String) {
        let city = userCity
        if city != location {
            userCity = location
            var parkingSpots: [String] = []
            if !isCurrentlyBooked {
                let ref = Database.database().reference().child("ParkingLocations").child(location)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    numberOfTotalParkingSpots = Int(snapshot.childrenCount)
                    print("number of total parking spots: \(numberOfTotalParkingSpots)")
                    ref.observe(.childAdded) { (snapshot) in
                        if let key = snapshot.value as? String {
                            parkingSpots.append(key)
                            if parkingSpots.count == numberOfTotalParkingSpots {
                                for parking in parkingSpots {
                                    let ref = Database.database().reference().child("ParkingSpots").child(parking)
                                    ref.observe(.value, with: { (snapshot) in
                                        if var dictionary = snapshot.value as? [String:AnyObject] {
                                            let park = ParkingSpots(dictionary: dictionary)
                                            let parkingID = dictionary["parkingID"] as! String
                                            self.parkingSpotsDictionary[parkingID] = park
                                            self.parkingSpots = Array(self.parkingSpotsDictionary.values)
                                            
                                            if parking == parkingSpots.last {
                                                DispatchQueue.main.async {
                                                    self.organizeAvailableParking()
                                                }
                                            }
                                        }
                                    }) { (error) in
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.organizeAvailableParking()
        }
    }
    
    func organizeAvailableParking() {
        if let fromDate = bookingFromDate, let toDate = bookingToDate {
            DynamicParking.getDynamicParking(parkingSpots: self.parkingSpots, dateFrom: fromDate, dateTo: toDate) { (parkingSpots) in
                self.availableParkingSpots = parkingSpots
                self.placeAvailableParking(shouldDraw: true)
            }
        }
    }
    
    func placeAvailableParking(shouldDraw: Bool) {
        for parking in self.availableParkingSpots {
            if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let marker = MGLPointAnnotation()
                marker.title = parking.overallAddress
                marker.coordinate = location.coordinate
                self.mapView.addAnnotation(marker)
                //                self.mainBarController.parkingState = .foundParking
                if parking == self.availableParkingSpots.last && shouldDraw == true {
                    if let destination = DestinationAnnotationLocation {
                        self.organizeParkingLocation(searchLocation: destination)
                    }
                }
            }
        }
    }
    
    func organizeParkingLocation(searchLocation: CLLocation) {
        var cheapestParkingSpots: [ParkingSpots] = []
        var closeParkingSpots: [ParkingSpots] = []
        var bookingSpots: [ParkingSpots] = []
        if self.availableParkingSpots.count > 0 {
            for parking in self.availableParkingSpots {
                if let latitude = parking.latitude as? Double, let longitude = parking.longitude as? Double, let state = parking.stateAddress, let city = parking.cityAddress {
                    let coordinates = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                    let distance = searchLocation.distance(from: coordinates)
                    parking.parkingDistance = distance
                    dynamicPricing.getDynamicPricing(place: coordinates.coordinate, state: state, city: city, overallDestination: searchLocation.coordinate) { (dynamicPrice: CGFloat) in
                        parking.parkingCost = dynamicPrice
                        if !cheapestParkingSpots.contains(parking) {
                            cheapestParkingSpots.append(parking)
                        }
                        if cheapestParkingSpots.count == self.availableParkingSpots.count {
                            DispatchQueue.main.async {
                                closeParkingSpots = cheapestParkingSpots.sorted(by: { $0.parkingDistance! > $1.parkingDistance! })
                                if let closestBooking = closeParkingSpots.last {
                                    bookingSpots.append(closestBooking)
                                    self.parkingController.parkingSpots = bookingSpots
                                    
                                    cheapestParkingSpots = cheapestParkingSpots.dropLast()
                                    cheapestParkingSpots = cheapestParkingSpots.sorted(by: { $0.parkingCost! > $1.parkingCost! })
                                    if let cheapestBooking = cheapestParkingSpots.last {
                                        bookingSpots.append(cheapestBooking)
                                        cheapestParkingSpots = cheapestParkingSpots.dropLast()
                                        
                                        closeParkingSpots = cheapestParkingSpots.sorted(by: { $0.parkingDistance! > $1.parkingDistance! })
                                        for park in closeParkingSpots {
                                            bookingSpots.append(park)
                                        }
                                        self.parkingController.parkingSpots = bookingSpots
                                    }
                                }
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
    
    //if a user taps a parking spot
    func findParkingNearUserLocation() {
        if let userLocation = locationManager.location {
            self.organizeParkingLocation(searchLocation: userLocation)
        }
    }
    
}
