//
//  MapKitParkingAvailability.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation

extension MapKitViewController {
    func checkAvailabilityForMarkers(parking: ParkingSpots, ref: DatabaseReference, parkingType: String) {
//        ref.child("Current").observe(.childAdded) { (snapshot) in
//            if let vailable = snapshot.value as? String {
//                if vailable == "Unavailable" {
//                    parking.currentAvailable = false
//                }
//            }
//            ref.observeSingleEvent(of: .value, with: { (currentSnap) in
//                let count = currentSnap.childrenCount
//                ref.observeSingleEvent(of: .value, with: { (parkSnap) in
//                    if let dictionary = parkSnap.value as? [String:AnyObject] {
//                        if let numberString = dictionary["numberOfSpots"] as? String {
//                            let numberSpots: Int = Int(numberString)!
//                            if numberSpots > count {
//                                parking.currentAvailable = true
//                            } else {
//                                parking.currentAvailable = false
//                            }
//                        }
//                    }
//                })
//            })
//        }
//        ref.child("Availability").observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? [String:AnyObject] {
//                if dictionary["Monday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//                if dictionary["Tuesday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//                if dictionary["Wednesday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//                if dictionary["Thursday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//                if dictionary["Friday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//                if dictionary["Saturday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//                if dictionary["Sunday"] as? Int == 0 {
//                    parking.currentAvailable = false
//                } else {
//                    parking.currentAvailable = true
//                }
//            }
//        }
//        if parkingType == "house" {
//            parking.parkingType = parkingType
//        } else if parkingType == "apartment" {
//            parking.parkingType = parkingType
//        } else if parkingType == "parkingLot" {
//            parking.parkingType = parkingType
//        }
    }
    
    func openMessages() {
        self.vehicleDelegate?.openAccountView()
//        self.vehicleDelegate?.bringMessagesController()
    }
    
}
