//
//  Bookings.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Bookings: NSObject {
    
    var bookingID: String?
    var driverID: String?
    var fromDate: TimeInterval?
    var hours: Double?
    var parkingID: String?
    var vehicleID : String?
    var price: Double?
    var toDate: TimeInterval?
    
    var parkingLat: Double?
    var parkingLong: Double?
    var destinationLat: Double?
    var destinationLong: Double?
    
    var discount: Int?
    var totalCost: Double?
    var stringDate: String?
    var walkingTime: Double?
    
    var userName: String?
    var userDuration: String?
    var userProfileURL: String?
    var userRating: Double?
    var userOverstayed: Bool?
    
    var parkingName: String?
    var parkingType: String?
    var parkingRating: Double?
    var destinationName: String?
    
    var checkedIn: Bool?
    var section: TableSection?
    var key: String?
    var context: String = "Booking"
    
    init(dictionary: [String:Any]) {
        super.init()
        
        bookingID = dictionary["bookingID"] as? String
        driverID = dictionary["driverID"] as? String
        fromDate = dictionary["fromDate"] as? TimeInterval
        hours = dictionary["hours"] as? Double
        parkingID = dictionary["parkingID"] as? String
        vehicleID = dictionary["vehicleID"] as? String
        price = dictionary["price"] as? Double
        toDate = dictionary["toDate"] as? TimeInterval
        
        parkingLat = dictionary["finalParkingLat"] as? Double
        parkingLong = dictionary["finalParkingLong"] as? Double
        destinationLat = dictionary["finalDestinationLat"] as? Double
        destinationLong = dictionary["finalDestinationLong"] as? Double
        
        discount = dictionary["discount"] as? Int
        totalCost = dictionary["totalCost"] as? Double
        walkingTime = dictionary["walkingTime"] as? Double
        
        parkingName = dictionary["parkingName"] as? String
        parkingType = dictionary["parkingType"] as? String
        parkingRating = dictionary["parkingRating"] as? Double
        destinationName = dictionary["destinationName"] as? String
        
        userName = dictionary["driverName"] as? String
        userProfileURL = dictionary["driverPicture"] as? String
        userRating = dictionary["driverRating"] as? Double
        if userRating == nil {
            userRating = 5.0
        }
        
        checkedIn = dictionary["checkedIn"] as? Bool
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        guard let from = fromDate else { return }
        let date = Date(timeIntervalSince1970: from)
        stringDate = formatter.string(from: date)
        
        if let fromInterval = self.fromDate, let toInterval = self.toDate {
            let today = Date().timeIntervalSince1970
            if today > fromInterval && today < toInterval {
                self.userOverstayed = false
            } else if today > fromInterval && today >= toInterval {
                self.userOverstayed = true
            }
            let fromDate = Date(timeIntervalSince1970: fromInterval)
            let toDate = Date(timeIntervalSince1970: toInterval)
            let formatter = DateFormatter()
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            formatter.dateFormat = "h:mma"
            let fromString = formatter.string(from: fromDate)
            let toString = formatter.string(from: toDate)
            let dates = "\(fromString) - \(toString)"
            self.userDuration = dates
        }
        
        let today = Date()
        if let timestamp = self.fromDate {
            let date = Date(timeIntervalSince1970: timestamp)
            if date.isInToday {
                section = .today
            } else if date.isInYesterday {
                section = .yesterday
            } else if date.isInThisWeek {
                section = .week
            } else if date.isInSameMonth(date: today) {
                section = .month
            } else {
                section = .earlier
            }
        }
        
    }
        
}
