//
//  HostBookingsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handlePreviousBookings {
    func hostingPreviousPressed(booking: Bookings, parking: ParkingSpots)
    func dismissOngoingMessages()
}

class OldHostBookingsViewController: UIViewController {
    
    var delegate: handleHostingControllers?
    var noUpcoming: Bool = true
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var reservationsContainer: MyOngoingViewController = {
        let controller = MyOngoingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 1
        
        return controller
    }()

    lazy var reservationsTableContainer: ReservationsTableViewController = {
        let controller = ReservationsTableViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var hostingPreviousContainer: ExpandedBookingsViewController = {
        let controller = ExpandedBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
//        controller.delegate = self
        
        return controller
    }()
    
    lazy var messageContainer: OngoingMessageViewController = {
        let controller = OngoingMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var noUpcomingParking: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        view.alpha = 0
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You haven't had any bookings"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        label.sizeToFit()
        
        return view
    }()
    
    var seeMoreParking: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "See more"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -12).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        label.sizeToFit()
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    var openReservationAnchor: NSLayoutConstraint!
    var closeReservationAnchor: NSLayoutConstraint!
    
    var reservationsTopAnchor: NSLayoutConstraint!
    var hostingPreviousTopAnchor: NSLayoutConstraint!
    var messageTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 842)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(noUpcomingParking)
        scrollView.addSubview(reservationsContainer.view)
        reservationsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 4).isActive = true
        reservationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        reservationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        openReservationAnchor = reservationsContainer.view.heightAnchor.constraint(equalToConstant: 204)
            openReservationAnchor.isActive = false
        closeReservationAnchor = reservationsContainer.view.heightAnchor.constraint(equalToConstant: 128)
            closeReservationAnchor.isActive = true
        
        noUpcomingParking.topAnchor.constraint(equalTo: reservationsContainer.view.topAnchor).isActive = true
        noUpcomingParking.widthAnchor.constraint(equalTo: reservationsContainer.view.widthAnchor, constant: -24).isActive = true
        noUpcomingParking.heightAnchor.constraint(equalToConstant: 85).isActive = true
        noUpcomingParking.centerXAnchor.constraint(equalTo: reservationsContainer.view.centerXAnchor).isActive = true
        
        self.view.addSubview(seeMoreParking)
        seeMoreParking.topAnchor.constraint(equalTo: reservationsContainer.view.bottomAnchor, constant: 16).isActive = true
        seeMoreParking.widthAnchor.constraint(equalTo: reservationsContainer.view.widthAnchor, constant: -24).isActive = true
        seeMoreParking.heightAnchor.constraint(equalToConstant: 65).isActive = true
        seeMoreParking.centerXAnchor.constraint(equalTo: reservationsContainer.view.centerXAnchor).isActive = true
        let reservationsTap = UITapGestureRecognizer(target: self, action: #selector(expandReservationsContainer))
        seeMoreParking.addGestureRecognizer(reservationsTap)
        
        self.view.addSubview(reservationsTableContainer.view)
        reservationsTopAnchor = reservationsTableContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            reservationsTopAnchor.isActive = true
        reservationsTableContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        reservationsTableContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        reservationsTableContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight - 120).isActive = true
        reservationsTableContainer.backButton.addTarget(self, action: #selector(minimizeReservationsContainer), for: .touchUpInside)
        
        self.view.addSubview(hostingPreviousContainer.view)
        hostingPreviousTopAnchor = hostingPreviousContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            hostingPreviousTopAnchor.isActive = true
        hostingPreviousContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostingPreviousContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostingPreviousContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        hostingPreviousContainer.exitButton.addTarget(self, action: #selector(returnReservationsPressed), for: .touchUpInside)
        
        self.view.addSubview(messageContainer.view)
        messageTopAnchor = messageContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            messageTopAnchor.isActive = true
        messageContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        self.reservationsContainer.chatIcon.addTarget(self, action: #selector(openOngoingMessages), for: .touchUpInside)
        self.reservationsContainer.chatLabel.addTarget(self, action: #selector(openOngoingMessages), for: .touchUpInside)
        
        minimizeReservationsContainer()
    }
    
}


extension OldHostBookingsViewController: handlePreviousBookings {
    
    @objc func openOngoingMessages() {
        self.scrollView.isScrollEnabled = false
        self.delegate?.hideExitButton()
        self.delegate?.lightContentStatusBar()
        self.messageTopAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.messageContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.messageContainer.openMessageBar()
        }
    }
    
    func dismissOngoingMessages() {
        self.scrollView.isScrollEnabled = true
        self.delegate?.bringExitButton()
        self.delegate?.defaultContentStatusBar()
        self.messageContainer.closeMessageBar()
        self.messageTopAnchor.constant = phoneHeight
        UIView.animate(withDuration: animationIn) {
            self.messageContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func openCurrentReservation() {
        self.openReservationAnchor.isActive = true
        self.closeReservationAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.seeMoreParking.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func closeCurrentReservation() {
        self.openReservationAnchor.isActive = false
        self.closeReservationAnchor.isActive = true
        self.reservationsContainer.reservationLabel.text = "Previous booking"
        self.reservationsContainer.reservationLabel.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.7)
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func expandReservationsContainer() {
        self.scrollView.setContentOffset(.zero, animated: true)
        delayWithSeconds(animationIn * 2) {
            self.reservationsTopAnchor.constant = 0
            self.scrollView.isScrollEnabled = false
            self.delegate?.hideExitButton()
            UIView.animate(withDuration: animationOut, animations: {
                self.reservationsTableContainer.view.alpha = 1
                self.reservationsContainer.view.alpha = 0
                self.noUpcomingParking.alpha = 0
                self.seeMoreParking.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                
            }
        }
    }
    
    @objc func minimizeReservationsContainer() {
        self.reservationsTopAnchor.constant = phoneHeight
        self.scrollView.isScrollEnabled = true
        self.delegate?.bringExitButton()
        UIView.animate(withDuration: animationOut, animations: {
            self.reservationsTableContainer.view.alpha = 0
            if self.noUpcoming == true {
                self.noUpcomingParking.alpha = 1
                self.seeMoreParking.alpha = 0
            } else {
                self.reservationsContainer.view.alpha = 1
                self.seeMoreParking.alpha = 1
            }
            self.view.layoutIfNeeded()
        }) { (success) in

        }
    }
    
    func hostingPreviousPressed(booking: Bookings, parking: ParkingSpots) {
        self.hostingPreviousContainer.setData(booking: booking, parking: parking)
        self.hostingPreviousTopAnchor.constant = -statusHeight
        self.delegate?.defaultContentStatusBar()
        self.delegate?.hideExitButton()
        UIView.animate(withDuration: animationOut) {
            self.hostingPreviousContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func returnReservationsPressed() {
        self.hostingPreviousTopAnchor.constant = phoneHeight
        UIView.animate(withDuration: animationOut) {
            self.hostingPreviousContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    
}
