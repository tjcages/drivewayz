//
//  QuickCouponsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickCouponsViewController: UIViewController {
    
    var percentage: Int = 10
    
    var giftIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "coupon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 35/2
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
//    var giftView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = Theme.STRAWBERRY_PINK
//        view.layer.cornerRadius = 20
//        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 0.2
//
//        return view
//    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_ORANGE
        view.layer.cornerRadius = 35/2
        view.clipsToBounds = true
        
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.STRAWBERRY_PINK, bottomColor: Theme.LIGHT_ORANGE)
        background.frame = CGRect(x: 0, y: 0, width: 240, height: 75)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var couponLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10% off next booking!"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4

        setupViews()
    }
    
    var containerLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.addSubview(couponLabel)
        self.view.addSubview(giftIcon)
//        giftView.addSubview(giftIcon)
        
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerLeftAnchor = container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 210)
            containerLeftAnchor.isActive = true
        container.centerYAnchor.constraint(equalTo: giftIcon.centerYAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        giftIcon.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 4).isActive = true
        giftIcon.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        giftIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
        giftIcon.widthAnchor.constraint(equalTo: giftIcon.heightAnchor).isActive = true
        
//        giftIcon.topAnchor.constraint(equalTo: giftView.topAnchor).isActive = true
//        giftIcon.leftAnchor.constraint(equalTo: giftView.leftAnchor).isActive = true
//        giftIcon.rightAnchor.constraint(equalTo: giftView.rightAnchor).isActive = true
//        giftIcon.bottomAnchor.constraint(equalTo: giftView.bottomAnchor).isActive = true
        
        couponLabel.leftAnchor.constraint(equalTo: giftIcon.rightAnchor).isActive = true
        couponLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        couponLabel.sizeToFit()
        
    }
    
    func minimizeController() {
        self.containerLeftAnchor.constant = 124
        self.couponLabel.text = "\(percentage)% off"
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func maximizeController() {
        self.containerLeftAnchor.constant = 28
        self.couponLabel.text = "\(percentage)% off next booking!"
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeController() {
        self.containerLeftAnchor.constant = 210
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
}
