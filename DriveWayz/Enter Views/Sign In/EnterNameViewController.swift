//
//  EnterNameViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EnterNameViewController: UIViewController {

    var uid: String?
    var phoneNumber: String?
    
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
        label.text = "Please enter your"
        
        return label
    }()
    
    var mobileNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Full Name"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH4
        label.text = "Your full name is required for verification purposes. Your first name will be visible to hosts when you book their parking space."
        label.numberOfLines = 4
        
        return label
    }()
    
    var nameTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = Theme.OFF_WHITE
        field.font = Fonts.SSPSemiBoldH2
        field.placeholder = "First Last"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.BLUE
        field.textColor = Theme.BLACK
        field.layer.cornerRadius = 4
        field.autocapitalizationType = .words
        field.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        field.keyboardAppearance = .dark
        
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
        button.addTarget(self, action: #selector(moveToTerms), for: .touchUpInside)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        nameTextField.delegate = self
        
        setupLabels()
        setupTextfield()
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
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
        
        self.view.addSubview(mobileNumberLabel)
        mobileNumberLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        mobileNumberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mobileNumberLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mobileNumberLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mobileNumberLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func setupTextfield() {
        
        self.view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nameTextField.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 48).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(mainButton)
        mainButton.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        mainButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 36).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(deleteButton)
        deleteButton.rightAnchor.constraint(equalTo: nameTextField.rightAnchor, constant: -12).isActive = true
        deleteButton.topAnchor.constraint(equalTo: nameTextField.topAnchor, constant: 12).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -12).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    @objc func moveToTerms() {
        if let name = self.nameTextField.text, name != "" || name != "Enter your full name" {
            self.nameTextField.endEditing(true)
            let controller = AcceptTermsViewController()
            self.addChild(controller)
            controller.uid = self.uid
            controller.name = name
            controller.phoneNumber = self.phoneNumber
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func deletePressed() {
        self.nameTextField.text = ""
        self.mainButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationIn) {
            self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
            self.deleteButton.alpha = 0
        }
    }

    func moveToLocationServices() {
        let controller = LocationServicesViewController()
        self.addChild(controller)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension EnterNameViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            if textField.text == "" {
                textField.text = "Enter your full name"
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.nameTextField.text == "Enter your full name" {
            self.nameTextField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            if (nameTextField.text?.contains(" "))! {
                UIView.animate(withDuration: animationIn) {
                    self.mainButton.isUserInteractionEnabled = true
                    self.mainButton.backgroundColor = Theme.BLUE
                }
            } else {
                UIView.animate(withDuration: animationIn) {
                    self.mainButton.isUserInteractionEnabled = false
                    self.mainButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
                }
            }
        }
        return true
    }
    
    @objc func backButtonPressed() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        nameTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
