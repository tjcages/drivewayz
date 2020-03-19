//
//  ParkingLot.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/10/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ParkingLot: NSObject {
    
    var dictionary: [String: Any]?
    var id: String?

    var maxprice: String?
    var minprice: String?
    
    var address: String?
    var state: String?
    var city: String?
    var zip: String?
    
    var parkingOperator: String?
    var shortOperator: String?
    
    var stringLongitude: String?
    var stringLatitude: String?
    var latitude: Double?
    var longitude: Double?
    var location: CLLocation?
    var destination: CLLocation?
    
    var destinationLat: CLLocationDegrees?
    var destinationLong: CLLocationDegrees?
    var destinationDistance: CLLocationDistance?
    
    var numberOfSpots: String?
    var lotDescription: String?
    var lotSize: String?
    var lotOrGarage: String?
    var overnight: String?
    var street: String?
    var subAdministrativeArea: String?
    var subLocality: String?
    
    var handicap: String?
    var handicapNumber: String?
    
    var walkingDuration: Double?
    var walkingRoute: MKRoute? {
        didSet {
            if let route = walkingRoute {
                let minute = route.expectedTravelTime / 60
                walkingDuration = minute.rounded()
            }
        }
    }
    
    var parkingTimes = parkingValues
    var availabilityLikelihood: CGFloat?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        self.dictionary = dictionary
        id = dictionary["id"] as? String
        
        maxprice = dictionary["maxprice"] as? String
        if maxprice == nil {
            maxprice = dictionary["max price"] as? String
        }
        
        minprice = dictionary["minprice"] as? String
        if minprice == nil {
            minprice = dictionary["min price"] as? String
        }
        
        address = dictionary["address"] as? String
        state = dictionary["state"] as? String
        city = dictionary["city"] as? String
        zip = dictionary["zip"] as? String
        
        parkingOperator = dictionary["operator"] as? String
        if let parkOperator = parkingOperator {
            determineOperator(parkingOperator: parkOperator)
        }
        
        stringLongitude = dictionary["lng"] as? String
        stringLatitude = dictionary["lat"] as? String
        destinationLat = dictionary["destinationLat"] as? CLLocationDegrees
        destinationLong = dictionary["destinationLong"] as? CLLocationDegrees
        
        if let destLat = destinationLat, let destLong = destinationLong, let sLat = stringLatitude, let lat = Double(sLat), let sLong = stringLongitude, let long = Double(sLong) {
            latitude = lat
            longitude = long
            
            let coordinate = CLLocation(latitude: lat, longitude: long)
            location = coordinate
            let destination = CLLocation(latitude: destLat, longitude: destLong)
            self.destination = destination
            destinationDistance = destination.distance(from: coordinate) // In meters
        }
        
        if let locationInfo = dictionary["Location Info"] as? [String: Any] {
            numberOfSpots = locationInfo["Number of spots"] as? String
            lotDescription = locationInfo["lot description"] as? String
            lotSize = locationInfo["lot size"] as? String
            lotOrGarage = locationInfo["lotORgarage"] as? String
            overnight = locationInfo["overnight"] as? String
            street = locationInfo["street"] as? String
            if address == nil { address = street }
            subAdministrativeArea = locationInfo["subAdministrativeArea"] as? String
            subLocality = locationInfo["subLocality"] as? String
        }
        
        if let handicapInfo = dictionary["Handicap Info"] as? [String: Any] {
            handicap = handicapInfo["handicap"] as? String
            handicapNumber = handicapInfo["handicap number"] as? String
        }
        
        determineAvailability()
    }
    
    private func determineOperator(parkingOperator: String) {
        let defaultOperator = parkingOperator.lowercased()
        if defaultOperator.contains("abm ") {
            shortOperator = "ABM"
        } else if defaultOperator.contains("ace ") {
            shortOperator = "ACE"
        } else if defaultOperator.contains("ucsd ") {
            shortOperator = "UCSD"
        } else if defaultOperator.contains("dot ") {
            shortOperator = "DOT"
        } else if defaultOperator.contains("diamond ") {
            shortOperator = "Diamond"
        } else if defaultOperator.contains("park 'n ") {
            shortOperator = "PnF"
        } else if defaultOperator.contains("port ") {
            shortOperator = "PORT"
        } else if defaultOperator.contains("metropolitan transit ") {
            shortOperator = "MTS"
        } else if defaultOperator.contains("zoo") {
            shortOperator = "ZOO"
        } else if defaultOperator.contains("the lot") {
            shortOperator = "LOT"
        } else if defaultOperator.contains("laz") {
            shortOperator = "Laz"
        }
    }
    
    private func determineAvailability() {
        setTimes()
        if let first = parkingTimes.first {
            availabilityLikelihood = first
        }
    }
    
    private func setTimes() {
        let date = Date().round(precision: TimeInterval(1800), rule: .toNearestOrAwayFromZero)
        let hour = Calendar.current.component(.hour, from: date)
        var halfHour = Calendar.current.component(.minute, from: date)
        if halfHour == 30 {
            halfHour = 1
        } else {
            halfHour = 0
        }
        let index = hour * 2 + halfHour
        let first = parkingTimes[0..<index]
        let second = parkingTimes[index..<parkingTimes.count]
        let newTimes = second + first
        let array = newTimes.map({ (x) -> CGFloat in
            let y = 1 - x
            return y
        })
        parkingTimes = array
    }
    
}
