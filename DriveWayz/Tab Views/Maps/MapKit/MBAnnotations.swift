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
var mapAnnotationID: [String] = []

extension MapKitViewController {
    
    func observeAllParking() {
        mapAnnotationID = []
        dynamicPricing.readCityCSV()
        let ref = Database.database().reference().child("ParkingSpots")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.removeAllHostLocations()
                let park = ParkingSpots(dictionary: dictionary)
                let parkingID = dictionary["parkingID"] as! String
                self.parkingSpotsDictionary[parkingID] = park
                self.parkingSpots = Array(self.parkingSpotsDictionary.values)
                
                DispatchQueue.main.async {
                    self.placeAllAnnotations()
                }
            }
        }
    }
    
    func placeAllAnnotations() {
        for parking in self.parkingSpots {
            if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let marker = MGLPointAnnotation()
                marker.coordinate = location.coordinate
                if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
                    marker.title = ID
                    mapAnnotationID.append(ID)
                    self.mapView.addAnnotation(marker)
                }
            }
        }
    }
    
    func checkAnnotationsNearDestination(location: CLLocationCoordinate2D) {
        self.availableParkingSpots = []
        for parking in self.parkingSpots {
            if let latitude = parking.latitude, let longitude = parking.longitude {
                let parkingDestination = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
                let distance = location.distance(to: parkingDestination)
                if distance <= 1609.34 { //1 mile walking
                    parking.parkingDistance = Double(distance)
                    self.availableParkingSpots.append(parking)
                }
            }
        }
        if let fromDate = bookingFromDate, let toDate = bookingToDate {
            DynamicParking.getDynamicParking(parkingSpots: self.availableParkingSpots, dateFrom: fromDate, dateTo: toDate) { (parking) in
                self.availableParkingSpots = parking
                self.removeAllHostLocations()
                self.placeAvailableParking(location: location)
            }
        }
    }
    
    func placeAvailableParking(location: CLLocationCoordinate2D) {
        var index = 0
        mapAnnotationID = []
        for parking in self.availableParkingSpots {
            if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let marker = MGLPointAnnotation()
                marker.coordinate = location.coordinate
                if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
                    marker.title = ID
                    mapAnnotationID.append(ID)
                    self.mapView.addAnnotation(marker)
                }
            }
            if let destination = DestinationAnnotationLocation, let state = parking.stateAddress, let city = parking.cityAddress {
                dynamicPricing.getDynamicPricing(parking: parking, place: destination.coordinate, state: state, city: city, overallDestination: location) { (dynamicPrice) in
                    parking.dynamicCost = Double(dynamicPrice)
                    index += 1
                
                    if index == self.availableParkingSpots.count {
                        print(numberOfTotalParkingSpots)
                        DispatchQueue.main.async {
                            self.organizeParkingLocations()
                        }
                    }
                }
            }
        }
    }
    
    func placeAvailable() {
        mapAnnotationID = []
        if self.availableParkingSpots.count > 0 {
            for parking in self.availableParkingSpots {
                if let latitude = parking.latitude as? CLLocationDegrees, let longitude = parking.longitude as? CLLocationDegrees {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let marker = MGLPointAnnotation()
                    marker.coordinate = location.coordinate
                    if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
                        marker.title = ID
                        mapAnnotationID.append(ID)
                        self.mapView.addAnnotation(marker)
                    }
                }
            }
        } else {
            delayWithSeconds(1) {
                self.parkingHidden(showMainBar: true)
                self.createSimpleAlert(title: "No parking in this area", message: "Sign up to be a host today to help improve your parking community!")
            }
        }
    }
    
    func organizeParkingLocations() {
        var closeParkingSpots = self.availableParkingSpots.sorted(by: { $0.parkingDistance! < $1.parkingDistance! })
        var cheapestParkingSpots = self.availableParkingSpots.sorted(by: { $0.parkingCost! < $1.parkingCost! })
        var bookingSpots: [ParkingSpots] = []
        if let closestParking = closeParkingSpots.first {
            bookingSpots.append(closestParking)
            closeParkingSpots.remove(at: 0)
            if let cheapIndex = cheapestParkingSpots.index(of: closestParking) {
                cheapestParkingSpots.remove(at: cheapIndex)
                if let cheapestParking = cheapestParkingSpots.first {
                    bookingSpots.append(cheapestParking)
                    if let closeIndex = closeParkingSpots.index(of: cheapestParking) {
                        closeParkingSpots.remove(at: closeIndex)
                        for parking in closeParkingSpots {
                            bookingSpots.append(parking)
                        }
                        self.parkingController.parkingSpots = bookingSpots
                    }
                }
            } else {
                //no parking
            }
        } else {
            //no parking
        }
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // For better performance, always try to reuse existing annotations.
        if let title = annotation.title, title == "Destination" {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "destinationMarkerIcon")
            
            // If there is no reusable annotation image available, initialize a new one.
            if(annotationImage == nil) {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "destinationMarkerIcon")!, reuseIdentifier: "destinationMarkerIcon")
            }
            
            return annotationImage
        } else if let title = annotation.title, let parkingID = title, let parking = self.parkingSpotsDictionary[parkingID] {
            if parking.isSpotAvailable == false {
                var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationUnavailableMarker")
                
                // If there is no reusable annotation image available, initialize a new one.
                if(annotationImage == nil) {
                    annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationUnavailableMarker")!, reuseIdentifier: "annotationUnavailableMarker")
                }
                
                return annotationImage
            } else {
                var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationMapMarker")
                
                // If there is no reusable annotation image available, initialize a new one.
                if(annotationImage == nil) {
                    annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationMapMarker")!, reuseIdentifier: "annotationMapMarker")
                }
                
                return annotationImage
            }
        } else {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationMapMarker")
            
            // If there is no reusable annotation image available, initialize a new one.
            if(annotationImage == nil) {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationMapMarker")!, reuseIdentifier: "annotationMapMarker")
            }
            
            return annotationImage
        }
    }
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message != "" {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            self.present(alert, animated: true)
            delayWithSeconds(1) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
