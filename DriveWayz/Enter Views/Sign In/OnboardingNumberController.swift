//
//  OnboardingNumberController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/29/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import FlagPhoneNumber

protocol NumberDelegate {
    func showNextButton()
}

class OnboardingNumberController: UIViewController, NumberDelegate {
    
    var delegate: OnboardingDelegate?
    var phoneNumber: String?
    var verificationCode: String?

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
        label.text = "Enter your \nphone number"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH25
        label.numberOfLines = 2
        
        return label
    }()
    
    var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var areaCodeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 2
        button.layer.borderColor = Theme.GRAY_WHITE_3.cgColor
        button.layer.borderWidth = 1
        button.alpha = 0
        button.addTarget(self, action: #selector(fpnDisplayCountryList), for: .touchUpInside)
        
        return button
    }()
    
    var areaCodeImage: UIImageView = {
        let image = UIImage(named: "USA")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var areaCodeArrow: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Expand")?.rotated(by: Measurement(value: 180, unit: .degrees))?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+1"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH2
        label.alpha = 0
        
        return label
    }()
    
    lazy var phoneNumberField: FPNTextField = {
        let view = FPNTextField()
        view.font = Fonts.SSPRegularH2
        view.placeholder = "(213) 555 1234"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.BLUE
        view.textColor = Theme.BLACK
        view.keyboardType = .numberPad
        view.keyboardAppearance = .dark
        view.alpha = 0
        view.delegate = self
        view.flagButton.isHidden = true
        view.flagButtonSize = .zero
        view.hasPhoneNumberExample = true
        view.attributedPlaceholder = NSAttributedString(string: "(213) 555 1234", attributes: [NSAttributedString.Key.foregroundColor: Theme.GRAY_WHITE_1])

        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
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
        button.imageEdgeInsets = UIEdgeInsets(top: -40, left: -40, bottom: -40, right: -40)
        button.addTarget(self, action: #selector(sendVerificationCode(sender:)), for: .touchUpInside)
        
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
        label.text = "By continuing you may receive a \nverification code via SMS."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        label.numberOfLines = 4
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setupViews()
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if nextButton.tintColor != Theme.WHITE {
            UIView.animateOut(withDuration: animationOut, animations: {
                self.backButton.alpha = 1
                self.areaCodeButton.alpha = 1
                self.areaCodeLabel.alpha = 1
                self.phoneNumberField.alpha = 1
            }) { (success) in
                self.phoneNumberField.becomeFirstResponder()
                self.showNextButton()
            }
        } else {
            phoneNumberField.becomeFirstResponder()
        }
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!
    
    var informationTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(searchView)
        view.addSubview(areaCodeButton)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        mainLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        searchView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 104, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
        areaCodeButton.anchor(top: searchView.topAnchor, left: view.leftAnchor, bottom: nil, right: searchView.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        
        areaCodeButton.addSubview(areaCodeImage)
        areaCodeButton.addSubview(areaCodeArrow)
        
        areaCodeImage.anchor(top: areaCodeButton.topAnchor, left: areaCodeButton.leftAnchor, bottom: areaCodeButton.bottomAnchor, right: areaCodeButton.rightAnchor, paddingTop: 14, paddingLeft: 10, paddingBottom: 14, paddingRight: 32, width: 0, height: 0)
        
        areaCodeArrow.centerYAnchor.constraint(equalTo: areaCodeButton.centerYAnchor).isActive = true
        areaCodeArrow.anchor(top: nil, left: nil, bottom: nil, right: areaCodeButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 20, height: 20)
        
        view.addSubview(areaCodeLabel)
        areaCodeLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        areaCodeLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 20).isActive = true
        areaCodeLabel.sizeToFit()
        
        view.addSubview(phoneNumberField)
        phoneNumberField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        phoneNumberField.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 28).isActive = true
        phoneNumberField.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -20).isActive = true
        phoneNumberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        phoneNumberField.addSubview(underline)
        underline.anchor(top: nil, left: searchView.leftAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
     
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
        view.addSubview(informationLabel)
        informationTopAnchor = informationLabel.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 64)
            informationTopAnchor.isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
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
                
                if let fullString = self.phoneNumberField.text, fullString != "" {
                    self.nextButton.isEnabled = true
                    self.nextButton.backgroundColor = Theme.BLACK
                    self.nextButton.tintColor = Theme.WHITE
                } else {
                    self.nextButton.isEnabled = false
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
    
    func nextButtonPressed() {
        let controller = OnboardingVerifyController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        
        controller.phoneNumber = phoneNumber
        if let code = verificationCode {
            controller.verificationCode = code
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func backButtonPressed() {
        view.alpha = 0
        view.endEditing(true)
        delegate?.dismissNumberController()
        modalTransitionStyle = .coverVertical
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension OnboardingNumberController {
    
    @objc func sendVerificationCode(sender: UIButton) {
        hideNextButton {
            self.view.endEditing(true)
        }
        
        guard var phoneNumber = phoneNumberField.text else { return }
        self.phoneNumber = (areaCodeLabel.text ?? "+1") + " " + phoneNumber
        
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumber = (areaCodeLabel.text ?? "+1") + phoneNumber.replacingOccurrences(of: "-", with: "")

        if let language = phoneNumberField.selectedCountry?.code {
            Auth.auth().languageCode = language.rawValue.lowercased()
        }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                return
            }
            self.verificationCode = verificationID
            self.nextButtonPressed()
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

extension OnboardingNumberController: FPNTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animateOut(withDuration: animationIn, animations: {
            self.underline.alpha = 1
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animateOut(withDuration: animationIn, animations: {
            self.underline.alpha = 0
        }, completion: nil)
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
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        phoneNumberField.inputAccessoryView = toolBar
    }
    
    // The place to present/push the listController if you choosen displayMode = .list
    @objc func fpnDisplayCountryList() {
        phoneNumberField.displayMode = .list // .picker by default
        
        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .plain)
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        listController.setup(repository: phoneNumberField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberField.setFlag(countryCode: country.code)
        }
       
        present(navigationViewController, animated: true, completion: nil)
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        if areaCodeLabel.text != dialCode {
            if let key = FPNCountryCode(rawValue: code) {
                areaCodeLabel.text = dialCode
                phoneNumberField.setFlag(countryCode: key)
                if let image = phoneNumberField.flagButton.imageView?.image {
                    areaCodeImage.image = image
                    view.layoutIfNeeded()
                }
            }
        } else { return }
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            nextButton.isEnabled = true
            nextButton.backgroundColor = Theme.BLACK
            nextButton.tintColor = Theme.WHITE
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = Theme.GRAY_WHITE_3
            nextButton.tintColor = Theme.BLACK
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
