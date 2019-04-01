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
    
    private var paymentContext: STPPaymentContext
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.loadingActivity.startAnimating()
                    self.loadingActivity.alpha = 1
                    self.confirmDurationButton.alpha = 0.6
                    self.confirmDurationButton.setTitle("", for: .normal)
                }
                else {
                    self.loadingActivity.stopAnimating()
                    self.loadingActivity.alpha = 0
                    self.confirmDurationButton.alpha = 1
                    self.confirmDurationButton.isUserInteractionEnabled = true
                    self.confirmDurationButton.backgroundColor = Theme.BLUE
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.confirmDurationButton.setTitle("Confirm Purchase", for: .normal)
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
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
        
        return button
    }()
    
    var confirmOrderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Confirm your booking"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.text = "Wednesday, Oct 10"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "10:30 pm - 12:00 pm"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$9.10"
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.addSubview(line)
        
        return view
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(handlePaymentButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "singleCarIcon")
        var image = UIImage(cgImage: img!.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        button.setImage(image, for: .normal)
        button.alpha = 0.7
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Toyota 4Runner"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var confirmDurationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Comfirm Purchase", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
        setupPayment()
    }
    

    func setupViews() {
        
        self.view.addSubview(checkmark)
        checkmark.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        checkmark.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 18).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
        self.view.addSubview(confirmOrderLabel)
        confirmOrderLabel.leftAnchor.constraint(equalTo: checkmark.rightAnchor, constant: 12).isActive = true
        confirmOrderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        confirmOrderLabel.topAnchor.constraint(equalTo: checkmark.topAnchor, constant: 2).isActive = true
        confirmOrderLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: checkmark.rightAnchor, constant: 12).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: checkmark.bottomAnchor, constant: -2).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(totalCostLabel)
        totalCostLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        totalCostLabel.topAnchor.constraint(equalTo: checkmark.bottomAnchor, constant: 16).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(durationLabel)
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        durationLabel.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor, constant: 8).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        self.view.addSubview(confirmDurationButton)
        confirmDurationButton.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 68).isActive = true
        confirmDurationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        confirmDurationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        confirmDurationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: confirmDurationButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: confirmDurationButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    func setupPayment() {
        
        self.view.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        cardView.bottomAnchor.constraint(equalTo: confirmDurationButton.topAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cardView.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        paymentButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        paymentButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        cardView.addSubview(carIcon)
        carIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        carIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        carIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cardView.addSubview(carLabel)
        carLabel.rightAnchor.constraint(equalTo: carIcon.leftAnchor, constant: -4).isActive = true
        carLabel.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        carLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 36).isActive = true
        carLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setData(price: Double, fromDate: Date, toDate: Date) {
        let cost = String(format:"%.02f", price.rounded(toPlaces: 2))
        self.totalCostLabel.text = "$\(cost)"
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let fromString = formatter.string(from: fromDate)
        let toString = formatter.string(from: toDate)
        self.durationLabel.text = "\(fromString) - \(toString)"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE, MMM d"
        let day = dayFormatter.string(from: fromDate)
        self.dateLabel.text = day
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
//        self.paymentInProgress = true
//        self.paymentContext.requestPayment() //////////////////////////PAYMENT NOT SET UP///////////////////////////////////////
        
//        let alert = UIAlertController(title: "We apologize!", message: "Drivewayz is currently under some minor restorations and the ability to purchase spots is currently disabled. Functionality should be back by April, 2019.", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//        self.present(alert, animated: true)
        self.delegate?.confirmPurchasePressed()
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
            paymentButton.setTitle("Payment", for: .normal)
            paymentButton.setTitleColor(Theme.BLACK, for: .normal)
            return
        }
        
        // Show selected payment method image, label, and darker color
        paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
        paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
        paymentButton.setTitleColor(Theme.BLACK, for: .normal)
    }
    
    func reloadRequestRideButton() {
        // Show disabled state
        confirmDurationButton.backgroundColor = Theme.DARK_GRAY
        confirmDurationButton.setTitle("Book Spot", for: .normal)
        confirmDurationButton.setTitleColor(.white, for: .normal)
        //        requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        confirmDurationButton.isEnabled = false
        
        switch rideRequestState {
        case .none:
            // Show enabled state
            confirmDurationButton.backgroundColor = Theme.BLUE
            confirmDurationButton.setTitle("Book Spot", for: .normal)
            confirmDurationButton.setTitleColor(.white, for: .normal)
            //            requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            confirmDurationButton.isEnabled = true
        case .requesting:
            // Show loading state
            confirmDurationButton.backgroundColor = Theme.DARK_GRAY
            confirmDurationButton.setTitle("···", for: .normal)
            confirmDurationButton.setTitleColor(.white, for: .normal)
            confirmDurationButton.setImage(nil, for: .normal)
            confirmDurationButton.isEnabled = false
        case .active:
            // Show completion state
            confirmDurationButton.backgroundColor = .white
            confirmDurationButton.setTitle("Working", for: .normal)
            confirmDurationButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            confirmDurationButton.setImage(nil, for: .normal)
            confirmDurationButton.isEnabled = true
        }
    }
    
}
