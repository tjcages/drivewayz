//
//  MobileNumberViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol handlePhoneNumberVerification {
    func moveToMainController()
    func moveToOnboarding()
    func moveToLocationServices()
    func createNewUser(name: String)
}

class MobileNumberViewController: UIViewController, handlePhoneNumberVerification {
    
    var delegate: handleOnboardingControllers?
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH2
        label.text = "Get started with your"
        
        return label
    }()
    
    var mobileNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Mobile Number"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH4
        label.text = "Drivewayz will send you a verification code via SMS"
        label.numberOfLines = 2
        
        return label
    }()

    var areaCodeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.text = " +1"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var areaCodeButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "USA")
        button.setImage(origImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        button.imageEdgeInsets = UIEdgeInsets(top: -8, left: -1, bottom: -8, right: -1)
        button.clipsToBounds = true
        
        return button
    }()
    
    var phoneNumberTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.placeholder = "(213) 555 1234"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.BLUE
        field.textColor = Theme.BLACK
        field.keyboardType = .numberPad
        field.layer.cornerRadius = 4
        field.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
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
        button.addTarget(self, action: #selector(sendVerificationCode(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.alpha = 0
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    lazy var numberVerificationController: VerifyNumberViewController = {
        let controller = VerifyNumberViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var enterNameController: EnterNameViewController = {
        let controller = EnterNameViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var locationServicesController: LocationServicesViewController = {
        let controller = LocationServicesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        phoneNumberTextField.delegate = self

        setupLabels()
        setupAreaCode()
        setupTextfield()
        setupControllers()
    }
    
    func setupLabels() {
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 52).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
    
    func setupAreaCode() {
        
        self.view.addSubview(areaCodeView)
        areaCodeView.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        areaCodeView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 48).isActive = true
        areaCodeView.widthAnchor.constraint(equalToConstant: 86).isActive = true
        areaCodeView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        areaCodeView.addSubview(areaCodeButton)
        areaCodeButton.leftAnchor.constraint(equalTo: areaCodeView.leftAnchor, constant: 8).isActive = true
        areaCodeButton.topAnchor.constraint(equalTo: areaCodeView.topAnchor, constant: 16).isActive = true
        areaCodeButton.bottomAnchor.constraint(equalTo: areaCodeView.bottomAnchor, constant: -16).isActive = true
        areaCodeButton.widthAnchor.constraint(equalTo: areaCodeButton.heightAnchor, multiplier: 1.2).isActive = true
        
        areaCodeView.addSubview(areaCodeLabel)
        areaCodeLabel.leftAnchor.constraint(equalTo: areaCodeButton.rightAnchor).isActive = true
        areaCodeLabel.rightAnchor.constraint(equalTo: areaCodeView.rightAnchor, constant: -4).isActive = true
        areaCodeLabel.centerYAnchor.constraint(equalTo: areaCodeView.centerYAnchor).isActive = true
        areaCodeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupTextfield() {
        
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.leftAnchor.constraint(equalTo: areaCodeView.rightAnchor, constant: 8).isActive = true
        phoneNumberTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        phoneNumberTextField.centerYAnchor.constraint(equalTo: areaCodeView.centerYAnchor).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(mainButton)
        mainButton.rightAnchor.constraint(equalTo: phoneNumberTextField.rightAnchor).isActive = true
        mainButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 36).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(deleteButton)
        deleteButton.rightAnchor.constraint(equalTo: phoneNumberTextField.rightAnchor, constant: -12).isActive = true
        deleteButton.topAnchor.constraint(equalTo: phoneNumberTextField.topAnchor, constant: 12).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: -12).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    var numberVerifyTopAnchor: NSLayoutConstraint!
    var enterNameTopAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        self.view.addSubview(numberVerificationController.view)
        numberVerificationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        numberVerificationController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        numberVerifyTopAnchor = numberVerificationController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            numberVerifyTopAnchor.isActive = true
        numberVerificationController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        self.view.addSubview(enterNameController.view)
        self.view.bringSubviewToFront(backButton)
        enterNameController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        enterNameController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        enterNameTopAnchor = enterNameController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            enterNameTopAnchor.isActive = true
        enterNameController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        self.view.addSubview(locationServicesController.view)
        locationServicesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        locationServicesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        locationServicesController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        locationServicesController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
    }
    
    @objc func mainButtonPressed() {
        self.view.endEditing(true)
        self.numberVerifyTopAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.numberVerificationController.firstVerificationField.becomeFirstResponder()
            UIView.animate(withDuration: animationIn, animations: {
                self.backButton.alpha = 1
            })
        }
    }
    
    @objc func deletePressed() {
        self.phoneNumberTextField.text = ""
        self.mainButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationIn) {
            self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
            self.deleteButton.alpha = 0
        }
    }
    
    @objc func backButtonPressed() {
        self.view.endEditing(true)
        if self.numberVerifyTopAnchor.constant == 0 {
            self.numberVerifyTopAnchor.constant = phoneHeight
            UIView.animate(withDuration: animationOut, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.numberVerificationController.firstVerificationField.text = ""
                self.numberVerificationController.secondVerificationField.text = ""
                self.numberVerificationController.thirdVerificationField.text = ""
                self.numberVerificationController.fourthVerificationField.text = ""
                self.numberVerificationController.fifthVerificationField.text = ""
                self.numberVerificationController.sixthVerificationField.text = ""
            }
        } else if self.enterNameTopAnchor.constant == 0 {
            self.enterNameTopAnchor.constant = phoneHeight
            UIView.animate(withDuration: animationOut, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.enterNameController.nameTextField.text = ""
            }
        } else {
            self.delegate?.dismissMobileNumber()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension MobileNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneNumberTextField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
            UIView.animate(withDuration: animationIn) {
                if fullString.count == 1 && string == "" {
                    self.deleteButton.alpha = 0
                } else {
                    self.deleteButton.alpha = 1
                }
                if fullString.count == 14 && string != "" {
                    self.mainButton.isUserInteractionEnabled = true
                    self.mainButton.backgroundColor = Theme.BLUE
                } else {
                    self.mainButton.isUserInteractionEnabled = false
                    self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
                }
            }
            return false
        } else {
            return true
        }
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        return number
    }
    
}


// SIGN IN WITH PHONE NUMBER
extension MobileNumberViewController {
    
    @objc func sendVerificationCode(sender: UIButton) {
        self.phoneNumberTextField.endEditing(true)
        guard var phoneNumber = self.phoneNumberTextField.text else { return }
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumber = "+1" + phoneNumber.replacingOccurrences(of: "-", with: "")
        self.mainButton.isUserInteractionEnabled = false
        self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
            if let error = error {
                self.mainButton.isUserInteractionEnabled = true
                UIView.animate(withDuration: animationIn) {
                    self.mainButton.backgroundColor = Theme.BLUE
                }
                print(error.localizedDescription)
                return
            }
            self.mainButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: animationIn) {
                self.mainButton.backgroundColor = Theme.BLUE
            }
            self.numberVerificationController.phoneNumber = self.phoneNumberTextField.text!
            self.numberVerificationController.verificationCode = verificationID
            self.mainButtonPressed()
        }
    }
    
    func createNewUser(name: String) {
        self.numberVerificationController.createNewUser(name: name)
    }
    
    func moveToOnboarding() {
        self.view.endEditing(true)
        self.enterNameTopAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.enterNameController.nameTextField.becomeFirstResponder()
            UIView.animate(withDuration: animationIn, animations: {
                self.backButton.alpha = 1
            })
        }
    }
    
    func moveToLocationServices() {
        self.view.endEditing(true)
        UIView.animate(withDuration: animationOut, animations: {
            self.locationServicesController.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func moveToMainController() {
        self.delegate?.moveToMainController()
    }
}
