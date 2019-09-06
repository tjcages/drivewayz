//
//  CardParser.swift
//
//  Created by Jason Clark on 6/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

//MARK: - CardType


class CardType: NSObject {
    
    var prefix: String?
    
    init(dictionary: String) {
        super.init()
        
        if dictionary == "amex" { prefix = "34" }
        else if dictionary == "diners" { prefix = "300" }
        else if dictionary == "discover" { prefix = "6011" }
        else if dictionary == "jcb" { prefix = "3528" }
        else if dictionary == "mastercard" { prefix = "51" }
        else if dictionary == "visa" { prefix = "4" }
        else { prefix = "1" }

    }
}

