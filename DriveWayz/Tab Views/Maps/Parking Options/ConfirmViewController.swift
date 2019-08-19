//
//  ConfirmPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe
import NVActivityIndicatorView

class ConfirmViewController: UIViewController {
    
    var delegate: handleCheckoutParking?
    let stripePublishableKey = "pk_live_xPZ14HLRoxNVnMRaTi8ecUMQ"
    let backendBaseURL: String? = "https://boiling-shore-28466.herokuapp.com"
    let paymentCurrency = "usd"
    
    var parking: ParkingSpots?
    var fromDate: Date?
    var toDate: Date?
    var price: Double?
    var hours: Double?
    var totalTime: String?
    var discount: Int = 0
    
    var paymentContext: STPPaymentContext
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.loadingActivity.startAnimating()
                    self.loadingActivity.alpha = 1
                    self.mainButton.alpha = 0.6
                    self.mainButton.setTitle("", for: .normal)
                }
                else {
                    self.loadingActivity.stopAnimating()
                    self.loadingActivity.alpha = 0
                    self.mainButton.alpha = 1
                    self.mainButton.isUserInteractionEnabled = true
                    self.mainButton.backgroundColor = Theme.STRAWBERRY_PINK
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.mainButton.setTitle("Purchase Spot", for: .normal)
                    }
                }
            }, completion: nil)
        }
    }
    
    enum RideRequestState {
        case none
        case requesting
        case active
    }
    
    var rideRequestState: RideRequestState = .none {
        didSet {
            reloadRequestRideButton()
        }
    }
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 35
        let image = UIImage(named: "Residential Home Parking")
        view.image = image
        
        return view
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25/2
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "5 hours"
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GREEN_PIGMENT
        label.text = "$0.00"
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .right
        
        return label
    }()
    
    var couponCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "$0.00"
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        label.alpha = 0
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE
        label.addSubview(view)
        view.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 2).isActive = true
        view.leftAnchor.constraint(equalTo: label.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        return label
    }()
    
    var line2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: phoneWidth/2 - 72)
        button.addTarget(self, action: #selector(handlePaymentButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.setTitle("Purchase Spot", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(confirmPurchasePressed), for: .touchUpInside)
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    var calendarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "calendarIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var calendarLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Today", for: .normal)
        label.setTitleColor(Theme.PRUSSIAN_BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "time")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var timeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("2 hours 15 minutes", for: .normal)
        label.setTitleColor(Theme.PRUSSIAN_BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var changeButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Change", for: .normal)
        label.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        NotificationCenter.default.addObserver(self, selector: #selector(monitorCurrentParking), name: NSNotification.Name(rawValue: "confirmBookingCheck"), object: nil)
        
        setupViews()
        setupCalendar()
        setupPayment()
    }
    
    var normalCostAnchor: NSLayoutConstraint!
    var couponCostAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(spotIcon)
        spotIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        spotIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 18).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 70).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        self.view.addSubview(checkmark)
        checkmark.centerXAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: -12).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: -12).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
        self.view.addSubview(couponCostLabel)
        self.view.addSubview(totalCostLabel)
        normalCostAnchor = totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32)
            normalCostAnchor.isActive = true
        couponCostAnchor = totalCostLabel.rightAnchor.constraint(equalTo: couponCostLabel.leftAnchor, constant: -8)
            couponCostAnchor.isActive = false
        totalCostLabel.topAnchor.constraint(equalTo: spotIcon.topAnchor, constant: 12).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        totalCostLabel.sizeToFit()
        
        couponCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        couponCostLabel.topAnchor.constraint(equalTo: spotIcon.topAnchor, constant: 16).isActive = true
        couponCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        couponCostLabel.sizeToFit()
        
        self.view.addSubview(durationLabel)
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        durationLabel.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor, constant: 4).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        durationLabel.sizeToFit()
        
        self.view.addSubview(line)
        line.topAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: 16).isActive = true
        line.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupCalendar() {
        
        self.view.addSubview(calendarLabel)
        self.view.addSubview(calendarButton)
        calendarLabel.leftAnchor.constraint(equalTo: calendarButton.rightAnchor, constant: 12).isActive = true
        calendarLabel.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calendarLabel.sizeToFit()
        
        calendarButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        calendarButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 14).isActive = true
        calendarButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        calendarButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(timeButton)
        timeLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 12).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeLabel.sizeToFit()
        
        timeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        timeButton.topAnchor.constraint(equalTo: calendarButton.bottomAnchor, constant: 12).isActive = true
        timeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        timeButton.widthAnchor.constraint(equalTo: timeButton.heightAnchor).isActive = true
        
        self.view.addSubview(changeButton)
        changeButton.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        changeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        changeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        changeButton.sizeToFit()
        
    }
    
    func setupPayment() {
        
        self.view.addSubview(mainButton)
        mainButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28).isActive = true
        mainButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -12).isActive = true
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        paymentButton.rightAnchor.constraint(equalTo: mainButton.leftAnchor).isActive = true
        paymentButton.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        line2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func changeDates(fromDate: Date, totalTime: String) {
        var hours: Int = 0
        var minutes: Int = 0
        self.totalTime = totalTime
        let timeArray = totalTime.split(separator: " ")
        print(timeArray)
        if let hourString = timeArray.dropFirst().first, hourString.contains("h") {
            if let timeHours = timeArray.first {
                if let intHours = Int(timeHours) {
                    hours = intHours
                }
            }
        }
        if timeArray.count == 2 {
            if let minuteString = timeArray.dropFirst().first, minuteString.contains("m") {
                if let timeMinutes = timeArray.first {
                    if let intMinutes = Int(timeMinutes) {
                        minutes = intMinutes
                    }
                }
            }
        } else {
            if let minuteString = timeArray.dropFirst().dropFirst().dropFirst().first, minuteString.contains("m") {
                if let timeMinutes = timeArray.dropFirst().dropFirst().first {
                    if let intMinutes = Int(timeMinutes) {
                        minutes = intMinutes
                    }
                }
            }
        }
        let additionalSeconds: Double = Double((hours * 60 + minutes) * 60)
        let toDate = fromDate.addingTimeInterval(additionalSeconds)
        
        let calendar = Calendar.current
        let toHour = calendar.component(.minute, from: toDate)
        let nextDiff = toHour.roundedUp(toMultipleOf: 5) - toHour
        if let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: toDate) {
            self.toDate = nextDate
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm"
            let fromString = formatter.string(from: fromDate)
            let toString = formatter.string(from: nextDate)
            let APformatter = DateFormatter()
            APformatter.dateFormat = "a"
            let APString = APformatter.string(from: nextDate).lowercased()
            
            let finalString = fromString + " - " + toString + " " + APString
            self.timeLabel.setTitle(finalString, for: .normal)
//            self.durationLabel.text = finalString
            self.setHourLabel(minutes: Int(hours * 60 + minutes))
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "MMMM d"
        if let dateWeek = Date().dayOfWeek() {
            if let dayOfTheWeekFrom = fromDate.dayOfWeek() {
                var timeString = totalTime
                timeString = timeString.replacingOccurrences(of: "hrs", with: "hours")
                timeString = timeString.replacingOccurrences(of: "hr", with: "hour")
                timeString = timeString.replacingOccurrences(of: "min", with: "minutes")
//                self.timeLabel.setTitle(timeString, for: .normal)
                if dateWeek == dayOfTheWeekFrom {
                    let fromDay = dayFormatter.string(from: fromDate)
                    self.calendarLabel.setTitle("Today, \(fromDay)", for: .normal)
                } else {
                    let fromDay = formatter.string(from: fromDate)
                    self.calendarLabel.setTitle(fromDay, for: .normal)
                }
            }
        }
    }
    
    func setData(price: Double, hours: Double, parking: ParkingSpots) {
        self.parking = parking
        self.fromDate = bookingFromDate /////////////////////
//        self.toDate = bookingToDate //////////////////////
        self.price = price
        self.hours = hours
        
        let cost = (price * hours)
        let fees = cost * 0.029 + 0.3
        let endPrice = (cost + fees).rounded(toPlaces: 2)
        self.totalCostLabel.text = String(format:"$%.02f", endPrice)
        self.couponCostLabel.text = String(format:"$%.02f", endPrice)
        
        if let secondaryType = parking.secondaryType {
            if secondaryType == "driveway" {
                let image = UIImage(named: "Residential Home Driveway")
                self.spotIcon.image = image
            } else if secondaryType == "parking lot" {
                let image = UIImage(named: "Parking Lot")
                self.spotIcon.image = image
            } else if secondaryType == "apartment" {
                let image = UIImage(named: "Apartment Parking")
                self.spotIcon.image = image
            } else if secondaryType == "alley" {
                let image = UIImage(named: "Alley Parking")
                self.spotIcon.image = image
            } else if secondaryType == "garage" {
                let image = UIImage(named: "Parking Garage")
                self.spotIcon.image = image
            } else if secondaryType == "gated spot" {
                let image = UIImage(named: "Gated Spot")
                self.spotIcon.image = image
            } else if secondaryType == "street spot" {
                let image = UIImage(named: "Street Parking")
                self.spotIcon.image = image
            } else if secondaryType == "underground spot" {
                let image = UIImage(named: "UnderGround Parking")
                self.spotIcon.image = image
            } else if secondaryType == "condo" {
                let image = UIImage(named: "Residential Home Driveway")
                self.spotIcon.image = image
            } else if secondaryType == "circular" {
                let image = UIImage(named: "Other Parking")
                self.spotIcon.image = image
            }
        }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if (dictionary["CurrentCoupon"] as? [String: Any]) != nil {
                    ref.child("CurrentCoupon").observe(.childAdded) { (snapshot) in
                        if let dictionary = snapshot.value as? Int {
                            self.normalCostAnchor.isActive = false
                            self.couponCostAnchor.isActive = true
                            self.discount = dictionary
                            let discountedCost = endPrice - Double(dictionary)/100 * endPrice
                            self.totalCostLabel.text = String(format:"$%.02f", discountedCost)
                            UIView.animate(withDuration: animationIn, animations: {
                                self.couponCostLabel.alpha = 1
                                self.view.layoutIfNeeded()
                            })
                        } else {
                            self.normalCostAnchor.isActive = true
                            self.couponCostAnchor.isActive = false
                            self.totalCostLabel.text = String(format:"$%.02f", endPrice)
                            UIView.animate(withDuration: animationIn, animations: {
                                self.couponCostLabel.alpha = 0
                                self.view.layoutIfNeeded()
                            })
                        }
                    }
                } else {
                    self.normalCostAnchor.isActive = true
                    self.couponCostAnchor.isActive = false
                    self.totalCostLabel.text = String(format:"$%.02f", endPrice)
                    UIView.animate(withDuration: animationIn, animations: {
                        self.couponCostLabel.alpha = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func setHourLabel(minutes: Int) {
        let tuple = minutesToHoursMinutes(minutes: minutes)
        if tuple.hours == 1 {
            self.mainButton.alpha = 1
            self.mainButton.isUserInteractionEnabled = true
            if tuple.leftMinutes == 0 {
                self.durationLabel.text = "\(tuple.hours) hour"
            } else {
                self.durationLabel.text = "\(tuple.hours) hour \(tuple.leftMinutes) min"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                self.durationLabel.text = "00 min"
                self.mainButton.alpha = 0.5
                self.mainButton.isUserInteractionEnabled = false
            } else {
                self.mainButton.alpha = 1
                self.mainButton.isUserInteractionEnabled = true
                self.durationLabel.text = "\(tuple.leftMinutes) min"
            }
        } else {
            self.mainButton.alpha = 1
            self.mainButton.isUserInteractionEnabled = true
            if tuple.leftMinutes == 0 {
                self.durationLabel.text = "\(tuple.hours) hours"
            } else {
                self.durationLabel.text = "\(tuple.hours) hours \(tuple.leftMinutes) min"
            }
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.requiredBillingAddressFields = STPBillingAddressFields.none
        config.additionalPaymentOptions = .all
        
        // Create card sources instead of card tokens
        config.createCardSources = true
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: .default())
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentCurrency = self.paymentCurrency
        
        self.paymentContext = paymentContext
        
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        
        
        super.init(nibName: nil, bundle: nil)
        
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
    }

}
