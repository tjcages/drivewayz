//
//  PaymentMethod.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PaymentMethod: NSObject {
    
    var dictionary: [String: Any]?
    var address_zip_check: String?
    var id: String?
    var dynamic_last4: String?
    var address_city: String?
    var exp_month: NSNumber?
    var month: String?
    var country: String?
    var name: String?
    var tokenization_method: String?
    var customer: String?
    var address_country: String?
    var object: String?
    var address_zip: String?
    var address_line1: String?
    var funding: String?
    var exp_year: NSNumber?
    var year: String?
    var cvc_check: String?
    var last4: String?
    
    var metaData: [String: Any]?
    var address_line1_check: String?
    var fingerprint: String?
    var address_state: String?
    var brand: String?
    var address_line2: String?
    var token: String?
    var defaultCard: Bool = false
    
    init(dictionary: [String: Any]) {
        super.init()
        self.dictionary = dictionary
        address_zip_check = dictionary["address_zip_check"] as? String
        id = dictionary["id"] as? String
        dynamic_last4 = dictionary["dynamic_last4"] as? String
        address_city = dictionary["address_city"] as? String
        exp_month = dictionary["exp_month"] as? NSNumber
        if let month = exp_month {
            let monthString = "\(month)"
            if monthString.count == 1 {
                self.month = "0" + monthString
            } else {
                self.month = monthString
            }
        }
        country = dictionary["country"] as? String
        name = dictionary["name"] as? String
        tokenization_method = dictionary["tokenization_method"] as? String
        customer = dictionary["customer"] as? String
        address_country = dictionary["address_country"] as? String
        object = dictionary["object"] as? String
        address_zip = dictionary["address_zip"] as? String
        address_line1 = dictionary["address_line1"] as? String
        funding = dictionary["funding"] as? String
        exp_year = dictionary["exp_year"] as? NSNumber
        if let year = exp_year {
            self.year = "\(year)"
        }
        cvc_check = dictionary["cvc_check"] as? String
        last4 = dictionary["last4"] as? String
        
        metaData = dictionary["metadata"] as? [String: Any]
        address_line1_check = dictionary["address_line1_check"] as? String
        fingerprint = dictionary["fingerprint"] as? String
        address_state = dictionary["address_state"] as? String
        brand = dictionary["brand"] as? String
        address_line2 = dictionary["address_line2"] as? String
        token = dictionary["token"] as? String
        
        if let status = dictionary["default"] as? Bool {
            defaultCard = status
        }
    }
}

