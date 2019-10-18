//
//  User.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/21/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit

class Users: NSObject {
    
    var id: String?
    var name: String?
    var email: String?
    var phone: String?
    var picture: String?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        phone = dictionary["phone"] as? String
        picture = dictionary["picture"] as? String
        
    }
    
}



enum Device {
    case iphone8
    case iphoneX
//    case iphonePlus
//    case iPad
}

enum SolarTime {
    case day
    case night
}
