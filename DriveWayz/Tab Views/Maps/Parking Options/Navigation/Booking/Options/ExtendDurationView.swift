//
//  ExtendDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFirestore
import NVActivityIndicatorView

protocol handleExtendPaymentMethod {
    func closeBackground()
}

class ExtendDurationView: UIViewController {

    var delegate: handleCurrentBooking?
    var currentBooking: Bookings?
    var dynamicPrice: CGFloat?
    var bottomAnchor: CGFloat = 0.0
    
    var selectedHours: Int = 1
    var selectedMinutes: Int = 30
    var totalSelectedTime: Double = 1.5
    
    let dimView = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
    
    let paymentController = ChoosePaymentView()
    var currentPaymentMethod: PaymentMethod?
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.loadingActivity.startAnimating()
                    self.loadingActivity.alpha = 1
                    self.mainButtonUnavailable()
                    self.mainButton.setTitle("", for: .normal)
                }
                else {
                    self.loadingActivity.stopAnimating()
                    self.loadingActivity.alpha = 0
                    self.mainButtonAvailable()
                    self.mainButton.setTitle("Confirm Purchase", for: .normal)
                }
            }, completion: nil)
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.backgroundColor = Theme.WHITE
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.setTitle("Confirm Purchase", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Extend Duration"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set payment method", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.text = "1 hr 30 min"
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var sliderView: DurationTimeView = {
        let controller = DurationTimeView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var totalCost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "$4.56"
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        
        let minutes = Int(totalSelectedTime * 60)
        setHourLabel(minutes: minutes)
        sliderView.initializeTime(minutes: minutes)
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(closeButton)
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -24
        case .iphoneX:
            profitsBottomAnchor = closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        }
        
        container.addSubview(mainButton)
        mainButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -8).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        paymentButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -8).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        paymentButton.rightAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        view.addSubview(totalCost)
        totalCost.centerYAnchor.constraint(equalTo: paymentButton.centerYAnchor).isActive = true
        totalCost.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        totalCost.sizeToFit()
        
        view.addSubview(line)
        line.anchor(top: nil, left: view.leftAnchor, bottom: paymentButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, width: 0, height: 1)
        
        view.addSubview(sliderView.view)
        sliderView.view.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        sliderView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        sliderView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sliderView.view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
//        view.addSubview(mainLabel)
//        mainLabel.bottomAnchor.constraint(equalTo: sliderView.view.topAnchor, constant: -16).isActive = true
//        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        mainLabel.sizeToFit()
//
//        view.addSubview(totalTimeLabel)
//        totalTimeLabel.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
//        totalTimeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        totalTimeLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: sliderView.view.topAnchor, constant: -20).isActive = true
     
        view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    @objc func confirmButtonPressed() {
        // First check if a payment method is specified
        if let paymentMethod = currentPaymentMethod {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            paymentInProgress = true
            loadingActivity.alpha = 1
            loadingActivity.startAnimating()
            
            // Use the token in the next step
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            
            guard let text = self.totalCost.text?.replacingOccurrences(of: "$", with: "") else { return }
            guard let costs = Double(text) else { return }
            let pennies = Int(costs * 100)
            
            let amount = pennies
            let description = "Current booking extension"
            let timestamp = Date().timeIntervalSince1970
            
            if let id = paymentMethod.id, let customer = paymentMethod.customer {
                let data = ["source": id, "customer_id": customer, "amount": amount, "description": description, "timestamp": timestamp] as [String : Any]
                ref = db.collection("stripe_customers").document(userId).collection("charges").addDocument(data: data, completion: { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                        return
                    }
                    if let key = ref?.documentID {
                        self.monitorPayments(key: key)
                    }
                })
            } else {
                // The payment source was invalid
                print("There was an issue processing your request")
            }
        } else {
            paymentButtonPressed()
        }
    }
    
    func monitorPayments(key: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("charges").document(key)
        db.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            let stripePayment = StripePayment(dictionary: data)
            if let status = stripePayment.status {
                self.paymentInProgress = false
                self.loadingActivity.alpha = 0
                self.loadingActivity.stopAnimating()
                self.backButtonPressed()
                
                if status == "succeeded" {
                    // Stripe payment succeeded
                    pushQuickAlert(title: "Success!", message: "")
                    self.increaseDuration()
                    print(status)
                } else if status == "failed" {
                    // Stripe payment failed
                    print(status)
                    if let failureMessage = stripePayment.failure_message {
                        pushQuickAlert(title: "The payment could not be completed.", message: failureMessage)
                    }
                }
            }
        }
    }
    
    func increaseDuration() {
        if let booking = currentBooking, let bookingId = booking.bookingID, let toTime = booking.toDate {
            let seconds = totalSelectedTime * 3600
            let newTime = seconds + toTime
            let ref = Database.database().reference().child("UserBookings").child(bookingId)
            ref.updateChildValues(["toDate": newTime]) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "restartBookingObservations"), object: nil)
            }
        }
    }
    
    func mainButtonAvailable() {
        UIView.animate(withDuration: animationIn) {
            self.mainButton.setTitleColor(Theme.WHITE, for: .normal)
            self.mainButton.backgroundColor = Theme.BLUE
            self.mainButton.isEnabled = true
        }
    }
    
    func mainButtonUnavailable() {
        UIView.animate(withDuration: animationIn) {
            self.mainButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.mainButton.backgroundColor = lineColor
            self.mainButton.isEnabled = false
        }
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                self.backButtonPressed()
            }
        } else if state == .ended {
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                self.backButtonPressed()
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func paymentButtonPressed() {
        paymentController.extendedDelegate = self
        let navigation = UINavigationController(rootViewController: paymentController)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overCurrentContext
        self.present(navigation, animated: true, completion: nil)
        
        profitsBottomAnchor.constant = 100
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBackground() {
        profitsBottomAnchor.constant = self.bottomAnchor
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension ExtendDurationView: handleHoursSelected, handleExtendPaymentMethod {
    
    func setHourLabel(minutes: Int) {
        let tuple = minutesToHoursMinutes(minutes: minutes)
        if tuple.hours == 1 {
            mainButtonAvailable()
            if tuple.leftMinutes == 0 {
                totalTimeLabel.text = "\(tuple.hours) hr"
            } else {
                totalTimeLabel.text = "\(tuple.hours) hr \(tuple.leftMinutes) min"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                mainButtonUnavailable()
                totalTimeLabel.text = "00 min"
            } else {
                mainButtonAvailable()
                totalTimeLabel.text = "\(tuple.leftMinutes) min"
            }
        } else {
            mainButtonAvailable()
            if tuple.leftMinutes == 0 {
                totalTimeLabel.text = "\(tuple.hours) hrs"
            } else {
                totalTimeLabel.text = "\(tuple.hours) hrs \(tuple.leftMinutes) min"
            }
        }
        selectedHours = tuple.hours
        selectedMinutes = tuple.leftMinutes
        totalSelectedTime = Double(tuple.hours) + Double(tuple.leftMinutes)/60
        if let price = dynamicPrice {
            let totalCost = totalSelectedTime * Double(price)
            let totalString = String(format: "%.2f", totalCost)
            self.totalCost.text = "$\(totalString)"
        }
    }
    
    func changeStartDate(date: Date) { }
    
    func setData(isToday: Bool) { }
    
    func changeToBooking() { }
    
    func changeToReservation() { }

}

var paymentCardTextField = STPPaymentCardTextField()

func setDefaultPaymentMethod(method: PaymentMethod) -> UIImage {
    let params = STPCardParams()
    if let brand = method.brand?.lowercased() {
        let methodStyle = CardType(dictionary: brand)
        if let prefix = methodStyle.prefix {
            params.number = prefix
        }
    }
    paymentCardTextField.cardParams = STPPaymentMethodCardParams(cardSourceParams: params)
    if let image = paymentCardTextField.brandImage {
        return image
    } else {
        return UIImage()
    }
}
