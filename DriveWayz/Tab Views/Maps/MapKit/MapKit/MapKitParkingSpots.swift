//
//  MapKitParkingSpots.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

var ParkingRoutePolyLine: [MKOverlay] = []
var DestinationRoutePolyLine = MKPolyline()
var DestinationAnnotation: MKAnnotation?
var ZoomMapView: MGLCoordinateBounds?
var ZoomPurchaseMapView: MGLCoordinateBounds?
var IncreasedZoomMapView: CLLocationCoordinate2D?
var CurrentDestinationLocation: CLLocation?
var ClosestParkingLocation: CLLocation?

extension MapKitViewController {
    
    func observeUserParkingSpots() {
//        if alreadyLoadedSpots == false {
//            alreadyLoadedSpots = true
//            let ref = Database.database().reference().child("parking")
//            ref.observe(.childAdded, with: { (snapshot) in
//                let parkingID = [snapshot.key]
//                self.fetchParking(parkingID: parkingID)
//            }, withCancel: nil)
//            ref.observe(.childRemoved, with: { (snapshot) in
//                self.parkingSpotsDictionary.removeValue(forKey: snapshot.key)
//                self.reloadOfTable()
//            }, withCancel: nil)
//        }
    }
    
    private func fetchParking(parkingID: [String]) {
//        for parking in parkingID {
//            let parkingID = parking
//            let ref = Database.database().reference().child("parking").child(parkingID)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                if var dictionary = snapshot.value as? [String:AnyObject] {
//                    let parking = ParkingSpots(dictionary: dictionary)
//                    if let avgRating = dictionary["rating"] as? Double { parking.rating = avgRating } else { parking.rating = 5.0 }
//                    guard let parkingType = dictionary["parkingType"] as? String else { return }
//                    self.checkAvailabilityForMarkers(parking: parking, ref: ref, parkingType: parkingType)
//                    DispatchQueue.main.async(execute: {
//                        let parkingID = dictionary["parkingID"] as! String
//                        self.parkingSpotsDictionary[parkingID] = parking
//                        self.reloadOfTable()
//                    })
//                }
//            }, withCancel: nil)
//        }
    }
    
//    private func reloadOfTable() {
//        self.timer?.invalidate()
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//    }
//
//    @objc func handleReloadTable() {
//        self.parkingSpots = Array(self.parkingSpotsDictionary.values)
//        self.parkingSpots.sort(by: { (message1, message2) -> Bool in
//            return ((message1.parkingDistance! as NSString).intValue) < ((message2.parkingDistance! as NSString).intValue)
//        })
//        DispatchQueue.main.async(execute: {
//            self.showPartyMarkers()
//        })
//    }
    
    func showPartyMarkers() {
//        if let annotations = self.mapView.annotations {
//            self.mapView.removeAnnotations(annotations)
//        }
//        if parkingSpots.count > 0 {
//            for number in 0...(parkingSpots.count - 1) {
//                let marker = MGLPointAnnotation()
//                let parking = parkingSpots[number]
//
//                let geoCoder = CLGeocoder()
//                geoCoder.geocodeAddressString(parking.parkingAddress!) { (placemarks, error) in
//                    guard let placemarks = placemarks, let location = placemarks.first?.location else {
//                        print("Couldn't find location showing party markers")
//                        return
//                    }
//                    marker.title = parking.parkingCost
//                    marker.subtitle = "\(number)"
//                    marker.coordinate = location.coordinate
//                    if let myLocation = self.mapView.userLocation, let location = myLocation.location {
//                        let distanceToParking = (location.distance(from: location)) / 1609.34 // miles
//                        let roundedStepValue = Double(round(10 * distanceToParking) / 10)
//                        let formattedDistance = String(format: "%.1f", roundedStepValue)
//                        parking.parkingDistance = formattedDistance
//                    }
//                    self.mapView.addAnnotation(marker)
//                }
//            }
//        }
    }
    
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        guard annotation is MGLPointAnnotation else { return nil }
//        let reuseIdentifier = "\(annotation.coordinate.longitude)"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//        
//        if annotationView == nil {
//            if annotation.subtitle == "Destination" {
//                annotationView = DestinationAnnotationView(reuseIdentifier: DestinationAnnotationView.ReuseID)
//                annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
//                return annotationView
//            } else {
//                return annotationView
//            }
//        }
//        
//        return annotationView
//    }
    
    
}
