//
//  DiscountsHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DiscountsHelpView: UIViewController {
    
    var discountOption: DiscountOptions = .code {
        didSet {
            switch self.discountOption {
            case .share:
                handleShare()
            case .code:
                handleCode()
            case .host:
                handleHost()
            case .help:
                return
            }
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = phoneHeight
        controller.setBackButton()
        
        return controller
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 10
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 15
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var mainButtonBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.scrollView.addSubview(mainLabel)
        gradientController.scrollView.addSubview(subLabel)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        mainLabel.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func handleShare() {
        gradientController.mainLabel.text = "About Invites"
        mainLabel.text = "Refer a friend to try Drivewayz and get 25% off your next park."
        subLabel.text = "Only available the first time you invite a friend to try Drivewayz. Does not require a personal code and can only be used once. \n\nCoupon is valid on any booking or reservation and will be applied to your next purchase."
    }
    
    func handleCode() {
        gradientController.mainLabel.text = "About Discounts"
        mainLabel.text = "Enter a valid coupon code and press Apply Code to get a discount."
        subLabel.text = "Must enter the correct code and each code can only be used once. Can only be applied to bookings and reservations and will be applied to your next purchase. \n\nHost credit codes will be applied to your host earnings account. Must be a Drivewayz host to use credit back toward parking or to transfer credit to an external account. \n\nHost account must contain $10 or more to transfer money out."
    }
    
    func handleHost() {
        
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
