//
//  VerifyNumberViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

protocol handleVerification {
    func createNewUser(name: String)
}

class VerifyNumberViewController: UIViewController {
    
    var delegate: handlePhoneNumberVerification?
    var phoneNumber: String?
    var uid: String?
    var verificationCode: String? {
        didSet {
            guard let number = self.phoneNumber else { return }
            let fullText = "Enter the 6-digit code sent to you at \n\(number) via SMS."
            let range = (NSString(string: fullText)).range(of: "\(number)")
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLACK , range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPSemiBoldH4 , range: range)
            self.subLabel.attributedText = attributedString
        }
    }

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH2
        label.text = "We have sent you a"
        
        return label
    }()
    
    var mobileNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Confirmation Code"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH4
        label.text = "Enter the 6-digit code sent to you at \n+1 (303) 564-4120 via SMS"
        label.numberOfLines = 2
        
        return label
    }()
    
    var firstVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 4
        
        return field
    }()
    
    var secondVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 4
        field.text = "•"
        
        return field
    }()
    
    var thirdVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 4
        field.text = "•"
        
        return field
    }()
    
    var fourthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 4
        field.text = "•"
        
        return field
    }()
    
    var fifthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 4
        field.text = "•"
        
        return field
    }()

    var sixthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.layer.cornerRadius = 4
        field.text = "•"
        
        return field
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "Expand")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addTarget(self, action: #selector(checkVerificationCode), for: .touchUpInside)
        
        return button
    }()
    
    var resendLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH4
        let fullText = "didn't receive code? Resend."
        let range = (NSString(string: fullText)).range(of: "Resend.")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE , range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE , range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1 , range: range)
        label.attributedText = attributedString
        
        return label
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        firstVerificationField.delegate = self
        secondVerificationField.delegate = self
        thirdVerificationField.delegate = self
        fourthVerificationField.delegate = self
        fifthVerificationField.delegate = self
        sixthVerificationField.delegate = self
        
        setupLabels()
        setupVerificationField()
        setupButton()
    }
    
    func setupLabels() {

        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 132).isActive = true
        }
        
        self.view.addSubview(mobileNumberLabel)
        mobileNumberLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        mobileNumberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mobileNumberLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mobileNumberLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mobileNumberLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func setupVerificationField() {
        
        let width = (phoneWidth - 88)/6
        
        self.view.addSubview(firstVerificationField)
        firstVerificationField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        firstVerificationField.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 48).isActive = true
        firstVerificationField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        firstVerificationField.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.view.addSubview(secondVerificationField)
        secondVerificationField.leftAnchor.constraint(equalTo: firstVerificationField.rightAnchor, constant: 8).isActive = true
        secondVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        secondVerificationField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        secondVerificationField.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.view.addSubview(thirdVerificationField)
        thirdVerificationField.leftAnchor.constraint(equalTo: secondVerificationField.rightAnchor, constant: 8).isActive = true
        thirdVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        thirdVerificationField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        thirdVerificationField.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.view.addSubview(fourthVerificationField)
        fourthVerificationField.leftAnchor.constraint(equalTo: thirdVerificationField.rightAnchor, constant: 8).isActive = true
        fourthVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        fourthVerificationField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        fourthVerificationField.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.view.addSubview(fifthVerificationField)
        fifthVerificationField.leftAnchor.constraint(equalTo: fourthVerificationField.rightAnchor, constant: 8).isActive = true
        fifthVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        fifthVerificationField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        fifthVerificationField.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        self.view.addSubview(sixthVerificationField)
        sixthVerificationField.leftAnchor.constraint(equalTo: fifthVerificationField.rightAnchor, constant: 8).isActive = true
        sixthVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        sixthVerificationField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        sixthVerificationField.widthAnchor.constraint(equalToConstant: width).isActive = true
        
    }
    
    func setupButton() {
        
        self.view.addSubview(resendLabel)
        resendLabel.leftAnchor.constraint(equalTo: firstVerificationField.leftAnchor).isActive = true
        resendLabel.rightAnchor.constraint(equalTo: sixthVerificationField.rightAnchor).isActive = true
        resendLabel.topAnchor.constraint(equalTo: firstVerificationField.bottomAnchor, constant: 16).isActive = true
        resendLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(mainButton)
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainButton.topAnchor.constraint(equalTo: sixthVerificationField.bottomAnchor, constant: 36).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    @objc func checkVerificationCode() {
        if let first = self.firstVerificationField.text, let second = self.secondVerificationField.text, let third = self.thirdVerificationField.text, let fourth = self.fourthVerificationField.text, let fifth = self.fifthVerificationField.text, let sixth = self.sixthVerificationField.text {
            if first != " " && second != " " && third != " " && fourth != " " && fifth != " " && sixth != " " {
                let verification = first + second + third + fourth + fifth + sixth
                self.registerWithPhoneNumber(verification: verification)
                self.view.endEditing(true)
            }
        }
    }

}


extension VerifyNumberViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = Theme.WHITE
        textField.layer.borderColor = Theme.BLUE.cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = Theme.OFF_WHITE
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        UIView.animate(withDuration: animationIn) {
            if string == "" {
                textField.text = "•"
                textField.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
                if textField == self.secondVerificationField {
                    self.firstVerificationField.text = "•"
                    self.firstVerificationField.becomeFirstResponder()
                } else if textField == self.thirdVerificationField {
                    self.secondVerificationField.text = "•"
                    self.secondVerificationField.becomeFirstResponder()
                } else if textField == self.fourthVerificationField {
                    self.thirdVerificationField.text = "•"
                    self.thirdVerificationField.becomeFirstResponder()
                } else if textField == self.fifthVerificationField {
                    self.fourthVerificationField.text = "•"
                    self.fourthVerificationField.becomeFirstResponder()
                } else if textField == self.sixthVerificationField {
                    self.fifthVerificationField.text = "•"
                    self.fifthVerificationField.becomeFirstResponder()
                    self.mainButton.isUserInteractionEnabled = false
                    self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
//                    self.checkVerificationCode()/////////////
                }
            } else {
                textField.text = string
                textField.textColor = Theme.BLACK
                if textField == self.firstVerificationField {
                    self.secondVerificationField.becomeFirstResponder()
                } else if textField == self.secondVerificationField {
                    self.thirdVerificationField.becomeFirstResponder()
                } else if textField == self.thirdVerificationField {
                    self.fourthVerificationField.becomeFirstResponder()
                } else if textField == self.fourthVerificationField {
                    self.fifthVerificationField.becomeFirstResponder()
                } else if textField == self.fifthVerificationField {
                    self.sixthVerificationField.becomeFirstResponder()
                } else if textField == self.sixthVerificationField {
                    self.sixthVerificationField.endEditing(true)
                    self.mainButton.isUserInteractionEnabled = true
                    self.mainButton.backgroundColor = Theme.BLUE
//                    self.checkVerificationCode()/////
                }
            }
        }
        
        return false
    }
    
}


extension VerifyNumberViewController: handleVerification {
    
    func registerWithPhoneNumber(verification: String) {
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
        if let verificationID = self.verificationCode {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verification)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    self.createAlert(title: "Error", message: error.localizedDescription)
                    self.loadingActivity.alpha = 0
                    self.loadingActivity.stopAnimating()
                    print(error.localizedDescription)
                    return
                }
                guard let userID = authResult?.user.uid else { return }
                self.uid = userID
                let ref = Database.database().reference().child("users").child(userID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if (snapshot.value as? [String:AnyObject]) != nil {
                        self.login(uid: userID)
                    } else {
                        self.delegate?.moveToOnboarding()
                        self.loadingActivity.alpha = 0
                        self.loadingActivity.stopAnimating()
                    }
                })
            }
        }
    }
        
    func login(uid: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.delegate?.moveToLocationServices()
                self.loadingActivity.alpha = 0
                self.loadingActivity.stopAnimating()
            case .authorizedAlways, .authorizedWhenInUse:
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                self.delegate?.moveToMainController()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
                    self.loadingActivity.alpha = 0
                    self.loadingActivity.stopAnimating()
                    let ref = Database.database().reference().child("users").child(uid)
                    ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
                }
            }
        } else {
            self.delegate?.moveToOnboarding()
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
        }
    }
    
    func createNewUser(name: String) {
        self.delegate?.moveToLocationServices()
        guard let userID = self.uid, let number = self.phoneNumber else { return }
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersReference = ref.child("users").child(userID)
        let values = ["name": name,
                      "phone": "+1 " + number,
                      "DeviceID": AppDelegate.DEVICEID]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }
            print("Successfully logged in!")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(name, forKey: "userName")
            UserDefaults.standard.synchronize()
        })
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}
