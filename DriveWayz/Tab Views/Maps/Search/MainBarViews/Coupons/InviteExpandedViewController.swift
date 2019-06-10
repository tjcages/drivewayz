//
//  InviteExpandedViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class InviteExpandedViewController: UIViewController {
    
    var delegate: handleInviteControllers?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.clipsToBounds = false
        let background = CAGradientLayer().purpleBlueColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Rewards"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 2
        
        return view
    }()

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var parkingController: ParkingCouponViewController = {
        let controller = ParkingCouponViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.alpha = 0

        setupViews()
        setupControllers()
    }
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        gradientHeightAnchor = scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            gradientHeightAnchor.isActive = true
        switch device {
        case .iphone8:
            scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight - 150)
        case .iphoneX:
            scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight - 170)
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -16).isActive = true
        
        scrollView.addSubview(parkingController.view)
        parkingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        switch device {
        case .iphone8:
            parkingController.view.heightAnchor.constraint(equalToConstant: phoneHeight - 160).isActive = true
        case .iphoneX:
            parkingController.view.heightAnchor.constraint(equalToConstant: phoneHeight - 180).isActive = true
        }
        
    }
    
    func openController() {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.mainLabel.alpha = 1
                self.exitButton.alpha = 1
                switch device {
                case .iphone8:
                    self.gradientHeightAnchor.constant = 160
                case .iphoneX:
                    self.gradientHeightAnchor.constant = 180
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func closeController() {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.exitButton.alpha = 0
            self.gradientHeightAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.view.alpha = 0
            }
        }
    }
    
    @objc func exitButtonPressed() {
        self.closeController()
        self.delegate?.inviteControllerDismissed()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
