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
    
    var dictionary: [String: Any]?

    var fingerprint: String?
    var timestamp: NSNumber?
    
    var vehicleLicensePlate: String?
    var vehicleMake: String?
    var vehicleModel: String?
    var vehicleYear: String?
    
    var defaultVehicle: Bool = false
    
    init(dictionary: [String: Any]) {
        super.init()
        self.dictionary = dictionary
        
        fingerprint = dictionary["fingerprint"] as? String
        
        timestamp = dictionary["timestamp"] as? NSNumber
        
        vehicleMake = dictionary["make"] as? String
        vehicleModel = dictionary["model"] as? String
        vehicleYear = dictionary["year"] as? String
        vehicleLicensePlate = dictionary["license"] as? String
        
        if let status = dictionary["default"] as? Bool {
            defaultVehicle = status
        }
    }
}
