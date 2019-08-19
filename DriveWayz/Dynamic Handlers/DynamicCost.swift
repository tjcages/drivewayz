//
//  DynamicCost.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import CoreLocation
import EventKit

//var sameLocation: CLLocationCoordinate2D?

var surgePercentage: CGFloat = 0.8
var surgeCutoff: CGFloat = 0.6
var percentReduction: CGFloat = 0.85

var SurgeDemand: [String: [String: [String: [String: Int]]]]?
var SurgeCheck: [String: [String: [String: [String: Int]]]]?
var surgeCheckedCity: String?
var surgeCheckedLocation: CLLocationCoordinate2D?

struct DynamicPricing {
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    static func getDynamicPricing(parking: ParkingSpots, completion: @escaping(CGFloat) -> ()) {
        if let state = parking.stateAddress, let latitude = parking.latitude, let longitude = parking.longitude, let surgeDemand = SurgeDemand, let surgeCheck = SurgeCheck {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            if let zip = parking.zipAddress, let city = parking.cityAddress, let parkingCost = parking.parkingCost {
                var dynamicPrice: CGFloat = CGFloat(parkingCost)
                if let totalStates = surgeDemand[state], let totalCities = totalStates[city], let totalZips = totalCities[zip], let totalStatesCheck = surgeCheck[state], let totalCitiesCheck = totalStatesCheck[city], let totalZipsCheck = totalCitiesCheck[zip] {
                    var totalHosts = 0
                    for value in totalZipsCheck.values {
                        totalHosts += value
                    }
                    var totalAvailable: Int = 0
                    let values = totalZips.values
                    // Count up host many spaces are available in each location
                    for value in values {
                        totalAvailable += value
                    }
                    
                    if totalHosts >= 5 {
                        let percent = CGFloat(Double(totalAvailable)/Double(totalHosts))
                        if percent <= surgeCutoff {
                            // Surge
                            let surgeAmount = surgePercentage * (1 - percent)
                            dynamicPrice = dynamicPrice + dynamicPrice * surgeAmount
                            let finalPrice = self.filterDynamicPricing(place: location, state: state, city: city, averagePrice: dynamicPrice)
                            completion(finalPrice)
                            return
                        } else {
                            // No surge
                            let finalPrice = self.filterDynamicPricing(place: location, state: state, city: city, averagePrice: dynamicPrice)
                            completion(finalPrice)
                            return
                        }
                    } else {
                        // No surge
                        let finalPrice = self.filterDynamicPricing(place: location, state: state, city: city, averagePrice: dynamicPrice)
                        completion(finalPrice)
                        return
                    }
                } else {
                    // Error
                    completion(dynamicPrice)
                    return
                }
            } else {
                // Error
                completion(3.0)
                return
            }
        } else {
            // Error
            completion(3.0)
            return
        }
    }
    
    static var checkedAdresses: [String] = []
    static var checkedLocations: [String: CLLocation] = [:]
    
    //filter through all dynamic pricing options to determine a final price
    static func filterDynamicPricing(place: CLLocationCoordinate2D, state: String, city: String, averagePrice: CGFloat) -> CGFloat {
        let location = checkLocations(city: city, state: state)
        if location != CLLocationCoordinate2D() {
            let cityPricing = getCityPricing(place: place, geoLocation: location, state: state, city: city, averagePrice: averagePrice)
            let eventPricing = getEventPricing(place: place, geoLocation: location, averagePrice: cityPricing)
            let timePricing = getTimePricing(averagePrice: eventPricing)
            let yearPricing = getYearPricing(averagePrice: timePricing)
            let holidayPricing = getHolidayPricing(averagePrice: yearPricing)
            
            return holidayPricing
        } else {
            let timePricing = getTimePricing(averagePrice: averagePrice)
            let yearPricing = getYearPricing(averagePrice: timePricing)
            let holidayPricing = getHolidayPricing(averagePrice: yearPricing)
            
            return holidayPricing
        }
    }
    
    static func checkLocations(city: String, state: String) -> CLLocationCoordinate2D {
        guard let stateAbrv = statesDictionary[state] else { return CLLocationCoordinate2D() }
        if surgeCheckedCity == nil {
            surgeCheckedCity = city
            for stringArray in stringCityArray {
                if let stateAr = stringArray.first {
                    if stateAr == stateAbrv {
                        if let cityAr = stringArray.dropFirst().first {
                            if cityAr == city {
                                if let lat = stringArray.dropFirst().dropFirst().first, let long = stringArray.dropFirst().dropFirst().dropFirst().first {
                                    if let latitude = Double(lat), let longitude = Double(long) {
                                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        surgeCheckedLocation = location
                                        
                                        return location
                                    } else {
                                        // Error
                                        return CLLocationCoordinate2D()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return CLLocationCoordinate2D()
        } else {
            if let location = surgeCheckedLocation {
                return location
            } else {
                return CLLocationCoordinate2D()
            }
        }
    }
    
    //change price based on distance to city center
    static func getCityPricing(place: CLLocationCoordinate2D, geoLocation: CLLocationCoordinate2D, state: String, city: String, averagePrice: CGFloat) -> CGFloat {
        let distance = place.distance(to: geoLocation)
        if distance <= 322 { //0.2 mile away from center city
            let newAverage = averagePrice + averagePrice * 0.3
            return newAverage
        } else if distance <= 644 { //0.4 mile away from center city
            let newAverage = averagePrice + averagePrice * 0.2
            return newAverage
        } else if distance <= 966 { //0.6 mile away from center city
            let newAverage = averagePrice + averagePrice * 0.1
            return newAverage
        } else { //1 mile away from center city
            let newAverage = averagePrice - averagePrice * 0.3
            return newAverage
        }
    }
    
    //change price if spot is located near an event location
    static func getEventPricing(place: CLLocationCoordinate2D, geoLocation: CLLocationCoordinate2D, averagePrice: CGFloat) -> CGFloat {
        let nonDynamicPrice = percentReduction * averagePrice
        return nonDynamicPrice
        
        
//        DynamicEvents.eventLookup(userLocation: place, searchCity: city) { (results) in
//            if results > 0.0 {
//                let dynamicPrice = averagePrice + averagePrice * CGFloat(results)
//                completion(dynamicPrice)
//            } else {
//                let nonDynamicPrice = 0.45 * averagePrice
//                completion(nonDynamicPrice)
//            }
//        }
//        DynamicEvents.checkDistance(userLocation: geoLocation.coordinate) { (results) in
//            if results > 0.0 {
//                let percentage = results * 0.2
//                let dynamicPrice = averagePrice + averagePrice * CGFloat(percentage)
//                completion(dynamicPrice)
//            } else {
//                let nonDynamicPrice = 0.45 * averagePrice
//                completion(nonDynamicPrice)
//            }
//        }
    }
    
    //change price based on time of day
    static func getTimePricing(averagePrice: CGFloat) -> CGFloat {
        switch solar {
        case .day:
            return averagePrice
        case .night:
            let nightPrice = averagePrice + averagePrice * 0.35
            return nightPrice
        }
    }
    
    //change price based on time of year
    static func getYearPricing(averagePrice: CGFloat) -> CGFloat {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        if let month = calendar.dateComponents([Calendar.Component.month], from: currentDate).month {
            if month >= 11 || month < 2 {
                let percentage: CGFloat = 0.05
                let monthPricing = averagePrice + averagePrice * percentage
                return monthPricing
            } else if month >= 2 && month < 5 {
                let percentage: CGFloat = 0.0
                let monthPricing = averagePrice + averagePrice * percentage
                return monthPricing
            } else if month >= 5 && month < 8 {
                let percentage: CGFloat = 0.1
                let monthPricing = averagePrice + averagePrice * percentage
                return monthPricing
            } else if month >= 8 && month < 11 {
                let percentage: CGFloat = 0.0
                let monthPricing = averagePrice + averagePrice * percentage
                return monthPricing
            } else {
                return averagePrice
            }
        } else {
            // Error
            return averagePrice
        }
    }
    
    static var stringCityArray: [[String]] = []
    
    static func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    static func readDataFromCSV(fileName: String, fileType: String) -> String! {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    static func cleanRows(file: String) -> String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: ",,,", with: "")
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    
    static func readCityCSV() {
//        if var data = readDataFromCSV(fileName: "uscitiesv1.5", fileType: "csv") {
        if var data = readDataFromCSV(fileName: "cities", fileType: "csv") {
            data = cleanRows(file: data)
            let csvRows = csv(data: data)
            var newRows: [[String]] = []
            for rows in csvRows {
                let separator = rows[0]
                let strings = separator.split(separator: ",")
                var stringArray: [String] = []
                for string in strings {
                    stringArray.append(String(string))
                }
                newRows.append(stringArray)
            }
            self.stringCityArray = newRows
        }
    }

}


class CSV: NSObject {
    
    var driverID: String?
    var fromDate: TimeInterval?
    var hours: Double?
    var parkingID: String?
    var vehicleID : String?
    var price: Double?
    var toDate: TimeInterval?
    
    var parkingLat: Double?
    var parkingLong: Double?
    var destinationLat: Double?
    var destinationLong: Double?
    
    var discount: Int?
    var totalCost: Double?
    var stringDate: String?
    
    var userName: String?
    var userDuration: String?
    var userProfileURL: String?
    var userRating: Double?
    var userOverstayed: Bool?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        driverID = dictionary["driverID"] as? String
        fromDate = dictionary["fromDate"] as? TimeInterval
        hours = dictionary["hours"] as? Double
        parkingID = dictionary["parkingID"] as? String
        vehicleID = dictionary["vehicleID"] as? String
        price = dictionary["price"] as? Double
        toDate = dictionary["toDate"] as? TimeInterval
        
        parkingLat = dictionary["finalParkingLat"] as? Double
        parkingLong = dictionary["finalParkingLong"] as? Double
        destinationLat = dictionary["finalDestinationLat"] as? Double
        destinationLong = dictionary["finalDestinationLong"] as? Double
        
        discount = dictionary["discount"] as? Int
        totalCost = dictionary["totalCost"] as? Double
        
        userName = dictionary["driverName"] as? String
        userProfileURL = dictionary["driverPicture"] as? String
        userRating = dictionary["driverRating"] as? Double
        if userRating == nil {
            userRating = 5.0
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        guard let from = fromDate else { return }
        let date = Date(timeIntervalSince1970: from)
        stringDate = formatter.string(from: date)
        
        if let fromInterval = self.fromDate, let toInterval = self.toDate {
            let today = Date().timeIntervalSince1970
            if today > fromInterval && today < toInterval {
                self.userOverstayed = false
            } else if today > fromInterval && today >= toInterval {
                self.userOverstayed = true
            }
            let fromDate = Date(timeIntervalSince1970: fromInterval)
            let toDate = Date(timeIntervalSince1970: toInterval)
            let formatter = DateFormatter()
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            formatter.dateFormat = "h:mma"
            let fromString = formatter.string(from: fromDate)
            let toString = formatter.string(from: toDate)
            let dates = "\(fromString) - \(toString)"
            self.userDuration = dates
        }
        
    }
    
}


//weather 
//events /
//////surge/demand
//traffic
//time of year /
//time of day /
//holidays /
//structured by distance to destination /

//let reference = Database.database().reference().child("Average Prices")
//reference.child("OK").updateChildValues(["Oklahoma City":0.8333])
//reference.child("MO").updateChildValues(["Jefferson City":1.6667,"Kansas City":1.6667, "St Louis":3.0833])
//reference.child("KS").updateChildValues(["Kansas City":1.6667, "Topeka":1.6667])
//reference.child("FL").updateChildValues(["Tampa":1.7000, "St Petersburg":1.7000, "Clearwater":1.7000, "Jacksonville":2.5833, "Miami":3.2550, "Fort Lauderdale":3.2550, "West Palm Beach":3.2550])
//reference.child("AZ").updateChildValues(["Tucson":1.9167, "Phoenix":2.1667, "Mesa":2.1667, "Scottsdale":2.1667])
//reference.child("NV").updateChildValues(["Las Vegas":1.9167, "Henderson":1.9167, "Paradise":1.9167])
//reference.child("KY").updateChildValues(["Louisville":2.1667, "Jefferson County":2.1667, "Cincinnati":2.1667])
//reference.child("IN").updateChildValues(["Louisville":2.1667, "Jefferson County":2.1667, "Cincinnati":2.1667, "Indianapolis":4.4167, "Carmel":4.4167, "Anderson":4.4167, "Chicago":10.2833, "Naperville":10.2833, "Elgin":10.2833])
//reference.child("OH").updateChildValues(["Cincinnati":2.1667, "Columbus":2.7500, "Cleveland":3.8333, "Elyria":3.8333])
//reference.child("NY").updateChildValues(["Rochester":2.2000, "Buffalo":3.3833, "Cheektowaga":3.3833, "Niagara Falls":3.3833, "New York":24.4140, "Newark":24.4140, "Jersey City":24.4140, "Jersey Shore":24.4140])
//reference.child("NC").updateChildValues(["Raleigh":2.2500, "Charlotte":3.1667, "Concord":3.1667, "Gastonia":3.1667])
//reference.child("TN").updateChildValues(["Memphis":2.3167, "Nashville":4.2500, "Davidson":4.2500, "Murfreesboro":4.2500, "Franklin":4.2500])
//reference.child("MS").updateChildValues(["Memphis":2.3167])
//reference.child("AR").updateChildValues(["Memphis":2.3167])
//reference.child("TX").updateChildValues(["Dallas":2.5000, "Fort Worth":2.5000, "Arlington":2.5000, "San Antonio":2.8333, "New Braunfels":2.8333, "Austin":4.6667, "Round Rock":4.6667, "Houston":7.2500, "The Woodlands":7.2500, "Sugar Land":7.2500])
//reference.child("GA").updateChildValues(["Atlanta":2.6667, "Sandy Springs":2.6667, "Roswell":2.6667])
//reference.child("AL").updateChildValues(["Birmingham":2.7500, "Hoover":2.7500])
//reference.child("IL").updateChildValues(["St Louis":3.0833, "Chicago":10.2833, "Naperville":10.2833, "Elgin":10.2833])
//reference.child("SC").updateChildValues(["Charlotte":3.1667, "Concord":3.1667, "Gastonia":3.1667])
//reference.child("CA").updateChildValues(["San Jose":3.5833, "Sunnyvale":3.5833, "Santa Clara":3.5833, "Los Angeles":4.1667, "Long Beach":4.1667, "Anaheim":4.1667, "Sacramento":6.0000, "Roseville":6.0000, "Arden":6.0000, "Arcade":6.0000, "San Diego":6.1667, "Carlsbad":6.1667, "San Francisco":10.6667, "Oakland":10.6667, "Hayward":10.6667])
//reference.child("WI").updateChildValues(["Milwaukee":3.9360, "Waukesha":3.9360, "West Allis":3.9360, "Minneapolis":5.5833, "St Paul":5.5833, "Bloomington":5.5833, "Chicago":10.2833, "Naperville":10.2833, "Elgin":10.2833])
//reference.child("MI").updateChildValues(["Grand Rapids":4.2667, "Wyoming":4.2667, "Detroit":4.8333, "Warren":4.8333, "Dearborn":4.8333])
//reference.child("MN").updateChildValues(["Minneapolis":5.5833, "St Paul":5.5833, "Bloomington":5.5833])
//reference.child("CO").updateChildValues(["Denver":5.6667, "Aurora":5.6667, "Lakewood":5.6667])
//reference.child("LA").updateChildValues(["New Orleans":5.7500, "Metairie":5.7500])
//reference.child("MD").updateChildValues(["Baltimore":6.4167, "Columbia":6.4167, "Towson":6.4167, "Philadelphia":10.8333, "Camden":10.8333, "Wilmington":10.8333, "Washington":14.2977, "Arlington":14.2977, "Alexandria":14.2977])
//reference.child("OR").updateChildValues(["Portland":6.5500, "Vancouver":6.5500, "Hillsboro":6.5500])
//reference.child("WA").updateChildValues(["Portland":6.5500, "Vancouver":6.5500, "Hillsboro":6.5500, "Seattle":9.5875, "Tacoma":9.5875, "Bellevue":9.5875])
//reference.child("PA").updateChildValues(["Pittsburgh":8.1667, "Philadelphia":10.8333, "Camden":10.8333, "Wilmington":10.8333, "New York":24.4140, "Newark":24.4140, "Jersey City":24.4140, "Jersey Shore":24.4140])
//reference.child("OR").updateChildValues(["Chicago":10.2833, "Naperville":10.2833, "Elgin":10.2833])
//reference.child("NJ").updateChildValues(["Philadelphia":10.8333, "Camden":10.8333, "Wilmington":10.8333, "New York":24.4140, "Newark":24.4140, "Jersey City":24.4140, "Jersey Shore":24.4140])
//reference.child("DE").updateChildValues(["Philadelphia":10.8333, "Camden":10.8333, "Wilmington":10.8333])
//reference.child("DC").updateChildValues(["Washington":14.2977, "Arlington":14.2977, "Alexandria":14.2977])
//reference.child("VA").updateChildValues(["Washington":14.2977, "Arlington":14.2977, "Alexandria":14.2977])
//reference.child("WV").updateChildValues(["Washington":14.2977, "Arlington":14.2977, "Alexandria":14.2977])
//reference.child("MA").updateChildValues(["Boston":15.2500, "Cambridge":15.2500, "Newton":15.2500])
//reference.child("NH").updateChildValues(["Boston":15.2500, "Cambridge":15.2500, "Newton":15.2500])

//let reference = Database.database().reference().child("Average Prices")
//reference.child("OK").updateChildValues(["Standard":0.8333])
//reference.child("MO").updateChildValues(["Standard":1.6667])
//reference.child("KS").updateChildValues(["Standard":1.6667])
//reference.child("FL").updateChildValues(["Standard":1.7000])
//reference.child("AZ").updateChildValues(["Standard":1.9167])
//reference.child("NV").updateChildValues(["Standard":1.9167])
//reference.child("KY").updateChildValues(["Standard":2.1667])
//reference.child("IN").updateChildValues(["Standard":2.1667])
//reference.child("OH").updateChildValues(["Standard":2.1667])
//reference.child("NY").updateChildValues(["Standard":2.2000])
//reference.child("NC").updateChildValues(["Standard":2.2500])
//reference.child("TN").updateChildValues(["Standard":2.3167])
//reference.child("MS").updateChildValues(["Standard":2.3167])
//reference.child("AR").updateChildValues(["Standard":2.3167])
//reference.child("TX").updateChildValues(["Standard":2.5000])
//reference.child("GA").updateChildValues(["Standard":2.6667])
//reference.child("AL").updateChildValues(["Standard":2.7500])
//reference.child("IL").updateChildValues(["Standard":3.0833])
//reference.child("SC").updateChildValues(["Standard":3.1667])
//reference.child("CA").updateChildValues(["Standard":3.5833])
//reference.child("WI").updateChildValues(["Standard":3.9360])
//reference.child("MI").updateChildValues(["Standard":4.2667])
//reference.child("MN").updateChildValues(["Standard":5.5833])
//reference.child("CO").updateChildValues(["Standard":5.6667])
//reference.child("LA").updateChildValues(["Standard":5.7500])
//reference.child("MD").updateChildValues(["Standard":6.4167])
//reference.child("OR").updateChildValues(["Standard":6.5500])
//reference.child("WA").updateChildValues(["Standard":6.5500])
//reference.child("PA").updateChildValues(["Standard":7.1667])
//reference.child("OR").updateChildValues(["Standard":8.2833])
//reference.child("NJ").updateChildValues(["Standard":8.8333])
//reference.child("DE").updateChildValues(["Standard":8.8333])
//reference.child("DC").updateChildValues(["Standard":9.2977])
//reference.child("VA").updateChildValues(["Standard":9.2977])
//reference.child("WV").updateChildValues(["Standard":9.2977])
//reference.child("MA").updateChildValues(["Standard":9.2500])
//reference.child("NH").updateChildValues(["Standard":9.2500])
