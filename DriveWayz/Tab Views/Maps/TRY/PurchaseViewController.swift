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

class PurchaseViewController: UIViewController, STPPaymentContextDelegate {

    // Controllers

    let stripePublishableKey = "pk_test_D5D2xLIBELH4ZlTwigJEWyKF"
    let backendBaseURL: String? = "https://boiling-shore-28466.herokuapp.com"
    
    let paymentCurrency = "usd"
    var count: Int = 0

    var hours: Int = 0
    var id: String = ""
    var account: String = ""
    var cost: Double = 0.00
    var parkingId: String = ""
    
    private var paymentContext: STPPaymentContext
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    private enum RideRequestState {
        case none
        case requesting
        case active(Ride)
    }
    private var rideRequestState: RideRequestState = .none {
        didSet {
            reloadRequestRideButton()
        }
    }

    private var price = 0 {
        didSet {
            // Forward value to payment context
            paymentContext.paymentAmount = price
        }
    }
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    reserveButton.alpha = 0.6
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    reserveButton.alpha = 1
                }
            }, completion: nil)
        }
    }
    
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
        hours.layer.cornerRadius = 10
        
        return hours
    }()

    // MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        let stripePublishableKey = self.stripePublishableKey
        let backendBaseURL = self.backendBaseURL
        
        assert(stripePublishableKey.hasPrefix("pk_"), "You must set your Stripe publishable key at the top of CheckoutViewController.swift to run this app.")
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        
//        self.hours = hours
//        self.id = ID
//        self.parkingId = parkingID
//        self.account = account
        
//        let stringPrice = String(price / hours)
//        var reversed = String(stringPrice.reversed())
//        reversed.insert(".", at: stringPrice.index(reversed.startIndex, offsetBy: 2))
//        let singleCost = String(reversed.reversed())
//        cost = Double(singleCost)! * Double(hours)

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
        paymentContext.paymentAmount = price
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let red: CGFloat = 0
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.alpha = 0

        setupViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.didMove(toParentViewController: self)
    }
    
    func setupViews() {
        
        self.view.addSubview(reserveContainer)
        reserveContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        reserveContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        reserveContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reserveContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        reserveContainer.addSubview(line)
        line.centerYAnchor.constraint(equalTo: reserveContainer.centerYAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(reserveButton)
        reserveButton.addTarget(self, action: #selector(handleRequestRideButtonTapped), for: .touchUpInside)
        reserveButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        reserveButton.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        reserveButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        paymentButton.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 40)
        
        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 2).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line2.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor, constant: -100).isActive = true
        
        self.view.addSubview(hoursButton)
        hoursButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        hoursButton.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        hoursButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hoursButton.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        self.activityIndicator.center = reserveButton.center
    }

    @objc private func handlePaymentButtonTapped() {
        self.paymentContext.presentPaymentMethodsViewController()
        
    }

    @objc private func handleRequestRideButtonTapped() {
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
        paymentContext.paymentAmount = 100
        MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                amount: self.paymentContext.paymentAmount,
                                                email: userEmail!, account: self.account,
                                                completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        let title: String
        let message: String
        let completed: Bool
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
            completed = false
        case .success:
            title = "Success"
            message = "Success fo real!"
            completed = true
            self.updateUserProfile()
            self.beginRoute()
        case .userCancellation:
            completed = false
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            if completed == true {
                //completed payment
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.navigationBar.isHidden = true
                UIApplication.shared.statusBarStyle = .lightContent
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                    //
                }
            } else {
                //payment error
                self.navigationController?.popViewController(animated: true)
                UIApplication.shared.statusBarStyle = .lightContent
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func beginRoute() {
        
        let currentUser = Auth.auth().currentUser?.uid
        let timestamp = NSDate().timeIntervalSince1970
        let userRef = Database.database().reference().child("users").child(currentUser!).child("currentParking").child(parkingId)
        userRef.updateChildValues(["timestamp": timestamp, "hours": self.hours, "parkingID": parkingId])
        
    }
    
    private func updateUserProfile() {
        
        let currentUser = Auth.auth().currentUser?.uid
        let timestamp = NSDate().timeIntervalSince1970
        let userRef = Database.database().reference().child("users").child(currentUser!).child("recentParking").child(parkingId)
        userRef.updateChildValues(["timestamp": timestamp, "cost": self.cost, "hours": self.hours])
        
        let paymentRef = Database.database().reference().child("users").child(id).child("payments")
        let currentRef = Database.database().reference().child("users").child(id)
        currentRef.observeSingleEvent(of: .value) { (current) in
            let dictionary = current.value as? [String:AnyObject]
            var currentFunds = dictionary!["userFunds"] as? Double
            if currentFunds != nil {} else {currentFunds = 0}
            paymentRef.observeSingleEvent(of: .value) { (snapshot) in
                self.count =  Int(snapshot.childrenCount)
                let payRef = paymentRef.child("\(self.count)")
                let newFunds = Double(currentFunds!) + (Double(self.cost) * 0.8)
                payRef.updateChildValues(["cost": self.cost, "currentFunds": newFunds, "hours": self.hours, "user": currentUser!, "timestamp": timestamp, "parkingID": self.parkingId])
            }
        }
        let fundRef = Database.database().reference().child("users").child(id)
        fundRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if var dictionary = snapshot.value as? [String:AnyObject] {
                
                if let previousFunds = dictionary["userFunds"] {
                    let funds = Double(truncating: previousFunds as! NSNumber) + (self.cost) * 0.8
                    fundRef.updateChildValues(["userFunds": funds])
                } else {
                    fundRef.updateChildValues(["userFunds": (self.cost * 0.8)])
                }
                if let previousHours = dictionary["hostHours"] as? Int{
                    let hours = previousHours + self.hours
                    fundRef.updateChildValues(["hostHours": hours])
                } else {
                    fundRef.updateChildValues(["hostHours": self.hours])
                }
                
            }
        }, withCancel: nil)
    }

}
