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
        if let parking = self.parking, let parkingID = parking.parkingID, let userID = Auth.auth().currentUser?.uid, let fromDate = self.fromDate, let toDate = self.toDate, let price = self.price, let hours = self.hours {
            let fromTime = fromDate.timeIntervalSince1970
            let toTime = toDate.timeIntervalSince1970
            let userRef = Database.database().reference().child("users").child(userID)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let selectedVehicle = dictionary["selectedVehicle"] as? String {
                        let ref = Database.database().reference().child("UserBookings")
                        let bookingRef = ref.childByAutoId()
                        if let finalDestination = DestinationAnnotationLocation, let finalParking = FinalAnnotationLocation {
                            bookingRef.updateChildValues(["driverID": userID, "fromDate": fromTime, "toDate": toTime, "price": price, "hours": hours, "vehicleID": selectedVehicle, "parkingID": parkingID, "finalDestinationLat": finalDestination.latitude, "finalDestinationLong": finalDestination.longitude, "finalParkingLat": finalParking.latitude, "finalParkingLong": finalParking.longitude])
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
//                                                        self.delegate?.confirmPurchasePressed(booking: booking)
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
    
}
