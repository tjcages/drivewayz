//
//  ParkingCouponViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class ParkingCouponViewController: UIViewController {
    
    var couponCodes: [String: Any] = [:]
    var dynamicLink: URL?
    
    var codeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var codeTextfield: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = "Enter code"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BACKGROUND_GRAY
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "Expand")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        button.tintColor = Theme.BLACK.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: -6, left: -4, bottom: -2, right: -4)
        button.addTarget(self, action: #selector(redeemPressed), for: .touchUpInside)
        
        return button
    }()
    
    var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.2)
        label.font = Fonts.SSPRegularH4
        label.text = "or"
        label.textAlignment = .center
        
        return label
    }()
    
    var leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var inviteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Invite a friend", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 45/2
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        codeTextfield.delegate = self
        
        setupTextfield()
        setupButtons()
        observeAvailableCoupons()
        prepareDynamicLink()
    }
    
    var codeTopAnchor: NSLayoutConstraint!
    var codeBottomAnchor: NSLayoutConstraint!
    
    func setupTextfield() {
        
        self.view.addSubview(codeButton)
        codeButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        codeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        codeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        codeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(codeTextfield)
        codeTextfield.leftAnchor.constraint(equalTo: codeButton.leftAnchor, constant: 16).isActive = true
        codeTextfield.rightAnchor.constraint(equalTo: codeButton.rightAnchor, constant: -16).isActive = true
        codeTextfield.centerYAnchor.constraint(equalTo: codeButton.centerYAnchor).isActive = true
        codeTextfield.sizeToFit()
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: codeButton.rightAnchor, constant: -12).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: codeButton.centerYAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: codeButton.topAnchor, constant: 12).isActive = true
        nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor).isActive = true
        
    }
    
    func setupButtons() {
        
        self.view.addSubview(orLabel)
        orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        orLabel.topAnchor.constraint(equalTo: codeButton.bottomAnchor, constant: 20).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        orLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(leftLine)
        leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        leftLine.leftAnchor.constraint(equalTo: codeButton.leftAnchor).isActive = true
        leftLine.rightAnchor.constraint(equalTo: orLabel.leftAnchor).isActive = true
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(rightLine)
        rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        rightLine.rightAnchor.constraint(equalTo: codeButton.rightAnchor).isActive = true
        rightLine.leftAnchor.constraint(equalTo: orLabel.rightAnchor).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(inviteButton)
        inviteButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20).isActive = true
        inviteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inviteButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        inviteButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func observeAvailableCoupons() {
        let ref = Database.database().reference().child("AvailableCoupons")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.couponCodes = dictionary
            }
        }
    }
    
    @objc func redeemPressed() {
        guard let code =  codeTextfield.text?.uppercased().replacingOccurrences(of: " ", with: "") else { return }
        self.compareCouponCode(code: code)
    }
    
    private func compareCouponCode(code: String) {
        if let value = self.couponCodes[code] as? String {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    if let dictionary = dictionary["Coupons"] as? [String: Any] {
                        if (dictionary[code] as? String) != nil {
                            self.sendAlert(title: "Whoops!", message: "Looks like you've already redeemed this coupon code.")
                        } else {
                            self.updateUserCoupons(code: code, value: value)
                        }
                    } else {
                        self.updateUserCoupons(code: code, value: value)
                    }
                }
            }
        } else {
            self.sendAlert(title: "Hmmm", message: "This doesn't look like a correct coupon code.")
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
            self.sendAlert(title: "Success!", message: "You have redeemed this coupon and it will be applied to your next purchase.")
            self.codeTextfield.text = ""
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
                    self.codeTextfield.text = ""
                }
            })
        }
    }

}


extension ParkingCouponViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delayWithSeconds(0.1) {
            UIView.animate(withDuration: animationIn) {
                if textField.text != "" {
                    self.nextButton.isUserInteractionEnabled = true
                    self.nextButton.backgroundColor = Theme.BLUE
                    self.nextButton.tintColor = Theme.WHITE
                } else {
                    self.nextButton.isUserInteractionEnabled = false
                    self.nextButton.backgroundColor = Theme.BACKGROUND_GRAY
                    self.nextButton.tintColor = Theme.BLACK.withAlphaComponent(0.4)
                }
            }
        }
        return true
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}


extension ParkingCouponViewController {
    
    func prepareDynamicLink() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.drivewayz.io"
        components.path = "/invites"
        
        let idQueryItem = URLQueryItem(name: "inviteID", value: userID)
        components.queryItems = [idQueryItem]
        
        guard let linkParam = components.url else { return }
        guard let shareLink = DynamicLinkComponents.init(link: linkParam, domainURIPrefix: "https://drivewayz.page.link") else { return }
        
        if let bundleID = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        }
        shareLink.iOSParameters?.appStoreID = "1397265391"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Drivewayz on the App Store"
        shareLink.socialMetaTagParameters?.descriptionText = ""
        shareLink.socialMetaTagParameters?.imageURL = URL(fileURLWithPath: "https://scontent-lax3-1.xx.fbcdn.net/v/t1.0-9/65676636_363729731000524_5831666724327391232_o.png?_nc_cat=106&_nc_oc=AQlUvN9bk_xNcoAi7HD1sCPDqIBVBP_GBaOnLw5mOb0OU9u-jbMSg_sF8mvxAH68qbM&_nc_ht=scontent-lax3-1.xx&oh=c92befcbf0204b3943b26117b6fd8315&oe=5DBB5DD4")
        
        shareLink.shorten { (url, warnings, error) in
            if let err = error {
                print("Dynamic link unable to shorten", err.localizedDescription)
            }
            guard let url = url else { return }
            self.dynamicLink = url
        }
    }
    
}
