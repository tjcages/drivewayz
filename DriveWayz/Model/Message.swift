//
//  Message.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/24/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var text: String?
    var timestamp: Double?
    var toID: String?
    var date: String?
    
    var name: String?
    var email: String?
    
    var imageURL: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var context: String?
    
    var videoURL: String?
    var picture: String?
    
    var communicationsId: String?
    var communicationsStatus: String?
    
    init(dictionary: [String: Any]) {
        super.init()
        fromID = dictionary["fromID"] as? String
        text = dictionary["message"] as? String
        timestamp = dictionary["timestamp"] as? Double
        toID = dictionary["toID"] as? String
        imageURL = dictionary["imageURL"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        videoURL = dictionary["videoURL"] as? String
        communicationsId = dictionary["communicationsId"] as? String
        communicationsStatus = dictionary["communicationsStatus"] as? String
        context = dictionary["context"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        picture = dictionary["picture"] as? String
        
        if let time = timestamp {
            let today = Date()
            let date = Date(timeIntervalSince1970: time)
            if let differenceSec = date.totalDistance(from: today, resultIn: .second),
                let differenceMin = date.totalDistance(from: today, resultIn: .minute),
                let differenceHour = date.totalDistance(from: today, resultIn: .hour),
                let differenceDays = date.totalDistance(from: today, resultIn: .day),
                let differenceMonths = date.totalDistance(from: today, resultIn: .month),
                let differenceYears = date.totalDistance(from: today, resultIn: .year) {
                if differenceSec >= 60 {
                    if differenceMin >= 60 {
                        if differenceHour >= 24 {
                            if differenceDays >= 30 {
                                if differenceMonths >= 12 {
                                    self.date = "\(differenceYears) yr"
                                } else {
                                    self.date = "\(differenceMonths) mo"
                                }
                            } else {
                                if differenceDays == 1 {
                                    self.date = "\(differenceDays) day"
                                } else {
                                    self.date = "\(differenceDays) days"
                                }
                            }
                        } else {
                            self.date = "\(differenceHour) hrs"
                        }
                    } else {
                        self.date = "\(differenceMin) min"
                    }
                } else {
                    if differenceSec == 0 {
                        self.date = "1 sec"
                    } else {
                        self.date = "\(differenceSec) sec"
                    }
                }
            }
        }
    }
    
    func chatPartnerID() -> String? {
        return (fromID! == (Auth.auth().currentUser?.uid)! ? toID : fromID)!
    }
    
}
