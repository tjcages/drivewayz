//
//  MBSelectAnnotation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox

extension MapKitViewController {

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//        if let searchLocation = DestinationAnnotationLocation {
//            self.removePolylineAnnotations()
//            for i in 0..<parkingSpots.count {
//                let parking = self.parkingSpots[i]
//                if annotation.subtitle == "\(i)" {
////                    self.closeParkingSpots = [parking]
//                    self.dismissKeyboard()
//                    self.takeAwayEvents()
//                    let latitude = parking.latitude
//                    let longitude = parking.longitude
//                    let location = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
//                    if let address = parking.overallAddress {
//                        self.mapView.setCenter(location.coordinate, animated: true)
//                        if let userLocation = locationManager.location {
//                            let search = CLLocation(latitude: searchLocation.coordinate.latitude, longitude: searchLocation.coordinate.longitude)
//                            self.findBestParking(location: location, sourceLocation: userLocation, searchLocation: search, address: address)
//                            delayWithSeconds(1.6) {
//                                self.dismissKeyboard()
//                            }
//                        }
//                    }
//                }
//            }
//        } else {
//            self.removeAllMapOverlays(shouldRefresh: true)
//            for i in 0..<parkingSpots.count {
//                let parking = self.parkingSpots[i]
//                if annotation.subtitle == "\(i)" {
////                    self.closeParkingSpots = [parking]
//                    self.dismissKeyboard()
//                    self.takeAwayEvents()
//                    let latitude = parking.latitude
//                    let longitude = parking.longitude
//                    let location = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
//                    if var streetAddress = parking.streetAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType {
//                        if let spaceRange = streetAddress.range(of: " ") {
//                            streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
//                            if let number = Int(numberSpots) {
//                                let wordString = number.asWord
//                                let publicAddress = "\(streetAddress)"
//                                let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
//                                self.mapView.setCenter(location.coordinate, animated: true)
////                                self.organizeParkingLocation(searchLocation: location, shouldDraw: true)
//                                delayWithSeconds(animationOut) {
//                                    self.dismissKeyboard()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
}
