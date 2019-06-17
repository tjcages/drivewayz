//
//  LocalEvents.swift
//  DrivewayzPractice
//
//  Created by Tyler Jordan Cagle on 12/14/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation

var localEventLookup: [LocalEvents]?

struct LocalEvents {
    let name: String
    let date: String
    let time: String
    let imageURL: String
    let venueName: String
    let venueImageURL: String
    let venueParking: String
    let hrefEvent: String
    let city: String
    let address: String
    
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
        guard let city = json["city"] as? String else { throw SerializationError.missing("Venue city missing")}
        guard let address = json["address"] as? String else { throw SerializationError.missing("Venue address missing")}
        self.name = name
        self.date = date
        self.time = time
        self.imageURL = imageURL
        self.venueName = venueName
        self.venueImageURL = venueImageURL
        self.venueParking = venueParking
        self.hrefEvent = hrefEvent
        self.city = city
        self.address = address
    }
    
    static let basePath = "https://app.ticketmaster.com/discovery/v2/events.json?"
    static let endPath = "&apikey=BZ9kNjuf6LB0KSXYgAAOXvfTHvePM4nA"
    
    static func eventLookup(withLocation location: String, completion: @escaping([LocalEvents]) -> ()) {
        localEventLookup = []
        var localEvents: [LocalEvents] = []
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
                                                    if let eventImages = data["images"] as? [[String:Any]] {
                                                        var hrefEvent = ""
                                                        if let urlEvent = data["url"] as? String {
                                                            hrefEvent = urlEvent
                                                        }
                                                        if let embeddedVenues = data["_embedded"] as? [String:Any] {
                                                            if let venues = embeddedVenues["venues"] as? [[String:Any]] {
                                                                for (eventImage, venue) in zip(eventImages, venues) {
                                                                    guard let venueName = venue["name"] as? String else { return }
                                                                    var venueCity = ""
                                                                    var venueAddress = ""
                                                                    if let venueCities = venue["city"] as? [String:Any], let venueAddres = venue["address"] as? [String:Any], let venueStates = venue["state"] as? [String:Any] {
                                                                        guard let venueSpot = venueCities["name"] as? String else { return }
                                                                        guard let venueSpotAdd = venueAddres["line1"] as? String else { return }
                                                                        guard let venueSpotState = venueStates["name"] as? String else { return }
                                                                        venueCity = venueSpot
                                                                        venueAddress = venueSpotAdd + " " + venueSpot + ", " + venueSpotState
                                                                    }
                                                                    if let eventImageURL = eventImage["url"] as? String {
                                                                        var venueImageURL: String = ""
                                                                        var venueParking: String = ""
                                                                        if let parking = venue["parkingDetail"] as? String {
                                                                            venueParking = parking
                                                                        }
                                                                        if let venueImages = venue["images"] as? [[String:Any]] {
                                                                            for image in venueImages {
                                                                                if let imageURL = image["url"] as? String {
                                                                                    venueImageURL = imageURL
                                                                                }
                                                                            }
                                                                        }
                                                                        let jsonArray = ["name": eventName, "date": localDate, "time": localTime, "imageURL": eventImageURL, "venueName": venueName, "venueImageURL": venueImageURL, "venueParking": venueParking, "hrefEvent": hrefEvent, "city": venueCity, "address": venueAddress]
                                                                        if let eventObject = try? LocalEvents(json: jsonArray) {
                                                                            localEvents.append(eventObject)
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
                                }
                            }
                        }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    localEventLookup = localEvents
                    completion(localEvents)
                }
            }
            task.resume()
        }
    }
}
