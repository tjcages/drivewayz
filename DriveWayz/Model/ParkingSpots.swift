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

    var hostEmail: String?
    var hostMessage: String?
    var id: String?
    var parkingCost: String?
    var parkingID: String?
    var timestamp: NSNumber?
    var parkingDistance: Double?
    
    var ParkingType: [String:Any]?
    var gateNumber: String?
    var mainType: String?
    var numberSpots: String?
    var parkingNumber: String?
    var secondaryType: String?
    
    var parkingAmenities: [String]?
    
    var ParkingReviews: [String:Any]?
    var totalRating: String?
    var numberRatings: String?
    
    var ParkingLocation: [String:Any]?
    var cityAddress: String?
    var countryAddress: String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var overallAddress: String?
    var stateAddress: String?
    var streetAddress: String?
    var zipAddress: String?
    
    var ParkingImages: [String:Any]?
    var firstImage: String?
    var secondImage: String?
    var thirdImage: String?
    var fourthImage: String?
    var fifthImage: String?
    var sixthImage: String?
    var seventhImage: String?
    var eighthImage: String?
    var ninethImage: String?
    var tenthImage: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        hostEmail = dictionary["hostEmail"] as? String
        hostMessage = dictionary["hostMessage"] as? String
        id = dictionary["id"] as? String
        parkingCost = dictionary["parkingCost"] as? String
        parkingID = dictionary["parkingID"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        
        ParkingType = dictionary["Type"] as? [String: Any]
        if let parkingType = ParkingType {
            gateNumber = parkingType["gateNumber"] as? String
            mainType = parkingType["mainType"] as? String
            numberSpots = parkingType["numberSpots"] as? String
            parkingNumber = parkingType["parkingNumber"] as? String
            secondaryType = parkingType["secondaryType"] as? String
            parkingAmenities = parkingType["Amenities"] as? [String]
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
        
        ParkingReviews = dictionary["Reviews"] as? [String:Any]
        if let parkingReviews = ParkingReviews {
            totalRating = parkingReviews["totalRating"] as? String
            numberRatings = parkingReviews["numberRatings"] as? String
        }
        
        ParkingImages = dictionary["SpotImages"] as? [String:Any]
        if let parkingImages = ParkingImages {
            firstImage = parkingImages["firstImage"] as? String
            secondImage = parkingImages["secondImage"] as? String
            thirdImage = parkingImages["thirdImage"] as? String
            fourthImage = parkingImages["fourthImage"] as? String
            fifthImage = parkingImages["fifthImage"] as? String
            sixthImage = parkingImages["sixthImage"] as? String
            seventhImage = parkingImages["seventhImage"] as? String
            eighthImage = parkingImages["eighthImage"] as? String
            ninethImage = parkingImages["ninethImage"] as? String
            tenthImage = parkingImages["tenthImage"] as? String
        }
        
    }
}
