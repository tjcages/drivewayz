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
                let removalDay = self.removeBlackoutDays(parkingSpot: parking, dateFrom: dateFrom, dateTo: dateTo)
                if removalDay != true {
                    let removalHour = self.removeBlackoutHours(parkingSpot: parking, dateFrom: dateFrom, dateTo: dateTo)
                    if removalHour != true {
                        ///////
                        
                    } else {
                        finalParking = finalParking.filter { $0 != parking }
                    }
                } else {
                    finalParking = finalParking.filter { $0 != parking }
                }
            } else {
                finalParking = finalParking.filter { $0 != parking }
            }
            if parking == parkingSpots.last {
                completion(finalParking)
            }
        }
    }
    
    static func removeBlackoutDays(parkingSpot: ParkingSpots, dateFrom: Date, dateTo: Date) -> Bool {
        if let dayOfTheWeekFrom = dateFrom.dayOfWeek(), let dayOfTheWeekTo = dateTo.dayOfWeek() {
            if dayOfTheWeekFrom == dayOfTheWeekTo {
                if dayOfTheWeekFrom == "Monday" {
                    let unavailableDay = parkingSpot.mondayUnavailable
                    return unavailableDay
                } else if dayOfTheWeekFrom == "Tuesday" {
                    let unavailableDay = parkingSpot.tuesdayUnavailable
                    return unavailableDay
                } else if dayOfTheWeekFrom == "Wednesday" {
                    let unavailableDay = parkingSpot.wednesdayUnavailable
                    return unavailableDay
                } else if dayOfTheWeekFrom == "Thursday" {
                    let unavailableDay = parkingSpot.thursdayUnavailable
                    return unavailableDay
                } else if dayOfTheWeekFrom == "Friday" {
                    let unavailableDay = parkingSpot.fridayUnavailable
                    return unavailableDay
                } else if dayOfTheWeekFrom == "Saturday" {
                    let unavailableDay = parkingSpot.saturdayUnavailable
                    return unavailableDay
                } else if dayOfTheWeekFrom == "Sunday" {
                    let unavailableDay = parkingSpot.sundayUnavailable
                    return unavailableDay
                }
            } else {
                //days not equal
                return false
            }
        } else {
            return true
        }
        return true
    }
    
    static func removeBlackoutHours(parkingSpot: ParkingSpots, dateFrom: Date, dateTo: Date) -> Bool {
        if let dayOfTheWeekFrom = dateFrom.dayOfWeek(), let dayOfTheWeekTo = dateTo.dayOfWeek() {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyy"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyy h:mm a"
            if dayOfTheWeekFrom == dayOfTheWeekTo {
                let days = formatter.string(from: dateFrom)
                var fullStringFrom = days + " "
                var fullStringTo = days + " "
                if dayOfTheWeekFrom == "Monday" {
                    if let availableStart = parkingSpot.mondayAvailableFrom, let availableEnd = parkingSpot.mondayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                } else if dayOfTheWeekFrom == "Tuesday" {
                    if let availableStart = parkingSpot.tuesdayAvailableFrom, let availableEnd = parkingSpot.tuesdayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                } else if dayOfTheWeekFrom == "Wednesday" {
                    if let availableStart = parkingSpot.wednesdayAvailableFrom, let availableEnd = parkingSpot.wednesdayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                } else if dayOfTheWeekFrom == "Thursday" {
                    if let availableStart = parkingSpot.thursdayAvailableFrom, let availableEnd = parkingSpot.thursdayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                } else if dayOfTheWeekFrom == "Friday" {
                    if let availableStart = parkingSpot.fridayAvailableFrom, let availableEnd = parkingSpot.fridayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                } else if dayOfTheWeekFrom == "Saturday" {
                    if let availableStart = parkingSpot.saturdayAvailableFrom, let availableEnd = parkingSpot.saturdayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                } else if dayOfTheWeekFrom == "Sunday" {
                    if let availableStart = parkingSpot.sundayAvailableFrom, let availableEnd = parkingSpot.sundayAvailableTo {
                        if availableStart == "All day" || availableEnd == "All day" {
                            fullStringFrom = fullStringFrom + "0:00 AM"
                            let timeInterval = TimeInterval(3600 * 24)
                            let days = formatter.string(from: dateFrom.addingTimeInterval(timeInterval))
                            fullStringTo = days + " " + "0:00 AM"
                        } else {
                            fullStringFrom = fullStringFrom + availableStart
                            fullStringTo = fullStringTo + availableEnd
                        }
                    }
                }
                if let availableFromDate = dateFormatter.date(from: fullStringFrom), let availableToDate = dateFormatter.date(from: fullStringTo) {
                    if dateFrom >= availableFromDate && dateTo <= availableToDate {
                        return false
                    } else {
                        return true
                    }
                } else {
                    return true
                }
            } else {
                //days not equal
                return false
            }
        } else {
            return true
        }
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
