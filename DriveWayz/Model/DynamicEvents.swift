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

struct DynamicEvents {
    let name: String
    let date: String
    let time: String
    let imageURL: String
    let venueName: String
    let venueImageURL: String
    let venueParking: String
    let hrefEvent: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let name = json["name"] as? String else { throw SerializationError.missing("Name missing")}
        guard let date = json["date"] as? String else { throw SerializationError.missing("Date missing")}
        guard let time = json["time"] as? String else { throw SerializationError.missing("Time missing")}
        guard let imageURL = json["imageURL"] as? String else { throw SerializationError.missing("Image URL missing")}
        guard let venueName = json["venueName"] as? String else { throw SerializationError.missing("Venue name missing")}
        guard let venueImageURL = json["venueImageURL"] as? String else { throw SerializationError.missing("Venue image missing")}
        guard let venueParking = json["venueParking"] as? String else { throw SerializationError.missing("Venue parking missing")}
        guard let hrefEvent = json["hrefEvent"] as? String else { throw SerializationError.missing("Event href missing")}
        self.name = name
        self.date = date
        self.time = time
        self.imageURL = imageURL
        self.venueName = venueName
        self.venueImageURL = venueImageURL
        self.venueParking = venueParking
        self.hrefEvent = hrefEvent
    }
    
    static let basePath = "https://app.ticketmaster.com/discovery/v2/events.json?"
    static let endPath = "&apikey=BZ9kNjuf6LB0KSXYgAAOXvfTHvePM4nA"
    
    static func eventLookup(withLocation location: String, userLocation: CLLocationCoordinate2D, completion: @escaping(CGFloat) -> ()) {
        localEventLocations = []
        var checkedEvents: [String] = []
        var eventCounter: Int = 0
        var locationCounter: Int = 0
        for i in 1...2 {
            var eventTypePath = ""
            if i == 1 {
                eventTypePath = "classificationName=music"
            } else if i == 2 {
                eventTypePath = "classificationName=sports"
            }
            let url = basePath + eventTypePath + "&latlong=" + location + endPath
            let request = URLRequest(url: URL(string: url)!)
            
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    do { if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let embeddedEvents = json["_embedded"] as? [String:Any] {
                            if let events = embeddedEvents["events"] as? [[String:Any]] {
                                for data in events {
                                    if var eventName = data["name"] as? String {
                                        if let range = eventName.range(of: "HALF PRICE GAME: ") { eventName.removeSubrange(range) }
                                        eventName = eventName.replacingOccurrences(of: " v ", with: " vs. ", options: .literal, range: nil)
                                        if let eventDate = data["dates"] as? [String:Any] {
                                            if let eventStart = eventDate["start"] as? [String:Any] {
                                                if let localDate = eventStart["localDate"] as? String, let localTime = eventStart["localTime"] as? String {
                                                    if let embeddedVenues = data["_embedded"] as? [String:Any] {
                                                        if let venues = embeddedVenues["venues"] as? [[String:Any]] {
                                                            for venue in venues {
                                                                let isoDate = "\(localDate) \(localTime)"
                                                                let currentDate = Date()
                                                                let dateFormatter = DateFormatter()
                                                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                                if let date = dateFormatter.date(from: isoDate) {
                                                                    let hours = date.hours(from: currentDate)
                                                                    if hours < 6 {
                                                                        if let addressObj = venue["address"] as? [String:Any], let address = addressObj["line1"] as? String {
                                                                            if !checkedEvents.contains(address) {
                                                                                checkedEvents.append(address)
                                                                                let geoCoder = CLGeocoder()
                                                                                eventCounter += 1
                                                                                geoCoder.geocodeAddressString(address) { (placemarks, error) in
                                                                                    guard
                                                                                        let placemarks = placemarks,
                                                                                        let location = placemarks.first?.location
                                                                                        else {
                                                                                            print(error?.localizedDescription as Any, "\nCannot find dynamic price for event")
                                                                                            completion(0.0)
                                                                                            return
                                                                                    }
                                                                                    locationCounter += 1
                                                                                    localEventLocations.append(location.coordinate)
                                                                                    if locationCounter == eventCounter {
                                                                                        DispatchQueue.main.async {
                                                                                            checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
                                                                                                completion(numberOfEvents)
                                                                                            })
                                                                                        }
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
                                                                                    completion(numberOfEvents)
                                                                                })
                                                                            }
                                                                        }
                                                                    } else {
                                                                        checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
                                                                            completion(numberOfEvents)
                                                                        })
                                                                    }
                                                                }
                                                            }
                                                        } else {
                                                            checkDistance(userLocation: userLocation, completion: { (numberOfEvents) in
                                                                completion(numberOfEvents)
                                                            })
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    static func checkDistance(userLocation: CLLocationCoordinate2D, completion: @escaping(CGFloat) -> ()) {
        var numberOfEvents: CGFloat = 0.0
        for location in localEventLocations {
            let distance = userLocation.distance(to: location)
            if distance < 1609.34/6 { //0.17 mile away from event
                numberOfEvents += 2.0
            } else if distance < 1609.34/4 { //0.25 mile away from event
                numberOfEvents += 1.0
            } else if distance < 1609.34/2 { //0.5 mile away from event
                numberOfEvents += 0.5
            }
        }
        completion(numberOfEvents)
    }
    
}
