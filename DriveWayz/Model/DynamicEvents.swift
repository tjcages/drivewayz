//
//  DynamicEvents.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import CoreLocation

var localEventLocations: [CLLocationCoordinate2D] = []
var lastEventName: String = ""

struct DynamicEvents {
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {

    }
    
    static func eventLookup(userLocation: CLLocationCoordinate2D, searchCity: String, completion: @escaping(CGFloat) -> ()) {
//        var checkedEvents: [String] = []
        var eventCounter: Int = 0
//        var locationCounter: Int = 0
        
        if let localEvents = localEventLookup {
            for event in localEvents {
                if event.name != lastEventName {
                    lastEventName = event.name
                    let isoDate = "\(event.date) \(event.time)"
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let date = dateFormatter.date(from: isoDate) {
                        let hours = date.hours(from: currentDate)
                        if hours < 48 {
                            eventCounter += 1
                        }
                        if hours < 8 {
                            eventCounter += 1
                        }
                    }
                } else {
                    let addPercent = 0.3 * CGFloat(eventCounter)
                    completion(addPercent)
                }
            }
            let addPercent = 0.3 * CGFloat(eventCounter)
            completion(addPercent)
        } else {
            completion(0.0)
        }
//
//        if let localEvents = localEventLookup {
//            let userPlace = searchCity
//            for event in localEvents {
//                if event.name == lastEventName {
//                    checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
//                        completion(numberOfEvents)
//                    })
//                    return
//                } else {
//                    lastEventName = event.name
//                }
//                if event.city == userPlace {
//                    let address = event.address
//                    if !checkedEvents.contains(address) {
//                        let isoDate = "\(event.date) \(event.time)"
//                        let currentDate = Date()
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        if let date = dateFormatter.date(from: isoDate) {
//                            let hours = date.hours(from: currentDate)
//                            if hours < 800 {
//                                checkedEvents.append(address)
//                                let geoCoder = CLGeocoder()
//                                eventCounter += 1
//                                geoCoder.geocodeAddressString(address) { (placemarks, error) in
//                                    guard
//                                        let placemarks = placemarks,
//                                        let location = placemarks.first?.location
//                                        else {
//                                            print(error?.localizedDescription as Any, "\nCannot find dynamic price for event")
//                                            completion(0.0)
//                                            return
//                                    }
//                                    locationCounter += 1
//                                    if !localEventLocations.contains(location.coordinate) {
//                                        localEventLocations.append(location.coordinate)
//                                    }
//                                    if locationCounter == eventCounter {
//                                        DispatchQueue.main.async {
//                                            checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
//                                                completion(numberOfEvents)
//                                            })
//                                        }
//                                    }
//                                }
//                            } else {
//                                checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
//                                    completion(numberOfEvents)
//                                })
//                            }
//                        } else {
//                            checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
//                                completion(numberOfEvents)
//                            })
//                        }
//                    }
//                }
//            }
//            checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
//                completion(numberOfEvents)
//            })
//        }
    }

//    static func checkDistance(userLocation: CLLocationCoordinate2D, completion: @escaping(CGFloat) -> ()) {
//        var numberOfEvents: CGFloat = 0.0
//        for location in localEventLocations {
//            let distance = userLocation.distance(to: location)
//            if distance < 1609.34/6 { //0.17 mile away from event
//                numberOfEvents += 2.0
//            } else if distance < 1609.34/4 { //0.25 mile away from event
//                numberOfEvents += 1.0
//            } else if distance < 1609.34/2 { //0.5 mile away from event
//                numberOfEvents += 0.5
//            }
//        }
//        completion(numberOfEvents)
//    }
    
}
