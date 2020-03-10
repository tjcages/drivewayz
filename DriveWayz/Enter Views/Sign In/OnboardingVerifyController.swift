//
//  OnboradingVerifyController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/29/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol VerifyDelegate {
    func showNextButton()
}

class OnboardingVerifyController: UIViewController, VerifyDelegate, NameDelegate {

    var delegate: NumberDelegate?

    var phoneNumber: String?
    var uid: String?
    var verificationCode: String? {
        didSet {
            guard let number = self.phoneNumber else { return }
            let fullText = "Enter the 6-digit code sent to you at \(number)"
            let range = (NSString(string: fullText)).range(of: "\(number)")
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLACK , range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPSemiBoldH25 , range: range)
            self.mainLabel.attributedText = attributedString
            
            delayWithSeconds(4) {
                if self.informationLabel.alpha == 0 {
                    self.informationTopAnchor.constant = 32
                    UIView.animate(withDuration: animationOut, animations: {
                        self.informationLabel.alpha = 1
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCount), userInfo: nil, repeats: true)
                    }
                }
            }
        }
    }
    
    var timer: Timer?
    var timeLeft = 30 {
        didSet {
            if timeLeft < 10 {
                informationLabel.text = "Resend code in 0:0\(timeLeft)"
            } else {
                informationLabel.text = "Resend code in 0:\(timeLeft)"
            }
        }
    }

    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH25
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var firstVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.LINE_GRAY
        field.font = Fonts.SSPRegularH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.keyboardAppearance = .dark
        field.delegate = self
        
        return field
    }()
    
    lazy var secondVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.LINE_GRAY
        field.font = Fonts.SSPRegularH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = "•"
        field.keyboardAppearance = .dark
        field.delegate = self
        
        return field
    }()
    
    lazy var thirdVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.LINE_GRAY
        field.font = Fonts.SSPRegularH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = "•"
        field.keyboardAppearance = .dark
        field.delegate = self
        
        return field
    }()
    
    lazy var fourthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.LINE_GRAY
        field.font = Fonts.SSPRegularH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = "•"
        field.keyboardAppearance = .dark
        field.delegate = self
        
        return field
    }()
    
    lazy var fifthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.LINE_GRAY
        field.font = Fonts.SSPRegularH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = "•"
        field.keyboardAppearance = .dark
        field.delegate = self
        
        return field
    }()

    lazy var sixthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Theme.LINE_GRAY
        field.font = Fonts.SSPRegularH2
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = "•"
        field.keyboardAppearance = .dark
        field.delegate = self
        
        return field
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE_3
        button.layer.cornerRadius = 35
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.imageEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        button.addTarget(self, action: #selector(checkVerificationCode), for: .touchUpInside)
        
        return button
    }()
    
    var underline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Resend code in 0:30"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    var resendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Resend code", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.alpha = 0
        button.addTarget(self, action: #selector(resendCodePressed), for: .touchUpInside)
        
        return button
    }()
    
    var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setupViews()
        setupVerificationField()
        setupNext()
        
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.backButton.alpha = 1
        }) { (success) in
            self.firstVerificationField.becomeFirstResponder()
            self.showNextButton()
        }
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!
    
    var informationTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        mainLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    func setupVerificationField() {
        
        view.addSubview(firstVerificationField)
        view.addSubview(secondVerificationField)
        view.addSubview(thirdVerificationField)
        view.addSubview(fourthVerificationField)
        view.addSubview(fifthVerificationField)
        view.addSubview(sixthVerificationField)
        
        firstVerificationField.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 50)
        
        secondVerificationField.anchor(top: firstVerificationField.topAnchor, left: firstVerificationField.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 45, height: 50)
        
        thirdVerificationField.anchor(top: firstVerificationField.topAnchor, left: secondVerificationField.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 45, height: 50)
        
        fourthVerificationField.anchor(top: firstVerificationField.topAnchor, left: thirdVerificationField.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 45, height: 50)
        
        fifthVerificationField.anchor(top: firstVerificationField.topAnchor, left: fourthVerificationField.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 45, height: 50)
        
        sixthVerificationField.anchor(top: firstVerificationField.topAnchor, left: fifthVerificationField.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 45, height: 50)
        
    }
    
    var underlineCenterAnchor: NSLayoutConstraint!
    
    func setupNext() {
        
       view.addSubview(underline)
       underline.anchor(top: nil, left: nil, bottom: firstVerificationField.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 2)
        underlineCenterAnchor = underline.centerXAnchor.constraint(equalTo: firstVerificationField.centerXAnchor)
            underlineCenterAnchor.isActive = true
    
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
       
        view.addSubview(informationLabel)
        view.addSubview(resendButton)
        
        informationTopAnchor = informationLabel.topAnchor.constraint(equalTo: firstVerificationField.bottomAnchor, constant: 48)
            informationTopAnchor.isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        resendButton.centerYAnchor.constraint(equalTo: informationLabel.centerYAnchor).isActive = true
        resendButton.leftAnchor.constraint(equalTo: informationLabel.leftAnchor).isActive = true
        resendButton.sizeToFit()
        
        view.addSubview(dimmingView)
        dimmingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animateOut(withDuration: animationOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animateOut(withDuration: animationOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                if self.firstVerificationField.text != "" && self.secondVerificationField.text != "" && self.thirdVerificationField.text != "" && self.fourthVerificationField.text != "" && self.fifthVerificationField.text != "" && self.sixthVerificationField.text != "" {
                    self.nextButton.isUserInteractionEnabled = true
                    self.nextButton.backgroundColor = Theme.BLACK
                    self.nextButton.tintColor = Theme.WHITE
                } else {
                    self.nextButton.isUserInteractionEnabled = false
                    self.nextButton.backgroundColor = Theme.GRAY_WHITE_3
                    self.nextButton.tintColor = Theme.BLACK
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.BLACK
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                completion()
            }
        }
    }
    
    func nextButtonPressed(uid: String) {
        let controller = OnboardingNameController()
        controller.delegate = self
        controller.uid = uid
        controller.phoneNumber = self.phoneNumber
        controller.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToLocationServices() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0.8
        }) { (success) in
            self.view.endEditing(true)
            let controller = OnboardingLocationServices()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func successfulSignIn() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 1
        }) { (success) in
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            let controller = LaunchMainController()
//            controller.delegate = 
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func timerCount() {
        timeLeft -= 1

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            informationLabel.alpha = 0
            resendButton.alpha = 1
        }
    }
    
    @objc func resendCodePressed() {
        resendButton.alpha = 0
        timeLeft = 30
        
        guard let phoneNumber = phoneNumber else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                return
            }
            self.verificationCode = verificationID
        }
    }

    func closeBackground() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0
        }) { (success) in
            self.showNextButton()
        }
    }
    
    @objc func backButtonPressed() {
        view.endEditing(true)
        delegate?.showNextButton()
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension OnboardingVerifyController {
    
    @objc func checkVerificationCode() {
        if let first = firstVerificationField.text, let second = secondVerificationField.text, let third = thirdVerificationField.text, let fourth = fourthVerificationField.text, let fifth = fifthVerificationField.text, let sixth = sixthVerificationField.text {
            if first != " " && second != " " && third != " " && fourth != " " && fifth != " " && sixth != " " {
                let verification = first + second + third + fourth + fifth + sixth
                registerWithPhoneNumber(verification: verification)
                hideNextButton {
                    self.view.endEditing(true)
                }
            }
        }
    }

    func registerWithPhoneNumber(verification: String) {
        if let verificationID = self.verificationCode {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verification)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                guard let userID = authResult?.user.uid else { return }
                self.uid = userID

                let ref = Database.database().reference().child("users").child(userID)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if let name = dictionary["name"] as? String {
                            self.login(uid: userID, name: name)
                        } else {
                            self.nextButtonPressed(uid: userID)
                        }
                    } else {
                        self.nextButtonPressed(uid: userID)
                    }
                }
            }
        }
    }
        
    func login(uid: String, name: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.moveToLocationServices()
            case .authorizedAlways, .authorizedWhenInUse:
                let ref = Database.database().reference().child("users").child(uid)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.synchronize()
                
                self.successfulSignIn()
            default:
                print("Verify Number Failed to login")
            }
        } else {
            self.moveToLocationServices()
        }
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.showNextButton()
        }))
        present(alert, animated: true)
    }
    
}


extension OnboardingVerifyController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underline.alpha = 0
        underline.isHidden = false
        if textField == firstVerificationField {
            underlineCenterAnchor.constant = 0
        } else if textField == secondVerificationField {
            underlineCenterAnchor.constant = 53
        } else if textField == thirdVerificationField {
            underlineCenterAnchor.constant = 106
        } else if textField == fourthVerificationField {
            underlineCenterAnchor.constant = 159
        } else if textField == fifthVerificationField {
            underlineCenterAnchor.constant = 212
        } else if textField == sixthVerificationField {
            underlineCenterAnchor.constant = 265
        }
        view.layoutIfNeeded()
        UIView.animateOut(withDuration: animationOut, animations: {
            self.underline.alpha = 1
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.underline.alpha = 0
        }, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        underline.alpha = 0
        if string == "" {
            textField.text = "•"
            if textField == self.secondVerificationField {
                self.underlineCenterAnchor.constant = 53
                self.firstVerificationField.text = "•"
                self.firstVerificationField.becomeFirstResponder()
            } else if textField == self.thirdVerificationField {
                self.underlineCenterAnchor.constant = 106
                self.secondVerificationField.text = "•"
                self.secondVerificationField.becomeFirstResponder()
            } else if textField == self.fourthVerificationField {
                self.underlineCenterAnchor.constant = 159
                self.thirdVerificationField.text = "•"
                self.thirdVerificationField.becomeFirstResponder()
            } else if textField == self.fifthVerificationField {
                self.underlineCenterAnchor.constant = 212
                self.fourthVerificationField.text = "•"
                self.fourthVerificationField.becomeFirstResponder()
            } else if textField == self.sixthVerificationField {
                self.underlineCenterAnchor.constant = 265
                self.fifthVerificationField.text = "•"
                self.fifthVerificationField.becomeFirstResponder()
                
                self.nextButton.isUserInteractionEnabled = false
                self.nextButton.backgroundColor = Theme.GRAY_WHITE_3
                self.nextButton.tintColor = Theme.BLACK
//                    self.checkVerificationCode()/////////////
            }
        } else {
            textField.text = string
            textField.textColor = Theme.BLACK
            if textField == self.firstVerificationField {
                self.underlineCenterAnchor.constant = 53
                self.secondVerificationField.becomeFirstResponder()
            } else if textField == self.secondVerificationField {
                self.underlineCenterAnchor.constant = 106
                self.thirdVerificationField.becomeFirstResponder()
            } else if textField == self.thirdVerificationField {
                self.underlineCenterAnchor.constant = 159
                self.fourthVerificationField.becomeFirstResponder()
            } else if textField == self.fourthVerificationField {
                self.underlineCenterAnchor.constant = 212
                self.fifthVerificationField.becomeFirstResponder()
            } else if textField == self.fifthVerificationField {
                self.underlineCenterAnchor.constant = 265
                self.sixthVerificationField.becomeFirstResponder()
            } else if textField == self.sixthVerificationField {
                self.underline.isHidden = true
                self.sixthVerificationField.endEditing(true)
                
                self.nextButton.isUserInteractionEnabled = true
                self.nextButton.backgroundColor = Theme.BLACK
                self.nextButton.tintColor = Theme.WHITE

                self.checkVerificationCode()
            }
        }
        self.view.layoutIfNeeded()
        self.underline.alpha = 1
        
        return false
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let height = keyboardViewEndFrame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            nextButtonBottomAnchor.isActive = true
            nextButtonKeyboardAnchor.isActive = false
//            detailsController.spotView.switchButton.isUserInteractionEnabled = true
        } else {
            nextButtonBottomAnchor.isActive = false
            nextButtonKeyboardAnchor.isActive = true
            nextButtonKeyboardAnchor.constant = -height - 16
//            detailsController.spotView.switchButton.isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        firstVerificationField.inputAccessoryView = toolBar
        secondVerificationField.inputAccessoryView = toolBar
        thirdVerificationField.inputAccessoryView = toolBar
        fourthVerificationField.inputAccessoryView = toolBar
        fifthVerificationField.inputAccessoryView = toolBar
        sixthVerificationField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
