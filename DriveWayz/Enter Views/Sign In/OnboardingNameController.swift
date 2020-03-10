//
//  OnboardingNameController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/30/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol NameDelegate {
    func closeBackground()
    func successfulSignIn()
}

class OnboardingNameController: UIViewController, NameDelegate {
    
    var delegate: VerifyDelegate?
    
    var uid: String?
    var name: String?
    var phoneNumber: String?

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
        label.text = "What's your name?"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH25
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var firstNameField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.font = Fonts.SSPRegularH2
        view.textColor = Theme.BLACK
        view.keyboardAppearance = .dark
        view.delegate = self
        view.placeholder = "First"
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
    }()
    
    lazy var lastNameField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.font = Fonts.SSPRegularH2
        view.textColor = Theme.BLACK
        view.placeholder = "Last"
        view.keyboardAppearance = .dark
        view.delegate = self
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
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
        button.addTarget(self, action: #selector(createNewUser), for: .touchUpInside)
        
        return button
    }()
    
    var underline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var informationLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.isSelectable = false
        let string = "By continuing, you agree to our \nTerms of Service and Privacy Policy."
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let privacyRange = (string as NSString).range(of: "Privacy Policy")
        let termsRange = (string as NSString).range(of: "Terms of Service")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH4, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: termsRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: termsRange)
        
        let privacyAttribute = [NSAttributedString.Key.myAttributeName: "Privacy Policy", NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        attributedString.addAttributes(privacyAttribute, range: privacyRange)
        let termsAttribute = [NSAttributedString.Key.myAttributeName: "Terms of Service", NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        attributedString.addAttributes(termsAttribute, range: termsRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        label.backgroundColor = .clear
        label.alpha = 0
        
        return label
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
        
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        mainTap.delegate = self
        informationLabel.addGestureRecognizer(mainTap)
        
        setupViews()
        setupNameField()
        setupNext()
        
        createToolbar()
        createToolbar2()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.backButton.alpha = 1
        }) { (success) in
            self.firstNameField.becomeFirstResponder()
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
        mainLabel.sizeToFit()
        
    }
    
    func setupNameField() {
        
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        
        firstNameField.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.centerXAnchor, paddingTop: 32, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
        
        lastNameField.anchor(top: firstNameField.topAnchor, left: firstNameField.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
    }
    
    var underlineCenterAnchor: NSLayoutConstraint!
    var underlineSecondAnchor: NSLayoutConstraint!
    
    func setupNext() {
        
        view.addSubview(underline)
        underline.anchor(top: nil, left: nil, bottom: firstNameField.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        underline.widthAnchor.constraint(equalTo: firstNameField.widthAnchor).isActive = true
        underlineCenterAnchor = underline.centerXAnchor.constraint(equalTo: firstNameField.centerXAnchor)
            underlineCenterAnchor.isActive = true
        underlineSecondAnchor = underline.centerXAnchor.constraint(equalTo: lastNameField.centerXAnchor)
            underlineSecondAnchor.isActive = false
    
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
       
        view.addSubview(informationLabel)
        informationTopAnchor = informationLabel.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 64) //Text field has 8px padding on top - should be 32
            informationTopAnchor.isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
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
            self.informationTopAnchor.constant = 32
            UIView.animateOut(withDuration: animationOut, animations: {
                self.informationLabel.alpha = 1
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
                if self.firstNameField.text != "" && self.lastNameField.text != "" {
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
    
    func hideNextButton(dim: Bool, completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.BLACK
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                if dim { self.dimmingView.alpha = 0.8 } else { self.dimmingView.alpha = 0 }
                self.view.layoutIfNeeded()
            }) { (success) in
                completion()
            }
        }
    }
    
    @objc func nextButtonPressed() {
        let controller = OnboardingLocationServices()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func login() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                nextButtonPressed()
            case .authorizedAlways, .authorizedWhenInUse:
                successfulSignIn()
            default:
                print("Verify Number Failed to login")
            }
        } else {
            nextButtonPressed()
        }
    }
    
    @objc func createNewUser() {
        let name = "\(firstNameField.text ?? "") \(lastNameField.text ?? "")"
        self.name = name
        if let userID = self.uid {
            nextButton.isEnabled = false
            let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
            let usersReference = ref.child("users").child(userID)
            var values = ["name": name,
                          "id": userID,
                          "DeviceID": AppDelegate.DEVICEID]
            if let number = self.phoneNumber {
                values["phone"] = number
            }
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                self.nextButton.isEnabled = true
                if let error = err {
                    print(error.localizedDescription as Any)
                    self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.synchronize()
                
                self.hideNextButton(dim: true) {
                    self.view.endEditing(true)
                    self.login()
                }
            })
        }
    }

    func successfulSignIn() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 1
        }) { (success) in
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            let controller = LaunchMainController()
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonPressed() {
        view.endEditing(true)
        delegate?.showNextButton()
        navigationController?.popViewController(animated: true)
    }
    
    func closeBackground() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0
        }) { (success) in
            self.showNextButton()
        }
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.showNextButton()
        }))
        present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension OnboardingNameController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underline.alpha = 0
        underline.isHidden = false
        if textField == firstNameField {
            underlineCenterAnchor.isActive = true
            underlineSecondAnchor.isActive = false
        } else if textField == lastNameField {
            underlineCenterAnchor.isActive = false
            underlineSecondAnchor.isActive = true
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
        if let first = firstNameField.text, let last = lastNameField.text {
            if first.count > 0 && last.count > 0 {
                self.nextButton.isUserInteractionEnabled = true
                self.nextButton.backgroundColor = Theme.BLACK
                self.nextButton.tintColor = Theme.WHITE
            } else {
                self.nextButton.isUserInteractionEnabled = false
                self.nextButton.backgroundColor = Theme.GRAY_WHITE_3
                self.nextButton.tintColor = Theme.BLACK
            }
        }
        if string == " " && firstNameField.isFirstResponder {
            lastNameField.becomeFirstResponder()
            return false
        }
        return true
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
        } else {
            nextButtonBottomAnchor.isActive = false
            nextButtonKeyboardAnchor.isActive = true
            nextButtonKeyboardAnchor.constant = -height - 16
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func toLastName() {
        lastNameField.becomeFirstResponder()
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toLastName))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        firstNameField.inputAccessoryView = toolBar
    }
    
    func createToolbar2() {
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
        
        lastNameField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension OnboardingNameController: UIGestureRecognizerDelegate {
    
    @objc func textViewMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            // check if the tap location has a certain attribute
            let attributeName = NSAttributedString.Key.myAttributeName
            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let value = attributeValue as? String {
                sender.view?.isUserInteractionEnabled = false
                if value == "Privacy Policy" {
                    moveToPrivacy()
                } else if value == "Terms of Service" {
                    moveToTerms()
                }
                delayWithSeconds(1) {
                    sender.view?.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func moveToTerms() {
        hideNextButton(dim: false) {
            self.view.endEditing(true)
            let controller = ReadPoliciesViewController()
            controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func moveToPrivacy() {
        hideNextButton(dim: false) {
            self.view.endEditing(true)
            let controller = ReadPoliciesViewController()
            controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
