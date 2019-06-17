//
//  NavigationCurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationBottomViewController: UIViewController {
    
    var delegate: handleCurrentNavigationViews?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.layer.cornerRadius = 8
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
    
    lazy var optionsController: BookingOptionsViewController = {
        let controller = BookingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    func setData(booking: Bookings) {
//        if let parkingID = booking.parkingID, let price = booking.price, let hours = booking.price {
//            if let time = finalDriveTime {
//                let driveTime = Int(time.rounded())
////                self.distanceLabel.text = "\(driveTime) min"
//            }
//
//            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
//            ref.observeSingleEvent(of: .value) { (snapshot) in
//                if let dictionary = snapshot.value as? [String:Any] {
//                    if let bookings = dictionary["totalBookings"] as? Int {
//                        self.infoController.starsLabel.text = "\(bookings)"
//                    }
//                    let hourlyPrice = String(format: "%.2f", (price/hours))
//                    self.infoController.priceLabel.text = "$\(hourlyPrice) per hour"
//                    if let message = dictionary["hostMessage"] as? String {
//                        if message == "Message" {
//                            self.infoController.parkingMessage = "There is no host message."
//                        } else {
//                            self.infoController.parkingMessage = message
//                        }
//                        self.infoHeightAnchor.constant = self.infoController.messageHeightAnchor.constant + 154
//                        self.paymentController.costLabel.setTitle(userInformationNumbers, for: .normal)
//                        self.paymentController.costLabel.setImage(userInformationImage, for: .normal)
//                        self.view.layoutIfNeeded()
//                    }
//                    if let type = dictionary["Type"] as? [String:Any] {
//                        if let amenities = type["Amenities"] as? [String] {
//                            self.infoController.currentAmenitiesController.amenitiesName = amenities
//                            self.infoController.currentAmenitiesController.amenitiesPicker.reloadData()
//                        }
//                    }
//                }
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        horizontalScrollView.delegate = self
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 8
        
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
    
    func setupControllers() {
        
        scrollView.addSubview(durationController.view)
        scrollView.bringSubviewToFront(scrollBar)
        durationController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        durationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationController.view.heightAnchor.constraint(equalToConstant: 170).isActive = true
        durationController.expandButton.addTarget(self, action: #selector(expandDurationController(sender:)), for: .touchUpInside)
        
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
        bookedImageController.view.heightAnchor.constraint(equalToConstant: 532).isActive = true
        bookedImageController.overviewButton.addTarget(self, action: #selector(hostButtonsPressed(sender:)), for: .touchUpInside)
        bookedImageController.paymentButton.addTarget(self, action: #selector(hostButtonsPressed(sender:)), for: .touchUpInside)
        bookedImageController.reviewsButton.addTarget(self, action: #selector(hostButtonsPressed(sender:)), for: .touchUpInside)
        
        scrollView.addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(bookedInfoController.view)
        horizontalScrollView.addSubview(paymentController.view)
        
        horizontalScrollView.contentSize = CGSize(width: phoneWidth * 3, height: 200)
        horizontalScrollView.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor).isActive = true
        horizontalScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        horizontalScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        horizontalScrollView.heightAnchor.constraint(equalTo: bookedInfoController.view.heightAnchor).isActive = true
        
    }
    
    func setupScroll() {
        
        bookedInfoController.view.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor).isActive = true
        bookedInfoController.view.leftAnchor.constraint(equalTo: horizontalScrollView.leftAnchor).isActive = true
        bookedInfoController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        bookedInfoController.view.heightAnchor.constraint(equalToConstant: 308).isActive = true
        
        paymentController.view.topAnchor.constraint(equalTo: bookedImageController.view.bottomAnchor).isActive = true
        paymentController.view.leftAnchor.constraint(equalTo: bookedInfoController.view.rightAnchor).isActive = true
        paymentController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        paymentController.view.bottomAnchor.constraint(equalTo: bookedInfoController.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(optionsController.view)
        optionsController.view.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor, constant: 4).isActive = true
        optionsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsController.view.heightAnchor.constraint(equalToConstant: 668).isActive = true
        
    }
    
    @objc func navigationPressed() {
        self.delegate?.beginRouteNavigation()
    }
    
    @objc func expandDurationController(sender: UIButton) {
        if sender.titleLabel?.text == "Expand" {
            self.delegate?.maximizeBottomView()
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
            self.delegate?.minimizeBottomView()
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
    
    @objc func endReservation() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("CurrentBooking")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let bookingID = dictionary["bookingID"] as? String {
                        let bookingRef = Database.database().reference().child("UserBookings").child(bookingID)
                        bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:Any] {
                                if let parkingID = dictionary["parkingID"] as? String {
                                    let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("CurrentBooking")
                                    parkingRef.removeValue()
                                    ref.removeValue()
                                    isCurrentlyBooked = false
                                    self.delegate?.closeCurrentBooking()
                                    let center = UNUserNotificationCenter.current()
                                    
                                    center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
                                    center.removeAllDeliveredNotifications()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
}

extension NavigationBottomViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let translation = scrollView.contentOffset.y
            if translation <= -36 {
                self.delegate?.minimizeBottomView()
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
