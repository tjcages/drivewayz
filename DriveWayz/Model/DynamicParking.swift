//
//  Dynamic Parking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Firebase

struct DynamicParking {
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    static func getDynamicParking(parkingSpots: [ParkingSpots], dateFrom: Date, dateTo: Date, completion: @escaping([ParkingSpots]) -> ()) {
        var finalParking = parkingSpots
        for parking in parkingSpots {
            let isAvailable = parking.isSpotAvailable
            if isAvailable == true {
                
            } else {
                finalParking = finalParking.filter { $0 != parking }
            }
        }
        
        
        
//        var parkingSpots: [ParkingSpots] = []
//        var parkingSpotsDictionary: [String: ParkingSpots] = [:]
//        let numberOfTotalParkingSpots: Int = parkingIDs.count
//
//        let ref = Database.database().reference().child("ParkingSpots")
//        for parking in parkingIDs {
//            ref.child(parking).observe(.value, with: { (snapshot) in
//                if var dictionary = snapshot.value as? [String:AnyObject] {
//                    let parking = ParkingSpots(dictionary: dictionary)
//                    let parkingID = dictionary["parkingID"] as! String
//                    parkingSpotsDictionary[parkingID] = parking
//                    parkingSpots = Array(parkingSpotsDictionary.values)
//
//                    if parkingSpotsDictionary.count == numberOfTotalParkingSpots {
//                        self.filterUnavailable(parkingSpots: parkingSpots, completion: { (finalParking) in
//                            completion(finalParking)
//                        })
//                    }
//                }
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        }
    }
    
    
    
    
    
    
    
//
//    static func filterUnavailable(parkingSpots: [ParkingSpots], completion: @escaping([ParkingSpots]) -> ()) {
//        let today = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        var parkingSpots = parkingSpots
//        var i = 0
//        for parking in parkingSpots {
//            i += 1
//            if parking.isSpotAvailable == false {
//                parkingSpots = parkingSpots.filter { $0 != parking }
//            } else {
//                if let day = today.dayOfWeek() {
//                    let todayString = formatter.string(from: today)
//                    let times = self.matchDayTimes(day: day, todayString: todayString, parking: parking)
//                    if let from = times.first, let to = times.last {
//                        if from == "Unavailable" || to == "Unavailable" {
//                            parking.isSpotAvailable = false
//                        }
//                        if i == parkingSpots.count {
//                            completion(parkingSpots)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    static func matchDayTimes(day: String, todayString: String, parking: ParkingSpots) -> [String] {
//        if day == "Monday" {
//            if let monday = parking.MondayUnavailable {
//                if monday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let mondayFrom = parking.mondayAvailableFrom, let mondayTo = parking.mondayAvailableTo {
//                return [mondayFrom, mondayTo]
//            } else {
//                return [""]
//            }
//        } else if day == "Tuesday" {
//            if let tuesday = parking.TuesdayUnavailable {
//                if tuesday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let tuesdayFrom = parking.tuesdayAvailableFrom, let tuesdayTo = parking.tuesdayAvailableTo {
//                return [tuesdayFrom, tuesdayTo]
//            } else {
//                return [""]
//            }
//        } else if day == "Wednesday" {
//            if let wednesday = parking.WednesdayUnavailable {
//                if wednesday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let wednesdayFrom = parking.wednesdayAvailableFrom, let wednesdayTo = parking.wednesdayAvailableTo {
//                return [wednesdayFrom, wednesdayTo]
//            } else {
//                return [""]
//            }
//        } else if day == "Thursday" {
//            if let thursday = parking.ThursdayUnavailable {
//                if thursday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let thursdayFrom = parking.thursdayAvailableFrom, let thursdayTo = parking.thursdayAvailableTo {
//                return [thursdayFrom, thursdayTo]
//            } else {
//                return [""]
//            }
//        } else if day == "Friday" {
//            if let friday = parking.FridayUnavailable {
//                if friday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let fridayFrom = parking.fridayAvailableFrom, let fridayTo = parking.fridayAvailableTo {
//                return [fridayFrom, fridayTo]
//            } else {
//                return [""]
//            }
//        } else if day == "Saturday" {
//            if let saturday = parking.SaturdayUnavailable {
//                if saturday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let saturdayFrom = parking.saturdayAvailableFrom, let saturdayTo = parking.saturdayAvailableTo {
//                return [saturdayFrom, saturdayTo]
//            } else {
//                return [""]
//            }
//        } else if day == "Sunday" {
//            if let sunday = parking.SundayUnavailable {
//                if sunday.contains(todayString) {
//                    return ["Unavailable"]
//                }
//            }
//            if let sundayFrom = parking.sundayAvailableFrom, let sundayTo = parking.sundayAvailableTo {
//                return [sundayFrom, sundayTo]
//            } else {
//                return [""]
//            }
//        } else {
//            return [""]
//        }
//    }
    
}
