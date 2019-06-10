//
//  Bookings.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

class Bookings: NSObject {
    
    var driverID: String?
    var fromDate: TimeInterval?
    var hours: Double?
    var parkingID: String?
    var vehicleID : String?
    var price: Double?
    var toDate: TimeInterval?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        driverID = dictionary["driverID"] as? String
        fromDate = dictionary["fromDate"] as? TimeInterval
        hours = dictionary["hours"] as? Double
        parkingID = dictionary["parkingID"] as? String
        vehicleID = dictionary["vehicleID"] as? String
        price = dictionary["price"] as? Double
        toDate = dictionary["toDate"] as? TimeInterval
        
    }
        
}
