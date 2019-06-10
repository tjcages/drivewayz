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

    var delegate: handlePhoneNumberVerification?
    
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
        label.text = "Generate Lorem Ipsum placeholder text for use in your graphic, print."
        label.numberOfLines = 2
        
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
        button.addTarget(self, action: #selector(createNewUser), for: .touchUpInside)
        
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
    
    @objc func createNewUser() {
        self.nameTextField.endEditing(true)
        if let name = self.nameTextField.text, name != "" || name != "Enter your full name" {
            self.delegate?.createNewUser(name: name)
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
    
}
