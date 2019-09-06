//
//  CurrentBookingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleCurrentBooking {
    func bookingOptionsPressed()
    func parkingTakenPressed()
    func parkingSpotOptionsPressed()
    func askToEndReservation()
    func paymentOptionsPressed()
    func extendDurationPressed()
    
    func closeBackground()
}

class CurrentBookingView: UIViewController {
    
    var delegate: mainBarSearchDelegate?
    var currentBooking: Bookings? {
        didSet {
            if let booking = self.currentBooking {
                if let parkingSpot = booking.parkingID {
                    self.observeHostInformation(parkingId: parkingSpot)
                }
                if var destinationName = booking.destinationName {
                    if destinationName == "" { destinationName = "Current location" }
                    self.tripController.destinationLabel.text = destinationName
                    self.tripController.destinationSubLabel.text = "Destination"
                } else {
                    self.tripController.destinationLabel.text = "Current location"
                    self.tripController.destinationSubLabel.text = "Destination"
                }
                if let walktime = booking.walkingTime {
                    let walk = String(format: "%.0f", walktime)
                    self.tripController.walkingLabel.text = "\(walk) minute walk"
                }
                if let toTime = booking.toDate {
                    let date = Date(timeIntervalSince1970: toTime)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mma"
                    dateFormatter.amSymbol = "am"
                    dateFormatter.pmSymbol = "pm"
                    let leave = dateFormatter.string(from: date)
                    self.detailsController.durationButton.setTitle("Leave at \(leave)", for: .normal)
                }
                if let totalCost = booking.totalCost {
                    let price = String(format: "$%.2f", totalCost)
                    self.paymentController.paymentAmountLabel.text = price
                }
                if let timestamp = booking.fromDate {
                    let date = Date(timeIntervalSince1970: timestamp)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
                    let dateString = dateFormatter.string(from: date)
                    self.paymentController.dateLabel.text = dateString
                }
            }
        }
    }
    
    var currentParking: ParkingSpots? {
        didSet {
            if let parking = self.currentParking {
                if let numberSpots = parking.numberSpots, let mainType = parking.mainType, let secondaryType = parking.secondaryType {
                    self.detailsController.secondaryType = secondaryType
                    self.detailsController.spotLabel.text = "\(numberSpots)-Car \(secondaryType.capitalizingFirstLetter())"
                    self.detailsController.subSpotLabel.text = mainType.capitalizingFirstLetter() + " space"
                    self.tripController.parkingLabel.text = "\(mainType.capitalizingFirstLetter()) \(numberSpots)-Car \(secondaryType.capitalizingFirstLetter())"
                }
                if let streetAddress = parking.streetAddress {
                    let addressArray = streetAddress.split(separator: " ")
                    let newArray = addressArray.dropFirst()
                    let streetString = newArray.joined(separator: " ")
                    self.tripController.parkingSubLabel.text = streetString
                }
                if let totalRating = parking.totalRating, let bookings = parking.totalBookings {
                    let rating: Double = Double(totalRating)/Double(bookings)
                    self.detailsController.stars.text = String(format: "%.2f", rating)
                    self.detailsController.stars.rating = rating
                }
                DynamicPricing.getDynamicPricing(parking: parking) { (dynamicCost) in
                    parking.dynamicCost = dynamicCost
                    let cost = String(format: "%.2f", dynamicCost)
                    let option = BookingOptions(mainText: "Extend parking duration", subText: "$\(cost) per hour", iconImage: UIImage(named: "setTimeIcon")?.withRenderingMode(.alwaysTemplate))
                    self.detailsController.options[0] = option
                    self.detailsController.extensionDynamicPrice = dynamicCost
                }
            }
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.axis = .vertical
        view.spacing = 3
        
        return view
    }()
    
    lazy var detailsController: CurrentDetailsView = {
        let controller = CurrentDetailsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var tripController: CurrentTripView = {
        let controller = CurrentTripView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.navigateButton.addTarget(self, action: #selector(startNavigation), for: .touchUpInside)
//        controller.delegate = self
        
        return controller
    }()
    
    lazy var paymentController: CurrentPaymentView = {
        let controller = CurrentPaymentView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()

    lazy var optionsController: CurrentOptionsView = {
        let controller = CurrentOptionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    let extendController = ExtendDurationView()
    
    @objc func observeBooking() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("CurrentBooking")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            let bookingRef = Database.database().reference().child("UserBookings").child(key)
            bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let booking = Bookings(dictionary: dictionary)
                    self.currentBooking = booking
                    NotificationCenter.default.addObserver(self, selector: #selector(self.monitorBooking), name: NSNotification.Name(rawValue: "currentBookingCheckedIn"), object: nil)
                }
            })
        }
    }
    
    @objc func monitorBooking() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("CurrentBooking")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            let bookingRef = Database.database().reference().child("UserBookings").child(key)
            bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let booking = Bookings(dictionary: dictionary)
                    self.currentBooking = booking
                }
            })
        }
    }
    
    func observeHostInformation(parkingId: String) {
        let ref = Database.database().reference().child("ParkingSpots").child(parkingId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let parking = ParkingSpots(dictionary: dictionary)
                self.currentParking = parking
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        scrollView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeBooking), name: NSNotification.Name(rawValue: "restartBookingObservations"), object: nil)
        
        observeBooking()
        observePaymentMethod()
        
        setupStack()
        setupViews()
    }
    
    func setupViews() {
        setupDetails(0, last: true)
        setupTrip(0, last: true)
        setupPayment(0, last: true)
        setupOptions(0, last: true)
    }
    
    func setupStack() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1000)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stackView.sizeToFit()
        
    }
    
    func setupDetails(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(detailsController.view)
        } else {
            stackView.insertArrangedSubview(detailsController.view, at: index)
        }
        detailsController.view.heightAnchor.constraint(equalToConstant: 332).isActive = true
    }
    
    func setupTrip(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(tripController.view)
        } else {
            stackView.insertArrangedSubview(tripController.view, at: index)
        }
        tripController.view.heightAnchor.constraint(equalToConstant: 296).isActive = true
    }
    
    func setupPayment(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(paymentController.view)
        } else {
            stackView.insertArrangedSubview(paymentController.view, at: index)
        }
        paymentController.view.heightAnchor.constraint(equalToConstant: 88).isActive = true
    }
    
    func setupOptions(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(optionsController.view)
        } else {
            stackView.insertArrangedSubview(optionsController.view, at: index)
        }
        optionsController.view.heightAnchor.constraint(equalToConstant: 668).isActive = true
    }

}

// Booking Options
extension CurrentBookingView: handleCurrentBooking {
    
    @objc func startNavigation() {
        if let booking = currentBooking {
            delegate?.openNavigation(success: false, booking: booking)
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    func extendDurationPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            self.extendController.dynamicPrice = self.detailsController.extensionDynamicPrice
            self.extendController.delegate = self
            self.extendController.currentBooking = self.currentBooking
            self.extendController.modalPresentationStyle = .overCurrentContext
            self.present(self.extendController, animated: true, completion: nil)
        }
    }
    
    func observePaymentMethod() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("selectedPayment")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let paymentMethod = PaymentMethod(dictionary: dictionary)
                if let cardNumber = paymentMethod.last4 {
                    let card = "•••• \(cardNumber)"
                    self.extendController.paymentButton.setTitle(card, for: .normal)
                    self.extendController.paymentButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                    let image = setDefaultPaymentMethod(method: paymentMethod)
                    self.extendController.paymentButton.setImage(image, for: .normal)
                    self.extendController.currentPaymentMethod = paymentMethod
                    
                    if let brand = paymentMethod.brand {
                        self.paymentController.creditCardLabel.text = "\(brand.capitalizingFirstLetter()) •••• \(cardNumber)"
                    }
                }
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.extendController.paymentButton.setTitle("Set payment method", for: .normal)
            self.extendController.paymentButton.setImage(nil, for: .normal)
            self.extendController.currentPaymentMethod = nil
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let paymentMethod = PaymentMethod(dictionary: dictionary)
                    if let cardNumber = paymentMethod.last4 {
                        let card = "•••• \(cardNumber)"
                        self.extendController.paymentButton.setTitle(card, for: .normal)
                        let image = setDefaultPaymentMethod(method: paymentMethod)
                        self.extendController.paymentButton.setImage(image, for: .normal)
                        self.extendController.currentPaymentMethod = paymentMethod
                    }
                }
            })
        }
    }
    
    func paymentOptionsPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            let controller = PaymentExpandedView()
            controller.paymentController.creditCardLabel.text = self.paymentController.creditCardLabel.text
            controller.paymentController.dateLabel.text = self.paymentController.dateLabel.text
            controller.paymentController.paymentAmountLabel.text = self.paymentController.paymentAmountLabel.text
            
            controller.detailsController.currentBooking = self.currentBooking
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func bookingOptionsPressed() {
        self.bringContactController(contactText: "There was a problem with my recent booking")
    }
    
    func parkingTakenPressed() {
        self.bringContactController(contactText: "My parking space is taken by someone else")
    }
    
    func parkingSpotOptionsPressed() {
        self.bringContactController(contactText: "There was an issue with my recent parking space")
    }
    
    func bringContactController(contactText: String) {
        let controller = UserContactViewController()
        controller.context = "Booking"
        controller.informationLabel.text = contactText
        self.present(controller, animated: true, completion: nil)
    }
    
    func askToEndReservation() {
        let alertController = UIAlertController(title: "Are you sure?", message: "You are confirming that your vehicle has been removed from the parking space.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            self.endReservation()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func endReservation() {
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
                            self.scrollView.setContentOffset(.zero, animated: true)
                            self.delegate?.closeCurrentBooking()
                        }
                    }
                })
            }
        }
    }
    
    func closeBackground() {
        UIView.animate(withDuration: animationOut) {
            tabDimmingView.alpha = 0
        }
    }
    
}

extension CurrentBookingView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        let translation = scrollView.contentOffset.y
        if translation <= -40.0 {
//            scrollView.setContentOffset(.zero, animated: true)
            self.delegate?.closeCurrentBooking()
        }
    }
    
}
