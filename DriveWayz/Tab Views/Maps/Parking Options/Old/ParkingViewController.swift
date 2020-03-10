//
//  TestParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

protocol handleTestParking {
    func bookSpotPressed(amount: Double)
}


class ParkingViewController: UIViewController, handleTestParking {
    
    var delegate: handleCheckoutParking?
//    var navigationDelegate: handleRouteNavigation?
    var locatorDelegate: handleLocatorButton?
    
    let paymentController = ChoosePaymentView()
    let vehicleController = ChooseVehicleView()
    
    let identifier = "cellID"
    let cellHeight: CGFloat = 242
    let cellWidth: CGFloat = phoneWidth
    
    var spotIsAvailable: Bool = false {
        didSet {
            if let parking = self.selectedParkingSpot {
                let incorrectDuration = parking.unavailableReason
                self.bubbleWidthAnchor.constant = incorrectDuration.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH4) + 24
                self.bubbleArrow.message = incorrectDuration
                if let streetAddress = parking.streetAddress {
                    let addressArray = streetAddress.split(separator: " ")
                    if addressArray.count > 2 {
                        let address = "\(String(addressArray[1])) \(String(addressArray[2]))"
//                        delegate?.setQuickParkingLabel(text: address)
                    } else if addressArray.count > 1 {
//                        delegate?.setQuickParkingLabel(text: String(addressArray[1]))
                    } else {
//                        delegate?.setQuickParkingLabel(text: "")
                    }
                }
            }
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                if self.spotIsAvailable {
                    self.mainButton.backgroundColor = Theme.BLACK
                    self.mainButton.setTitleColor(Theme.WHITE, for: .normal)
                    self.mainButton.isUserInteractionEnabled = true
                    self.bubbleArrow.alpha = 0
                }
                else {
                    self.mainButton.backgroundColor = Theme.LINE_GRAY
                    self.mainButton.setTitleColor(Theme.BLACK, for: .normal)
                    self.mainButton.isUserInteractionEnabled = false
                    self.bubbleArrow.alpha = 1
                }
            }, completion: nil)
        }
    }
    
    var selectedParkingSpot: ParkingSpots? {
        didSet {
            if let parking = self.selectedParkingSpot {
                let isAvailable = parking.isSpotAvailable
                if isAvailable {
                    if let availableTimes = parking.CurrentDurationAvailable {
                        if let fromTime = availableTimes.first, let toTime = availableTimes.last {
                            if fromTime <= bookingFromDate && toTime >= bookingToDate {
                                self.spotIsAvailable = true
                            } else {
                                self.spotIsAvailable = false
                            }
                        } else {
                            self.spotIsAvailable = false
                        }
                    } else {
                        self.spotIsAvailable = false
                    }
                } else {
                    self.spotIsAvailable = false
                }
            }
        }
    }
    
    var parkingSpots: [ParkingSpots] = [] {
        didSet {
            self.selectedParkingSpot = parkingSpots.first
            self.bookingSliderController.view.alpha = 1
            
            for parking in self.parkingSpots {
                DynamicPricing.getDynamicPricing(parking: parking) { (dynamicCost) in
                    parking.dynamicCost = dynamicCost
                    self.bookingPicker.reloadData()
                }
            }
        }
    }
    
    var bookingLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var bookingPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: bookingLayout)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor.clear
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(BookingCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.isPagingEnabled = true
        
        return picker
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Book Prime Spot", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var bookingSliderController: BookingSliderViewController = {
        let controller = BookingSliderViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var calendarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 4
        let image = UIImage(named: "setCalendarIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.showsTouchWhenHighlighted = true
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var paymentArrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 0, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    lazy var expandedBookingController: BookingExpandedViewController = {
        let controller = BookingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.alpha = 0
        view.rightTriangle()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideBubbleArrow))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingPicker.delegate = self
        bookingPicker.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
        setupCalendar()
        observePaymentMethod()
        observeUser()
    }
    
    func setData(closestParking: [ParkingSpots], cheapestParking: [ParkingSpots], overallDestination: CLLocationCoordinate2D) {
        
    }
    
    func setupViews() {
        
        view.addSubview(mainButton)
        view.addSubview(calendarButton)
        view.addSubview(bookingPicker)
        view.addSubview(bookingSliderController.view)
        
        bookingPicker.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        bookingPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bookingPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bookingPicker.bottomAnchor.constraint(equalTo: mainButton.topAnchor).isActive = true
        
        calendarButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        calendarButton.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        calendarButton.heightAnchor.constraint(equalTo: mainButton.heightAnchor).isActive = true
        calendarButton.widthAnchor.constraint(equalTo: calendarButton.heightAnchor).isActive = true
        
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28).isActive = true
        mainButton.rightAnchor.constraint(equalTo: calendarButton.leftAnchor, constant: -12).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        bookingSliderController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bookingSliderController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookingSliderController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bookingSliderController.view.bottomAnchor.constraint(equalTo: bookingPicker.topAnchor).isActive = true
        
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(parkingPanned(sender:)))
//        self.view.addGestureRecognizer(pan)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(expandBookingPressed))
//        bookingPicker.addGestureRecognizer(tap)
        
    }
    
    var expandedBookingTopAnchor: NSLayoutConstraint!
    var bubbleWidthAnchor: NSLayoutConstraint!
    
    func setupCalendar() {
        
        view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        paymentButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -8).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -8).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(bubbleArrow)
        bubbleArrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bubbleArrow.bottomAnchor.constraint(equalTo: calendarButton.topAnchor, constant: -12).isActive = true
        bubbleWidthAnchor = bubbleArrow.widthAnchor.constraint(equalToConstant: phoneWidth * 0.66)
            bubbleWidthAnchor.isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func hideBubbleArrow() {
        UIView.animate(withDuration: animationIn) {
            self.bubbleArrow.alpha = 0
        }
    }
    
    func loadBookings() {
        self.bookingSliderController.view.alpha = 0
        self.view.layoutIfNeeded()
    }
    
    func bookSpotPressed(amount: Double) {
        
    }
    
    @objc func becomeAHost(sender: UIButton) {
//        self.delegate?.becomeAHost()
    }
    
    func changeDates(fromDate: Date, totalTime: String) {
        var timeString = totalTime
        timeString = timeString.replacingOccurrences(of: "hrs", with: "hours")
        timeString = timeString.replacingOccurrences(of: "hr", with: "hour")
        timeString = timeString.replacingOccurrences(of: "min", with: "minutes")
//        self.timeLabel.setTitle(timeString, for: .normal)
    }
    
    func observePaymentMethod() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("selectedPayment")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let paymentMethod = PaymentMethod(dictionary: dictionary)
                if let cardNumber = paymentMethod.last4 {
                    let card = "•••• \(cardNumber)"
                    self.paymentButton.setTitle(card, for: .normal)
                    self.paymentButton.setTitleColor(Theme.BLACK, for: .normal)
                    let image = setDefaultPaymentMethod(method: paymentMethod)
                    self.paymentButton.setImage(image, for: .normal)
//                    self.currentPaymentMethod = paymentMethod
                }
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.paymentButton.setTitle("Select payment", for: .normal)
            self.paymentButton.setImage(nil, for: .normal)
//            self.currentPaymentMethod = nil
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let paymentMethod = PaymentMethod(dictionary: dictionary)
                    if let cardNumber = paymentMethod.last4 {
                        let card = "•••• \(cardNumber)"
                        self.paymentButton.setTitle(card, for: .normal)
                        let image = setDefaultPaymentMethod(method: paymentMethod)
                        self.paymentButton.setImage(image, for: .normal)
//                        self.currentPaymentMethod = paymentMethod
                    }
                }
            })
        }
    }
    
    @objc func paymentButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            self.paymentController.extendedDelegate = self
            let navigation = UINavigationController(rootViewController: self.paymentController)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
}

extension ParkingViewController: handleExtendPaymentMethod {
    
    func closeBackground() {
        UIView.animate(withDuration: animationOut) {
            tabDimmingView.alpha = 0
        }
    }
    
    func observeUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId)
        ref.observe(.childAdded) { (snapshot) in
            if snapshot.key == "Vehicles" {
                ref.child("selectedVehicle").observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                })
            }
        }
    }
    
}


extension ParkingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bookingPicker {
            let contentSize = collectionView.contentSize
            self.bookingSliderController.scrollView.contentSize = contentSize
            if parkingSpots.count > 0 {
                self.bookingSliderController.view.alpha = 1
                self.bookingPicker.alpha = 1
                self.view.layoutIfNeeded()
                delayWithSeconds(animationIn) {
                    self.checkPolyline(percentage: 0)
                    self.getCellAtIndex(index: 0)
                }
            }
            print(parkingSpots.count)
            return parkingSpots.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! BookingCell
        if collectionView == bookingPicker && parkingSpots.count > indexPath.row {
            cell.endAnimations()
            cell.minimizePrice()
            let parking = parkingSpots[indexPath.row]
            if let secondaryType = parking.secondaryType, let numberSpots = parking.numberSpots, let streetAddress = parking.streetAddress {
                cell.secondaryType = secondaryType
                cell.numberSpots = numberSpots
                cell.streetAddress = streetAddress
            }
            if let totalRating = parking.totalRating, let totalBookings = parking.ParkingReviews?.count {
                let averageRating = Double(totalRating)/Double(totalBookings)
                cell.stars.rating = averageRating
                cell.starLabel.text = "\(totalBookings)"
            } else {
                cell.stars.rating = 5.0
                cell.starLabel.text = "0"
            }
            if let parkingCost = parking.dynamicCost {
                let cost = String(format: "$%.2f/hour", parkingCost)
                cell.price = cost
            }
            if indexPath.row > 2 {
                cell.expandPrice()
            }
        } else {
            cell.beginAnimations()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        self.bookingSliderController.translation = translation
        let percentage = translation/phoneWidth
        if percentage == 0 && self.mainButton.titleLabel?.text != "Book Prime Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Prime Spot", for: .normal)
                    self.bookingSliderController.firstIcon.alpha = 1
                    self.bookingSliderController.firstIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            }
        } else if percentage == 0 {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.bookingSliderController.firstIcon.alpha = 1
                self.bookingSliderController.firstIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else if percentage == 1 && self.mainButton.titleLabel?.text != "Book Economy Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Economy Spot", for: .normal)
                    self.bookingSliderController.secondIcon.alpha = 1
                    self.bookingSliderController.secondIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            }
        } else if percentage == 1 {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.bookingSliderController.secondIcon.alpha = 1
                self.bookingSliderController.secondIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else if percentage == 2 && self.mainButton.titleLabel?.text != "Book Standard Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Standard Spot", for: .normal)
                }, completion: nil)
            }
        }
    }
    
    func getCellAtIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = self.bookingPicker.cellForItem(at: indexPath) as? BookingCell {
            cell.expandPrice()
        }
    }
    
    func closeCellAtIndex(index: Int) {
        delayWithSeconds(animationOut) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.bookingPicker.cellForItem(at: indexPath) as? BookingCell {
                cell.minimizePrice()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        let percentage = translation/phoneWidth
        self.checkPolyline(percentage: Int(percentage))
    }
    
    func checkPolyline(percentage: Int) {
        self.selectedParkingSpot = parkingSpots[percentage]
        self.expandedBookingController.setData(parking: parkingSpots[percentage])
        self.getCellAtIndex(index: percentage)
        self.closeCellAtIndex(index: percentage - 1)
        self.closeCellAtIndex(index: percentage + 1)
        if let latitude = self.selectedParkingSpot?.latitude, let longitude = self.selectedParkingSpot?.longitude {
            let location = CLLocation(latitude: latitude , longitude: longitude )
//            self.parkingDelegate?.drawHostPolyline(fromLocation: location)
        }
    }
    
}

