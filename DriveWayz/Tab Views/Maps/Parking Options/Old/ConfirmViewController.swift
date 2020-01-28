//
//  ConfirmPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import FirebaseFirestore
import NVActivityIndicatorView

var paymentNormalHeight: CGFloat = 316

class ConfirmViewController: UIViewController {
    
    var delegate: handleCheckoutParking?
    var additionalDelegate: handleAdditionalSteps?
    
    var parking: ParkingSpots?
    var fromDate: Date?
    var toDate: Date?
    var price: Double?
    var hours: Double?
    var totalTime: String?
    var discount: Int = 0
    var currentParkingImage: UIImage?
    
    let paymentController = ChoosePaymentView()
    let vehicleController = ChooseVehicleView()
    
    var currentPaymentMethod: PaymentMethod?
    var currentVehicleMethod: Vehicles?
    
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
                    self.mainButton.setTitle("Purchase Spot", for: .normal)
                }
            }, completion: nil)
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please confirm booking"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You can always extend time later"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var selectionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        
        return view
    }()
    
    var parkingTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prime Spot"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3:15pm to 4:30pm", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "$0.00"
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.addTarget(self, action: #selector(informationButtonPressed), for: .touchUpInside)
        
        return button
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
    
    var saleIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "saleIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DarkGreen
        button.transform = CGAffineTransform(scaleX: -0.8, y: 0.8)
        button.alpha = 0
        
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
    
    var vehicleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add vehicle", for: .normal)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(vehicleButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var vehicleArrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 0, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(vehicleButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
        setupPayment()
        observePayments()
        observeVehicles()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(greetingLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        greetingLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        greetingLabel.sizeToFit()
        
        view.addSubview(selectionContainer)
        view.addSubview(parkingTypeLabel)
        view.addSubview(totalCostLabel)
        view.addSubview(couponCostLabel)
        view.addSubview(saleIcon)
        view.addSubview(informationIcon)
        view.addSubview(durationButton)
        
        parkingTypeLabel.topAnchor.constraint(equalTo: selectionContainer.topAnchor, constant: 12).isActive = true
        parkingTypeLabel.leftAnchor.constraint(equalTo: selectionContainer.leftAnchor, constant: 16).isActive = true
        parkingTypeLabel.sizeToFit()
        
        totalCostLabel.centerYAnchor.constraint(equalTo: parkingTypeLabel.centerYAnchor).isActive = true
        totalCostLabel.rightAnchor.constraint(equalTo: selectionContainer.rightAnchor, constant: -16).isActive = true
        totalCostLabel.sizeToFit()
        
        couponCostLabel.centerYAnchor.constraint(equalTo: durationButton.centerYAnchor).isActive = true
        couponCostLabel.rightAnchor.constraint(equalTo: totalCostLabel.rightAnchor).isActive = true
        couponCostLabel.sizeToFit()
        
        saleIcon.centerYAnchor.constraint(equalTo: totalCostLabel.centerYAnchor).isActive = true
        saleIcon.rightAnchor.constraint(equalTo: totalCostLabel.leftAnchor, constant: -4).isActive = true
        saleIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        saleIcon.widthAnchor.constraint(equalTo: saleIcon.heightAnchor).isActive = true
        
        informationIcon.centerYAnchor.constraint(equalTo: parkingTypeLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: parkingTypeLabel.rightAnchor, constant: 12).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(lessThanOrEqualTo: informationIcon.heightAnchor).isActive = true
        
        durationButton.topAnchor.constraint(equalTo: parkingTypeLabel.bottomAnchor, constant: 4).isActive = true
        durationButton.leftAnchor.constraint(equalTo: parkingTypeLabel.leftAnchor).isActive = true
        durationButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        durationButton.sizeToFit()
        
        selectionContainer.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20).isActive = true
        selectionContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        selectionContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        selectionContainer.bottomAnchor.constraint(equalTo: durationButton.bottomAnchor, constant: 12).isActive = true
        
    }
    
    func setupPayment() {
        
        view.addSubview(mainButton)
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        view.addSubview(paymentButton)
        paymentButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        paymentButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -8).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        view.addSubview(vehicleButton)
        view.addSubview(vehicleArrowButton)
        
        vehicleButton.centerYAnchor.constraint(equalTo: paymentButton.centerYAnchor).isActive = true
        vehicleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        vehicleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        vehicleButton.sizeToFit()
        
        vehicleArrowButton.rightAnchor.constraint(equalTo: vehicleButton.leftAnchor, constant: -4).isActive = true
        vehicleArrowButton.centerYAnchor.constraint(equalTo: paymentButton.centerYAnchor).isActive = true
        vehicleArrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        vehicleArrowButton.widthAnchor.constraint(equalTo: vehicleArrowButton.heightAnchor).isActive = true
        
        view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -8).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func vehicleButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            self.vehicleController.extendedDelegate = self
            let navigation = UINavigationController(rootViewController: self.vehicleController)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
}


// Handle Stripe payments
extension ConfirmViewController: handleExtendPaymentMethod {
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        if currentPaymentMethod == nil || currentVehicleMethod == nil {
            additionalDelegate?.openAdditionalStep()
            return
        }
//        self.setupNotifications()
//        return ///////////////////// TESTING PLEASE REMOVE
        
        
        // First check if a payment method is specified
        if let paymentMethod = currentPaymentMethod {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            paymentInProgress = true
            loadingActivity.alpha = 1
            loadingActivity.startAnimating()
            
            // Use the token in the next step
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            
            guard let text = self.totalCostLabel.text?.replacingOccurrences(of: "$", with: "") else { return }
            guard let costs = Double(text) else { return }
            let pennies = Int(costs * 100)
            
            let amount = pennies
            let description = "New booking"
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
                
                if status == "succeeded" {
                    // Stripe payment succeeded
                    print(status)
                    self.setupNotifications()
                } else if status == "failed" {
                    // Stripe payment failed
                    print(status)
                }
            }
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
    
    @objc func informationButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            let controller = PaymentBreakdownViewController()
            if let cost = self.totalCostLabel.text, let price = self.price {
                let hourlyCost = String(format: "$%.2f", price)
                controller.setData(totalCost: cost, hourlyCost: hourlyCost, discount: self.discount)
            }
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func observePayments() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("sources")
        db.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.paymentController.paymentMethods = []
            for document in documents {
                let dataDescription = document.data()
                
                let paymentMethod = PaymentMethod(dictionary: dataDescription)
                if let cardNumber = paymentMethod.last4, paymentMethod.defaultCard {
                    let card = "•••• \(cardNumber)"
                    self.paymentButton.setTitle(card, for: .normal)
                    self.paymentButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                    let image = setDefaultPaymentMethod(method: paymentMethod)
                    self.paymentButton.setImage(image, for: .normal)
                    self.currentPaymentMethod = paymentMethod
                    addStepController.currentPaymentMethod = paymentMethod
                }
            }
        }
    }
    
    func observeVehicles() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles")
        db.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.vehicleController.vehicleMethods = []
            for document in documents {
                let dataDescription = document.data()
                
                let vehicleMethod = Vehicles(dictionary: dataDescription)
                if let model = vehicleMethod.vehicleModel, vehicleMethod.defaultVehicle {
                    self.vehicleButton.setTitle(model, for: .normal)
                    self.vehicleButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                    self.currentVehicleMethod = vehicleMethod
                    addStepController.currentVehicleMethod = vehicleMethod
                }
            }
        }
    }
    
//    func observePaymentMethod() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(userId).child("selectedPayment")
//        ref.observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//                let paymentMethod = PaymentMethod(dictionary: dictionary)
//                if let cardNumber = paymentMethod.last4 {
//                    let card = "•••• \(cardNumber)"
//                    self.paymentButton.setTitle(card, for: .normal)
//                    self.paymentButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
//                    let image = setDefaultPaymentMethod(method: paymentMethod)
//                    self.paymentButton.setImage(image, for: .normal)
//                    self.currentPaymentMethod = paymentMethod
//                    addStepController.currentPaymentMethod = paymentMethod
//                }
//            }
//        }
//        ref.observe(.childRemoved) { (snapshot) in
//            self.paymentButton.setTitle("Select payment", for: .normal)
//            self.paymentButton.setImage(nil, for: .normal)
//            self.currentPaymentMethod = nil
//            ref.observe(.childAdded, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    let paymentMethod = PaymentMethod(dictionary: dictionary)
//                    if let cardNumber = paymentMethod.last4 {
//                        let card = "•••• \(cardNumber)"
//                        self.paymentButton.setTitle(card, for: .normal)
//                        let image = setDefaultPaymentMethod(method: paymentMethod)
//                        self.paymentButton.setImage(image, for: .normal)
//                        self.currentPaymentMethod = paymentMethod
//                        addStepController.currentPaymentMethod = paymentMethod
//                    }
//                }
//            })
//        }
//    }
//
//    func observeVehicleMethod() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(userId).child("selectedVehicle")
//        ref.observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//                let vehicleMethod = Vehicles(dictionary: dictionary)
//                if let model = vehicleMethod.vehicleModel {
//                    self.vehicleButton.setTitle(model, for: .normal)
//                    self.vehicleButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
//                    self.currentVehicleMethod = vehicleMethod
//                    addStepController.currentVehicleMethod = vehicleMethod
//                }
//            }
//        }
//        ref.observe(.childRemoved) { (snapshot) in
//            self.vehicleButton.setTitle("Add vehicle", for: .normal)
//            self.vehicleButton.setImage(nil, for: .normal)
//            self.currentVehicleMethod = nil
//            ref.observe(.childAdded, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    let vehicleMethod = Vehicles(dictionary: dictionary)
//                    if let model = vehicleMethod.vehicleModel {
//                        self.vehicleButton.setTitle(model, for: .normal)
//                        self.vehicleButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
//                        self.currentVehicleMethod = vehicleMethod
//                        addStepController.currentVehicleMethod = vehicleMethod
//                    }
//                }
//            })
//        }
//    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func closeBackground() {
        UIView.animate(withDuration: animationOut) {
            tabDimmingView.alpha = 0
        }
    }
    
}


// Handle timing and information
extension ConfirmViewController {
    
    func changeDates() {
        let fromDate = bookingFromDate
        let toDate = bookingToDate
        
        let formatter = DateFormatter()
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        if fromDate.isInSameDay(date: toDate) {
            if fromDate.isInToday {
                formatter.dateFormat = "h:mma"
                let fromString = formatter.string(from: fromDate)
                let toString = formatter.string(from: toDate)
                let overallString = "\(fromString) to \(toString)"
                durationButton.setTitle(overallString, for: .normal)
            } else if fromDate.isInTomorrow {
                formatter.dateFormat = "h:mma"
                let fromString = formatter.string(from: fromDate)
                let toString = formatter.string(from: toDate)
                let overallString = "Tomorrow \(fromString) to \(toString)"
                durationButton.setTitle(overallString, for: .normal)
            } else {
                formatter.dateFormat = "E h:mma"
                let fromString = formatter.string(from: fromDate)
                formatter.dateFormat = "h:mma"
                let toString = formatter.string(from: toDate)
                let overallString = "\(fromString) to \(toString)"
                durationButton.setTitle(overallString, for: .normal)
            }
        } else {
            formatter.dateFormat = "E h:mma"
            let fromString = formatter.string(from: fromDate)
            let toString = formatter.string(from: toDate)
            let overallString = "\(fromString) to \(toString)"
            durationButton.setTitle(overallString, for: .normal)
        }
    }
    
    func setData(price: Double, parking: ParkingSpots) {
        self.price = price
        self.parking = parking
        var hour: Double = 2.25
        if parkNow {
            hours = bookingDuration
            if let time = hours {
                hour = time
            }
            bookingFromDate = Date()
            bookingToDate = Date().addingTimeInterval(TimeInterval(hour * 3600)).round(precision: (5 * 60), rule: FloatingPointRoundingRule.up)
            self.fromDate = bookingFromDate
            self.toDate = bookingToDate
        } else {
            self.fromDate = bookingFromDate
            self.toDate = bookingToDate
            if let from = fromDate, let to = toDate {
                let hours = to.hours(from: from)
                let minutes = to.minutes(from: from)
                let total: Double = Double(hours) + Double(minutes)/60.0
                hour = total
            }
        }
        currentTotalTime = "\(hour) hours"
        changeDates()
        
        let cost = (price * hour)
        let fees = cost * 0.029 + 0.3
        let endPrice = (cost + fees).rounded(toPlaces: 2)
        self.totalCostLabel.text = String(format:"$%.02f", endPrice)
        self.couponCostLabel.text = String(format:"$%.02f", endPrice)
        
        if let secondaryType = parking.secondaryType {
            if secondaryType == "driveway" {
                let image = UIImage(named: "Residential Home Driveway")
                currentParkingImage = image
            } else if secondaryType == "parking lot" {
                let image = UIImage(named: "Parking Lot")
                currentParkingImage = image
            } else if secondaryType == "apartment" {
                let image = UIImage(named: "Apartment Parking")
                currentParkingImage = image
            } else if secondaryType == "alley" {
                let image = UIImage(named: "Alley Parking")
                currentParkingImage = image
            } else if secondaryType == "garage" {
                let image = UIImage(named: "Parking Garage")
                currentParkingImage = image
            } else if secondaryType == "gated spot" {
                let image = UIImage(named: "Gated Spot")
                currentParkingImage = image
            } else if secondaryType == "street spot" {
                let image = UIImage(named: "Street Parking")
                currentParkingImage = image
            } else if secondaryType == "underground spot" {
                let image = UIImage(named: "UnderGround Parking")
                currentParkingImage = image
            } else if secondaryType == "condo" {
                let image = UIImage(named: "Residential Home Driveway")
                currentParkingImage = image
            } else if secondaryType == "circular" {
                let image = UIImage(named: "Other Parking")
                currentParkingImage = image
            }
        }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if (dictionary["CurrentCoupon"] as? [String: Any]) != nil {
                    ref.child("CurrentCoupon").observe(.childAdded) { (snapshot) in
                        if let dictionary = snapshot.value as? Int {
                            self.discount = dictionary
                            let discountedCost = endPrice - Double(dictionary)/100 * endPrice
                            self.totalCostLabel.text = String(format:"$%.02f", discountedCost)
                            if discountedCost <= 0 { self.mainButtonUnavailable() } else { self.mainButtonAvailable()}
                            UIView.animate(withDuration: animationIn, animations: {
                                self.couponCostLabel.alpha = 1
                                self.saleIcon.alpha = 1
                                self.view.layoutIfNeeded()
                            })
                        } else {
                            self.totalCostLabel.text = String(format:"$%.02f", endPrice)
                            if endPrice <= 0 { self.mainButtonUnavailable() } else { self.mainButtonAvailable()}
                            UIView.animate(withDuration: animationIn, animations: {
                                self.couponCostLabel.alpha = 0
                                self.saleIcon.alpha = 0
                                self.view.layoutIfNeeded()
                            })
                        }
                    }
                } else {
                    self.totalCostLabel.text = String(format:"$%.02f", endPrice)
                    if endPrice <= 0 { self.mainButtonUnavailable() } else { self.mainButtonAvailable()}
                    UIView.animate(withDuration: animationIn, animations: {
                        self.couponCostLabel.alpha = 0
                        self.saleIcon.alpha = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func mainButtonAvailable() {
        mainButton.setTitleColor(Theme.WHITE, for: .normal)
        mainButton.backgroundColor = Theme.DARK_GRAY
        mainButton.isUserInteractionEnabled = true
    }
    
    func mainButtonUnavailable() {
        mainButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
        mainButton.backgroundColor = lineColor
        mainButton.isUserInteractionEnabled = false
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
}
