//
//  MBAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
//import Mapbox

var numberOfTotalParkingSpots: Int = 0
var mapAnnotationID: [String] = []

extension MapKitViewController {
    
    func monitorSurge() {
        let ref = Database.database().reference().child("Surge")
        ref.child("SurgeDemand").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: [String: [String: [String: Int]]]] {
                SurgeDemand = dictionary
            }
        }
        ref.child("SurgeDemand").observe(.childChanged) { (snapshot) in
            let key = snapshot.key
            if let dictionary = snapshot.value as? [String: [String: [String: Int]]] {
                SurgeDemand?[key] = dictionary
            }
        }
        ref.child("SurgeCheck").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: [String: [String: [String: Int]]]] {
                SurgeCheck = dictionary
            }
        }
        ref.child("SurgeCheck").observe(.childChanged) { (snapshot) in
            let key = snapshot.key
            if let dictionary = snapshot.value as? [String: [String: [String: Int]]] {
                SurgeCheck?[key] = dictionary
            }
        }
        ref.child("SurgeValues").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let percentage = dictionary["surgePercentage"] as? CGFloat {
                    surgePercentage = percentage
                }
                if let cutoff = dictionary["surgeCutoff"] as? CGFloat {
                    surgeCutoff = cutoff
                }
                if let reduction = dictionary["percentReduction"] as? CGFloat {
                    percentReduction = reduction
                }
            }
        }
    }
    
    func observeAllParking() {
        if BookedState != .currentlyBooked {
            mapAnnotationID = []
            let ref = Database.database().reference().child("ParkingSpots")
            ref.observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let park = ParkingSpots(dictionary: dictionary)
                    if let parkingID = dictionary["parkingID"] as? String {
                        
                        if let zip = park.zipAddress, let city = park.cityAddress, let state = park.stateAddress, let number = park.numberSpots {
                            let tempRef = Database.database().reference().child("Surge").child("SurgeDemand").child(state).child(city).child(zip).child(parkingID)
                            tempRef.setValue(Int(number))
                            let checkRef = Database.database().reference().child("Surge").child("SurgeCheck").child(state).child(city).child(zip).child(parkingID)
                            checkRef.setValue(Int(number))
                        }
                        
                        DynamicParking.getDynamicParking(parkingSpot: park, dateFrom: bookingFromDate, dateTo: bookingToDate) { (parking) in
                            self.parkingSpotsDictionary[parkingID] = parking
                            self.parkingSpots = Array(self.parkingSpotsDictionary.values)
                            
                            self.placeAvailableParking(parking: parking)
                        }
                    }
                }
            }
        }
    }
    
    func placeAvailableParking(parking: ParkingSpots) {
        if let latitude = parking.latitude, let longitude = parking.longitude {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            let position = location.coordinate
            let marker = GMSMarker(position: position)
            if let id = parking.parkingID {
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.title = id
                mapAnnotationID.append(id)
            }
            if parking.isSpotAvailable {
                marker.icon = UIImage(named: "annotationMapMarker")
            } else {
                marker.icon = UIImage(named: "annotationUnavailableMarker")
            }
            marker.map = mapView
            
//            let marker = MGLPointAnnotation()
//            marker.coordinate = location.coordinate
//            if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
//                marker.title = ID
//                mapAnnotationID.append(ID)
//                self.mapView.addAnnotation(marker)
//            }
        }
        if let location = DestinationAnnotationLocation {
            let position = location.coordinate
            let marker = GMSMarker(position: position)
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.title = "Destination"
            marker.icon = UIImage(named: "annotationMapMarker")
            marker.map = mapView
            
//            let marker = MGLPointAnnotation()
//            marker.coordinate = location.coordinate
//            marker.title = "Destination"
//            self.mapView.addAnnotation(marker)
            self.checkAnnotationsNearDestination(location: location.coordinate, checkDistance: true)
        }
    }
    
    func placeAllAnnotations() {
        for parking in self.parkingSpots {
            if let latitude = parking.latitude, let longitude = parking.longitude {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                
                let position = location.coordinate
                let marker = GMSMarker(position: position)
                if let id = parking.parkingID {
                    marker.appearAnimation = GMSMarkerAnimation.pop
                    marker.title = id
                    mapAnnotationID.append(id)
                }
                if parking.isSpotAvailable {
                    marker.icon = UIImage(named: "annotationMapMarker")
                } else {
                    marker.icon = UIImage(named: "annotationUnavailableMarker")
                }
                marker.map = mapView
//                let marker = MGLPointAnnotation()
//                marker.coordinate = location.coordinate
//                if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
//                    marker.title = ID
//                    mapAnnotationID.append(ID)
//                    self.mapView.addAnnotation(marker)
//                }
            }
        }
        if let location = DestinationAnnotationLocation {
            let position = location.coordinate
            let marker = GMSMarker(position: position)
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.title = "Destination"
            marker.icon = UIImage(named: "annotationMapMarker")
            marker.map = mapView
            
//            let marker = MGLPointAnnotation()
//            marker.coordinate = location.coordinate
//            marker.title = "Destination"
//            self.mapView.addAnnotation(marker)
            self.checkAnnotationsNearDestination(location: location.coordinate, checkDistance: true)
        }
    }
    
    func checkAnnotationsNearDestination(location: CLLocationCoordinate2D, checkDistance: Bool) {
        self.availableParkingSpots = []
        for parking in self.parkingSpots {
            if let latitude = parking.latitude, let longitude = parking.longitude {
                let parkingDestination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let distance = location.distance(to: parkingDestination)
                if distance <= (1609.34 * 2) && checkDistance { //2 mile walking
                    parking.parkingDistance = Double(distance)
                    self.availableParkingSpots.append(parking)
                } else if distance <= (1609.34 * 6) && !checkDistance {
                    parking.parkingDistance = Double(distance)
                    self.availableParkingSpots.append(parking)
                }
            }
        }
        DispatchQueue.main.async {
            self.organizeParkingLocations()
        }
    }
    
//    func placeAvailableParking(location: CLLocationCoordinate2D) {
//        var index = 0
//        mapAnnotationID = []
//        for parking in self.availableParkingSpots {
//            if let latitude = parking.latitude, let longitude = parking.longitude {
//                let location = CLLocation(latitude: latitude, longitude: longitude)
//                let marker = MGLPointAnnotation()
//                marker.coordinate = location.coordinate
//                if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
//                    marker.title = ID
//                    mapAnnotationID.append(ID)
//                    self.mapView.addAnnotation(marker)
//                }
//            }
//            if let destination = DestinationAnnotationLocation, let state = parking.stateAddress, let city = parking.cityAddress {
//                dynamicPricing.getDynamicPricing(parking: parking, place: destination.coordinate, state: state, city: city, overallDestination: location) { (dynamicPrice) in
//                    parking.dynamicCost = Double(dynamicPrice)
//                    index += 1
//
//                    if index == self.availableParkingSpots.count {
//                        DispatchQueue.main.async {
//                            self.organizeParkingLocations()
//                        }
//                    }
//                }
//            }
//        }
//        delayWithSeconds(1) {
//            if self.availableParkingSpots.count == 0 {
//                self.parkingHidden(showMainBar: true)
//                self.createSimpleAlert(title: "No parking in this area", message: "Sign up to be a host today to help improve your parking community!")
//                self.placeAllAnnotations()
//            }
//        }
//    }
    
    func placeAvailable() {
        mapAnnotationID = []
//        if self.availableParkingSpots.count > 0 {
//            for parking in self.availableParkingSpots {
//                if let latitude = parking.latitude, let longitude = parking.longitude {
//                    let location = CLLocation(latitude: latitude, longitude: longitude)
//                    let marker = MGLPointAnnotation()
//                    marker.coordinate = location.coordinate
//                    if let ID = parking.parkingID, !mapAnnotationID.contains(ID) {
//                        marker.title = ID
//                        mapAnnotationID.append(ID)
//                        self.mapView.addAnnotation(marker)
//                    }
//                }
//            }
//        } else {
//            delayWithSeconds(1) {
//                self.parkingHidden(showMainBar: true)
//                self.createSimpleAlert(title: "No parking in this area", message: "Sign up to be a host today to help improve your parking community!")
//                self.placeAllAnnotations()
//            }
//        }
    }
    
    func organizeParkingLocations() {
        var closeParkingSpots = self.availableParkingSpots.sorted(by: { $0.parkingDistance! < $1.parkingDistance! })
        var cheapestParkingSpots = self.availableParkingSpots.sorted(by: { $0.parkingCost! < $1.parkingCost! })
        var bookingSpots: [ParkingSpots] = [] 
        if let closestParking = closeParkingSpots.first {
            bookingSpots.append(closestParking)
            closeParkingSpots.remove(at: 0)
            if let cheapIndex = cheapestParkingSpots.firstIndex(of: closestParking) {
                cheapestParkingSpots.remove(at: cheapIndex)
                if let cheapestParking = cheapestParkingSpots.first {
                    bookingSpots.append(cheapestParking)
                    if let closeIndex = closeParkingSpots.firstIndex(of: cheapestParking) {
                        closeParkingSpots.remove(at: closeIndex)
                        for parking in closeParkingSpots {
                            bookingSpots.append(parking)
                        }
//                        self.parkingController.parkingSpots = bookingSpots
                    }
                } else {
//                    self.parkingController.parkingSpots = bookingSpots
                    //no parking
                }
            } else {
//                self.parkingController.parkingSpots = bookingSpots
                //no parking
            }
        } else {
            //no parking
        }
    }
    
//    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
//        // For better performance, always try to reuse existing annotations.
//        if let title = annotation.title, title == "Destination" {
//            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "destinationMarkerIcon")
//            
//            // If there is no reusable annotation image available, initialize a new one.
//            if(annotationImage == nil) {
//                annotationImage = MGLAnnotationImage(image: UIImage(named: "destinationMarkerIcon")!, reuseIdentifier: "destinationMarkerIcon")
//            }
//            
//            return annotationImage
//        } else if let title = annotation.title, let parkingID = title, let parking = self.parkingSpotsDictionary[parkingID] {
//            if parking.isSpotAvailable == false {
//                var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationUnavailableMarker")
//                
//                // If there is no reusable annotation image available, initialize a new one.
//                if(annotationImage == nil) {
//                    annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationUnavailableMarker")!, reuseIdentifier: "annotationUnavailableMarker")
//                }
//                
//                return annotationImage
//            } else {
//                var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationMapMarker")
//                
//                // If there is no reusable annotation image available, initialize a new one.
//                if(annotationImage == nil) {
//                    annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationMapMarker")!, reuseIdentifier: "annotationMapMarker")
//                }
//                
//                return annotationImage
//            }
//        } else {
//            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationMapMarker")
//            
//            // If there is no reusable annotation image available, initialize a new one.
//            if(annotationImage == nil) {
//                annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationMapMarker")!, reuseIdentifier: "annotationMapMarker")
//            }
//            
//            return annotationImage
//        }
//    }
    
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
