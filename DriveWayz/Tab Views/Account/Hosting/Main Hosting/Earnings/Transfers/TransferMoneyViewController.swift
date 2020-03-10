//
//  TransferMoneyViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import StoreKit

class TransferMoneyViewController: UIViewController {
    
    var accountID: String?
    var userFunds: Double?
    var delegate: handlePayoutOptions?

    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm transfer amount"
        label.textColor = Theme.BLACK
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
        button.setTitle("Transfer", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    lazy var iconController: BankIconsView = {
        let controller = BankIconsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var transferController: BankTransferViewController = {
        let controller = BankTransferViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var successContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.alpha = 0
        
        return view
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.backgroundColor = Theme.GREEN
        button.imageEdgeInsets = UIEdgeInsets(top: -12, left: -12, bottom: -12, right: -12)
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 2
        button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return button
    }()
    
    var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Bank transfer initiated!"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        setupViews()
        setupButtons()
        setupSuccess()
        setupAccount()
    }
    
    var confirmLeftAnchor: NSLayoutConstraint!
    
    var nameCenterAnchor: NSLayoutConstraint!
    var locationCenterAnchor: NSLayoutConstraint!
    var ssnCenterAnchor: NSLayoutConstraint!
    var routingCenterAnchor: NSLayoutConstraint!
    var transferCenterAnchor: NSLayoutConstraint!
    
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
        
        self.view.addSubview(transferController.view)
        transferController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        transferController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        transferController.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        switch device {
        case .iphone8:
            transferController.view.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 86).isActive = true
        case .iphoneX:
            transferController.view.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 110).isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
    }
    
    func setupButtons() {
        
        self.view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: transferController.view.bottomAnchor, constant: 12).isActive = true
        confirmLeftAnchor = nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            confirmLeftAnchor.isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(dimmingView)
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        dimmingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupSuccess() {
        
        self.view.addSubview(successContainer)
        successContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        successContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        successContainer.widthAnchor.constraint(equalToConstant: phoneWidth * 3/4).isActive = true
        successContainer.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        successContainer.addSubview(checkmark)
        checkmark.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: successContainer.centerYAnchor, constant: -30).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 120).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
        successContainer.addSubview(successLabel)
        successLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        successLabel.topAnchor.constraint(equalTo: checkmark.bottomAnchor, constant: 32).isActive = true
        successLabel.sizeToFit()
        
    }
    
    func expandCheckmark() {
        UIView.animate(withDuration: animationOut, animations: {
            self.successContainer.alpha = 1
            self.checkmark.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.mainLabel.alpha = 0
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (success) in
            self.mainLabel.text = "$0.00"
            delayWithSeconds(1.4, completion: {
                UIView.animate(withDuration: animationOut) {
                    self.successContainer.alpha = 0
                    self.checkmark.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.mainLabel.alpha = 1
                    self.mainLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            })
        }
    }
    
    func setupAccount() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let userFunds = dictionary["userFunds"] as? Double {
                    self.userFunds = userFunds
                    self.transferController.mainLabel.text = String(format: "$%.2f", userFunds)
                    self.nextButton.isUserInteractionEnabled = true
                }
                if let accounts = dictionary["Accounts"] as? [String: Any] {
                    if let accountID = accounts["accountID"] as? String {
                        self.accountID = accountID
                    }
                }
            }
        }
    }
    
    @objc func nextPressed() {
        self.nextButton.isUserInteractionEnabled = false
        self.nextButton.alpha = 0.5
        if let userFunds = self.userFunds, let accountID = self.accountID {
            if userFunds >= 10.0 {
                MyAPIClient.sharedClient.transferToBank(account: accountID, funds: userFunds) { (success) in
                    if success == true {
                        if let currentUser = Auth.auth().currentUser?.uid {
                            let checkRef = Database.database().reference().child("users").child(currentUser)
                            checkRef.updateChildValues(["userFunds": 0.0])
                            let payRef = checkRef.child("Payouts").childByAutoId()
                            
                            let accountRef = Database.database().reference().child("PayoutAccounts").child(accountID)
                            accountRef.observeSingleEvent(of: .value) { (snapshot) in
                                if let dictionary = snapshot.value as? [String: Any] {
                                    if let accountNumber = dictionary["accountNumber"] as? String, let routingNumber = dictionary["routingNumber"] as? String, let accountType = dictionary["type"] as? String {
                                        payRef.updateChildValues(["timestamp": Date().timeIntervalSince1970, "transferAmount": userFunds, "accountID": accountID, "accountLabel": accountNumber, "routingLabel": routingNumber, "accountType": accountType])
                                        
                                        UIView.animate(withDuration: animationIn, animations: {
                                            self.dimmingView.alpha = 0.8
                                        }, completion: { (success) in
                                            self.expandCheckmark()
                                            delayWithSeconds(1.7, completion: {
                                                UIView.animate(withDuration: animationIn, animations: {
                                                    self.dimmingView.alpha = 0
                                                })
                                                delayWithSeconds(0.6, completion: {
                                                    let appStoreReview = UserDefaults.standard.bool(forKey: "AppStoreReview")
                                                    if appStoreReview == false {
                                                        if #available( iOS 10.3,*){
                                                            SKStoreReviewController.requestReview()
                                                            UserDefaults.standard.set(true, forKey: "AppStoreReview")
                                                        }
                                                    }
                                                })
                                            })
                                        })
                                        delayWithSeconds(2 + animationOut, completion: {
                                            self.dismissView()
                                            self.nextButton.isUserInteractionEnabled = true
                                            self.nextButton.alpha = 1
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                self.sendAlert(title: "Almost there!", message: "You must have earned at least $10 or more before you can transfer money to your account.")
                self.nextButton.isUserInteractionEnabled = true
                self.nextButton.alpha = 1
            }
        }
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func dismissView() {
        self.delegate?.dismissAll()
        self.dismiss(animated: true, completion: nil)
    }
    
}
