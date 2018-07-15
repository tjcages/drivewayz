//
//  CheckoutViewController.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/22/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import UserNotifications

class CheckoutViewController: UIViewController, STPPaymentContextDelegate {
    
    var count: Int = 0
    
    var exitButton: UIImage = {
        let exitButton = UIImageView()
        let exitImage = UIImage(named: "Expand")
        let tintedImage = exitImage?.withRenderingMode(.alwaysTemplate)
        exitButton.image = tintedImage
        exitButton.tintColor = Theme.DARK_GRAY
        exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        let image = exitButton.image
        exitButton.isUserInteractionEnabled = true
        
        return image!
    }()

    // 1) To get started with this demo, first head to https://dashboard.stripe.com/account/apikeys
    // and copy your "Test Publishable Key" (it looks like pk_test_abcdef) into the line below.
    let stripePublishableKey = "pk_test_D5D2xLIBELH4ZlTwigJEWyKF"

    // 2) Next, optionally, to have this demo save your user's payment details, head to
    // https://github.com/stripe/example-ios-backend/tree/v13.0.3, click "Deploy to Heroku", and follow
    // the instructions (don't worry, it's free). Replace nil on the line below with your
    // Heroku URL (it looks like https://blazing-sunrise-1234.herokuapp.com ).
    let backendBaseURL: String? = "https://boiling-shore-28466.herokuapp.com"

    // 3) Optionally, to enable Apple Pay, follow the instructions at https://stripe.com/docs/mobile/apple-pay
    // to create an Apple Merchant ID. Replace nil on the line below with it (it looks like merchant.com.yourappname).
    let appleMerchantID: String? = nil

    // These values will be shown to the user when they purchase with Apple Pay.
    let companyName = "Drivewayz"
    let paymentCurrency = "usd"

    let paymentContext: STPPaymentContext

    let theme: STPTheme
    let paymentRow: CheckoutRowView
    let totalRow: CheckoutRowView
    let buyButton: BuyButton
    let rowHeight: CGFloat = 60
    let productImage = UILabel()
    let costImage = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let numberFormatter: NumberFormatter
    var product: String = ""
    var hours: Int = 0
    var id: String = ""
    var account: String = ""
    var cost: Double = 0.00
    var parkingId: String = ""
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.buyButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.buyButton.alpha = 1
                }
                }, completion: nil)
        }
    }

    init(product: String, price: Int, hours: Int, ID: String, account: String, parkingID: String) {

        let stripePublishableKey = self.stripePublishableKey
        let backendBaseURL = self.backendBaseURL

        assert(stripePublishableKey.hasPrefix("pk_"), "You must set your Stripe publishable key at the top of CheckoutViewController.swift to run this app.")
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")

        self.product = product
        self.hours = hours
        self.productImage.text = product
        self.id = ID
        self.parkingId = parkingID
        self.account = account
        
        let stringPrice = String(price / hours)
        var reversed = String(stringPrice.reversed())
        reversed.insert(".", at: stringPrice.index(reversed.startIndex, offsetBy: 2))
        let singleCost = String(reversed.reversed())
        cost = Double(singleCost)! * Double(hours)
        
        self.costImage.text = "$\(singleCost)/hour for \(hours) hour(s)"
        
        self.theme = .default()
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL

        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        config.companyName = self.companyName
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

        self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                          theme: .default())
        self.totalRow = CheckoutRowView(title: "Total", detail: "", tappable: false,
                                        theme: .default())
        self.buyButton = BuyButton(enabled: true, theme: .default())
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
        ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        self.numberFormatter = numberFormatter
        super.init(nibName: nil, bundle: nil)
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.backgroundColor = Theme.OFF_WHITE
        var red: CGFloat = 0
        self.theme.primaryBackgroundColor.getRed(&red, green: nil, blue: nil, alpha: nil)
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        self.navigationItem.title = "Drivewayz"

        self.productImage.font = UIFont.systemFont(ofSize: 32)
        self.productImage.textColor = Theme.DARK_GRAY
        self.costImage.font = UIFont.systemFont(ofSize: 28)
        self.costImage.textColor = Theme.PRIMARY_COLOR
        self.view.addSubview(self.totalRow)
        self.view.addSubview(self.paymentRow)
        self.view.addSubview(self.productImage)
        self.view.addSubview(self.costImage)
        self.view.addSubview(self.buyButton)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.alpha = 0
        self.buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
        self.paymentRow.onTap = { [weak self] in
            self?.paymentContext.pushPaymentMethodsViewController()
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: exitButton, style: .plain, target: self, action: #selector(dismissDetails(sender:)))
        self.navigationController?.navigationBar.tintColor = Theme.PRIMARY_COLOR
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        }
        let width = self.view.bounds.width - (insets.left + insets.right)
        self.productImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 50)
        self.productImage.center = CGPoint(x: width/2.0,
                                           y: self.productImage.bounds.height/2.0 + rowHeight + 20)
        self.costImage.sizeToFit()
        self.costImage.center = CGPoint(x: width/2.0, y: self.costImage.bounds.height + self.productImage.frame.maxY)
        self.paymentRow.frame = CGRect(x: insets.left, y: self.costImage.frame.maxY + (rowHeight * 1.5),
                                       width: width, height: rowHeight)
        self.totalRow.frame = CGRect(x: insets.left, y: self.paymentRow.frame.maxY,
                                     width: width, height: rowHeight)
        self.buyButton.frame = CGRect(x: insets.left, y: 0, width: 88, height: 44)
        self.buyButton.center = CGPoint(x: width/2.0, y: self.totalRow.frame.maxY + rowHeight*1.5)
        self.activityIndicator.center = self.buyButton.center
    }

    @objc func didTapBuy() {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.paymentInProgress = true
        self.paymentContext.requestPayment()
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
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
            self.updateUserProfile()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            title = "Success"
            message = "You bought parking in\(self.product) for \(self.hours) hours!"
            completed = true
            beginRoute()
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
            }
        }, withCancel: nil)
    }
    

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.paymentRow.loading = paymentContext.loading
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            self.paymentRow.detail = paymentMethod.label
        }
        else {
            self.paymentRow.detail = "Select Payment"
        }
        self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
    }

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
    
    @objc func dismissDetails(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
