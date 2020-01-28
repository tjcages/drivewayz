//
//  NavigationCurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import UserNotifications

class NavigationBottomViewController: UIViewController {
    
    var selectedBooking: Bookings?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var scrollBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var horizontalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var durationController: BookingDurationViewController = {
        let controller = BookingDurationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var routeController: BookingRouteViewController = {
        let controller = BookingRouteViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var bookedImageController: BookingImageViewController = {
        let controller = BookingImageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var bookedInfoController: BookingInfoViewController = {
        let controller = BookingInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var paymentController: BookingPaymentViewController = {
        let controller = BookingPaymentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var reviewsController: BookingReviewsViewController = {
        let controller = BookingReviewsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var optionsController: BookingOptionsViewController = {
        let controller = BookingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    func setData(booking: Bookings) {
        self.selectedBooking = booking
        if let toTime = booking.toDate, let fromTime = booking.fromDate, let parkingID = booking.parkingID {
            self.durationController.timerController.setData(toTime: toTime)
            self.durationController.destinationLabel.text = "Make sure to check in once you have parked your vehicle..."
            
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let parking = ParkingSpots(dictionary: dictionary)
                    
                    self.reviewsController.setData(parking: parking)
                    if let parkingStreet = parking.streetAddress, let parkingName = booking.parkingName, let destinationAddress = booking.destinationName {
                        self.routeController.parkingLocationLabel.text = parkingStreet
                        self.routeController.destinationLocationLabel.text = destinationAddress
                        self.bookedImageController.mainLabel.text = parkingStreet
                        self.bookedImageController.subLabel.text = parkingName
                        self.bookedImageController.checkImages(parking: parking)
                    }
                    if let totalRating = parking.totalRating, let numberReviews = parking.ParkingReviews?.count {
                        let rating = Double(totalRating)/Double(numberReviews)
                        self.bookedImageController.starLabel.text = "\(String(format:"%.1f", rating))"
                    }
                    if let totalBooking = parking.totalBookings {
                        self.reviewsController.bookingsValue.text = "\(totalBooking)"
                    }
                    if let timestamp = parking.timestamp {
                        let date2 = Date(timeIntervalSince1970: timestamp)
                        let dateFormatter3 = DateFormatter()
                        dateFormatter3.dateFormat = "M/dd/yyyy"
                        let stringDate2 = dateFormatter3.string(from: date2)
                        self.bookedInfoController.dateLabel.text = "Listed on \(stringDate2)"
                    }
                    if let amenities = parking.parkingAmenities {
                        self.bookedInfoController.currentAmenitiesController.amenitiesName = amenities
                    }
                    if let spotNumber = parking.parkingNumber, spotNumber != "" {
                        self.bookedInfoController.spotNumberValue.text = spotNumber
                    } else {
                        self.bookedInfoController.spotNumberValue.text = "N/A"
                    }
                    if let hostMessage = parking.hostMessage {
                        self.bookedInfoController.message = hostMessage
                    }
                }
            }
            
            let today = Date().timeIntervalSince1970
            let seconds = toTime - today
            if seconds <= 3600 {
                self.durationController.openTimeLeft()
            } else {
                self.durationController.openLeaveAt()
            }
            
            if let walkingTime = booking.walkingTime {
                self.routeController.walkLabel.text = "\(String(format:"%.0f", walkingTime)) minute walk to your destination"
                self.routeController.walkTimeLabel.text = "\(String(format:"%.0f min", walkingTime))"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            let date = Date(timeIntervalSince1970: toTime)
            let fromDate = Date(timeIntervalSince1970: fromTime)
            let dateString = dateFormatter.string(from: date)
            let fromString = dateFormatter.string(from: fromDate)
            self.durationController.duration = dateString
            self.paymentController.toTimeLabel.text = dateString
            self.paymentController.fromTimeLabel.text = fromString
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "E, d MMM yyyy"
            let fromDayString = dateFormatter2.string(from: fromDate)
            self.paymentController.dateLabel.text = fromDayString
            
            if let parkingPrice = booking.price, let parkingHours = booking.hours, let totalPayment = booking.totalCost {
                self.paymentController.totalHoursFee.text = "\(parkingHours) hours"
                self.paymentController.hourlyPriceFee.text = String(format:"$%.2f/hour", parkingPrice)
                self.paymentController.userProfit.text = String(format:"$%.2f", totalPayment)
                
                let bookingFee = 0.30
                let processingFee = 0.029 * totalPayment
                self.paymentController.userBookingFee.text = String(format:"$%.02f", bookingFee)
                self.paymentController.userProcessingFee.text = String(format:"$%.02f", processingFee)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        horizontalScrollView.delegate = self
        
        view.backgroundColor = lineColor
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        setupViews()
        setupControllers()
        setupScroll()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 100, height: 1378)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 40).isActive = true
        
        scrollView.addSubview(scrollBar)
        scrollBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollBar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        scrollBar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBar.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
    }
    
    var bookedControllerMinimizedAnchor: NSLayoutConstraint!
    var bookedControllerExpandAnchor: NSLayoutConstraint!
    var bookedControllerHeightAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(durationController.view)
        scrollView.bringSubviewToFront(scrollBar)
        durationController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        durationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationController.view.heightAnchor.constraint(equalToConstant: 246).isActive = true
        durationController.expandButton.addTarget(self, action: #selector(expandDurationController(sender:)), for: .touchUpInside)
        durationController.endReservationButton.addTarget(self, action: #selector(askToEndReservation), for: .touchUpInside)
        let checkInTap = UITapGestureRecognizer(target: self, action: #selector(checkButtonPressed))
        durationController.checkInView.addGestureRecognizer(checkInTap)
        let navigateTap = UITapGestureRecognizer(target: self, action: #selector(navigateButtonPressed))
        durationController.navigationView.addGestureRecognizer(navigateTap)
        
        scrollView.addSubview(routeController.view)
        routeController.view.topAnchor.constraint(equalTo: durationController.view.bottomAnchor, constant: 4).isActive = true
        routeController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        routeController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        routeController.view.heightAnchor.constraint(equalToConstant: 368).isActive = true
        
        scrollView.addSubview(bookedImageController.view)
        bookedControllerMinimizedAnchor = bookedImageController.view.topAnchor.constraint(equalTo: durationController.view.bottomAnchor, constant: 4)
            bookedControllerMinimizedAnchor.isActive = true
        bookedControllerExpandAnchor = bookedImageController.view.topAnchor.constraint(equalTo: routeController.view.bottomAnchor, constant: 4)
            bookedControllerExpandAnchor.isActive = false
        bookedImageController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookedImageController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
         bookedImageController.view.heightAnchor.constraint(equalToConstant: 144 + bookedImageController.bookedImageHeight).isActive = true
        bookedImageController.overviewButton.addTarget(self, action: #selector(hostButtonsPressed(sender:)), for: .touchUpInside)
        bookedImageController.paymentButton.addTarget(self, action: #selector(hostButtonsPressed(sender:)), for: .touchUpInside)
        bookedImageController.reviewsButton.addTarget(self, action: #selector(hostButtonsPressed(sender:)), for: .touchUpInside)
        
        scrollView.addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(bookedInfoController.view)
        horizontalScrollView.addSubview(paymentController.view)
        horizontalScrollView.addSubview(reviewsController.view)
        
        horizontalScrollView.contentSize = CGSize(width: phoneWidth * 3, height: 200)
        horizontalScrollView.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor).isActive = true
        horizontalScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        horizontalScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        horizontalScrollView.heightAnchor.constraint(equalTo: bookedInfoController.view.heightAnchor).isActive = true
        
    }
    
    func setupScroll() {
        
        bookedInfoController.view.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor, constant: -12).isActive = true
        bookedInfoController.view.leftAnchor.constraint(equalTo: horizontalScrollView.leftAnchor).isActive = true
        bookedInfoController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        bookedControllerHeightAnchor = bookedInfoController.view.heightAnchor.constraint(equalToConstant: 308)
            bookedControllerHeightAnchor.isActive = true
        bookedInfoController.moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        bookedInfoController.lessButton.addTarget(self, action: #selector(lessButtonPressed), for: .touchUpInside)
        
        paymentController.view.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor).isActive = true
        paymentController.view.leftAnchor.constraint(equalTo: bookedInfoController.view.rightAnchor).isActive = true
        paymentController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        paymentController.view.bottomAnchor.constraint(equalTo: bookedInfoController.view.bottomAnchor).isActive = true
        
        reviewsController.view.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor).isActive = true
        reviewsController.view.leftAnchor.constraint(equalTo: paymentController.view.rightAnchor).isActive = true
        reviewsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        reviewsController.view.bottomAnchor.constraint(equalTo: bookedInfoController.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(optionsController.view)
        optionsController.view.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor, constant: 4).isActive = true
        optionsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsController.view.heightAnchor.constraint(equalToConstant: 668).isActive = true
        optionsController.endButton.addTarget(self, action: #selector(askToEndReservation), for: .touchUpInside)
        optionsController.issueButton.addTarget(self, action: #selector(bookingOptionsPressed(sender:)), for: .touchUpInside)
        optionsController.problemButton.addTarget(self, action: #selector(bookingOptionsPressed(sender:)), for: .touchUpInside)
        
    }
    
    @objc func bookingOptionsPressed(sender: UIButton) {
        if sender == self.optionsController.issueButton {
            self.bringContactController(contactText: "There was an issue with my recent parking space")
        } else if sender == self.optionsController.problemButton {
            self.bringContactController(contactText: "There was a problem with my recent booking")
        }
    }
    
    func bringContactController(contactText: String) {
//        self.delegate?.bringContactController(contactText: contactText)
    }
    
    @objc func navigateButtonPressed() {
        if self.durationController.checkInView.alpha == 1 {
//            self.delegate?.beginRouteNavigation(route: "Parking")
        } else {
            let alert = UIAlertController(title: "Where would you like to navigate?", message: "We can direct you to your parking spot or to your final destination", preferredStyle: UIAlertController.Style.actionSheet)
            alert.popoverPresentationController?.sourceView = self.view
            alert.addAction(UIAlertAction(title: "Parking spot", style: UIAlertAction.Style.default, handler: { action in
                self.durationController.navigationView.alpha = 0.5
                self.durationController.navigationView.isUserInteractionEnabled = false
            }))
            var destinationName = "Final destination"
            if let booking = self.selectedBooking, let bookingName = booking.destinationName {
                destinationName = bookingName
            }
            alert.addAction(UIAlertAction(title: "\(destinationName)", style: UIAlertAction.Style.default, handler: { action in
//                self.delegate?.beginRouteNavigation(route: "Destination")
                self.durationController.navigationView.alpha = 0.5
                self.durationController.navigationView.isUserInteractionEnabled = false
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
            delayWithSeconds(5) {
                self.durationController.navigationView.alpha = 1
                self.durationController.navigationView.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func checkButtonPressed() {
        if let booking = self.selectedBooking, let secondaryType = booking.parkingType, let bookingID = booking.bookingID {
            self.durationController.checkInPressed(secondaryType: secondaryType)
//            self.delegate?.drawCurrentParkingPolyline(driving: false)
            delayWithSeconds(2) {
                self.durationController.openTimeLeft()
            }
            
            let ref = Database.database().reference().child("UserBookings").child(bookingID)
            ref.updateChildValues(["checkedIn": true])
        }
    }
    
    @objc func moreButtonPressed() {
        let height = self.bookedInfoController.messageHeight - 45
        self.bookedInfoController.messageLabelRightAnchor.constant = -20
        self.bookedInfoController.messageLabelHeightAnchor.constant = self.bookedInfoController.messageHeight
        self.bookedControllerHeightAnchor.constant = self.bookedControllerHeightAnchor.constant + height
        let scrollHeight = self.scrollView.contentSize.height
        self.scrollView.contentSize = CGSize(width: 100, height: scrollHeight + height)
        UIView.animate(withDuration: animationIn) {
            self.bookedInfoController.moreButton.alpha = 0
            self.bookedInfoController.lessButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func lessButtonPressed() {
        let height = self.bookedInfoController.messageHeight - 45
        self.bookedInfoController.messageLabelRightAnchor.constant = -60
        self.bookedInfoController.messageLabelHeightAnchor.constant = 50
        self.bookedControllerHeightAnchor.constant = self.bookedControllerHeightAnchor.constant - height
        let scrollHeight = self.scrollView.contentSize.height
        self.scrollView.contentSize = CGSize(width: 100, height: scrollHeight - height)
        UIView.animate(withDuration: animationIn, animations: {
            self.bookedInfoController.moreButton.alpha = 1
            self.bookedInfoController.lessButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.bookedInfoController.hostMessageLabel.setContentOffset(.zero, animated: false)
        }
    }
    
    @objc func expandDurationController(sender: UIButton) {
        if sender.titleLabel?.text == "Expand" {
//            self.delegate?.maximizeBottomView()
            self.bookedControllerMinimizedAnchor.isActive = false
            self.bookedControllerExpandAnchor.isActive = true
            UIView.transition(with: self.durationController.expandButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.durationController.expandButton.setTitle("", for: .normal)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.contentSize = CGSize(width: 100, height: 1766)
                UIView.transition(with: self.durationController.expandButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.durationController.expandButton.setTitle("Show less", for: .normal)
                }, completion: nil)
            }
        } else {
//            self.delegate?.minimizeBottomView()
            self.bookedControllerMinimizedAnchor.isActive = true
            self.bookedControllerExpandAnchor.isActive = false
            UIView.transition(with: self.durationController.expandButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.durationController.expandButton.setTitle("", for: .normal)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.contentSize = CGSize(width: 100, height: 1378)
                UIView.transition(with: self.durationController.expandButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.durationController.expandButton.setTitle("Expand", for: .normal)
                }, completion: nil)
            }
        }
    }
    
    @objc func hostButtonsPressed(sender: UIButton) {
        if sender == self.bookedImageController.overviewButton {
            self.horizontalScrollView.setContentOffset(.zero, animated: true)
        } else if sender == self.bookedImageController.paymentButton {
            self.horizontalScrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0), animated: true)
        } else if sender == self.bookedImageController.reviewsButton {
            self.horizontalScrollView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0), animated: true)
        }
    }
    
    @objc func askToEndReservation() {
        let alertController = UIAlertController(title: "Are you sure?", message: "You are confirming that your vehicle has been removed from the parking space.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            self.endReservation()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func endReservation() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            ref.child("CurrentBooking").observeSingleEvent(of: .childAdded) { (snapshot) in
                let key = snapshot.key
                let bookingRef = Database.database().reference().child("UserBookings").child(key)
                bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        if let parkingID = dictionary["parkingID"] as? String {
                            let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                            parkingRef.child("CurrentBooking").removeValue()
                            ref.child("CurrentBooking").removeValue()
                            timerStarted = false
                            if bookingTimer != nil {
                                bookingTimer!.invalidate()
                            }
//                            self.delegate?.closeCurrentBooking()
                            let center = UNUserNotificationCenter.current()
                            
                            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
                            center.removeAllDeliveredNotifications()
                            
                            parkingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String: Any] {
                                    guard let parkingUserID = dictionary["id"] as? String else { return }
                                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                        if let dictionary = snapshot.value as? [String: Any] {
                                            guard let name = dictionary["name"] as? String else { return }
                                            let nameArray = name.split(separator: " ")
                                            if let firstName = nameArray.first {
                                                let title = "\(String(firstName)) has left your parking space"
                                                let subtitle = "Open to see details"
                                                
//                                                let sender = PushNotificationSender()
//                                                sender.sendPushNotification(toUser: parkingUserID, title: title, subtitle: subtitle)
                                                
                                                self.durationController.resetDuration()
                                            }
                                        }
                                    })
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
}

extension NavigationBottomViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let translation = scrollView.contentOffset.y
            if translation <= -36 {
//                self.delegate?.minimizeBottomView()
            }
        } else if scrollView == self.horizontalScrollView {
            let translation = scrollView.contentOffset.x
            var percent = translation/phoneWidth
            if percent >= 0 && percent <= 1 {
                self.bookedImageController.overviewButton.alpha = 1 - 0.8 * percent
                self.bookedImageController.paymentButton.alpha = 0.2 + 0.8 * percent
                self.bookedImageController.selectionCenterAnchor.constant = phoneWidth/3 * percent
                self.view.layoutIfNeeded()
            } else if percent >= 1 && percent <= 2 {
                percent = percent - 1
                self.bookedImageController.paymentButton.alpha = 1 - 0.8 * percent
                self.bookedImageController.reviewsButton.alpha = 0.2 + 0.8 * percent
                self.bookedImageController.selectionCenterAnchor.constant = phoneWidth/3 * (percent + 1)
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
