//
//  NewBankViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NewBankViewController: UIViewController {
    
    var delegate: handlePayoutOptions?
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivewayz uses Stripe to link your bank"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var iconController: BankIconsViewController = {
        let controller = BankIconsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var secureController: BankSecureViewController = {
        let controller = BankSecureViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var namesController: BankNamesViewController = {
        let controller = BankNamesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var locationController: BankLocationViewController = {
        let controller = BankLocationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var dobController: BankDOBViewController = {
        let controller = BankDOBViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var ssnController: BankSSNViewController = {
        let controller = BankSSNViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    lazy var routingController: BankRoutingViewController = {
        let controller = BankRoutingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE

        setupViews()
        retriveInfo()
    }
    
    var confirmLeftAnchor: NSLayoutConstraint!
    
    var nameCenterAnchor: NSLayoutConstraint!
    var locationCenterAnchor: NSLayoutConstraint!
    var dobCenterAnchor: NSLayoutConstraint!
    var ssnCenterAnchor: NSLayoutConstraint!
    var routingCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {

        self.view.addSubview(iconController.view)
        iconController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight + 60).isActive = true
        iconController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        iconController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        iconController.view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        mainLabel.sizeToFit()
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 8).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 32).isActive = true
        }
        
        self.view.addSubview(secureController.view)
        secureController.view.leftAnchor.constraint(equalTo: iconController.phoneIcon.leftAnchor, constant: 0).isActive = true
        secureController.view.rightAnchor.constraint(equalTo: iconController.bankIcon.rightAnchor, constant: 12).isActive = true
        secureController.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        switch device {
        case .iphone8:
            secureController.view.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 86).isActive = true
        case .iphoneX:
            secureController.view.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 110).isActive = true
        }
        
        self.view.addSubview(dismissButton)
        dismissButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            dismissButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            dismissButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        setupButtons()
       
        self.view.addSubview(namesController.view)
        namesController.view.topAnchor.constraint(equalTo: secureController.view.topAnchor).isActive = true
        nameCenterAnchor = namesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: phoneWidth)
            nameCenterAnchor.isActive = true
        namesController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        namesController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12).isActive = true
        
        self.view.addSubview(locationController.view)
        locationController.view.topAnchor.constraint(equalTo: secureController.view.topAnchor).isActive = true
        locationCenterAnchor = locationController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: phoneWidth)
            locationCenterAnchor.isActive = true
        locationController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        locationController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12).isActive = true
        
        self.view.addSubview(dobController.view)
        dobController.view.topAnchor.constraint(equalTo: secureController.view.topAnchor).isActive = true
        dobCenterAnchor = dobController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: phoneWidth)
            dobCenterAnchor.isActive = true
        dobController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        dobController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12).isActive = true
        
        self.view.addSubview(ssnController.view)
        ssnController.view.topAnchor.constraint(equalTo: secureController.view.topAnchor).isActive = true
        ssnCenterAnchor = ssnController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: phoneWidth)
            ssnCenterAnchor.isActive = true
        ssnController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        ssnController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12).isActive = true
        
        self.view.addSubview(routingController.view)
        routingController.view.topAnchor.constraint(equalTo: secureController.view.topAnchor).isActive = true
        routingCenterAnchor = routingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: phoneWidth)
            routingCenterAnchor.isActive = true
        routingController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        routingController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12).isActive = true
        
    }
    
    func setupButtons() {
        
        self.view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: secureController.view.bottomAnchor, constant: 12).isActive = true
        confirmLeftAnchor = nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            confirmLeftAnchor.isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -(self.view.frame.width/3.5)).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func retriveInfo() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let email = dictionary["email"] as? String {
                    self.namesController.emailTextField.text = email
                }
                if let fullName = dictionary["name"] as? String {
                    let fullNameArr = fullName.split(separator: " ")
                    if let firstName = fullNameArr.first {
                        self.namesController.nameTextField.text = String(firstName)
                    }
                    if let lastName = fullNameArr.last {
                        self.namesController.lastTextField.text = String(lastName)
                    }
                }
                if let hostingSpots = dictionary["Hosting Spots"] as? [String: Any] {
                    if let parkingID = hostingSpots.values.first as? String {
                        let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Location")
                        parkingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String: Any] {
                                if let streetAddress = dictionary["streetAddress"] as? String {
                                    self.locationController.address1TextField.text = streetAddress
                                }
                                if let cityAddress = dictionary["cityAddress"] as? String {
                                    self.locationController.cityTextField.text = cityAddress
                                }
                                if let stateAddress = dictionary["stateAddress"] as? String {
                                    self.locationController.stateTextField.text = stateAddress
                                }
                                if let zipAddress = dictionary["zipAddress"] as? String {
                                    self.locationController.zipTextField.text = zipAddress
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    @objc func dismissView() {
        self.delegate?.dismissAll()
        self.dismiss(animated: true, completion: nil)
    }

}


extension NewBankViewController {
    
    func registerAccount() {
        self.routingController.loadingActivity.alpha = 1
        self.routingController.loadingActivity.startAnimating()
        self.nextButton.isUserInteractionEnabled = false
        self.nextButton.alpha = 0.5
        if let firstName = self.namesController.nameTextField.text, let lastName = self.namesController.lastTextField.text, let emailAddress = self.namesController.emailTextField.text, let addressLine1 = self.locationController.address1TextField.text, let cityAddress = self.locationController.cityTextField.text, let stateAddress = self.locationController.stateLabel.text, let zipCode = self.locationController.zipTextField.text, let ssnCode = self.ssnController.ssnTextField.text?.replacingOccurrences(of: " ", with: ""), let routingNumber = self.routingController.routingTextField.text, let accountNumber = self.routingController.accountTextField.text, let birthDay = self.dobController.dayTextField.text, let birthMonth = self.dobController.monthTextField.text, let birthYear = self.dobController.yearTextField.text {
            MyAPIClient.sharedClient.createAccountKey(routingNumber: routingNumber, accountNumber: accountNumber, addressLine1: addressLine1, addressCity: cityAddress, addressState: stateAddress, addressPostalCode: zipCode, firstName: firstName, lastName: lastName, ssnLast4: ssnCode, email: emailAddress, birthDay: birthDay, birthMonth: birthMonth, birthYear: birthYear) { (success) in
                self.routingController.loadingActivity.alpha = 0
                self.routingController.loadingActivity.stopAnimating()
                self.nextButton.isUserInteractionEnabled = true
                self.nextButton.alpha = 1
                if success == true {
                    self.moveToTransfer()
                }
            }
        } else {
            self.routingController.loadingActivity.alpha = 0
            self.routingController.loadingActivity.stopAnimating()
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.alpha = 1
        }
    }
    
    func moveToTransfer() {
        delayWithSeconds(1.5) {
            self.dismissView()
        }
    }
    
    @objc func nextPressed() {
        if self.secureController.view.alpha == 1 {
            self.iconController.expandPhone()
            self.nameCenterAnchor.constant = 0
            self.confirmLeftAnchor.constant = self.view.frame.width/6
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.secureController.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please confirm some information"
                    self.backButton.alpha = 1
                    self.nextButton.setTitle("Next", for: .normal)
                }, completion: nil)
            }
        } else if self.nameCenterAnchor.constant == 0 {
            self.nameCenterAnchor.constant = -phoneWidth
            self.locationCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please confirm some information"
                }, completion: nil)
            }
        } else if self.locationCenterAnchor.constant == 0 {
            self.locationCenterAnchor.constant = -phoneWidth
            self.dobCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please enter your \nDate of Birth"
                }, completion: nil)
            }
        } else if self.dobCenterAnchor.constant == 0 {
            self.iconController.expandBank()
            self.dobCenterAnchor.constant = -phoneWidth
            self.ssnCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please enter the last 4 of your Social Security Number"
                }, completion: nil)
            }
        } else if self.ssnCenterAnchor.constant == 0 {
            self.ssnCenterAnchor.constant = -phoneWidth
            self.routingCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please enter your account details"
                }, completion: nil)
            }
        } else if self.routingCenterAnchor.constant == 0 {
            self.registerAccount()
        }
    }
    
    @objc func backPressed() {
        self.view.endEditing(true)
        if self.nameCenterAnchor.constant == 0 {
            self.iconController.expandStripe()
            self.nameCenterAnchor.constant = phoneWidth
            self.confirmLeftAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.backButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Drivewayz uses Stripe to link your bank"
                    self.secureController.view.alpha = 1
                    self.nextButton.setTitle("Continue", for: .normal)
                }, completion: nil)
            }
        } else if self.locationCenterAnchor.constant == 0 {
            self.locationCenterAnchor.constant = phoneWidth
            self.nameCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please confirm some information"
                }, completion: nil)
            }
        } else if self.dobCenterAnchor.constant == 0 {
            self.dobCenterAnchor.constant = phoneWidth
            self.locationCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please confirm some information"
                }, completion: nil)
            }
        } else if self.ssnCenterAnchor.constant == 0 {
            self.iconController.expandPhone()
            self.ssnCenterAnchor.constant = phoneWidth
            self.dobCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please enter your \nDate of Birth"
                }, completion: nil)
            }
        } else if self.routingCenterAnchor.constant == 0 {
            self.routingCenterAnchor.constant = phoneWidth
            self.ssnCenterAnchor.constant = 0
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Please enter the last 4 of your Social Security Number"
                }, completion: nil)
            }
        }
    }
    
}
