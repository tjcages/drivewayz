//
//  MySpotsData.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit


extension UserHostingViewController {
    
    func observeSpotData() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(userID)
//        ref.child("Hosting Spots").observe(.childAdded) { (snapshot) in
//            if let parkingID = snapshot.value as? String {
//                self.observeUserSpot(parkingID: parkingID)
//            }
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    if let userFunds = dictionary["userFunds"] as? Double {
//                        self.profitsController.profitsContainer.profitsAmount.text = String(format:"$%.02f", userFunds)
//                    } else {
//                        self.profitsController.profitsContainer.profitsAmount.text = "$0.00"
//                    }
//                }
//            })
//        }
    }
    
    func observeUserSpot(parkingID: String) {
        let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID)
        parkingRef.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let parking = ParkingSpots(dictionary: dictionary)
                self.userParking = parking
                self.checkBookingDates()
                self.handleParkingData(parking: parking)
            }
        }
    }
    
    func handleParkingData(parking: ParkingSpots) {
//        self.handleParkingProfits(parking: parking)
//        self.loadPreviousBookings(parking: parking)
//        self.monitorCurrentReservation(parking: parking)
//        self.bookingsController.reservationsTableContainer.setData(parking: parking)
//        self.notificationsController.notificationsContainer.setData(parking: parking)
//        self.spacesController.expandedController.setData(hosting: parking)
//        self.spacesController.hostContainer.setData(parking: parking)
    }
    
    func handleParkingProfits(parking: ParkingSpots) {
//        if let totalBookings = parking.totalBookings {
//            self.profitsController.profitsDateContainer.parkersAmount.text = "\(totalBookings)"
//            if let totalDistance = parking.totalDistance {
//                let miles = (totalDistance * 0.000621371)/Double(totalBookings)
//                self.profitsController.profitsDateContainer.distanceAmount.text = String(format:"%.02f mi", miles)
//            }
//            if let totalProfits = parking.totalProfits {
//                let totalAmount = totalProfits/0.75
//                let fees = totalAmount * 0.029 + 0.3 * Double(totalBookings)
//                let drivewayzFees = totalAmount * 0.25 - fees
//                self.profitsController.profitsEarningsContainer.earningsAmount.text = String(format:"$%.02f", totalProfits)
//                self.profitsController.profitsEarningsContainer.totalProfitsAmount.text = String(format:"$%.02f", totalAmount)
//                self.profitsController.profitsEarningsContainer.feesAmount.text = String(format:"$%.02f", fees)
//                self.profitsController.profitsEarningsContainer.drivewayzAmount.text = String(format:"$%.02f", drivewayzFees)
//            }
//        }
//        if let totalHours = parking.totalHours {
//            let tuple = minutesToHoursMinutes(minutes: Int(totalHours * 60.0))
//            if tuple.hours > 0 {
//                if tuple.leftMinutes > 0 {
//                    self.profitsController.profitsDateContainer.hoursAmount.text = "\(tuple.hours)h \(tuple.leftMinutes)m"
//                } else {
//                    self.profitsController.profitsDateContainer.hoursAmount.text = "\(tuple.hours)h"
//                }
//            } else {
//                if tuple.leftMinutes > 0 {
//                    self.profitsController.profitsDateContainer.hoursAmount.text = "\(tuple.leftMinutes)m"
//                } else {
//                    self.profitsController.profitsDateContainer.hoursAmount.text = "0h"
//                }
//            }
//        }
    }
    
    func loadPreviousBookings(parking: ParkingSpots) {
        self.userBookings = []
        if let bookings = parking.Bookings {
            for booking in bookings {
                let ref = Database.database().reference().child("UserBookings").child(booking)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let singleBooking = Bookings(dictionary: dictionary)
                        self.userBookings.append(singleBooking)
                    }
                }
            }
        }
    }
    
    func checkBookingDates() {
        self.stringDates = []
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let todayString = formatter.string(from: today)
        if let parking = self.userParking, let initialTime = parking.timestamp {
            var date = Date(timeIntervalSince1970: initialTime)
            var stringDate = formatter.string(from: date)
            self.stringDates.append(stringDate)
            self.dateProfits.append(0.0)
            self.emptyProfits.append(0.0)
            while stringDate != todayString {
                date = date.tomorrow
                stringDate = formatter.string(from: date)
                self.stringDates.append(stringDate)
                self.dateProfits.append(0.0)
                self.emptyProfits.append(0.0)
            }
        }
    }
    
    func monitorPreviousBookings() {
//        self.dateProfits = self.emptyProfits
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM d, yyyy"
//        for booking in self.userBookings {
//            if let timestamp = booking.fromDate, let price = booking.price, let hours = booking.hours {
//                let profit = price * hours * 0.75
//                let date = Date(timeIntervalSince1970: timestamp)
//                let stringDate = formatter.string(from: date)
//                if let index = self.stringDates.firstIndex(of: stringDate) {
//                    let value = self.dateProfits[index] + profit
//                    self.dateProfits.insert(value, at: index)
//                    self.dateProfits.remove(at: index + 1)
//                }
//            }
//        }
//        self.profitsController.profitsDateContainer.chartController.stringDates = self.stringDates
//        self.profitsController.profitsDateContainer.chartController.dateProfits = self.dateProfits
    }
    
    func monitorCurrentReservation(parking: ParkingSpots) {
//        if let parkingID = parking.parkingID {
//            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
//            ref.observeSingleEvent(of: .value) { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    if (dictionary["CurrentBooking"] as? [String: Any]) == nil {
//                        if let bookings = dictionary["Bookings"] as? [String: Any] {
//                            let bookingReversed = bookings.reversed()
//                            if let recentBooking = bookingReversed.first?.key {
//                                let bookingRef = Database.database().reference().child("UserBookings").child(recentBooking)
//                                bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                                    if let dictionary = snapshot.value as? [String: Any] {
//                                        let booking = Bookings(dictionary: dictionary)
//                                        self.bookingsController.noUpcoming = false
//                                        self.bookingsController.noUpcomingParking.alpha = 0
//                                        self.bookingsController.reservationsContainer.view.alpha = 1
//                                        self.bookingsController.reservationsContainer.setBooking(booking: booking)
//                                        self.bookingsController.closeCurrentReservation()
//                                    }
//                                })
//                            }
//                        } else {
//                            self.bookingsController.noUpcoming = true
//                            self.bookingsController.noUpcomingParking.alpha = 1
//                            self.bookingsController.reservationsContainer.view.alpha = 0
//                        }
//                    }
//                }
//            }
//            ref.child("CurrentBooking").observe(.childAdded) { (snapshot) in
//                if let bookingID = snapshot.value as? String {
//                    let bookingRef = Database.database().reference().child("UserBookings").child(bookingID)
//                    bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                        if let dictionary = snapshot.value as? [String: Any] {
//                            let booking = Bookings(dictionary: dictionary)
//                            self.bookingsController.noUpcoming = false
//                            self.bookingsController.noUpcomingParking.alpha = 0
//                            self.bookingsController.reservationsContainer.view.alpha = 1
//                            self.bookingsController.reservationsContainer.setBooking(booking: booking)
//                            self.bookingsController.openCurrentReservation()
//                        }
//                    })
//                }
//            }
//            ref.child("CurrentBooking").observe(.childRemoved) { (snapshot) in
//                ref.child("CurrentBooking").observeSingleEvent(of: .value, with: { (check) in
//                    if check.childrenCount > 0 {
//                        if let bookingID = snapshot.value as? String {
//                            let bookingRef = Database.database().reference().child("UserBookings").child(bookingID)
//                            bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                                if let dictionary = snapshot.value as? [String: Any] {
//                                    let booking = Bookings(dictionary: dictionary)
//                                    self.bookingsController.noUpcoming = false
//                                    self.bookingsController.noUpcomingParking.alpha = 0
//                                    self.bookingsController.reservationsContainer.view.alpha = 1
//                                    self.bookingsController.reservationsContainer.setBooking(booking: booking)
//                                    self.bookingsController.openCurrentReservation()
//                                }
//                            })
//                        }
//                    } else {
//                        self.bookingsController.noUpcoming = true
//                        self.bookingsController.noUpcomingParking.alpha = 1
//                        self.bookingsController.reservationsContainer.view.alpha = 0
//                        self.bookingsController.closeCurrentReservation()
//                    }
//                })
//            }
//        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
}
