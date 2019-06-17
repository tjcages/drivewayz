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
    
    private var paymentContext: STPPaymentContext
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
    
    private enum RideRequestState {
        case none
        case requesting
        case active
    }
    
    private var rideRequestState: RideRequestState = .none {
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
        let image = UIImage(named: "Apartment Parking")
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
        label.text = "$54.64"
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .right
        
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
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "carIcon")
//        var image = UIImage(cgImage: img!.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        button.setImage(image, for: .normal)
        button.alpha = 0.7
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "4Runner"
        label.font = Fonts.SSPSemiBoldH4
        
        return label
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
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 8
        
        setupViews()
        setupCalendar()
        setupPayment()
    }

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
        
        self.view.addSubview(totalCostLabel)
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        totalCostLabel.topAnchor.constraint(equalTo: spotIcon.topAnchor, constant: 12).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        totalCostLabel.sizeToFit()
        
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
        paymentButton.bottomAnchor.constraint(equalTo: mainButton.bottomAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        line2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(carLabel)
        self.view.addSubview(carIcon)
        carLabel.leftAnchor.constraint(equalTo: carIcon.rightAnchor, constant: 8).isActive = true
        carLabel.rightAnchor.constraint(equalTo: mainButton.leftAnchor).isActive = true
        carLabel.topAnchor.constraint(equalTo: mainButton.topAnchor, constant: -4).isActive = true
        carLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        carIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        carIcon.bottomAnchor.constraint(equalTo: carLabel.bottomAnchor, constant: 4).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        carIcon.heightAnchor.constraint(equalTo: carIcon.widthAnchor).isActive = true
        
    }
    
    func changeDates(fromDate: Date, totalTime: String) {
        var hours: Int = 0
        var minutes: Int = 0
        let timeArray = totalTime.split(separator: " ")
        if let hourString = timeArray.dropFirst().first, hourString.contains("h") {
            if let timeHours = timeArray.first {
                if let intHours = Int(timeHours) {
                    hours = intHours
                }
            }
        }
        if let minuteString = timeArray.dropFirst().dropFirst().dropFirst().first, minuteString.contains("m") {
            if let timeMinutes = timeArray.dropFirst().dropFirst().first {
                if let intMinutes = Int(timeMinutes) {
                    minutes = intMinutes
                }
            }
        }
        let additionalSeconds: Double = Double((hours * 60 + minutes) * 60)
        let toDate = fromDate.addingTimeInterval(additionalSeconds)
        
        let calendar = Calendar.current
        let toHour = calendar.component(.minute, from: toDate)
        let nextDiff = toHour.roundedUp(toMultipleOf: 5) - toHour
        if let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: toDate) {
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
        self.toDate = bookingToDate //////////////////////
        self.price = price
        self.hours = hours
        
        let cost = (price * hours).rounded(toPlaces: 2)
        self.totalCostLabel.text = String(format:"$%.02f", cost)
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    if let selectedVehicle = dictionary["selectedVehicle"] as? String {
                        let vehicleRef = Database.database().reference().child("UserVehicles").child(selectedVehicle)
                        vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:Any] {
                                if let vehicleMake = dictionary["vehicleMake"] as? String, let vehicleModel = dictionary["vehicleModel"] as? String {
                                    let text = vehicleMake + " " + vehicleModel
                                    self.carLabel.text = text
                                }
                            }
                        })
                    }
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
    
    @objc func confirmPurchasePressed(sender: UIButton) {
//        self.paymentInProgress = true
//        self.paymentContext.requestPayment() //////////////////////////PAYMENT NOT SET UP///////////////////////////////////////
        
        ///////////fasfasdfasdgfasgahdfg;jhS{LHFla;snf'd
        
        self.setupNotifications()
//        self.postToDatabase()
//        self.delegate?.confirmPurchasePressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.requiredBillingAddressFields = STPBillingAddressFields.full
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


extension ConfirmViewController: STPPaymentContextDelegate {
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
        reloadPaymentButtonContent()
        reloadRequestRideButton()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        guard let text = self.totalCostLabel.text?.replacingOccurrences(of: "$", with: "") else { return }
        guard let costs = Double(text) else { return }
        let pennies = Int(costs * 100)
        print(pennies)
        paymentContext.paymentAmount = pennies
        MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                amount: pennies,
                                                completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        switch status {
        case .error:
            print(error?.localizedDescription as Any)
        case .success:
            print("SUCCESSS AYAYYA")
//            self.addCurrentParking()
//            if reserveSegmentAnchor.isActive == true {
//                self.reserveParking()
//            } else if currentSegmentAnchor.isActive == true {
//                self.updateUserProfileCurrent()
//            }
//            UIView.animate(withDuration: animationIn) {
//                self.view.layoutIfNeeded()
//            }
        case .userCancellation:
            return
        }
    }
    
    @objc private func handlePaymentButtonTapped() {
        self.paymentContext.presentPaymentOptionsViewController()
    }
    
    private func reloadPaymentButtonContent() {
        guard let selectedPaymentMethod = paymentContext.selectedPaymentOption else {
            // Show default image, text, and color
            //            paymentButton.setImage(#imageLiteral(resourceName: "Payment"), for: .normal)
            userInformationNumbers = "No payment linked"
            userInformationImage = UIImage()
            paymentButton.setTitle("Payment", for: .normal)
            paymentButton.setTitleColor(Theme.BLUE, for: .normal)
            return
        }
        
        // Show selected payment method image, label, and darker color
        userInformationNumbers = selectedPaymentMethod.label
        userInformationImage = selectedPaymentMethod.image
        paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
        paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
        paymentButton.setTitleColor(Theme.BLACK, for: .normal)
    }
    
    func reloadRequestRideButton() {
        // Show disabled state
        mainButton.backgroundColor = Theme.DARK_GRAY
        self.mainButton.setTitle("Purchase Spot", for: .normal)
        mainButton.setTitleColor(.white, for: .normal)
        //        requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        mainButton.isEnabled = false
        
        switch rideRequestState {
        case .none:
            // Show enabled state
            mainButton.backgroundColor = Theme.STRAWBERRY_PINK
            self.mainButton.setTitle("Purchase Spot", for: .normal)
            mainButton.setTitleColor(.white, for: .normal)
            //            requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            mainButton.isEnabled = true
        case .requesting:
            // Show loading state
            mainButton.backgroundColor = Theme.DARK_GRAY
            mainButton.setTitle("···", for: .normal)
            mainButton.setTitleColor(.white, for: .normal)
            mainButton.setImage(nil, for: .normal)
            mainButton.isEnabled = false
        case .active:
            // Show completion state
            mainButton.backgroundColor = .white
            mainButton.setTitle("Working", for: .normal)
            mainButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            mainButton.setImage(nil, for: .normal)
            mainButton.isEnabled = true
        }
    }
    
}
