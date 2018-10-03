//
//  ParkingSpots.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ParkingSpots: NSObject {
    
    var timestamp: NSNumber?
    var parkingImageURL: String?
    var parkingCost: String?
    var parkingAddress: String?
    var parkingCity: String?
    var id: String?
    var currentAvailable: String?
    var parkingID: String?
    var parkingDistance: String?
    var message: String?
    var rating: Double?
    var Availability: [String]?
    var location: CLLocation?
    
    var payment: Double?
    var hours: Int?
    
    var Monday: [String]?
    var Tuesday: [String]?
    var Wednesday: [String]?
    var Thursday: [String]?
    var Friday: [String]?
    var Saturday: [String]?
    var Sunday: [String]?
    
    var To: [String]?
    var From: [String]?
    
    init(dictionary: [String: Any]) {
        super.init()
        timestamp = dictionary["timestamp"] as? NSNumber
        parkingImageURL = dictionary["parkingImageURL"] as? String
        parkingCost = dictionary["parkingCost"] as? String
        parkingAddress = dictionary["parkingAddress"] as? String
        parkingCity = dictionary["parkingCity"] as? String
        id = dictionary["id"] as? String
        currentAvailable = dictionary["currentUser"] as? String
        parkingID = dictionary["parkingID"] as? String
        parkingDistance = dictionary["parkingDistance"] as? String
        message = dictionary["message"] as? String
        rating = dictionary["rating"] as? Double
        location = dictionary["location"] as? CLLocation
        payment = dictionary["payment"] as? Double
        hours = dictionary["hours"] as? Int
        Availability = dictionary["Availability"] as? [String]
        Monday = dictionary["Monday"] as? [String]
        Tuesday = dictionary["Tuesday"] as? [String]
        Wednesday = dictionary["Wednesday"] as? [String]
        Thursday = dictionary["Thursday"] as? [String]
        Friday = dictionary["Friday"] as? [String]
        Saturday = dictionary["Saturday"] as? [String]
        Sunday = dictionary["Sunday"] as? [String]
    }
    
}
