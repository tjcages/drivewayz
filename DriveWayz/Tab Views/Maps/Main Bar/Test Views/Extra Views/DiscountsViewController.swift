//
//  DiscountsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

enum DiscountOptions {
    case share
    case code
    case host
    case help
}

class DiscountsViewController: UIViewController {
    
    var delegate: moveControllers?
    let dynamicLink = URL(string: "http://bit.ly/drivewayz")
    var couponCodes: [String: Any] = [:]
    
    var discountOption: DiscountOptions = .code {
        didSet {
            switch self.discountOption {
            case .share:
                handleShare()
            case .code:
                handleCode()
            case .host:
                handleHost()
            case .help:
                return
            }
        }
    }
    
    var graphicImage: UIImage? {
        didSet {
            if let image = self.graphicImage {
                let newImage = resizeImage(image: image, targetSize: CGSize(width: 400, height: 400))
                mainGraphic.image = newImage
            }
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = phoneHeight
        controller.setExitButton()
        controller.backButton.alpha = 0
        controller.mainLabel.alpha = 0
        
        return controller
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH1
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var informationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("How invites work", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(informationButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Invite Friends", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPSemiBoldH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .default
        view.lineTextView?.placeholderLabel.text = "Enter code"
        view.lineTextView?.showPlaceholderLabel()
        view.lineTextView?.autocapitalizationType = .allCharacters
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        view.alpha = 0
        
        return view
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        setupViews()
        observeAvailableCoupons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: animationIn) {
            self.gradientController.backButton.alpha = 1
            self.gradientController.mainLabel.alpha = 1
        }
    }
    
    var mainButtonBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.scrollView.addSubview(mainLabel)
        gradientController.scrollView.addSubview(subLabel)
        gradientController.scrollView.addSubview(mainTextView)
        gradientController.scrollView.addSubview(informationButton)
        gradientController.scrollView.addSubview(mainGraphic)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        mainLabel.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        mainTextView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 32).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainTextView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        informationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationButton.sizeToFit()
        if mainTextView.alpha == 1 {
            informationButton.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 16).isActive = true
        } else {
            informationButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 16).isActive = true
        }
        
        mainGraphic.topAnchor.constraint(equalTo: informationButton.bottomAnchor, constant: 32).isActive = true
        mainGraphic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 32).isActive = true
        mainGraphic.widthAnchor.constraint(equalToConstant: 200).isActive = true
        mainGraphic.heightAnchor.constraint(equalTo: mainGraphic.widthAnchor).isActive = true
        
        view.addSubview(buttonView)
        view.addSubview(mainButton)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainButtonBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48)
            mainButtonBottomAnchor.isActive = true
        
        buttonView.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func handleShare() {
        gradientController.setMainLabel(text: "Invite")
        mainLabel.text = "Help others \nPark Smarter too"
        subLabel.text = "Earn 25% off your next park when you refer a friend to try Drivewayz."
        informationButton.setTitle("How invites work", for: .normal)
        mainButton.setTitle("Invite Friends", for: .normal)
        mainTextView.alpha = 0
    }
    
    func handleCode() {
        gradientController.setMainLabel(text: "Discounts")
        mainLabel.text = "Get rewards and \ndiscounts"
        subLabel.text = "Enter your coupon code to save money the next time you park!"
        informationButton.setTitle("How coupons work", for: .normal)
        mainButton.setTitle("Apply Code", for: .normal)
        mainTextView.alpha = 1
    }
    
    func handleHost() {
        
    }
    
    @objc func informationButtonPressed() {
        let controller = DiscountsHelpView()
        controller.discountOption = discountOption
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func mainButtonPressed() {
        switch discountOption {
        case .share:
            shareButtonPressed()
        case .code:
            codeButtonPressed()
        case .host:
            hostButtonPressed()
        case .help:
            return 
        }
    }
    
    func shareButtonPressed() {
        if let url = dynamicLink {
            let promoText = "Check out Drivewayz the parking rental app!"
            let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
            
            delayWithSeconds(4) {
                guard let currentUser = Auth.auth().currentUser?.uid else {return}
                let ref = Database.database().reference().child("users").child(currentUser)
                ref.child("Coupons").observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        if (dictionary["INVITE25"] as? String) != nil {
                            let alert = UIAlertController(title: "Sorry", message: "You can only get one 25% off coupon for sharing.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            return
                        } else {
                            ref.child("Coupons").updateChildValues(["INVITE25": "25% off coupon!"])
                            ref.child("CurrentCoupon").updateChildValues(["invite": 25])
                            let alert = UIAlertController(title: "Thanks for sharing!", message: "You have successfully invited your friend and recieved a 25% off coupon for your next rental.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    } else {
                        ref.child("Coupons").updateChildValues(["INVITE25": "25% off coupon!"])
                        ref.child("CurrentCoupon").updateChildValues(["invite": 25])
                        let alert = UIAlertController(title: "Thanks for sharing!", message: "You have successfully invited your friend and recieved a 25% off coupon for your next rental.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func codeButtonPressed() {
        guard let code = mainTextView.lineTextView?.text?.uppercased().replacingOccurrences(of: " ", with: "") else { return }
        self.compareCouponCode(code: code)
    }
    
    func hostButtonPressed() {
        
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            mainButtonBottomAnchor.constant = -48
            gradientController.scrollView.setContentOffset(.zero, animated: true)
        } else {
            mainButtonBottomAnchor.constant = -keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 8
            gradientController.scrollView.scrollToView(view: mainTextView, animated: true, offset: 16)
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonPressed() {
        UIView.animate(withDuration: animationIn) {
            tabDimmingView.alpha = 0
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// Handle coupons
extension DiscountsViewController {
    
    func observeAvailableCoupons() {
        let ref = Database.database().reference().child("AvailableCoupons")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.couponCodes = dictionary
            }
        }
    }
    
    private func compareCouponCode(code: String) {
        if let value = self.couponCodes[code] as? String {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    if let dictionary = dictionary["Coupons"] as? [String: Any] {
                        if (dictionary[code] as? String) != nil {
                            self.sendAlert(title: "Already redeemed", message: "Looks like you've already redeemed this coupon code.")
                        } else {
                            self.updateUserCoupons(code: code, value: value)
                        }
                    } else {
                        self.updateUserCoupons(code: code, value: value)
                    }
                }
            }
        } else {
            sendAlert(title: "Wrong code", message: "This doesn't look like a correct coupon code.")
            mainTextView.clearCommentTextField()
        }
    }
    
    func updateUserCoupons(code: String, value: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.child("Coupons").updateChildValues([code: value])
        let couponArray = value.split(separator: " ")
        let amount: String = String(couponArray[0].replacingOccurrences(of: "%", with: ""))
        if let percent = Int(amount) {
            ref.child("CurrentCoupon").updateChildValues(["coupon": percent])
            sendAlert(title: "Success!", message: "You have redeemed this coupon and it will be applied to your next purchase.")
            mainTextView.clearCommentTextField()
        } else {
            var dollars: Int = 0
            if amount == "Five" {
                dollars = 5
            } else if amount == "Ten" {
                dollars = 10
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    if let userFunds = dictionary["userFunds"] as? Double {
                        let newFunds = userFunds + Double(dollars)
                        ref.updateChildValues(["userFunds": newFunds])
                    } else {
                        ref.updateChildValues(["userFunds": dollars])
                    }
                    self.sendAlert(title: "Success!", message: "Your account has been credited $\(dollars) for becoming a host.")
                    self.mainTextView.clearCommentTextField()
                    self.view.endEditing(true)
                }
            })
        }
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
