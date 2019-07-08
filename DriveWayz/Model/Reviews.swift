//
//  Reviews.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

class Reviews: NSObject {
    
    var rating: Int?
    var title: String?
    var timestamp: TimeInterval?
    var name: String?
    
    var date: String?
    var notificationImage: UIImage?
    
    init(dictionary: [String: Any]) {
        super.init()
        rating = dictionary["rating"] as? Int
        title = dictionary["message"] as? String
        timestamp = dictionary["timestamp"] as? TimeInterval
        name = dictionary["name"] as? String
        
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
                                    self.date = "\(differenceYears) year ago"
                                } else {
                                    self.date = "\(differenceMonths) month ago"
                                }
                            } else {
                                if differenceDays == 1 {
                                    self.date = "\(differenceDays) day ago"
                                } else {
                                    self.date = "\(differenceDays) days ago"
                                }
                            }
                        } else {
                            self.date = "\(differenceHour) hours ago"
                        }
                    } else {
                        self.date = "\(differenceMin) minutes ago"
                    }
                } else {
                    if differenceSec == 0 {
                        self.date = "1 second ago"
                    } else {
                        self.date = "\(differenceSec) second ago"
                    }
                }
            }
        }
        if let rating = rating {
            if rating >= 3 {
                notificationImage = UIImage(named: "notificationStar")
            } else {
                notificationImage = UIImage(named: "notificationStarPoor")
            }
        }
    }
    
}

