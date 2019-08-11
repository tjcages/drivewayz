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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }
    
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
        upcomingController.view.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        
    }
}


extension PreviousViewController: changeBookingInformation {
    
    // Open options to information on each booking
    @objc func expandBooking() {
        self.bookingDelegate?.expandBooking()
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
