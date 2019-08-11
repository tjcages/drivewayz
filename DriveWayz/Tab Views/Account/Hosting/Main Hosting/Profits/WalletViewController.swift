//
//  WalletViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    var delegate: handleHostScrolling?
    var twoPayments: Bool = false {
        didSet {
            if self.twoPayments {
                self.twoPaymentMethods()
            } else {
                self.onePaymentMethod()
            }
        }
    }

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var profitsWallet: ProfitsWalletViewController = {
        let controller = ProfitsWalletViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var profitsOptions: WalletOptionsViewController = {
        let controller = WalletOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var secondProfitsWallet: ProfitsWalletViewController = {
        let controller = ProfitsWalletViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.DarkGreen, bottomColor: Theme.LightGreen)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.63)
        background.zPosition = -10
        controller.container.layer.addSublayer(background)
        controller.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        controller.view.alpha = 0
        self.addChild(controller)
        
        return controller
    }()
    
    func setData(userID: String) {
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let userFunds = dictionary["userFunds"] as? Double {
                    self.profitsWallet.totalEarnings.text = String(format: "$%.2f", userFunds)
                    self.secondProfitsWallet.totalEarnings.text = String(format: "$%.2f", userFunds)
                }
            }
        }
        ref.observe(.childChanged) { (snapshot) in
            print(snapshot)
            let key = snapshot.key
            if key == "userFunds" {
                if let userFunds = snapshot.value as? Double {
                    self.profitsWallet.totalEarnings.text = String(format: "$%.2f", userFunds)
                    self.secondProfitsWallet.totalEarnings.text = String(format: "$%.2f", userFunds)
                }
            }
        }
        ref.child("Accounts").observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? String else { return }
            if key == "accountID" {
                self.profitsWallet.setData(accountID: value)
                self.onePaymentMethod()
            } else if key == "secondaryAccountID" {
                self.twoPayments = true
                self.secondProfitsWallet.setData(accountID: value)
                self.twoPaymentMethods()
            }
        }
        ref.child("Accounts").observe(.childRemoved) { (snapshot) in
            if self.twoPayments == true {
                self.twoPayments = false
                guard let value = snapshot.value as? String else { return }
                self.profitsWallet.setData(accountID: value)
                self.onePaymentMethod()
            } else {
                self.profitsWallet.accountNumber.text = "• • • •"
                self.profitsWallet.accountLabel.text = "NO ACCOUNT LINKED"
                self.profitsWallet.payoutAccount = nil
                self.profitsOptions.noAccount()
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        setupViews()
    }
    
    var onePaymentAnchor: NSLayoutConstraint!
    var twoPaymentAnchor: NSLayoutConstraint!
    var gonePaymentAnchor: NSLayoutConstraint!
    
    var secondPaymentHiddenAnchor: NSLayoutConstraint!
    var secondPaymentOpenAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneWidth * 0.63 + 524)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(profitsWallet.view)
        profitsWallet.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        profitsWallet.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsWallet.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        profitsWallet.view.heightAnchor.constraint(equalToConstant: phoneWidth * 0.63).isActive = true
        
        scrollView.addSubview(secondProfitsWallet.view)
        scrollView.bringSubviewToFront(profitsWallet.view)
        secondPaymentHiddenAnchor = secondProfitsWallet.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80)
            secondPaymentHiddenAnchor.isActive = true
        secondPaymentOpenAnchor = secondProfitsWallet.view.topAnchor.constraint(equalTo: profitsWallet.view.bottomAnchor, constant: 16)
            secondPaymentOpenAnchor.isActive = false
        secondProfitsWallet.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        secondProfitsWallet.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        secondProfitsWallet.view.heightAnchor.constraint(equalToConstant: phoneWidth * 0.63).isActive = true
        
        scrollView.addSubview(profitsOptions.view)
        onePaymentAnchor = profitsOptions.view.topAnchor.constraint(equalTo: profitsWallet.view.bottomAnchor, constant: 16)
            onePaymentAnchor.isActive = true
        twoPaymentAnchor = profitsOptions.view.topAnchor.constraint(equalTo: secondProfitsWallet.view.bottomAnchor, constant: 8)
            twoPaymentAnchor.isActive = false
        gonePaymentAnchor = profitsOptions.view.topAnchor.constraint(equalTo: profitsWallet.view.bottomAnchor, constant: phoneWidth)
            gonePaymentAnchor.isActive = false
        profitsOptions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsOptions.view.heightAnchor.constraint(equalToConstant: 324).isActive = true
        profitsOptions.deleteButton.addTarget(self, action: #selector(deletePaymentMethod), for: .touchUpInside)
        
    }
    
    func firstPaymentTapped() {
        self.profitsOptions.openAccount()
        if twoPayments {
            self.secondPaymentHiddenAnchor.isActive = true
            self.secondPaymentOpenAnchor.isActive = false
            self.scrollView.bringSubviewToFront(self.profitsWallet.view)
            UIView.animate(withDuration: animationOut, animations: {
                self.secondProfitsWallet.view.alpha = 0.8
                self.secondProfitsWallet.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.gonePaymentAnchor.isActive = false
                self.onePaymentAnchor.isActive = false
                self.twoPaymentAnchor.isActive = true
                UIView.animate(withDuration: animationOut) {
                    self.profitsOptions.view.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            self.secondPaymentHiddenAnchor.isActive = true
            self.secondPaymentOpenAnchor.isActive = false
            self.scrollView.bringSubviewToFront(self.profitsWallet.view)
            UIView.animate(withDuration: animationOut, animations: {
                self.secondProfitsWallet.view.alpha = 0
                self.secondProfitsWallet.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.gonePaymentAnchor.isActive = false
                self.onePaymentAnchor.isActive = true
                self.twoPaymentAnchor.isActive = false
                UIView.animate(withDuration: animationOut) {
                    self.profitsOptions.view.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func secondPaymentTapped() {
        self.profitsOptions.openAccount()
        self.secondPaymentHiddenAnchor.isActive = true
        self.secondPaymentOpenAnchor.isActive = false
        self.scrollView.bringSubviewToFront(self.secondProfitsWallet.view)
        UIView.animate(withDuration: animationOut, animations: {
            self.profitsWallet.view.alpha = 0.8
            self.profitsWallet.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.gonePaymentAnchor.isActive = false
            self.onePaymentAnchor.isActive = false
            self.twoPaymentAnchor.isActive = true
            UIView.animate(withDuration: animationOut) {
                self.profitsOptions.view.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func changePaymentMethod() {
        self.gonePaymentAnchor.isActive = true
        self.onePaymentAnchor.isActive = false
        self.twoPaymentAnchor.isActive = false
        UIView.animate(withDuration: animationIn, animations: {
            self.profitsOptions.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if self.twoPayments {
                self.secondPaymentHiddenAnchor.isActive = false
                self.secondPaymentOpenAnchor.isActive = true
                UIView.animate(withDuration: animationIn, animations: {
                    self.profitsWallet.view.alpha = 1
                    self.profitsWallet.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.secondProfitsWallet.view.alpha = 1
                    self.secondProfitsWallet.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.view.layoutIfNeeded()
                })
            } else {
                self.gonePaymentAnchor.isActive = false
                self.onePaymentAnchor.isActive = true
                self.profitsOptions.noAccount()
                UIView.animate(withDuration: animationIn, animations: {
                    self.profitsOptions.view.alpha = 1
                    self.profitsWallet.view.alpha = 1
                    self.profitsWallet.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func closePaymentMethod() {
        self.profitsOptions.openAccount()
        if twoPayments {
            self.secondPaymentHiddenAnchor.isActive = true
            self.secondPaymentOpenAnchor.isActive = false
            self.scrollView.bringSubviewToFront(profitsWallet.view)
            UIView.animate(withDuration: animationOut, animations: {
                self.secondProfitsWallet.view.alpha = 0.8
                self.secondProfitsWallet.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.gonePaymentAnchor.isActive = false
                self.onePaymentAnchor.isActive = false
                self.twoPaymentAnchor.isActive = true
                UIView.animate(withDuration: animationOut) {
                    self.profitsOptions.view.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            self.secondPaymentHiddenAnchor.isActive = true
            self.secondPaymentOpenAnchor.isActive = false
            self.scrollView.bringSubviewToFront(profitsWallet.view)
            UIView.animate(withDuration: animationOut, animations: {
                self.secondProfitsWallet.view.alpha = 0
                self.secondProfitsWallet.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.gonePaymentAnchor.isActive = false
                self.onePaymentAnchor.isActive = true
                self.twoPaymentAnchor.isActive = false
                UIView.animate(withDuration: animationOut) {
                    self.profitsOptions.view.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func onePaymentMethod() {
        self.profitsOptions.openAccount()
        self.onePaymentAnchor.isActive = true
        self.twoPaymentAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.profitsWallet.view.alpha = 1
            self.profitsWallet.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.secondProfitsWallet.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func twoPaymentMethods() {
        self.profitsOptions.openAccount()
        self.onePaymentAnchor.isActive = false
        self.twoPaymentAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.profitsWallet.view.alpha = 1
            self.profitsWallet.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.secondProfitsWallet.view.alpha = 0.8
            self.secondProfitsWallet.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func deletePaymentMethod() {
        let alertController = UIAlertController(title: "Are you sure you want to delete this payment method?", message: "This action cannot be undone. Any transfers in transit will be frozen.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Accounts")
            if self.profitsWallet.view.alpha == 1 {
                if let accountID = self.profitsWallet.payoutAccount?.accountID {
                    let accountRef = Database.database().reference().child("PayoutAccounts").child(accountID)
                    accountRef.removeValue()
                    ref.child("accountID").removeValue()
                    if self.twoPayments {
                        if let secondID = self.secondProfitsWallet.payoutAccount?.accountID {
                            ref.updateChildValues(["accountID": secondID])
                            ref.child("secondaryAccountID").removeValue()
                        }
                    }
                }
            } else if self.secondProfitsWallet.view.alpha == 1 {
                if let accountID = self.secondProfitsWallet.payoutAccount?.accountID {
                    let accountRef = Database.database().reference().child("PayoutAccounts").child(accountID)
                    accountRef.removeValue()
                    ref.child("secondaryAccountID").removeValue()
                }
            }
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }

}


extension WalletViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.gonePaymentAnchor.isActive != true {
            self.delegate?.makeScrollViewScroll(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.gonePaymentAnchor.isActive != true {
            self.delegate?.makeScrollViewEnd(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.gonePaymentAnchor.isActive != true {
            self.delegate?.makeScrollViewEnd(scrollView)
        }
    }
    
}
