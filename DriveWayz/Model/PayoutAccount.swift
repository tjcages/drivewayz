//
//  PayoutAccount.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

class PayoutAccount: NSObject {
    
    var accountID: String?
    var accountNumber: String?
    var addressCity: String?
    var addressLine1: String?
    var addressPostalCode: String?
    var addressState: String?
    
    var api_version: String?
    
    var birthDay: String?
    var birthMonth: String?
    var birthYear: String?
    var email: String?
    
    var firstName: String?
    var lastName: String?
    
    var routingNumber: String?
    var ssnLast4: String?
    var type: String?
    var timestamp: Double?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        accountID = dictionary["accountID"] as? String
        accountNumber = dictionary["accountNumber"] as? String
        addressCity = dictionary["addressCity"] as? String
        addressLine1 = dictionary["addressLine1"] as? String
        addressPostalCode = dictionary["addressPostalCode"] as? String
        addressState = dictionary["addressState"] as? String
        api_version = dictionary["api_version"] as? String
        birthDay = dictionary["birthDay"] as? String
        birthMonth = dictionary["birthMonth"] as? String
        birthYear = dictionary["birthYear"] as? String
        email = dictionary["email"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        routingNumber = dictionary["routingNumber"] as? String
        ssnLast4 = dictionary["ssnLast4"] as? String
        type = dictionary["type"] as? String
        timestamp = dictionary["timestamp"] as? Double
        
    }

}


// Table section enum to sort data into specific sections
enum TableSection: Int {
    case today = 0, yesterday, week, month, earlier, total
}


class Payouts: NSObject {
    
    var accountID: String?
    var timestamp: Double?
    var transferAmount: Double?
    
    var accountLabel: Int?
    var routingLabel: Int?
    
    var accountType: String?
    var section: TableSection?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        accountID = dictionary["accountID"] as? String
        timestamp = dictionary["timestamp"] as? Double
        transferAmount = dictionary["transferAmount"] as? Double
        accountLabel = dictionary["accountLabel"] as? Int
        routingLabel = dictionary["routingLabel"] as? Int
        accountType = dictionary["accountType"] as? String
    
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

        
    }
    
}
