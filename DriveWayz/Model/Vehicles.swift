//
//  Vehicles.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/17/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class Vehicles: NSObject {
    
    var id: String?
    var timestamp: NSNumber?
    var vehicleImageURL: String?
    var vehicleLicensePlate: String?
    var vehicleMake: String?
    var vehicleModel: String?
    var vehicleYear: String?
    
    init(dictionary: [String: Any]) {
        super.init()
        id = dictionary["id"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        vehicleImageURL = dictionary["vehicleImageURL"] as? String
        vehicleMake = dictionary["vehicleMake"] as? String
        vehicleModel = dictionary["vehicleModel"] as? String
        vehicleYear = dictionary["vehicleYear"] as? String
    }
}
