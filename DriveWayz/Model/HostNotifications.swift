//
//  HostNotifications.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

// Notification enum to sort data into specific types
enum NotificationSection: Int {
    case urgent = 0, // Needs response
    important, // Needs work or is necessary for host
    moderate, // Needs work
    mild, // Important but can be avoided
    soft, // Not very important but should still be seen
    unimportant, // Not important
    none, // Don't show as main
    total
}


class HostNotifications: NSObject {
    
    var image: String?
    var title: String?
    var subtitle: String?
    var timestamp: TimeInterval?
    var key: String?
    
    var date: String?
    var notificationImage: UIImage?
    var notificationType: String?
    
    var urgency: String?
    var type: NotificationSection?
    var section: TableSection?
    var containerGradient: [UIColor: UIColor]?
    
    init(dictionary: [String: Any]) {
        super.init()
        image = dictionary["image"] as? String
        title = dictionary["title"] as? String
        subtitle = dictionary["subtitle"] as? String
        timestamp = dictionary["timestamp"] as? TimeInterval
        notificationType = dictionary["notificationType"] as? String
        
        if self.image != nil && self.notificationType == nil {
            self.notificationType = self.image
        }
        
        let today = Date()
        if let timestamp = self.timestamp {
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
        
        if notificationType == "newHost" {
            self.type = .moderate
            self.containerGradient = [Theme.DarkPurple: Theme.LightPurple]
            self.notificationImage = UIImage(named: "notificationHouse")
        } else if notificationType == "notification" {
            self.type = .moderate
            self.containerGradient = [Theme.LightTeal: Theme.DarkTeal]
            self.notificationImage = UIImage(named: "flat-bell-message")
        } else if notificationType == "camera" {
            self.type = .mild
            self.containerGradient = [Theme.DarkTeal: Theme.LightTeal]
            self.notificationImage = UIImage(named: "flat-camera")
        } else if notificationType == "chat" {
            self.type = .moderate
            self.containerGradient = [Theme.STRAWBERRY_PINK: Theme.LightOrange]
            self.notificationImage = UIImage(named: "flat-chat-bubbles")
        } else if notificationType == "document" {
            self.type = .important
            self.containerGradient = [Theme.LightBlue: Theme.DarkBlue]
            self.notificationImage = UIImage(named: "flat-document")
        } else if notificationType == "folder" {
            self.type = .mild
            self.containerGradient = [Theme.BLUE: Theme.LightBlue]
            self.notificationImage = UIImage(named: "flat-folder")
        } else if notificationType == "search" {
            self.type = .urgent
            self.containerGradient = [Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1): Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)]
            self.notificationImage = UIImage(named: "Search")
        } else if notificationType == "mailbox" {
            self.type = .mild
            self.containerGradient = [Theme.LightPurple: Theme.DarkPurple]
            self.notificationImage = UIImage(named: "flat-mailbox")
        } else if notificationType == "phone" {
            self.type = .urgent
            self.containerGradient = [Theme.LightPink: Theme.DarkPink]
            self.notificationImage = UIImage(named: "flat-phone-connection")
        } else if notificationType == "update" {
            self.type = .mild
            self.containerGradient = [Theme.DarkGreen: Theme.LightGreen]
            self.notificationImage = UIImage(named: "flat-phone-hand")
        } else if notificationType == "photos" {
            self.type = .soft
            self.containerGradient = [Theme.LightOrange: Theme.STRAWBERRY_PINK]
            self.notificationImage = UIImage(named: "flat-photos")
        } else if notificationType == "plane" {
            self.type = .mild
            self.containerGradient = [Theme.STRAWBERRY_PINK: Theme.LightOrange]
            self.notificationImage = UIImage(named: "flat-plane")
        } else if notificationType == "telescope" {
            self.type = .soft
            self.containerGradient = [Theme.BLUE: Theme.DarkPurple]
            self.notificationImage = UIImage(named: "flat-telescope")
        } else if notificationType == "newHost" {
            self.type = .important
            self.containerGradient = [Theme.DarkPurple: Theme.LightPurple]
            self.notificationImage = UIImage(named: "flat-plant")
        } else if notificationType == "leftReviewGood" {
            self.type = .mild
            self.containerGradient = [Theme.LightGreen: Theme.DarkGreen]
            self.notificationImage = UIImage(named: "notificationStar")
        } else if notificationType == "leftReviewPoor" {
            self.type = .moderate
            self.containerGradient = [Theme.SEA_BLUE: Theme.SEA_BLUE]
            self.notificationImage = UIImage(named: "notificationStar")
        } else if notificationType == "userParked" {
            self.type = .moderate
            self.containerGradient = [Theme.LightRed: Theme.DarkRed]
            self.notificationImage = UIImage(named: "notificationPin")
        }
        
        urgency = dictionary["urgency"] as? String
        if let urgen = self.urgency {
            if urgen == "urgent" {
                self.type = .urgent
            } else if urgen == "important" {
                self.type = .important
            } else if urgen == "moderate" {
                self.type = .moderate
            } else if urgen == "mild" {
                self.type = .mild
            } else if urgen == "soft" {
                self.type = .soft
            } else if urgen == "unimportant" {
                self.type = .unimportant
            }
        }
        
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
    
}

