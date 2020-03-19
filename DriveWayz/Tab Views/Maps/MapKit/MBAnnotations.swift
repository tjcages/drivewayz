//
//  MBAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import FirebaseDatabase
import GoogleMapsUtils

var shouldShowLots: Bool = true
var zipTimer: Timer?
var observedZip: String?
var zipParkingLots: [ParkingLot: CLLocationDistance] = [:]
var zipSortedParkingLots: [ParkingLot] = []

var firstSpotView: SpotView?
var secondSpotView: SpotView?
var thirdSpotView: SpotView?

var firstLocation: CLLocation?
var secondLocation: CLLocation?
var thirdLocation: CLLocation?

extension MapKitViewController {
    
    func observeParking(placemark: CLPlacemark) {
        if let state = placemark.administrativeArea, let city = placemark.subAdministrativeArea, let zip = placemark.postalCode, let latitude = placemark.location?.coordinate.latitude, let longitude = placemark.location?.coordinate.longitude {
            observedZip = zip
            
            zipParkingLots.removeAll()
            let ref = Database.database().reference().child("Parking Information").child(state).child(city).child(zip)
            ref.observe(.childAdded) { (snapshot) in
                if var dictionary = snapshot.value as? [String: Any] {
                    zipTimer?.invalidate()
                    zipTimer = nil
                    
                    dictionary["id"] = snapshot.key
                    dictionary["state"] = state
                    dictionary["city"] = city
                    dictionary["zip"] = zip
                    dictionary["destinationLat"] = latitude
                    dictionary["destinationLong"] = longitude
                    
                    let parkingLot = ParkingLot(dictionary: dictionary)
                    
                    if let distance = parkingLot.destinationDistance {
                        zipParkingLots[parkingLot] = distance
                    }
                    
                    zipTimer = Timer.scheduledTimer(timeInterval: animationOut, target: self, selector: #selector(self.finishedObservingParking), userInfo: nil, repeats: false)
                }
            }
            
        }
    }
    
    @objc func finishedObservingParking() {
        let array = zipParkingLots.sorted(by: { $0.value < $1.value })
        zipSortedParkingLots.removeAll()
        array.forEach { (dict) in
            zipSortedParkingLots.append(dict.key)
        }
        if shouldShowLots {
            placeSortedParking()
        } else {
            clusterManager.clearItems()
            placeBookingPins()
            
            updateParkingLots()
        }
    }
    
    func placeSortedParking() {
        clusterManager.clearItems()
        for lot in zipSortedParkingLots {
            if let latitude = lot.latitude, let longitude = lot.longitude, let key = lot.id {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let position = location.coordinate
                
                let cluster = ClusterItem(position: position, name: key, lot: lot)
                clusterManager.add(cluster)
            }
        }
        clusterManager.cluster()
    }
    
    func placeBookingPins() {
        for i in 0..<3 {
            if zipSortedParkingLots.count > i {
                let lot = zipSortedParkingLots[i]
                if let location = lot.location {
                    let spotView = SpotView(frame: CGRect(x: 0, y: 0, width: 76, height: 82))
                    let point = mapView.projection.point(for: location.coordinate)
                    
                    mapView.addSubview(spotView)
                    spotView.center = point
                    spotView.lot = lot
                    
                    if i == 0 {
                        firstSpotView = spotView
                        firstLocation = location
                        
                        let newCamera = GMSCameraPosition.camera(withTarget: location.coordinate,
                          zoom: mapView.camera.zoom - 1)
                        let update = GMSCameraUpdate.setCamera(newCamera)
                        mapView.animate(with: update)
                    }
                    else if i == 1 { secondSpotView = spotView; secondLocation = location }
                    else if i == 2 { thirdSpotView = spotView; thirdLocation = location }
                }
            }
        }
    }

}
