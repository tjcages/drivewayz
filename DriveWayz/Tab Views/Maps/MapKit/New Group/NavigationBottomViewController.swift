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
        
        return view
    }()
    
    var scrollBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "0 min"
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "drive"
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var navigationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "navigationIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var navigationButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Navigate"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN_PIGMENT
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        //        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return view
    }()
    
    var checkInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check in", for: .normal)
        button.backgroundColor = Theme.BLUE
        button.alpha = 0.8
        button.layer.cornerRadius = 4
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        let image = UIImage(named: "exampleParking")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var parkingShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var infoController: FullInfoViewController = {
        let controller = FullInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var durationController: FullDurationViewController = {
        let controller = FullDurationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var paymentController: FullCostViewController = {
        let controller = FullCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var leaveSpotButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End booking", for: .normal)
        button.backgroundColor = Theme.HARMONY_RED
        button.layer.cornerRadius = 4
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(endReservation), for: .touchUpInside)
        
        return button
    }()
    
    func setData(booking: Bookings) {
        if let parkingID = booking.parkingID, let price = booking.price, let hours = booking.price {
            if let time = finalDriveTime {
                let driveTime = Int(time.rounded())
                self.distanceLabel.text = "\(driveTime) min"
            }
            
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let bookings = dictionary["totalBookings"] as? Int {
                        self.infoController.starsLabel.text = "\(bookings)"
                    }
                    let hourlyPrice = String(format: "%.2f", (price/hours))
                    self.infoController.priceLabel.text = "$\(hourlyPrice) per hour"
                    if let message = dictionary["hostMessage"] as? String {
                        if message == "Message" {
                            self.infoController.parkingMessage = "There is no host message."
                        } else {
                            self.infoController.parkingMessage = message
                        }
                        self.infoHeightAnchor.constant = self.infoController.messageHeightAnchor.constant + 154
                        self.paymentController.costLabel.setTitle(userInformationNumbers, for: .normal)
                        self.paymentController.costLabel.setImage(userInformationImage, for: .normal)
                        self.view.layoutIfNeeded()
                    }
                    if let type = dictionary["Type"] as? [String:Any] {
                        if let amenities = type["Amenities"] as? [String] {
                            self.infoController.currentAmenitiesController.amenitiesName = amenities
                            self.infoController.currentAmenitiesController.amenitiesPicker.reloadData()
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.6
        view.layer.cornerRadius = 10
        
        setupViews()
        setupNavigationButton()
        setupParkingInfo()
        setupPayment()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 100, height: 1340)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(scrollBar)
        scrollBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollBar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        scrollBar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBar.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
    }
    
    func setupNavigationButton() {
        
        scrollView.addSubview(navigationView)
        navigationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        navigationView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26).isActive = true
        navigationView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigationPressed))
        navigationView.addGestureRecognizer(tapGesture)
        
        navigationView.addSubview(navigationIcon)
        navigationIcon.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 4).isActive = true
        navigationIcon.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        navigationIcon.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        navigationIcon.widthAnchor.constraint(equalTo: navigationIcon.heightAnchor).isActive = true
        
        navigationView.addSubview(navigationButtonLabel)
        navigationButtonLabel.leftAnchor.constraint(equalTo: navigationIcon.rightAnchor, constant: 2).isActive = true
        navigationButtonLabel.rightAnchor.constraint(equalTo: navigationView.rightAnchor).isActive = true
        navigationButtonLabel.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        navigationButtonLabel.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        
        scrollView.addSubview(checkInButton)
        checkInButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        checkInButton.rightAnchor.constraint(equalTo: navigationView.leftAnchor, constant: -12).isActive = true
        checkInButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        checkInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: checkInButton.leftAnchor, constant: -12).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: checkInButton.centerYAnchor, constant: -10).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(unitLabel)
        unitLabel.centerXAnchor.constraint(equalTo: distanceLabel.centerXAnchor).isActive = true
        unitLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        unitLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 2).isActive = true
        unitLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    var infoHeightAnchor: NSLayoutConstraint!
    
    func setupParkingInfo() {
        
        scrollView.addSubview(parkingShadowView)
        parkingShadowView.topAnchor.constraint(equalTo: checkInButton.bottomAnchor, constant: 24).isActive = true
        parkingShadowView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingShadowView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        parkingShadowView.heightAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        
        parkingShadowView.addSubview(parkingImageView)
        parkingImageView.topAnchor.constraint(equalTo: parkingShadowView.topAnchor).isActive = true
        parkingImageView.leftAnchor.constraint(equalTo: parkingShadowView.leftAnchor).isActive = true
        parkingImageView.rightAnchor.constraint(equalTo: parkingShadowView.rightAnchor).isActive = true
        parkingImageView.bottomAnchor.constraint(equalTo: parkingShadowView.bottomAnchor).isActive = true
        
        scrollView.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 24).isActive = true
        infoController.view.topAnchor.constraint(equalTo: parkingImageView.bottomAnchor, constant: 12).isActive = true
        infoHeightAnchor = infoController.view.heightAnchor.constraint(equalToConstant: 280)
            infoHeightAnchor.isActive = true
        
        scrollView.addSubview(durationController.view)
        durationController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        durationController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        durationController.view.topAnchor.constraint(equalTo: infoController.view.bottomAnchor).isActive = true
        durationController.view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        scrollView.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: durationController.view.bottomAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func setupPayment() {
        
        scrollView.addSubview(paymentController.view)
        paymentController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        paymentController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        paymentController.view.topAnchor.constraint(equalTo: durationController.view.bottomAnchor, constant: 0).isActive = true
        paymentController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(lineView2)
        lineView2.topAnchor.constraint(equalTo: paymentController.view.bottomAnchor).isActive = true
        lineView2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(leaveSpotButton)
        leaveSpotButton.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 48).isActive = true
        leaveSpotButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 48).isActive = true
        leaveSpotButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -48).isActive = true
        leaveSpotButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    @objc func navigationPressed() {
        self.delegate?.beginRouteNavigation()
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
        let translation = scrollView.contentOffset.y
        if translation <= -36 {
            self.delegate?.minimizeBottomView()
        }
    }
    
}
