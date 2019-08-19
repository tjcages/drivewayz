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
    
    static func getDynamicParking(parkingSpot: ParkingSpots, dateFrom: Date, dateTo: Date, completion: @escaping(ParkingSpots) -> ()) {
        let parking = parkingSpot
        if let fromDay = dateFrom.dayOfWeek(), let toDay = dateTo.dayOfWeek() {
            if fromDay == toDay {
                // Only one day
                let dates = self.checkDayAvailability(day: fromDay, checkDate: dateFrom, parking: parking)
                if dates.count == 2 {
                    // Have correct dates to then check
                    parking.CurrentDurationAvailable = dates
                    let available = self.checkDurationAvailability(dayAvailability: dates, dateFrom: dateFrom, dateTo: dateTo)
                    if available == "" {
                        completion(parking)
                        return
                    } else {
                        parking.isSpotAvailable = false
                        completion(parking)
                        return
                    }
                } else {
                    // Database doesn't contain correct times
                    parking.isSpotAvailable = false
                    completion(parking)
                    return
                }
            } else {
                // Multiple days
                let fromDates = self.checkDayAvailability(day: fromDay, checkDate: dateFrom, parking: parking)
                let toDates = self.checkDayAvailability(day: toDay, checkDate: dateTo, parking: parking)
                if fromDates.count == 2 && toDates.count == 2 {
                    if let fromAvailable = fromDates.first, let toAvailable = toDates.last {
                        parking.CurrentDurationAvailable = [fromAvailable, toAvailable]
                        
                        let daysDifference = toAvailable.compare(with: fromAvailable, only: .day)
                        if daysDifference < 2 {
                            // Second day must be available
                            if let fromAvailableCheck = fromDates.last, let toAvailableCheck = toDates.first {
                                let fromTimestamp = fromAvailableCheck.timeIntervalSince1970
                                let toTimestamp = toAvailableCheck.timeIntervalSince1970
                                let minuteDifference = (toTimestamp - fromTimestamp)/60
                                if minuteDifference <= 15 {
                                    completion(parking)
                                    return
                                } else {
                                    // Second day isn't available early enough
                                    parking.isSpotAvailable = false
                                    completion(parking)
                                    return
                                }
                            } else {
                                // Error
                                parking.isSpotAvailable = false
                                completion(parking)
                                return
                            }
                        } else {
                            // NEEDS Longterm
                            parking.isSpotAvailable = false ///////////////////////NEEEDS FIZXING ///////////////////////////////////////////
                            completion(parking)
                            return
                        }
                    } else {
                        // Error
                        parking.isSpotAvailable = false
                        completion(parking)
                        return
                    }
                } else {
                    // Database doesn't contain correct times
                    parking.isSpotAvailable = false
                    completion(parking)
                    return
                }
            }
        } else {
            // Error
            parking.isSpotAvailable = false
            completion(parking)
            return
        }
    }
    
    static func checkDurationAvailability(dayAvailability: [Date], dateFrom: Date, dateTo: Date) -> String {
        guard let availableFrom = dayAvailability.first, let availabelTo = dayAvailability.last else { return "This spot is marked inactive" }
        if availabelTo > availableFrom {
            if dateFrom >= availableFrom && dateFrom < availabelTo {
                // From is available
                if dateTo > availableFrom && dateTo <= availabelTo {
                    // To is available
                    return ""
                } else {
                    // To is unavailable
                    return "Please reduce your end time"
                }
            } else {
                // From is unavailable
                return "Please change your start time"
            }
        } else {
            // The from and to times are the same
            return "Please change your duration"
        }
    }
    
    static func convertToDates(checkDate: Date, fromString: String, toString: String) -> [Date] {
        // NEED "MM-dd-yyyy hh:mm a"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy "
        let dateString = dateFormatter.string(from: checkDate)
        
        let finalDateFormatter = DateFormatter()
        finalDateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        
        if fromString != "All day" && toString != "All day" {
            // Spot is not available All day
            let fromDateString = dateString + fromString
            let toDateString = dateString + toString
            if let fromDate = finalDateFormatter.date(from: fromDateString), let toDate = finalDateFormatter.date(from: toDateString) {
                // Successfully converted from string to date
                return [fromDate, toDate]
            } else {
                // Error
                print("Error converting from string to date")
                return [Date()]
            }
        } else {
            // Spot is available All day
            let minString = "12:01 AM"
            let maxString = "11:59 PM"
            let fromDateString = dateString + minString
            let toDateString = dateString + maxString
            if let fromDate = finalDateFormatter.date(from: fromDateString), let toDate = finalDateFormatter.date(from: toDateString) {
                // Successfully converted from string to date
                return [fromDate, toDate]
            } else {
                // Error
                print("Error converting from string to date")
                return [Date()]
            }
        }
    }
    
    static func checkDayAvailability(day: String, checkDate: Date, parking: ParkingSpots) -> [Date] {
        if day == "Monday" {
            if let availableFrom = parking.mondayAvailableFrom, let availableTo = parking.mondayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else if day == "Tuesday" {
            if let availableFrom = parking.tuesdayAvailableFrom, let availableTo = parking.tuesdayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else if day == "Wednesday" {
            if let availableFrom = parking.wednesdayAvailableFrom, let availableTo = parking.wednesdayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else if day == "Thursday" {
            if let availableFrom = parking.thursdayAvailableFrom, let availableTo = parking.thursdayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else if day == "Friday" {
            if let availableFrom = parking.fridayAvailableFrom, let availableTo = parking.fridayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else if day == "Saturday" {
            if let availableFrom = parking.saturdayAvailableFrom, let availableTo = parking.saturdayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else if day == "Sunday" {
            if let availableFrom = parking.sundayAvailableFrom, let availableTo = parking.sundayAvailableTo {
                let dates = self.convertToDates(checkDate: checkDate, fromString: availableFrom, toString: availableTo)
                return dates
            } else {
                return [Date()]
            }
        } else {
            return [Date()]
        }
    }
    
}
