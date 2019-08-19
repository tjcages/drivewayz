//
//  UpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol changeBookingInformation {
    func expandBooking(booking: Bookings, image: UIImage)
    func bookingInformation()
    func expandNotificationsHeight(height: CGFloat)
}

class UpcomingViewController: UIViewController {

    var delegate: handleHostScrolling?
    var bookingDelegate: handleBookingInformation?
    
    var reservationKeys: [String] = []
    var keysArray: [String] = [] {
        didSet {
            if self.testTimer != nil {
                self.testTimer?.invalidate()
            }
            self.testTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkKeys), userInfo: nil, repeats: false)
        }
    }
    
    var testTimer: Timer?
    var testNotifications: [Bookings] = [] {
        didSet {
            if self.testTimer != nil {
                self.testTimer?.invalidate()
            }
            self.testTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(endLoading), userInfo: nil, repeats: false)
        }
    }
    
    @objc func endLoading() {
        self.loadingLine.endAnimating()
        self.notifications = self.testNotifications
    }
    
    // Data variable to track our sorted data
    var data = [TableSection: [Bookings]]()
    
    // Helper method to sort our data
    func sortData() {
        data[.today] = notificationData.filter({ $0.section == .today })
        data[.yesterday] = notificationData.filter({ $0.section == .yesterday })
        data[.week] = notificationData.filter({ $0.section == .week })
        data[.month] = notificationData.filter({ $0.section == .month })
        data[.earlier] = notificationData.filter({ $0.section == .earlier })
    }
    
    var notificationData: [Bookings] = []
    
    // Notification variable to hold all data and string to specify section
    var notifications: [Bookings] = [] {
        didSet {
            if self.notifications.count == 1 {
                self.noBookingsController.view.alpha = 0
                self.upcomingController.view.alpha = 0
                self.ongoingController.view.alpha = 1
            } else if self.notifications.count > 1 {
                self.noBookingsController.view.alpha = 0
                self.upcomingController.view.alpha = 1
                self.ongoingController.view.alpha = 1
            } else {
                self.noBookingsController.view.alpha = 1
                self.upcomingController.view.alpha = 0
                self.ongoingController.view.alpha = 0
            }
            
            self.notifications = self.notifications.sorted { $0.fromDate! > $1.fromDate! }
            
            if let ongoingBooking = self.notifications.first {
                self.notificationData = self.notifications.filter { $0 != ongoingBooking }
                self.ongoingController.booking = ongoingBooking
            } else {
                self.notificationData = self.notifications
            }
            
            // Reload data each time our observer appends a new Notification value
            self.sortData()
            
            self.upcomingController.data = self.data
            self.upcomingController.bookings = self.notificationData
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var noBookingsController: NoBookingsViewController = {
        let controller = NoBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var ongoingController: OngoingBookingViewController = {
        let controller = OngoingBookingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0

        return controller
    }()
    
    lazy var upcomingController: UpcomingBookingsViewController = {
        let controller = UpcomingBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // Observe Notifications data
    func observeData() {
        self.loadingLine.startAnimating()
        self.keysArray = []
        self.notifications = []
        self.testNotifications = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                let hostRef = Database.database().reference().child("ParkingSpots").child(key).child("CurrentBooking")
                hostRef.observe(.childAdded, with: { (snapshot) in
                    let key = snapshot.key
                    self.reservationKeys.append(key)
                })
                let hostRes = Database.database().reference().child("ParkingSpots").child(key).child("UpcomingReservations")
                hostRes.observe(.childAdded, with: { (snapshot) in
                    let key = snapshot.key
                    self.keysArray.append(key)
                })
            }
        }
        ref.observe(.childChanged) { (snapshot) in
            self.observeData()
        }
    }
    
    @objc func checkKeys() {
        for key in reservationKeys {
            let ref = Database.database().reference().child("UserBookings").child(key)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    let notification = Bookings(dictionary: dictionary)
                    notification.key = snapshot.key
                    notification.context = "Ongoing"
                    
                    self.testNotifications.append(notification)
                }
            }
        }
        for key in keysArray {
            let ref = Database.database().reference().child("UserReservations").child(key)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    let notification = Bookings(dictionary: dictionary)
                    notification.key = snapshot.key
                    notification.context = "Reservation"

                    self.testNotifications.append(notification)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }
    
    var notificationsHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(noBookingsController.view)
        noBookingsController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        noBookingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noBookingsController.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        noBookingsController.view.heightAnchor.constraint(equalToConstant: 204).isActive = true
        
        scrollView.addSubview(ongoingController.view)
        ongoingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        ongoingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ongoingController.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        ongoingController.view.heightAnchor.constraint(equalToConstant: 204).isActive = true
        ongoingController.transferButton.addTarget(self, action: #selector(bookingInformation), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandBookingPressed))
        ongoingController.view.addGestureRecognizer(tap)
        
        scrollView.addSubview(upcomingController.view)
        upcomingController.view.topAnchor.constraint(equalTo: ongoingController.view.bottomAnchor, constant: 16).isActive = true
        upcomingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        upcomingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        notificationsHeight = upcomingController.view.heightAnchor.constraint(equalToConstant: 0)
            notificationsHeight.isActive = true
        
        self.view.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true

    }
    
}


extension UpcomingViewController: changeBookingInformation {
    
    func expandNotificationsHeight(height: CGFloat) {
        let size = 204 + height + 240
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: size)
        self.notificationsHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    @objc func expandBookingPressed() {
        if let booking = self.ongoingController.booking, let image = self.ongoingController.profileImageView.image {
            self.bookingDelegate?.expandBooking(booking: booking, image: image)
        }
    }
    
    // Open options to information on each booking
    func expandBooking(booking: Bookings, image: UIImage) {
        self.bookingDelegate?.expandBooking(booking: booking, image: image)
    }
    
    @objc func bookingInformation() {
        self.bookingDelegate?.bookingInformation()
    }
    
    func closeBackground() {
        self.delegate?.closeBackground()
    }
    
}


extension UpcomingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.makeScrollViewScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.makeScrollViewEnd(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.makeScrollViewEnd(scrollView)
    }
    
}
