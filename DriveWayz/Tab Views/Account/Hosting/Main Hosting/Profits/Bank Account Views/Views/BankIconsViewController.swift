//
//  BankIconsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankIconsViewController: UIViewController {
    
    var stripeIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bankShield")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        return button
    }()
    
    var phoneIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        let image = UIImage(named: "bankPhone")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.cornerRadius = 25
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var bankIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        let image = UIImage(named: "bankIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.cornerRadius = 25
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var dotsImage: UIImageView = {
        let image = UIImage(named: "bankDots")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.contentMode = .scaleAspectFit

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    var phoneCenterAnchor: NSLayoutConstraint!
    var phoneRightAnchor: NSLayoutConstraint!
    var bankCenterAnchor: NSLayoutConstraint!
    var bankLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(stripeIcon)
        stripeIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stripeIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stripeIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stripeIcon.widthAnchor.constraint(equalTo: stripeIcon.heightAnchor).isActive = true
        
        self.view.addSubview(phoneIcon)
        phoneRightAnchor = phoneIcon.rightAnchor.constraint(equalTo: stripeIcon.leftAnchor, constant: -40)
            phoneRightAnchor.isActive = true
        phoneCenterAnchor = phoneIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            phoneCenterAnchor.isActive = false
        phoneIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        phoneIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        phoneIcon.widthAnchor.constraint(equalTo: phoneIcon.heightAnchor).isActive = true
        
        self.view.addSubview(bankIcon)
        bankLeftAnchor = bankIcon.leftAnchor.constraint(equalTo: stripeIcon.rightAnchor, constant: 40)
            bankLeftAnchor.isActive = true
        bankCenterAnchor = bankIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            bankCenterAnchor.isActive = false
        bankIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        bankIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bankIcon.widthAnchor.constraint(equalTo: bankIcon.heightAnchor).isActive = true
        
        self.view.addSubview(dotsImage)
        self.view.sendSubviewToBack(dotsImage)
        dotsImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dotsImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dotsImage.centerYAnchor.constraint(equalTo: stripeIcon.centerYAnchor).isActive = true
        dotsImage.sizeToFit()
        
    }
    
    func expandPhone() {
        self.phoneRightAnchor.isActive = false
        self.phoneCenterAnchor.isActive = true
        self.bankLeftAnchor.isActive = true
        self.bankCenterAnchor.isActive = false
        UIView.animate(withDuration: animationOut) {
            self.phoneIcon.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.phoneIcon.alpha = 1
            self.stripeIcon.alpha = 0
            self.bankIcon.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func expandBank() {
        self.bankLeftAnchor.isActive = false
        self.bankCenterAnchor.isActive = true
        self.phoneRightAnchor.isActive = true
        self.phoneCenterAnchor.isActive = false
        UIView.animate(withDuration: animationOut) {
            self.bankIcon.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.bankIcon.alpha = 1
            self.stripeIcon.alpha = 0
            self.phoneIcon.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func expandStripe() {
        self.bankLeftAnchor.isActive = true
        self.bankCenterAnchor.isActive = false
        self.phoneRightAnchor.isActive = true
        self.phoneCenterAnchor.isActive = false
        UIView.animate(withDuration: animationOut) {
            self.phoneIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.bankIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.phoneIcon.alpha = 1
            self.bankIcon.alpha = 1
            self.stripeIcon.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

}
