//
//  ChartViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    var delegate: handleHostScrolling?
    
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
                self.profitsPayments.view.alpha = 1
            } else {
                self.noBookingsController.view.alpha = 1
                self.profitsPayments.view.alpha = 0
            }
            
            self.notifications = self.notifications.sorted { $0.fromDate! > $1.fromDate! }
            
            // Reload data each time our observer appends a new Notification value
            self.sortData()
            
            self.profitsPayments.data = self.data
            self.profitsPayments.bookings = self.notifications
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
    
    lazy var profitsCharts: ProfitsChartsViewController = {
        let controller = ProfitsChartsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var profitsPayments: ProfitsPaymentsViewController = {
        let controller = ProfitsPaymentsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var noBookingsController: NoBookingsViewController = {
        let controller = NoBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.noMessagesLabel.text = "No previous transactions"
        controller.container.alpha = 0
        
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
                    
                    self.loadingLine.endAnimating()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }
    
    var paymentsHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(profitsCharts.view)
        profitsCharts.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        profitsCharts.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsCharts.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        profitsCharts.view.heightAnchor.constraint(equalToConstant: phoneWidth * 0.82).isActive = true
        
        scrollView.addSubview(noBookingsController.view)
        noBookingsController.view.topAnchor.constraint(equalTo: profitsCharts.view.bottomAnchor, constant: 16).isActive = true
        noBookingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noBookingsController.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        noBookingsController.view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        scrollView.addSubview(profitsPayments.view)
        profitsPayments.view.topAnchor.constraint(equalTo: profitsCharts.view.bottomAnchor, constant: 16).isActive = true
        profitsPayments.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsPayments.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        paymentsHeight = profitsPayments.view.heightAnchor.constraint(equalToConstant: 0)
            paymentsHeight.isActive = true
        
        self.view.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
}


extension ChartViewController: handleHostTransfers {
    
    func expandTransferHeight(height: CGFloat) {
        let size = phoneWidth * 0.82 + height + 240
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: size)
        self.paymentsHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func changePaymentAmount(total: Double, transit: Double) {
        
    }

    func closeBackground() {
        self.delegate?.closeBackground()
    }
    
}


extension ChartViewController: UIScrollViewDelegate {
    
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
