//
//  Parking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ParkingSpots: NSObject {
    
    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    var imageURL: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    var videoURL: String?
    
    init(dictionary: [String: Any]) {
        super.init()
        fromID = dictionary["fromID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toID = dictionary["toID"] as? String
        imageURL = dictionary["imageURL"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        videoURL = dictionary["videoURL"] as? String
    }
    
    func chatPartnerID() -> String? {
        return (fromID! == (Auth.auth().currentUser?.uid)! ? toID : fromID)!
    }
    
}
