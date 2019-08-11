//
//  FAQs.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class FAQs: NSObject {
    
    var mainInformation: [String]?
    var supportText: String?
    var contactSupport: String?
    
    var helpful: Bool?
    var like: Int?
    var dislike: Int?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        mainInformation = dictionary["mainInformation"] as? [String]
        supportText = dictionary["supportText"] as? String
        contactSupport = dictionary["contactSupport"] as? String
        
        helpful = dictionary["helpful"] as? Bool
        like = dictionary["like"] as? Int
        dislike = dictionary["dislike"] as? Int
        
    }
    
}
