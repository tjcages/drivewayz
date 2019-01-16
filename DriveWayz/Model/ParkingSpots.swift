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
    
//    var timestamp: NSNumber?
//    var parkingImageURL: String?
//    var parkingCost: String?
//    var parkingAddress: String?
//    var parkingCity: String?
//    var id: String?
//    var currentAvailable: Bool?
//    var parkingType: String?
//    var parkingID: String?
//    var parkingDistance: String?
//    var message: String?
//    var rating: Double?
//    var Availability: [String]?
//    var location: CLLocation?
//
//    var payment: Double?
//    var hours: Int?
//
//    var Monday: [String]?
//    var Tuesday: [String]?
//    var Wednesday: [String]?
//    var Thursday: [String]?
//    var Friday: [String]?
//    var Saturday: [String]?
//    var Sunday: [String]?
//
//    var To: [String]?
//    var From: [String]?
//
//    init(dictionary: [String: Any]) {
//        super.init()
//        timestamp = dictionary["timestamp"] as? NSNumber
//        parkingImageURL = dictionary["parkingImageURL"] as? String
//        parkingCost = dictionary["parkingCost"] as? String
//        parkingAddress = dictionary["parkingAddress"] as? String
//        parkingCity = dictionary["parkingCity"] as? String
//        id = dictionary["id"] as? String
//        currentAvailable = dictionary["currentUser"] as? Bool
//        parkingType = dictionary["parkingType"] as? String
//        parkingID = dictionary["parkingID"] as? String
//        parkingDistance = dictionary["parkingDistance"] as? String
//        message = dictionary["message"] as? String
//        rating = dictionary["rating"] as? Double
//        location = dictionary["location"] as? CLLocation
//        payment = dictionary["payment"] as? Double
//        hours = dictionary["hours"] as? Int
//        Availability = dictionary["Availability"] as? [String]
//        Monday = dictionary["Monday"] as? [String]
//        Tuesday = dictionary["Tuesday"] as? [String]
//        Wednesday = dictionary["Wednesday"] as? [String]
//        Thursday = dictionary["Thursday"] as? [String]
//        Friday = dictionary["Friday"] as? [String]
//        Saturday = dictionary["Saturday"] as? [String]
//        Sunday = dictionary["Sunday"] as? [String]
//    }
    
    
    
    
    
    
    
    var hostEmail: String?
    var hostMessage: String?
    var id: String?
    var parkingCost: Double?
    var parkingID: String?
    var timestamp: NSNumber?
    
    var ParkingType: [String:Any]?
    var gateNumber: String?
    var mainType: String?
    var numberSpots: Int?
    var parkingNumber: String?
    var secondaryType: String?
    
    var ParkingAmenities: [Int:Any]?
    var amenities: [String]?
    
    var ParkingLocation: [String:Any]?
    var cityAddress: String?
    var countryAddress: String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var overallAddress: String?
    var stateAddress: String?
    var streetAddress: String?
    var zipAddress: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        hostEmail = dictionary["hostEmail"] as? String
        hostMessage = dictionary["hostMessage"] as? String
        id = dictionary["id"] as? String
        parkingCost = dictionary["parkingCost"] as? Double
        parkingID = dictionary["parkingID"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        
        ParkingType = dictionary["Type"] as? [String: Any]
        if let parkingType = ParkingType {
            gateNumber = parkingType["gateNumber"] as? String
            mainType = parkingType["mainType"] as? String
            numberSpots = parkingType["numberSpots"] as? Int
            parkingNumber = parkingType["parkingNumber"] as? String
            secondaryType = parkingType["secondaryType"] as? String
            ParkingAmenities = parkingType["Amenities"] as? [Int:Any]
            if let parkingAmenities = ParkingAmenities {
                for i in 0...parkingAmenities.count {
                    if let amentity = parkingAmenities[i] as? String {
                        amenities?.append(amentity)
                    }
                }
            }
        }
        
        ParkingLocation = dictionary["Location"] as? [String:Any]
        if let parkingLocation = ParkingLocation {
            cityAddress = parkingLocation["cityAddress"] as? String
            countryAddress = parkingLocation["countryAddress"] as? String
            latitude = parkingLocation["latitude"] as? NSNumber
            longitude = parkingLocation["longitude"] as? NSNumber
            overallAddress = parkingLocation["overallAddress"] as? String
            stateAddress = parkingLocation["stateAddress"] as? String
            streetAddress = parkingLocation["streetAddress"] as? String
            zipAddress = parkingLocation["zipAddress"] as? String
        }
        
        
    }
    
    
}
