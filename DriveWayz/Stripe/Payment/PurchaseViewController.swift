//
//  RideRequestViewController.swift
//  RocketRides
//
//  Created by Romain Huet on 5/26/16.
//  Copyright © 2016 Romain Huet. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import UserNotifications
import Alamofire

protocol controlHourButton {
    func openHoursButton()
    func closeHoursButton(status: Bool)
}

class PurchaseViewController: UIViewController, STPPaymentContextDelegate, controlHourButton {

    // Controllers
    var delegate: removePurchaseView?
    var hoursDelegate: controlHoursButton?

    let stripePublishableKey = "pk_test_D5D2xLIBELH4ZlTwigJEWyKF"
    let backendBaseURL: String? = "https://boiling-shore-28466.herokuapp.com"
    
    let paymentCurrency = "usd"
    var count: Int = 0
    var recentCount: Int = 0
    
    var id: String = ""
    var cost: Double = 0.00
    var parkingId: String = ""
    
    private var paymentContext: STPPaymentContext
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

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

    private var price: Double = 0 {
        didSet {
            // Forward value to payment context
            paymentContext.paymentAmount = Int(price)
        }
    }
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.reserveButton.alpha = 1
                    self.reserveButton.backgroundColor = Theme.DARK_GRAY
                    self.costButton.alpha = 0.6
                    self.reserveButton.setTitle("", for: .normal)
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.reserveButton.alpha = 1
                    self.costButton.alpha = 1
                    self.reserveButton.backgroundColor = Theme.PRIMARY_DARK_COLOR
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.reserveButton.setTitle("Reserve Spot", for: .normal)
                    }
                }
            }, completion: nil)
        }
    }
    
    var reserveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        button.setTitle("Reserve Spot", for: .normal)
        button.setTitle("", for: .selected)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        let path = UIBezierPath(roundedRect:button.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        button.layer.mask = maskLayer
        button.alpha = 0.5
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var costButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRIMARY_DARK_COLOR
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("", for: .normal)
        button.alpha = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        let path = UIBezierPath(roundedRect:button.bounds,
                                byRoundingCorners:[.bottomRight],
                                cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        button.layer.mask = maskLayer
        
        return button
    }()
    
    var reserveContainer: UIView = {
        let reserve = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        reserve.translatesAutoresizingMaskIntoConstraints = false
        reserve.backgroundColor = UIColor.white
        reserve.layer.cornerRadius = 5
        reserve.clipsToBounds = false
        reserve.layer.shadowColor = UIColor.darkGray.cgColor
        reserve.layer.shadowOffset = CGSize(width: 1, height: 1)
        reserve.layer.shadowRadius = 1
        reserve.layer.shadowOpacity = 0.8
        reserve.alpha = 0.9
        
        return reserve
    }()
    
    var confirmContainer: UIView = {
        let reserve = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        reserve.translatesAutoresizingMaskIntoConstraints = false
        reserve.backgroundColor = UIColor.white
        reserve.clipsToBounds = false
        reserve.layer.shadowColor = UIColor.darkGray.cgColor
        reserve.layer.shadowOffset = CGSize(width: 1, height: 1)
        reserve.layer.shadowRadius = 1
        reserve.layer.shadowOpacity = 0.8
        let path = UIBezierPath(roundedRect:reserve.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        reserve.layer.mask = maskLayer
        reserve.alpha = 0
        
        return reserve
    }()
    
    var totalCostLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.isUserInteractionEnabled = false
        label.alpha = 0
        
        return label
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets.top = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePaymentButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)

        return button
    }()
    
    lazy var hoursButton: dropDownButton = {
        let hours = dropDownButton()
        hours.translatesAutoresizingMaskIntoConstraints = false
        hours.backgroundColor = Theme.WHITE
        hours.setTitleColor(Theme.DARK_GRAY, for: .normal)
        hours.setTitle("^ hours", for: .normal)
        hours.alpha = 0.9
        hours.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        hours.dropView.dropDownOptions = ["1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours", "11 hours", "12 hours"]
        hours.layer.cornerRadius = 5
        hours.delegate = self
        
        return hours
    }()
    
    var unavailable: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Unavailable currently", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 1
        button.clipsToBounds = true
        let path = UIBezierPath(roundedRect:button.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        button.layer.mask = maskLayer
        
        return button
    }()

    // MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {

        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.requiredBillingAddressFields = STPBillingAddressFields.full
        config.additionalPaymentMethods = .all
        
        // Create card sources instead of card tokens
        config.createCardSources = true;
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: .default())
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = Int(price * 100)
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
    
    func setData(parkingCost: String, parkingID: String, id: String) {
        let noHour = parkingCost.replacingOccurrences(of: "/hour", with: "", options: .regularExpression, range: nil)
        let noDollar = noHour.replacingOccurrences(of: "[$]", with: "", options: .regularExpression, range: nil)
        self.price = Double(noDollar.replacingOccurrences(of: "[.]", with: "", options: .regularExpression, range: nil))!
        
        self.id = id
        self.parkingId = parkingID
        self.cost = Double(noDollar)!
        costButton.setTitle(parkingCost, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let red: CGFloat = 0
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        self.activityIndicator.alpha = 0

        setupViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.didMove(toParentViewController: self)
    }
    
    func setAvailability(available: Bool) {
        if available == true {
            self.unavailable.alpha = 0
        } else {
            self.unavailable.alpha = 1
        }
    }
    
    var hourButtonHeight: NSLayoutConstraint!
    var reserveCenterAnchor: NSLayoutConstraint!
    var confirmCenterAnchor: NSLayoutConstraint!
    var reserveWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(reserveContainer)
        reserveContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hourButtonHeight = reserveContainer.topAnchor.constraint(equalTo: self.view.topAnchor)
            hourButtonHeight.isActive = true
        reserveContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reserveCenterAnchor = reserveContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            reserveCenterAnchor.isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        reserveContainer.addSubview(line)
        line.centerYAnchor.constraint(equalTo: reserveContainer.centerYAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(costButton)
        costButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        costButton.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        costButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        costButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line2.heightAnchor.constraint(equalTo: reserveContainer.heightAnchor).isActive = true
        line2.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor, constant: -100).isActive = true
        
        self.view.addSubview(reserveButton)
        reserveButton.addTarget(self, action: #selector(handleRequestRideButtonTapped), for: .touchUpInside)
        reserveWidthAnchor = reserveButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor, constant: -101)
            reserveWidthAnchor.isActive = true
        reserveButton.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        reserveButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(unavailable)
        unavailable.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        unavailable.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        unavailable.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        unavailable.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        paymentButton.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 40)
        
        self.view.addSubview(hoursButton)
        hoursButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        hoursButton.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        hoursButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hoursButton.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: reserveButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: reserveButton.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        self.view.addSubview(confirmContainer)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(bringBackReserve(sender:)))
        confirmContainer.addGestureRecognizer(gesture)
        confirmContainer.bottomAnchor.constraint(equalTo: reserveContainer.centerYAnchor).isActive = true
        confirmContainer.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        confirmContainer.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        confirmContainer.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true
        
        confirmContainer.addSubview(totalCostLabel)
        totalCostLabel.centerYAnchor.constraint(equalTo: confirmContainer.centerYAnchor).isActive = true
        totalCostLabel.centerXAnchor.constraint(equalTo: confirmContainer.centerXAnchor).isActive = true
        totalCostLabel.heightAnchor.constraint(equalTo: confirmContainer.heightAnchor).isActive = true
        totalCostLabel.widthAnchor.constraint(equalTo: confirmContainer.widthAnchor).isActive = true
        
    }
    
    @objc func bringBackReserve(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmContainer.alpha = 0
            self.totalCostLabel.alpha = 0
            self.reserveWidthAnchor.constant = -101
            self.view.layoutIfNeeded()
        }) { (success) in
            self.reserveButton.setTitle("Reserve Spot", for: .normal)
            self.reserveButton.removeTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
            self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
        }
    }

    @objc private func handlePaymentButtonTapped() {
        self.paymentContext.presentPaymentMethodsViewController()
        
    }

    @objc func handleRequestRideButtonTapped() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user-vehicles")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if (dictionary[currentUser] as? [String:AnyObject]) != nil {
                    let pricey: Double = (self.price * Double(hours!))/100
                    if couponActive != nil && couponActive != 0 {
                        let percent: Double = Double(couponActive!)/100
                        let payment = pricey - (percent * pricey)
                        let stringCost = String(format: "%.2f", payment)
                        self.totalCostLabel.text = "$\(stringCost)"
                    } else {
                        let stringCost = String(format: "%.2f", pricey)
                        self.totalCostLabel.text = "$\(stringCost)"
                    }
                    UIView.animate(withDuration: 0.3, animations: {
                        self.confirmContainer.alpha = 1
                        self.totalCostLabel.alpha = 1
                        self.reserveWidthAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        self.reserveButton.setTitle("Confirm Reservation", for: .normal)
                        self.reserveButton.removeTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
                        self.reserveButton.addTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
                    }
                } else {
                    self.delegate?.addAVehicleReminder()
                    self.sendHelp(title: "Vehicle Info Needed", message: "You must enter your vehicle information before reserving a spot")
                }
            }
        }
    }
    
    @objc private func handleConfirmRideButtonTapped() {
        self.paymentInProgress = true
        self.paymentContext.requestPayment()
    }
    
    

      private func reloadPaymentButtonContent() {
        
        guard let selectedPaymentMethod = paymentContext.selectedPaymentMethod else {
            // Show default image, text, and color
//            paymentButton.setImage(#imageLiteral(resourceName: "Payment"), for: .normal)
            paymentButton.setTitle("Select Payment", for: .normal)
            paymentButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            return
        }

        // Show selected payment method image, label, and darker color
        paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
        paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
        paymentButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
    }

    func reloadRequestRideButton() {
        // Show disabled state
        reserveButton.backgroundColor = Theme.DARK_GRAY
        reserveButton.setTitle("Reserve Spot", for: .normal)
        reserveButton.setTitleColor(.white, for: .normal)
//        requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        reserveButton.isEnabled = false

        switch rideRequestState {
        case .none:
            // Show enabled state
            reserveButton.backgroundColor = Theme.PRIMARY_DARK_COLOR
            reserveButton.setTitle("Reserve Spot", for: .normal)
            reserveButton.setTitleColor(.white, for: .normal)
//            requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            reserveButton.isEnabled = true
        case .requesting:
            // Show loading state
            reserveButton.backgroundColor = Theme.DARK_GRAY
            reserveButton.setTitle("···", for: .normal)
            reserveButton.setTitleColor(.white, for: .normal)
            reserveButton.setImage(nil, for: .normal)
            reserveButton.isEnabled = false
        case .active:
            // Show completion state
            reserveButton.backgroundColor = .white
            reserveButton.setTitle("Complete Ride", for: .normal)
            reserveButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            reserveButton.setImage(nil, for: .normal)
            reserveButton.isEnabled = true
        }
    }

    private func completeActiveRide() {
        guard case .active = rideRequestState else {
            // Missing active ride
            return
        }

        // Reset to none state
        rideRequestState = .none

    }

    // MARK: STPPaymentContextDelegate

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
        let costs = hours! * paymentContext.paymentAmount
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let value = dictionary["coupon"] as? Double
                let percent: Double = Double(value! / 100)
                let removal = Int(percent * Double(costs))
                let payment = costs - removal
                
                MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                        amount: payment,
                                                        completion: completion)
                
                ref.removeValue()
            } else {
                MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                        amount: costs,
                                                        completion: completion)
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        switch status {
        case .error:
            self.notify(status: false)
        case .success:
            self.changeReserveButton()
            self.updateUserProfile()
            self.addCurrentParking()
            self.notify(status: true)
        case .userCancellation:
            return
        }
    }
    
    func notify(status: Bool) {
        self.delegate?.showPurchaseStatus(status: status)
    }
    
    func changeReserveButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmContainer.alpha = 0
            self.totalCostLabel.alpha = 0
            self.reserveWidthAnchor.constant = -101
            self.view.layoutIfNeeded()
        }) { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reserveButton.setTitle("Reserve Spot", for: .normal)
                self.reserveButton.removeTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
                self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func sendHelp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func addCurrentParking() {
        self.reserveButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.reserveButton.alpha = 0.6
            self.costButton.alpha = 0.6
        }) { (success) in
            self.delegate?.purchaseButtonSwipedDown()
            UIView.animate(withDuration: 0.3, animations: {
                currentButton.alpha = 1
                self.view.alpha = 0
            })
        }
    }
    
    private func updateUserProfile() {
        self.cost = self.cost * Double(hours!)
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let timestamp = NSDate().timeIntervalSince1970
        
        let couponRef = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        couponRef.removeValue()
        couponActive = nil
        
        let userRef = Database.database().reference().child("users").child(currentUser).child("recentParking")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            self.recentCount =  Int(snapshot.childrenCount)
            let recentRef = userRef.child("\(self.recentCount)")
            recentRef.updateChildValues(["parkingID": self.parkingId, "timestamp": timestamp, "cost": self.cost, "hours": hours!])
        }
        
        let parkingRef = Database.database().reference().child("parking").child(self.parkingId)
        let currentParkingRef = parkingRef.child("Current")
        parkingRef.updateChildValues(["previousUser": currentUser])
        currentParkingRef.updateChildValues(["currentUser": currentUser])
        
        let paymentRef = Database.database().reference().child("users").child(self.id).child("Payments")
        let currentRef = Database.database().reference().child("users").child(self.id)
        currentRef.observeSingleEvent(of: .value) { (current) in
            let dictionary = current.value as? [String:AnyObject]
            var currentFunds = dictionary!["userFunds"] as? Double
            if currentFunds != nil {} else {currentFunds = 0}
            paymentRef.observeSingleEvent(of: .value) { (snapshot) in
                self.count =  Int(snapshot.childrenCount)
                let payRef = paymentRef.child("\(self.count)")
                let newFunds = Double(currentFunds!) + (Double(self.cost) * 0.75)
                payRef.updateChildValues(["cost": self.cost, "currentFunds": newFunds, "hours": hours!, "user": currentUser, "timestamp": timestamp, "parkingID": self.parkingId])
            }
        }
        
        let helpRef = Database.database().reference().child("users").child(currentUser).child("currentParking").child(self.parkingId)
        helpRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let oldHours = dictionary["hours"] as? Int {
                    let newHours = oldHours + hours!
                    helpRef.updateChildValues(["timestamp": timestamp, "hours": newHours, "parkingID": self.parkingId, "cost": self.cost])
                    seconds! = seconds! + (3600 * hours!)
                }
            } else {
                helpRef.updateChildValues(["timestamp": timestamp, "hours": hours!, "parkingID": self.parkingId, "cost": self.cost])
            }
        }
        ///////
        let observeRef = Database.database().reference().child("parking").child(self.parkingId).child("Current")
        observeRef.observe(.childAdded) { (snapshot) in
            self.sendNewCurrent(status: "start")
        }
        observeRef.observe(.childRemoved) { (snapshot) in
            self.sendNewCurrent(status: "end")
        }
        
        let fundRef = Database.database().reference().child("users").child(self.id)
        fundRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if var dictionary = snapshot.value as? [String:AnyObject] {
                
                if let previousFunds = dictionary["userFunds"] {
                    let funds = Double(truncating: previousFunds as! NSNumber) + (self.cost) * 0.75
                    fundRef.updateChildValues(["userFunds": funds])
                } else {
                    fundRef.updateChildValues(["userFunds": (self.cost * 0.75)])
                }
                if let previousHours = dictionary["hostHours"] as? Int{
                    let hour = previousHours + hours!
                    fundRef.updateChildValues(["hostHours": hour])
                } else {
                    fundRef.updateChildValues(["hostHours": hours!])
                }
                
            }
        }, withCancel: nil)
    }
    
    func sendNewCurrent(status: String) {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                var fullNameArr = userName?.split(separator: " ")
                let firstName: String = String(fullNameArr![0])
                
                let sendRef = Database.database().reference().child("currentParking").child(currentUser)
                if status == "start" {
                    sendRef.updateChildValues(["status": "In use", "deviceID": AppDelegate.DEVICEID, "fromID": currentUser, "toID": self.id])
                } else if status == "end" {
                    sendRef.updateChildValues(["status": "Finished", "deviceID": AppDelegate.DEVICEID, "fromID": currentUser, "toID": self.id])
                }
                self.fetchNewCurrent(key: self.id, name: firstName, status: status)
            }
        }
    }
    
    func fetchNewCurrent(key: String, name: String, status: String) {
        Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let fromDevice = dictionary["DeviceID"] as? String
                self.setupPushNotifications(fromDevice: fromDevice!, name: name, status: status)
            }
        }
    }
    
    fileprivate func setupPushNotifications(fromDevice: String, name: String, status: String) {
        if status == "start" {
            let title = "\(name) is currently parked in your spot!"
            let body = "Open to see more details."
            let toDevice = fromDevice
            var headers: HTTPHeaders = HTTPHeaders()
            
            headers = ["Content-Type": "application/json", "Authorization": "key=\(AppDelegate.SERVERKEY)"]
            let notification = ["to": "\(toDevice)", "notification": ["body": body, "title": title, "badge": 0, "sound": "default"]] as [String:Any]
            
            Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).response { (response) in
                //
            }
        } else if status == "end" {
            let title = "\(name)'s has ended her parking reservation."
            let body = "Let us know if they've left your parking space."
            let toDevice = fromDevice
            var headers: HTTPHeaders = HTTPHeaders()
            
            headers = ["Content-Type": "application/json", "Authorization": "key=\(AppDelegate.SERVERKEY)"]
            let notification = ["to": "\(toDevice)", "notification": ["body": body, "title": title, "badge": 0, "sound": "default"]] as [String:Any]
            
            Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).response { (response) in
                //
            }
            
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            let deleteRef = Database.database().reference().child("currentParking")
            deleteRef.child(currentUser).removeValue()
        }
    }
    
    func openHoursButton() {
        self.hourButtonHeight.constant = 120
        self.hoursDelegate?.openHoursButton()
    }
    
    func closeHoursButton(status: Bool) {
        if status == true {
            self.reserveButton.alpha = 1
            self.costButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
        }
        self.hourButtonHeight.constant = 0
        self.hoursDelegate?.closeHoursButton()
    }
    

}
