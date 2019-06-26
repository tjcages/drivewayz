//
//  HostNotifications.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

class HostNotifications: NSObject {
    
    var image: String?
    var title: String?
    var subtitle: String?
    var timestamp: TimeInterval?
    
    var date: String?
    var notificationImage: UIImage?
    
    init(dictionary: [String: Any]) {
        super.init()
        image = dictionary["image"] as? String
        title = dictionary["title"] as? String
        subtitle = dictionary["subtitle"] as? String
        timestamp = dictionary["timestamp"] as? TimeInterval
        
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
        if let imageName = image {
            if imageName == "newHost" {
                notificationImage = UIImage(named: "notificationPerson")
            } else if imageName == "leftReviewGood" {
                notificationImage = UIImage(named: "notificationStar")
            } else if imageName == "leftReviewPoor" {
                notificationImage = UIImage(named: "notificationStarPoor")
            } else if imageName == "userParked" {
                notificationImage = UIImage(named: "notificationVehicle")
            }
        }
    }
    
}

