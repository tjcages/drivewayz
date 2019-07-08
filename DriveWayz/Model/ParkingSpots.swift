//
//  ParkingSpots.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ParkingSpots: NSObject {

    var hostEmail: String?
    var hostMessage: String?
    var id: String?
    var parkingCost: Double?
    var dynamicCost: Double?
    var parkingID: String?
    var timestamp: TimeInterval?
    var parkingDistance: Double?
    
    var ParkingType: [String:Any]?
    var gateNumber: String?
    var mainType: String?
    var numberSpots: String?
    var parkingNumber: String?
    var secondaryType: String?
    
    var parkingAmenities: [String]?
    
    var ParkingReviews: [String:Any]?
    var totalRating: Int?
    var numberRatings: String?
    
    var ParkingLocation: [String:Any]?
    var cityAddress: String?
    var countryAddress: String?
    var latitude: Double?
    var longitude: Double?
    var overallAddress: String?
    var stateAddress: String?
    var streetAddress: String?
    var zipAddress: String?
    
    var ParkingImages: [String:Any]?
    var firstImage: String?
    var secondImage: String?
    var thirdImage: String?
    var fourthImage: String?
    var fifthImage: String?
    var sixthImage: String?
    var seventhImage: String?
    var eighthImage: String?
    var ninethImage: String?
    var tenthImage: String?
    
    var ParkingAvailability: [String:Any]?
    var Monday: [String:Any]?
    var mondayAvailableFrom: String?
    var mondayAvailableTo: String?
    var Tuesday: [String:Any]?
    var tuesdayAvailableFrom: String?
    var tuesdayAvailableTo: String?
    var Wednesday: [String:Any]?
    var wednesdayAvailableFrom: String?
    var wednesdayAvailableTo: String?
    var Thursday: [String:Any]?
    var thursdayAvailableFrom: String?
    var thursdayAvailableTo: String?
    var Friday: [String:Any]?
    var fridayAvailableFrom: String?
    var fridayAvailableTo: String?
    var Saturday: [String:Any]?
    var saturdayAvailableFrom: String?
    var saturdayAvailableTo: String?
    var Sunday: [String:Any]?
    var sundayAvailableFrom: String?
    var sundayAvailableTo: String?
    
    var UnavailableDays: [String:Any]?
    var MondayUnavailable: [String]?
    var TuesdayUnavailable: [String]?
    var WednesdayUnavailable: [String]?
    var ThursdayUnavailable: [String]?
    var FridayUnavailable: [String]?
    var SaturdayUnavailable: [String]?
    var SundayUnavailable: [String]?
    
    var mondayAvailable: [Date]?
    var tuesdayAvailable: [Date]?
    var wednesdayAvailable: [Date]?
    var thursdayAvailable: [Date]?
    var fridayAvailable: [Date]?
    var saturdayAvailable: [Date]?
    var sundayAvailable: [Date]?
    
    var mondayUnavailable: Bool = false
    var tuesdayUnavailable: Bool = false
    var wednesdayUnavailable: Bool = false
    var thursdayUnavailable: Bool = false
    var fridayUnavailable: Bool = false
    var saturdayUnavailable: Bool = false
    var sundayUnavailable: Bool = false
    
    var isSpotAvailable: Bool = true
    
    var totalBookings: Int?
    var totalHours: Double?
    var totalDistance: Double?
    var totalProfits: Double?
    
    var Bookings: [String]?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        hostEmail = dictionary["hostEmail"] as? String
        hostMessage = dictionary["hostMessage"] as? String
        id = dictionary["id"] as? String
        parkingCost = dictionary["parkingCost"] as? Double
        parkingID = dictionary["parkingID"] as? String
        timestamp = dictionary["timestamp"] as? TimeInterval
        
        totalRating = dictionary["totalRating"] as? Int
        totalBookings = dictionary["totalBookings"] as? Int
        totalHours = dictionary["totalHours"] as? Double
        totalDistance = dictionary["totalDistance"] as? Double
        totalProfits = dictionary["totalProfits"] as? Double
        
        ParkingType = dictionary["Type"] as? [String: Any]
        if let parkingType = ParkingType {
            gateNumber = parkingType["gateNumber"] as? String
            mainType = parkingType["mainType"] as? String
            numberSpots = parkingType["numberSpots"] as? String
            parkingNumber = parkingType["parkingNumber"] as? String
            secondaryType = parkingType["secondaryType"] as? String
            parkingAmenities = parkingType["Amenities"] as? [String]
        }
        
        ParkingLocation = dictionary["Location"] as? [String:Any]
        if let parkingLocation = ParkingLocation {
            cityAddress = parkingLocation["cityAddress"] as? String
            countryAddress = parkingLocation["countryAddress"] as? String
            latitude = parkingLocation["latitude"] as? Double
            longitude = parkingLocation["longitude"] as? Double
            overallAddress = parkingLocation["overallAddress"] as? String
            stateAddress = parkingLocation["stateAddress"] as? String
            streetAddress = parkingLocation["streetAddress"] as? String
            zipAddress = parkingLocation["zipAddress"] as? String
        }
        
        ParkingReviews = dictionary["Reviews"] as? [String:Any]
        if let parkingReviews = ParkingReviews {
            numberRatings = parkingReviews["numberRatings"] as? String
        }
        
        ParkingImages = dictionary["SpotImages"] as? [String:Any]
        if let parkingImages = ParkingImages {
            firstImage = parkingImages["firstImage"] as? String
            secondImage = parkingImages["secondImage"] as? String
            thirdImage = parkingImages["thirdImage"] as? String
            fourthImage = parkingImages["fourthImage"] as? String
            fifthImage = parkingImages["fifthImage"] as? String
            sixthImage = parkingImages["sixthImage"] as? String
            seventhImage = parkingImages["seventhImage"] as? String
            eighthImage = parkingImages["eighthImage"] as? String
            ninethImage = parkingImages["ninethImage"] as? String
            tenthImage = parkingImages["tenthImage"] as? String
        }
        
        ParkingAvailability = dictionary["AvailableTimes"] as? [String:Any]
        if let parkingAvailability = ParkingAvailability {
            Monday = parkingAvailability["Monday"] as? [String:Any]
            if let monday = Monday {
                mondayAvailableFrom = monday["From"] as? String
                mondayAvailableTo = monday["To"] as? String
            }
            Tuesday = parkingAvailability["Tuesday"] as? [String:Any]
            if let tuesday = Tuesday {
                tuesdayAvailableFrom = tuesday["From"] as? String
                tuesdayAvailableTo = tuesday["To"] as? String
            }
            Wednesday = parkingAvailability["Wednesday"] as? [String:Any]
            if let wednesday = Wednesday {
                wednesdayAvailableFrom = wednesday["From"] as? String
                wednesdayAvailableTo = wednesday["To"] as? String
            }
            Thursday = parkingAvailability["Thursday"] as? [String:Any]
            if let thursday = Thursday {
                thursdayAvailableFrom = thursday["From"] as? String
                thursdayAvailableTo = thursday["To"] as? String
            }
            Friday = parkingAvailability["Friday"] as? [String:Any]
            if let friday = Friday {
                fridayAvailableFrom = friday["From"] as? String
                fridayAvailableTo = friday["To"] as? String
            }
            Saturday = parkingAvailability["Saturday"] as? [String:Any]
            if let saturday = Saturday {
                saturdayAvailableFrom = saturday["From"] as? String
                saturdayAvailableTo = saturday["To"] as? String
            }
            Sunday = parkingAvailability["Sunday"] as? [String:Any]
            if let sunday = Sunday {
                sundayAvailableFrom = sunday["From"] as? String
                sundayAvailableTo = sunday["To"] as? String
            }
        }
        
        UnavailableDays = dictionary["UnavailableDays"] as? [String:Any]
        if let unavailableDays = UnavailableDays {
            MondayUnavailable = unavailableDays["Monday"] as? [String]
            TuesdayUnavailable = unavailableDays["Tuesday"] as? [String]
            WednesdayUnavailable = unavailableDays["Wednesday"] as? [String]
            ThursdayUnavailable = unavailableDays["Thursday"] as? [String]
            FridayUnavailable = unavailableDays["Friday"] as? [String]
            SaturdayUnavailable = unavailableDays["Saturday"] as? [String]
            SundayUnavailable = unavailableDays["Sunday"] as? [String]
        }
        
        if let currentBooking = dictionary["CurrentBooking"] as? [String:Any] {
            isSpotAvailable = false
        }
        
        if let currentlyUnavailable = dictionary["ParkingUnavailability"] as? TimeInterval {
            isSpotAvailable = false
        }
        
        if let bookings = dictionary["Bookings"] as? [String: Any] {
            Bookings = []
            for key in bookings.keys {
                Bookings?.append(key)
            }
        }
        
        self.appendTimes()
    }
    
    private func appendTimes() {
        var today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for _ in 0...6 {
            if let day = today.dayOfWeek() {
                let todayString = formatter.string(from: today)
                let times = self.matchDayTimes(day: day, todayString: todayString)
                if let from = times.first, let to = times.last {
                    if from == "All day" || to == "All day" {
                        let fromToday = todayString + " 12:00 AM"
                        let tomorrowString = formatter.string(from: today.tomorrow)
                        let toToday = tomorrowString + " 12:00 AM"
                        self.sendFinalTimes(fromDateString: fromToday, toDateString: toToday, day: day)
                    } else if from == "Unavailable" {
                        self.sendFinalTimes(fromDateString: "Unavailable", toDateString: "Unavailable", day: day)
                    } else {
                        let fromToday = todayString + " " + from
                        let toToday = todayString + " " + to
                        self.sendFinalTimes(fromDateString: fromToday, toDateString: toToday, day: day)
                    }
                }
            }
            today = today.tomorrow
        }
        
    }
    
    private func sendFinalTimes(fromDateString: String, toDateString: String, day: String) {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd h:mm a"
        
        if day == "Monday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                mondayUnavailable = true
                mondayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                mondayUnavailable = false
                mondayAvailable = [fromDate, toDate]
                return
            }
        } else if day == "Tuesday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                tuesdayUnavailable = true
                tuesdayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                tuesdayUnavailable = false
                tuesdayAvailable = [fromDate, toDate]
                return
            }
        } else if day == "Wednesday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                wednesdayUnavailable = true
                wednesdayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                wednesdayUnavailable = false
                wednesdayAvailable = [fromDate, toDate]
                return
            }
        } else if day == "Thursday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                thursdayUnavailable = true
                thursdayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                thursdayUnavailable = false
                thursdayAvailable = [fromDate, toDate]
                return
            }
        } else if day == "Friday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                fridayUnavailable = true
                fridayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                fridayUnavailable = false
                fridayAvailable = [fromDate, toDate]
                return
            }
        } else if day == "Saturday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                saturdayUnavailable = true
                saturdayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                saturdayUnavailable = false
                saturdayAvailable = [fromDate, toDate]
                return
            }
        } else if day == "Sunday" {
            if fromDateString == "Unavailable" && toDateString == "Unavailable" {
                sundayUnavailable = true
                sundayAvailable = []
                return
            } else if let fromDate = formatter2.date(from: fromDateString), let toDate = formatter2.date(from: toDateString) {
                sundayUnavailable = false
                sundayAvailable = [fromDate, toDate]
                return
            }
        }
    }
    
    private func matchDayTimes(day: String, todayString: String) -> [String] {
        if day == "Monday" {
            if let monday = MondayUnavailable {
                if monday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let mondayFrom = mondayAvailableFrom, let mondayTo = mondayAvailableTo {
                return [mondayFrom, mondayTo]
            } else {
                return [""]
            }
        } else if day == "Tuesday" {
            if let tuesday = TuesdayUnavailable {
                if tuesday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let tuesdayFrom = tuesdayAvailableFrom, let tuesdayTo = tuesdayAvailableTo {
                return [tuesdayFrom, tuesdayTo]
            } else {
                return [""]
            }
        } else if day == "Wednesday" {
            if let wednesday = WednesdayUnavailable {
                if wednesday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let wednesdayFrom = wednesdayAvailableFrom, let wednesdayTo = wednesdayAvailableTo {
                return [wednesdayFrom, wednesdayTo]
            } else {
                return [""]
            }
        } else if day == "Thursday" {
            if let thursday = ThursdayUnavailable {
                if thursday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let thursdayFrom = thursdayAvailableFrom, let thursdayTo = thursdayAvailableTo {
                return [thursdayFrom, thursdayTo]
            } else {
                return [""]
            }
        } else if day == "Friday" {
            if let friday = FridayUnavailable {
                if friday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let fridayFrom = fridayAvailableFrom, let fridayTo = fridayAvailableTo {
                return [fridayFrom, fridayTo]
            } else {
                return [""]
            }
        } else if day == "Saturday" {
            if let saturday = SaturdayUnavailable {
                if saturday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let saturdayFrom = saturdayAvailableFrom, let saturdayTo = saturdayAvailableTo {
                return [saturdayFrom, saturdayTo]
            } else {
                return [""]
            }
        } else if day == "Sunday" {
            if let sunday = SundayUnavailable {
                if sunday.contains(todayString) {
                    return ["Unavailable"]
                }
            }
            if let sundayFrom = sundayAvailableFrom, let sundayTo = sundayAvailableTo {
                return [sundayFrom, sundayTo]
            } else {
                return [""]
            }
        } else {
            return [""]
        }
    }
    
    private func checkStrings(dayArray: [String], today: String, array: [Date]?, fromTime: String, toTime: String) -> [Date] {
//        for day in dayArray {
//            if day == today {
//                isSpotAvailable = false
//                return []
//            }
//        }
//
//        let result = nextWeekdays.map { weekday -> Date in
//            let components = DateComponents(weekday: weekday)
//            let nextOccurrence = calendar.nextDate(after: currentDate, matching: components, matchingPolicy: .nextTime)!
//            currentDate = nextOccurrence
//            return nextOccurrence
//        }
//        print(result)
//
        return []
    }
    
}
