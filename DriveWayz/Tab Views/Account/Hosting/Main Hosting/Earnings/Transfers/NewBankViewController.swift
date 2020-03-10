//
//  NewBankViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol NewBankDelegate {
    func removeDim()
}

class NewBankViewController: UIViewController {
    
    var delegate: HostEarningsDelegate?
    
    var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivewayz uses Stripe to \nlink your bank"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return button
    }()
    
    var iconController = BankIconsView()
    var secureController = BankSecureView()
    var namesController = BankNamesView()
    var ssnController = BankSSNViewController()
    var routingController = BankRoutingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }

        setupViews()
    }
    
    func setupViews() {

        view.addSubview(backButton)
        view.addSubview(iconController.view)
        
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)

        iconController.view.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20).isActive = true
        iconController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        iconController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 32).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(secureController.view)
        secureController.mainButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        secureController.view.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(dimView)
        dimView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
//    func retriveInfo() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(userID)
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//                if let email = dictionary["email"] as? String {
//                    self.namesController.emailTextField.text = email
//                }
//                if let fullName = dictionary["name"] as? String {
//                    let fullNameArr = fullName.split(separator: " ")
//                    if let firstName = fullNameArr.first {
//                        self.namesController.nameTextField.text = String(firstName)
//                    }
//                    if let lastName = fullNameArr.last {
//                        self.namesController.lastTextField.text = String(lastName)
//                    }
//                }
//                if let hostingSpots = dictionary["Hosting Spots"] as? [String: Any] {
//                    if let parkingID = hostingSpots.values.first as? String {
//                        let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Location")
//                        parkingRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                            if let dictionary = snapshot.value as? [String: Any] {
//                                if let streetAddress = dictionary["streetAddress"] as? String {
//                                    self.locationController.address1TextField.text = streetAddress
//                                }
//                                if let cityAddress = dictionary["cityAddress"] as? String {
//                                    self.locationController.cityTextField.text = cityAddress
//                                }
//                                if let stateAddress = dictionary["stateAddress"] as? String {
//                                    self.locationController.stateTextField.text = stateAddress
//                                }
//                                if let zipAddress = dictionary["zipAddress"] as? String {
//                                    self.locationController.zipTextField.text = zipAddress
//                                }
//                            }
//                        })
//                    }
//                }
//            }
//        }
//    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
        delegate?.removeDim()
    }

}

extension NewBankViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismissController()
    }
}


extension NewBankViewController: NewBankDelegate {
    
    @objc func mainButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimView.alpha = 0.7
        }) { (success) in
            self.namesController.delegate = self
            self.namesController.presentationController?.delegate = self.namesController
            self.present(self.namesController, animated: true, completion: nil)
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationOut) {
            self.dimView.alpha = 0
        }
    }
    
//    func registerAccount() {
//        self.routingController.loadingActivity.alpha = 1
//        self.routingController.loadingActivity.startAnimating()
////        self.nextButton.isUserInteractionEnabled = false
////        self.nextButton.alpha = 0.5
//        if let firstName = self.namesController.nameTextField.text, let lastName = self.namesController.lastTextField.text, let emailAddress = self.namesController.emailTextField.text, let addressLine1 = self.locationController.address1TextField.text, let cityAddress = self.locationController.cityTextField.text, let stateAddress = self.locationController.stateLabel.text, let zipCode = self.locationController.zipTextField.text, let ssnCode = self.ssnController.ssnTextField.text?.replacingOccurrences(of: " ", with: ""), let routingNumber = self.routingController.routingTextField.text, let accountNumber = self.routingController.accountTextField.text, let birthDay = self.dobController.dayTextField.text, let birthMonth = self.dobController.monthTextField.text, let birthYear = self.dobController.yearTextField.text {
//            MyAPIClient.sharedClient.createAccountKey(routingNumber: routingNumber, accountNumber: accountNumber, addressLine1: addressLine1, addressCity: cityAddress, addressState: stateAddress, addressPostalCode: zipCode, firstName: firstName, lastName: lastName, ssnLast4: ssnCode, email: emailAddress, birthDay: birthDay, birthMonth: birthMonth, birthYear: birthYear) { (success) in
//                self.routingController.loadingActivity.alpha = 0
//                self.routingController.loadingActivity.stopAnimating()
////                self.nextButton.isUserInteractionEnabled = true
////                self.nextButton.alpha = 1
//                if success == true {
//                    self.moveToTransfer()
//                }
//            }
//        } else {
//            self.routingController.loadingActivity.alpha = 0
//            self.routingController.loadingActivity.stopAnimating()
////            self.nextButton.isUserInteractionEnabled = true
////            self.nextButton.alpha = 1
//        }
//    }
//
//    func moveToTransfer() {
//        delayWithSeconds(1.5) {
//            self.dismissController()
//        }
//    }
    
}
