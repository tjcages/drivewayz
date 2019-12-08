//
//  ACEParkingAPI.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation

struct ACEParkingAPI {
    
    static func testACEParking() {
        if let path = Bundle.main.path(forResource: "testACE", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print(data)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                  if let jsonResult = jsonResult as? [AnyObject] {
                    for json in jsonResult {
                        if let dictionary = json as? [String: AnyObject] {
                            print(dictionary)
                            let parking = ACEParking(dictionary: dictionary)
                            print(parking)
                            print(parking.aceDescription)
                            print(parking.address)
                            print(parking.category)
                            print(parking.city)
                            print(parking.covered)
                            print(parking.evchargers)
                            print(parking.friday)
                            print(parking.hdcp_stalls)
                            print(parking.lat)
                            print("\n\n next \n\n")
                        }
                        print("hey")
                    }
                  }
              } catch {
                   // handle error
              }
        }
    }

}

class ACEParking: NSObject {
    
    var dictionary: [String: Any]?
    var loc: NSNumber?
    
    var monday: String?
    var tuesday: String?
    var wednesday: String?
    var thursday: String?
    var friday: String?
    var saturday: String?
    var sunday: String?
    
    var lng: NSNumber?
    var lat: NSNumber?
    var postal: NSNumber?
    var region: String?
    var state: String?
    var city: String?
    var address: String?
    var phone: String?
    
    var covered: String?
    var evchargers: String?
    var ratedescription: String?
    
    var min_rate: String?
    var max_rate: String?
    var payment: AnyObject?
    
    var occupancyCount: NSNumber?
    var occupancy: String?
    var aceDescription: String?
    var stalls: NSNumber?
    var hdcp_stalls: NSNumber?
    var website: String?
    
    var category: String?
    var parkmobile: String?
    var ParkMobile: Bool = false
    
    var monthlypermint: String?
    var motorcycles: String?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        self.dictionary = dictionary
        
        loc = dictionary["loc"] as? NSNumber
        
        monday = dictionary["monday"] as? String
        tuesday = dictionary["tuesday"] as? String
        wednesday = dictionary["wednesday"] as? String
        thursday = dictionary["thursday"] as? String
        friday = dictionary["friday"] as? String
        saturday = dictionary["saturday"] as? String
        sunday = dictionary["sunday"] as? String
        
        lng = dictionary["lng"] as? NSNumber
        lat = dictionary["lat"] as? NSNumber
        postal = dictionary["postal"] as? NSNumber
        region = dictionary["region"] as? String
        state = dictionary["state"] as? String
        city = dictionary["city"] as? String
        address = dictionary["address"] as? String
        phone = dictionary["phone"] as? String
        
        covered = dictionary["covered"] as? String
        evchargers = dictionary["evchargers"] as? String
        ratedescription = dictionary["ratedescription"] as? String
        
        min_rate = dictionary["min_rate"] as? String
        max_rate = dictionary["max_rate"] as? String
        payment = dictionary["payment"] as AnyObject
        
        occupancyCount = dictionary["occupancyCount"] as? NSNumber
        occupancy = dictionary["occupancy"] as? String
        aceDescription = dictionary["description"] as? String
        stalls = dictionary["stalls"] as? NSNumber
        hdcp_stalls = dictionary["hdcp_stalls"] as? NSNumber
        website = dictionary["website"] as? String
    
        category = dictionary["category"] as? String
        monthlypermint = dictionary["monthlypermint"] as? String
        motorcycles = dictionary["motorcycles"] as? String
        parkmobile = dictionary["parkmobile"] as? String
        if let park = parkmobile {
            if park == "Y" {
                ParkMobile = true
            }
        }
        
    }
    
}
