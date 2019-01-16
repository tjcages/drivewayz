//
//  RegisterEmailViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class RegisterEmailViewController: UIViewController {
    
    var delegate: handleConfigureProcess?
    
    var emailTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.SEA_BLUE
        field.textColor = Theme.WHITE
        field.autocapitalizationType = .none
        field.clearButtonMode = .whileEditing
        
        return field
    }()
    
    var nameLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 3
        label.text = "Register your email so Drivewayz may contact you if there are any issues with the parking space."
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(nameLine)
        nameLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameLine.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        nameLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        nameLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: nameLine.bottomAnchor, constant: 20).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        createToolbar()
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.SEA_BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.emailTextField.inputAccessoryView = toolBar
    }
    
    func startMessage() {
        self.emailTextField.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.delegate?.moveToNextController()
    }

}
