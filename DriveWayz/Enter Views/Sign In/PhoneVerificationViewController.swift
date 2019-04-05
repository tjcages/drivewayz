//
//  OnboardingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/20/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FacebookLogin
import FacebookCore
import SwiftyJSON

protocol handleVerificationCode {
    func bringBackPhoneNumber()
    func bringBackVerification()
    func moveToOnboarding()
    func moveToLocationServices()
    func createNewUser(name: String)
    func moveToMainController()
}

class PhoneVerificationViewController: UIViewController, handleVerificationCode {
    
    static let SSPLightHH = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    var verificationCode: String?
    var delegate: handleSignIn?
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH1
        label.text = "Smarter parking"
        
        return label
    }()
    
    var phoneNumberTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPExtraLightH2
        field.text = "Enter your mobile number"
        field.textAlignment = .right
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.PACIFIC_BLUE
        field.textColor = Theme.BLACK
        field.keyboardType = .numberPad
        
        return field
    }()
    
    var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.text = " + 1"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var USAButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "USA")
        button.setImage(origImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var phoneLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var socialAccount: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Or connect with a social network", for: .normal)
        button.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(socialAccountPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(sendVerificationCode(sender:)), for: .touchUpInside)
        button.backgroundColor = Theme.DARK_GRAY
        button.alpha = 0
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        return button
    }()
    
    var hideButton: UIView = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        button.alpha = 0
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    lazy var verificationController: VerificationCodeViewController = {
        let controller = VerificationCodeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var onboardingController: OnboardingViewController = {
        let controller = OnboardingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var locationServicesController: LocationServicesViewController = {
        let controller = LocationServicesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var facebookButton: LoginButton = {
        let button = LoginButton(readPermissions: [.publicProfile, .email])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.alpha = 0
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.delegate = self
        view.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        phoneNumberTextField.delegate = self
        
        setupViews()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        UIView.animate(withDuration: animationIn) {
            if self.phoneNumberTextField.text == "" {
                self.hideButton.alpha = 1
            }
            self.view.layoutIfNeeded()
        }
    }
    
    var viewContainerHeightAnchor: NSLayoutConstraint!
    var mainLabelTopAnchor: NSLayoutConstraint!
    var phoneNumberWidthAnchor: NSLayoutConstraint!
    var verificationCenterAnchor: NSLayoutConstraint!
    var phoneNumberCenterAnchor: NSLayoutConstraint!
    var onboardingCenterAnchor: NSLayoutConstraint!
    var locationServicesCenterAnchor: NSLayoutConstraint!
    var phoneTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(viewContainer)
        phoneNumberCenterAnchor = viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            phoneNumberCenterAnchor.isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        viewContainerHeightAnchor = viewContainer.heightAnchor.constraint(equalToConstant: 260)
            viewContainerHeightAnchor.isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabelTopAnchor = mainLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 36)
            mainLabelTopAnchor.isActive = true
        mainLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        viewContainer.addSubview(phoneLine)
        viewContainer.addSubview(phoneNumberTextField)
        viewContainer.addSubview(USAButton)
        viewContainer.addSubview(areaCodeLabel)
        
        phoneTopAnchor = phoneNumberTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 30)
            phoneTopAnchor.isActive = true
        phoneNumberTextField.rightAnchor.constraint(equalTo: phoneLine.rightAnchor, constant: -4).isActive = true
        phoneNumberTextField.leftAnchor.constraint(equalTo: areaCodeLabel.rightAnchor, constant: -10).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        USAButton.centerYAnchor.constraint(equalTo: phoneNumberTextField.centerYAnchor).isActive = true
        USAButton.leftAnchor.constraint(equalTo: phoneLine.leftAnchor, constant: 4).isActive = true
        USAButton.widthAnchor.constraint(equalToConstant: 38).isActive = true
        USAButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        areaCodeLabel.centerYAnchor.constraint(equalTo: phoneNumberTextField.centerYAnchor).isActive = true
        areaCodeLabel.leftAnchor.constraint(equalTo: USAButton.rightAnchor, constant: 4).isActive = true
        areaCodeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        areaCodeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        phoneLine.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        phoneNumberWidthAnchor = phoneLine.widthAnchor.constraint(equalToConstant: 343)
            phoneNumberWidthAnchor.isActive = true
        phoneLine.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor).isActive = true
        phoneLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        viewContainer.addSubview(socialAccount)
        socialAccount.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        socialAccount.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        socialAccount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        socialAccount.topAnchor.constraint(equalTo: phoneLine.bottomAnchor, constant: 24).isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(verificationController.view)
        verificationController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        verificationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        verificationCenterAnchor = verificationController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            verificationCenterAnchor.isActive = true
        verificationController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(onboardingController.view)
        onboardingController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        onboardingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        onboardingCenterAnchor = onboardingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        onboardingCenterAnchor.isActive = true
        onboardingController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(locationServicesController.view)
        locationServicesController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        locationServicesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        locationServicesCenterAnchor = locationServicesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        locationServicesCenterAnchor.isActive = true
        locationServicesController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        viewContainer.addSubview(facebookButton)
        facebookButton.bottomAnchor.constraint(equalTo: phoneLine.topAnchor).isActive = true
        facebookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        facebookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enterPhoneNumber(sender:)))
        phoneNumberTextField.addGestureRecognizer(tapGesture)
        
        createToolbar()
    }
    
    @objc func socialAccountPressed(sender: UIButton) {
        UIView.animate(withDuration: animationIn) {
            if self.phoneNumberTextField.alpha == 1 {
                self.socialAccount.setTitle("Login with a phone number", for: .normal)
                self.phoneLine.alpha = 0
                self.phoneNumberTextField.alpha = 0
                self.USAButton.alpha = 0
                self.areaCodeLabel.alpha = 0
                self.facebookButton.alpha = 1
            } else {
                self.socialAccount.setTitle("Or connect with a social network", for: .normal)
                self.phoneLine.alpha = 1
                self.phoneNumberTextField.alpha = 1
                self.USAButton.alpha = 1
                self.areaCodeLabel.alpha = 1
                self.facebookButton.alpha = 0
            }
        }
    }

    @objc func enterPhoneNumber(sender: UITapGestureRecognizer) {
        self.viewContainerHeightAnchor.constant = self.view.frame.height - 160
        self.mainLabelTopAnchor.constant = -60
        self.phoneTopAnchor.constant = 60
        self.phoneNumberWidthAnchor.constant = 244
        self.mainLabel.text = "Enter your mobile number"
        if self.phoneNumberTextField.text == "Enter your mobile number" {
            self.phoneNumberTextField.text = ""
        }
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.textColor = Theme.WHITE
            self.phoneNumberTextField.font = Fonts.SSPRegularH2
            self.socialAccount.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.phoneNumberTextField.becomeFirstResponder()
            UIView.animate(withDuration: animationOut, animations: {
                self.backButton.alpha = 1
            })
        }
    }
    
    @objc func backToMain() {
        self.phoneNumberTextField.endEditing(true)
        UIView.animate(withDuration: animationOut, animations: {
            self.backButton.alpha = 0
            self.hideButton.alpha = 0
            self.nextButton.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.viewContainerHeightAnchor.constant = 260
                self.mainLabelTopAnchor.constant = 36
                self.phoneNumberWidthAnchor.constant = 343
                self.phoneTopAnchor.constant = 30
                self.socialAccount.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                self.mainLabel.textColor = Theme.BLACK
                self.phoneNumberTextField.font = Fonts.SSPExtraLightH2
                self.mainLabel.text = "Smarter parking"
                self.phoneNumberTextField.text = "Enter your mobile number"
            }
        }
    }
    
    func bringBackPhoneNumber() {
        UIView.animate(withDuration: animationOut) {
            self.verificationCenterAnchor.constant = self.view.frame.width
            self.phoneNumberCenterAnchor.constant = 0
            self.nextButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func moveToOnboarding() {
        self.onboardingController.selectFirstField()
        UIView.animate(withDuration: animationIn, animations: {
            self.onboardingCenterAnchor.constant = 0
            self.verificationCenterAnchor.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func bringBackVerification() {
        UIView.animate(withDuration: animationOut) {
            self.onboardingCenterAnchor.constant = self.view.frame.width
            self.verificationCenterAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func moveToLocationServices() {
        self.onboardingController.selectFirstField()
        UIView.animate(withDuration: animationIn, animations: {
            self.locationServicesCenterAnchor.constant = 0
            self.onboardingCenterAnchor.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    
    
    func createToolbar() {
        
        self.view.addSubview(nextButton)
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.topAnchor.constraint(equalTo: phoneLine.bottomAnchor, constant: 96).isActive = true
        nextButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        nextButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        
        self.view.addSubview(hideButton)
        hideButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        hideButton.topAnchor.constraint(equalTo: phoneLine.bottomAnchor, constant: 96).isActive = true
        hideButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        hideButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.viewContainer.endEditing(true)
    }
    
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    
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
                if fullString.count == 14 {
                    self.hideButton.alpha = 0
                    self.nextButton.alpha = 1
                } else {
                    self.hideButton.alpha = 1
                    self.nextButton.alpha = 0
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
extension PhoneVerificationViewController {
    
    @objc func sendVerificationCode(sender: UIButton) {
        guard var phoneNumber = self.phoneNumberTextField.text else { return }
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumber = "+1" + phoneNumber.replacingOccurrences(of: "-", with: "")
        self.nextButton.setTitle("", for: .normal)
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            self.nextButton.setTitle("Next", for: .normal)
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
            if let error = error {
                UIView.animate(withDuration: animationIn) {
                    self.nextButton.alpha = 0
                    self.hideButton.alpha = 1
                }
                print(error.localizedDescription)
                return
            }
            self.phoneNumberTextField.endEditing(true)
            self.nextButton.isUserInteractionEnabled = true
            self.verificationController.phoneNumber = self.phoneNumberTextField.text!
            self.verificationController.verificationCode = verificationID
            UIView.animate(withDuration: animationIn, animations: {
                self.verificationCenterAnchor.constant = 0
                self.phoneNumberCenterAnchor.constant = -self.view.frame.width
                self.hideButton.alpha = 0
                self.nextButton.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.verificationController.becomeFirst()
            })
        }
    }
    
    func createNewUser(name: String) {
        self.verificationController.createNewUser(name: name)
    }
    
    func moveToMainController() {
        self.delegate?.moveToMainController()
    }
}


extension PhoneVerificationViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print(result)
        print(AccessToken.self)
        let access = AccessToken.current
        guard let accessTok = access?.authenticationToken else {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTok)
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            let userID = user?.user.uid
            GraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(1000).height(1000)"]).start { (connection, results) in
                switch results {
                case .failed(let error):
                    print(error)
                case .success(response: let graphResponse):
                    if let dictionary = graphResponse.dictionaryValue {
                        let json = JSON(dictionary)
                        let email = json["email"].string!
                        let name = json["name"].string!
                        let pictureObject = json["picture"].dictionary!
                        let pictureData = pictureObject["data"]?.dictionary!
                        let pictureUrl = pictureData!["url"]?.string!
                        
                        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
                        let usersReference = ref.child("users").child(userID!)
                        let values = ["name": name,
                                      "email": email,
                                      "picture": pictureUrl!,
                                      "DeviceID": AppDelegate.DEVICEID]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                            print("Successfully logged in!")
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            let myViewController: TabViewController = TabViewController()
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = myViewController
                            appDelegate.window?.makeKeyAndVisible()
                            
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out of Facebook")
    }
    
    
    
    
}
