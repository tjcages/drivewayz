//
//  ConfirmDatabase.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation

extension ConfirmViewController {
    
    func postToDatabase() {
        if let parking = self.parking, let parkingID = parking.parkingID, let userID = Auth.auth().currentUser?.uid, let fromDate = self.fromDate, let toDate = self.toDate, let price = self.price, let hours = self.hours, let totalCost = self.totalCostLabel.text?.replacingOccurrences(of: "$", with: "") {
            let fromTime = fromDate.timeIntervalSince1970
            let toTime = toDate.timeIntervalSince1970
            let userRef = Database.database().reference().child("users").child(userID)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let name = dictionary["name"] as? String, let picture = dictionary["picture"] as? String {
                        let ref = Database.database().reference().child("UserBookings")
                        let bookingRef = ref.childByAutoId()
                        var distance: Double = 0.0
                        var rating: Double = 5.0
                        if let userRating = dictionary["rating"] as? Double {
                            rating = userRating
                        }
                        var selectedVehicle = ""
                        if let vehicle = dictionary["selectedVehicle"] as? String {
                            selectedVehicle = vehicle
                        }
                        if let finalDestination = DestinationAnnotationLocation, let parkingLat = parking.latitude, let parkingLong = parking.longitude, var streetAddress = parking.streetAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType, let spaceRange = streetAddress.range(of: " ") {
                            streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                            if let number = Int(numberSpots) {
                                let wordString = number.asWord
                                let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                                var parkingTotalRating = 5
                                var parkingTotalBooking = 1
                                if let parkingRating = parking.totalRating, let parkingBooking = parking.totalBookings {
                                    parkingTotalRating = parkingRating
                                    parkingTotalBooking = parkingBooking
                                }
                                let parkingRating = Double(parkingTotalRating)/Double(parkingTotalBooking)
                                
                                let finalParking = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: parkingLat), longitude: CLLocationDegrees(truncating: parkingLong))
                                bookingRef.updateChildValues(["driverID": userID, "fromDate": fromTime, "toDate": toTime, "price": price, "hours": hours, "totalCost": Double(totalCost)!, "discount": self.discount, "vehicleID": selectedVehicle, "parkingID": parkingID, "finalDestinationLat": finalDestination.coordinate.latitude, "finalDestinationLong": finalDestination.coordinate.longitude, "finalParkingLat": finalParking.latitude, "finalParkingLong": finalParking.longitude, "driverName": name, "driverPicture": picture, "driverRating": rating, "parkingName": descriptionAddress, "parkingType": secondaryType, "parkingRating": parkingRating])
                                distance = finalDestination.coordinate.distance(to: finalParking)
                            }
                        }
                        if let bookingID = bookingRef.key {
                            let hostRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                            hostRef.child("Bookings").updateChildValues([bookingID: bookingID])
                            hostRef.child("CurrentBooking").updateChildValues(["bookingID": bookingID])
                            userRef.child("Bookings").updateChildValues([bookingID: bookingID])
                            userRef.child("CurrentBooking").updateChildValues(["bookingID": bookingID])
                            hostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String:Any] {
                                    if let totalBookings = dictionary["totalBookings"] as? Int {
                                        let total = totalBookings + 1
                                        hostRef.updateChildValues(["totalBookings": total])
                                    } else {
                                        hostRef.updateChildValues(["totalBookings": 1])
                                    }
                                    if let totalHours = dictionary["totalHours"] as? Double {
                                        let total = totalHours + hours
                                        hostRef.updateChildValues(["totalHours": total])
                                    } else {
                                        hostRef.updateChildValues(["totalHours": hours])
                                    }
                                    if let totalDistance = dictionary["totalDistance"] as? Double {
                                        let total = totalDistance + distance
                                        hostRef.updateChildValues(["totalDistance": total])
                                    } else {
                                        hostRef.updateChildValues(["totalDistance": distance])
                                    }
                                    if let totalProfits = dictionary["totalProfits"] as? Double {
                                        let total = totalProfits + (price * hours) * 0.75
                                        hostRef.updateChildValues(["totalProfits": total])
                                    } else {
                                        hostRef.updateChildValues(["totalProfits": (price * hours) * 0.75])
                                    }
                                    
                                    let parking = ParkingSpots(dictionary: dictionary)
                                    let nameArray = name.split(separator: " ")
                                    if let mainType = parking.mainType, let firstName = nameArray.first {
                                        let title = "\(firstName) is parked in your \(mainType) spot"
                                        let fromDate = Date(timeIntervalSince1970: fromTime)
                                        let toDate = Date(timeIntervalSince1970: toTime)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "h:mm a"
                                        let fromString = dateFormatter.string(from: fromDate)
                                        let toString = dateFormatter.string(from: toDate)
                                        let subtitle = "\(fromString) - \(toString)"
                                        let notificationRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications").childByAutoId()
                                        notificationRef.updateChildValues(["image": "userParked", "title": title, "subtitle": subtitle, "timestamp": Date().timeIntervalSince1970])
                                    }
                                    
                                    if let parkingID = dictionary["id"] as? String {
                                        let hostRef = Database.database().reference().child("users").child(parkingID)
                                        hostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let dictionary = snapshot.value as? [String: Any] {
                                                let totalCost = price * hours * 0.75
                                                if let userFunds = dictionary["userFunds"] as? Double {
                                                    let finalCost = totalCost + userFunds
                                                    hostRef.updateChildValues(["userFunds": finalCost])
                                                } else {
                                                    hostRef.updateChildValues(["userFunds": totalCost])
                                                }
                                            }
                                        })
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func observeCurrentBookings() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("CurrentBooking")
            ref.observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let bookingID = dictionary["bookingID"] as? String {
                        let bookingRef = Database.database().reference().child("UserBookings").child(bookingID)
                        bookingRef.observeSingleEvent(of: .value, with: { (bookingSnapshot) in
                            if let bookingDictionary = bookingSnapshot.value as? [String:Any] {
                                if let fromDate = bookingDictionary["fromDate"] as? TimeInterval, let toDate = bookingDictionary["toDate"] as? TimeInterval, let parkingID = bookingDictionary["parkingID"] as? String, let finalDestinationLat = bookingDictionary["finalDestinationLat"] as? Double, let finalDestinationLong = bookingDictionary["finalDestinationLong"] as? Double, let finalParkingLat = bookingDictionary["finalParkingLat"] as? Double, let finalParkingLong = bookingDictionary["finalParkingLong"] as? Double {
                                    let finalDestination = CLLocationCoordinate2D(latitude: finalDestinationLat, longitude: finalDestinationLong)
                                    let finalParking = CLLocationCoordinate2D(latitude: finalParkingLat, longitude: finalParkingLong)
                                    finalDestinationCoordinate = finalDestination
                                    FinalAnnotationLocation = finalParking
                                    self.delegate?.setupReviewBooking(parkingID: parkingID)
                                    let hostRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                                    hostRef.child("Location").observeSingleEvent(of: .value, with: { (snapshot) in
                                        if let dictionary = snapshot.value as? [String:Any] {
                                            if let latitude = dictionary["latitude"] as? CLLocationDegrees, let longitude = dictionary["longitude"] as? CLLocationDegrees {
                                                let date = Date().timeIntervalSince1970
                                                if date >= fromDate {
                                                    if date < toDate {
                                                        let seconds = toDate - date
                                                        self.sendNotifications(latitude: latitude, longitude: longitude, seconds: seconds)
                                                        let booking = Bookings(dictionary: bookingDictionary)
                                                        isCurrentlyBooked = true
                                                        self.delegate?.confirmPurchasePressed(booking: booking)
                                                        print("sending notifications")
                                                    } else {
                                                        ref.removeValue()
                                                        hostRef.child("CurrentBooking").removeValue()
                                                        isCurrentlyBooked = false
                                                        print("reservation has ended")
                                                    }
                                                } else {
                                                    print("upcoming reservation")
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func monitorCurrentParking() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("CurrentBooking")
            ref.observe(.childAdded) { (snapshot) in
                self.observeCurrentBookings()
            }
            ref.observe(.childChanged) { (snapshot) in
                self.observeCurrentBookings()
            }
            ref.observe(.childRemoved) { (snapshot) in
                self.observeCurrentBookings()
            }
        }
    }
    
    func scheduleNotification(notificationType: String, title: String, message: String, seconds: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let date = Date(timeIntervalSinceNow: seconds)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func checkCoupons() {
        var canDelete = true
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("CurrentCoupon")
        ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            let key = snapshot.key as String
            if canDelete == true {
                canDelete = false
                ref.child(key).removeValue()
            }
        }
    }
    
}
