//
//  PreviousViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PreviousViewController: UIViewController {

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
        data[.today] = notifications.filter({ $0.section == .today })
        data[.yesterday] = notifications.filter({ $0.section == .yesterday })
        data[.week] = notifications.filter({ $0.section == .week })
        data[.month] = notifications.filter({ $0.section == .month })
        data[.earlier] = notifications.filter({ $0.section == .earlier })
    }
    
    // Notification variable to hold all data and string to specify section
    var notifications: [Bookings] = [] {
        didSet {
            if self.notifications.count > 0 {
                self.noBookingsController.view.alpha = 0
                self.upcomingController.view.alpha = 1
            } else {
                self.noBookingsController.view.alpha = 1
                self.upcomingController.view.alpha = 0
            }
            
            self.notifications = self.notifications.sorted { $0.fromDate! > $1.fromDate! }
            
            // Reload data each time our observer appends a new Notification value
            self.sortData()

            self.upcomingController.data = self.data
            self.upcomingController.bookings = self.notifications
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
        controller.noMessagesLabel.text = "No previous bookings"
        controller.container.alpha = 0
        
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
                let hostRef = Database.database().reference().child("ParkingSpots").child(key).child("Bookings")
                hostRef.observe(.childAdded, with: { (snapshot) in
                    let key = snapshot.key
                    self.keysArray.append(key)
                })
                let hostRes = Database.database().reference().child("ParkingSpots").child(key).child("Reservations")
                hostRes.observe(.childAdded, with: { (snapshot) in
                    let key = snapshot.key
                    self.keysArray.append(key)
                    self.reservationKeys.append(key)
                })
            }
        }
    }
    
    @objc func checkKeys() {
        for key in keysArray {
            let ref = Database.database().reference().child("UserBookings").child(key)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    let notification = Bookings(dictionary: dictionary)
                    notification.key = snapshot.key
                    if self.reservationKeys.contains(snapshot.key) {
                        notification.context = "Reservation"
                    }
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
        noBookingsController.view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        scrollView.addSubview(upcomingController.view)
        upcomingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
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


extension PreviousViewController: changeBookingInformation {
    
    func expandNotificationsHeight(height: CGFloat) {
        let size = height + 240
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: size)
        self.notificationsHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    // Open options to information on each booking
    @objc func expandBooking(booking: Bookings, image: UIImage) {
        self.bookingDelegate?.expandBooking(booking: booking, image: image)
    }
    
    @objc func bookingInformation() {
        self.bookingDelegate?.bookingInformation()
    }
    
    func closeBackground() {
        self.delegate?.closeBackground()
    }
    
}


extension PreviousViewController: UIScrollViewDelegate {
    
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