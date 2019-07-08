//
//  OnboardingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class OldOnboardingViewController: UIViewController {

    var delegate: handleVerificationCode?
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.9)
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH1
        label.text = "Welcome to Drivewayz!"
        
        return label
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        
        return button
    }()
    
    var nameTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.text = "Enter your full name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.PACIFIC_BLUE
        field.textColor = Theme.WHITE
        field.autocapitalizationType = .words
        field.clearButtonMode = .whileEditing
        
        return field
    }()
    
    var nameLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.8)
        
        return view
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(createNewUser), for: .touchUpInside)
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 10
        button.alpha = 0
        
        return button
    }()
    
    var hideButton: UIView = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 10
        button.alpha = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        nameTextField.delegate = self
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(viewContainer)
        viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        viewContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        viewContainer.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 120).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        viewContainer.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        backButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 24).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewContainer.addSubview(nameTextField)
        viewContainer.addSubview(nameLine)
        nameTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: nameLine.rightAnchor, constant: -4).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLine.leftAnchor, constant: 4).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLine.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        nameLine.widthAnchor.constraint(equalToConstant: 311).isActive = true
        nameLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        createToolbar()
    }
    
    @objc func createNewUser() {
        self.nameTextField.endEditing(true)
        if let name = self.nameTextField.text, name != "" || name != "Enter your full name" {
            self.delegate?.createNewUser(name: name)
        }
    }
    
    func selectFirstField() {
        UIView.animate(withDuration: animationIn) {
            self.viewContainer.alpha = 1
        }
    }
    
    @objc func backToMain() {
        self.view.endEditing(true)
        self.delegate?.bringBackVerification()
        UIView.animate(withDuration: animationOut) {
            self.viewContainer.alpha = 0
        }
    }
    
    func createToolbar() {
        
        self.view.addSubview(nextButton)
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.topAnchor.constraint(equalTo: nameLine.bottomAnchor, constant: 72).isActive = true
        nextButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        nextButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        
        self.view.addSubview(hideButton)
        hideButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hideButton.topAnchor.constraint(equalTo: nameLine.bottomAnchor, constant: 72).isActive = true
        hideButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        hideButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.viewContainer.endEditing(true)
    }

}


extension OldOnboardingViewController: UITextFieldDelegate {
    
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
                    self.hideButton.alpha = 0
                    self.nextButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: animationIn) {
                    self.hideButton.alpha = 1
                    self.nextButton.alpha = 0
                }
            }
        }
        return true
    }
    
}