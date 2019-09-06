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
    
    func postBookingToDatabase() {
        if let parking = self.parking, let parkingID = parking.parkingID, let userID = Auth.auth().currentUser?.uid, let fromDate = self.fromDate, let toDate = self.toDate, let price = self.price, let hours = self.hours, let totalCost = self.totalCostLabel.text?.replacingOccurrences(of: "$", with: "") {
            let fromTime = fromDate.timeIntervalSince1970
            let toTime = toDate.timeIntervalSince1970
            let userRef = Database.database().reference().child("users").child(userID)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let name = dictionary["name"] as? String {
                        var distance: Double = 0.0
                        var picture: String = ""
                        if let pic = dictionary["picture"] as? String {
                            picture = pic
                        }
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
                            if let number = Int(numberSpots), let walkingTime = WalkingTime {
                                let wordString = number.asWord
                                let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                                var parkingTotalRating = 5
                                var parkingTotalBooking = 1
                                if let parkingRating = parking.totalRating, let parkingBooking = parking.totalBookings {
                                    parkingTotalRating = parkingRating
                                    parkingTotalBooking = parkingBooking
                                }
                                let parkingRating = Double(parkingTotalRating)/Double(parkingTotalBooking)
                                let destinationName = DestinationAnnotationName ?? ""

                                let finalParking = CLLocationCoordinate2D(latitude: parkingLat, longitude: parkingLong)

                                let today = Date()
                                let difference = fromDate.seconds(from: today)
                                if difference > 0 {
                                    // Reservation
                                    let ref = Database.database().reference().child("UserReservations")
                                    let bookingRef = ref.childByAutoId()
                                    guard let bookingKey = bookingRef.key else { return }
                                    
                                    bookingRef.updateChildValues(["driverID": userID, "fromDate": fromTime, "toDate": toTime, "price": price, "hours": hours, "totalCost": Double(totalCost)!, "discount": self.discount, "vehicleID": selectedVehicle, "parkingID": parkingID, "finalDestinationLat": finalDestination.coordinate.latitude, "finalDestinationLong": finalDestination.coordinate.longitude, "finalParkingLat": finalParking.latitude, "finalParkingLong": finalParking.longitude, "driverName": name, "driverPicture": picture, "driverRating": rating, "parkingName": descriptionAddress, "parkingType": secondaryType, "parkingRating": parkingRating, "walkingTime": walkingTime, "destinationName": destinationName, "bookingID": bookingKey])
                                    distance = finalDestination.coordinate.distance(to: finalParking)
                                    
                                    if let bookingID = bookingRef.key {
                                        let hostRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                                        hostRef.child("Reservations").updateChildValues([bookingID: bookingID])
                                        hostRef.child("UpcomingReservations").updateChildValues([bookingID: bookingID])
                                        userRef.child("Reservations").updateChildValues([bookingID: bookingID])
                                        userRef.child("UpcomingReservations").updateChildValues([bookingID: bookingID])
                                        
                                        self.delegate?.expandCheckmark(current: false, booking: Bookings(dictionary: [:]))
                                        
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
                                                
                                                let nameArray = name.split(separator: " ")
                                                if let firstName = nameArray.first {
                                                    let title = "\(firstName) has reserved your spot"
                                                    let fromDate = Date(timeIntervalSince1970: fromTime)
                                                    let toDate = Date(timeIntervalSince1970: toTime)
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "h:mm a"
                                                    let fromString = dateFormatter.string(from: fromDate)
                                                    let toString = dateFormatter.string(from: toDate)
                                                    let subtitle = "\(fromString) - \(toString)"
                                                    let notificationRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications").childByAutoId()
                                                    notificationRef.updateChildValues(["notificationType": "userParked", "title": title, "subtitle": subtitle, "timestamp": Date().timeIntervalSince1970, "urgency": "important", "parkingID": parkingID])
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
                                } else {
                                    // Booking
                                    let ref = Database.database().reference().child("UserBookings")
                                    let bookingRef = ref.childByAutoId()
                                    guard let bookingKey = bookingRef.key else { return }
                                    let values = ["driverID": userID, "fromDate": fromTime, "toDate": toTime, "price": price, "hours": hours, "totalCost": Double(totalCost)!, "discount": self.discount, "vehicleID": selectedVehicle, "parkingID": parkingID, "finalDestinationLat": finalDestination.coordinate.latitude, "finalDestinationLong": finalDestination.coordinate.longitude, "finalParkingLat": finalParking.latitude, "finalParkingLong": finalParking.longitude, "driverName": name, "driverPicture": picture, "driverRating": rating, "parkingName": descriptionAddress, "parkingType": secondaryType, "parkingRating": parkingRating, "walkingTime": walkingTime, "destinationName": destinationName, "bookingID": bookingKey] as [String: Any]
                                    
                                    bookingRef.updateChildValues(values)
                                    distance = finalDestination.coordinate.distance(to: finalParking)
                                    
                                    if let bookingID = bookingRef.key {
                                        let hostRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                                        hostRef.child("Bookings").updateChildValues([bookingID: bookingID])
                                        hostRef.child("CurrentBooking").updateChildValues([bookingID: bookingID])
                                        userRef.child("Bookings").updateChildValues([bookingID: bookingID])
                                        userRef.child("CurrentBooking").updateChildValues([bookingID: bookingID])
                                        
                                        let booking = Bookings(dictionary: values)
                                        self.delegate?.expandCheckmark(current: true, booking: booking)
                                        
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
                                                
                                                let nameArray = name.split(separator: " ")
                                                if let firstName = nameArray.first {
                                                    let title = "\(firstName) is parked in your spot"
                                                    let fromDate = Date(timeIntervalSince1970: fromTime)
                                                    let toDate = Date(timeIntervalSince1970: toTime)
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "h:mm a"
                                                    let fromString = dateFormatter.string(from: fromDate)
                                                    let toString = dateFormatter.string(from: toDate)
                                                    let subtitle = "\(fromString) - \(toString)"
                                                    let notificationRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications").childByAutoId()
                                                    notificationRef.updateChildValues(["notificationType": "userParked", "title": title, "subtitle": subtitle, "timestamp": Date().timeIntervalSince1970, "urgency": "important", "parkingID": parkingID])
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
