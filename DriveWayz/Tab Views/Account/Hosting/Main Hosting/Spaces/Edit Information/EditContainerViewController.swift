//
//  EditContainerViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditContainerViewController: UIViewController {

    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Drivewayz"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var contactDrivewayzController: UserContactViewController = {
        let controller = UserContactViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.context = "Review"
        
        return controller
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var contactGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "contactGraphic")
        view.image = image
        
        return view
    }()
    
    var contactGraphicHouse: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "contactGraphicHouse")
        view.image = image
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        setupViews()
        setupControllers()
        setupTopbar()
        scrollMinimized()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var contactDrivewayzAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(contactGraphic)
        contactGraphic.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        contactGraphic.heightAnchor.constraint(equalToConstant: 160).isActive = true
        contactGraphic.sizeToFit()
        switch device {
        case .iphone8:
            contactGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32).isActive = true
        case .iphoneX:
            contactGraphic.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -72).isActive = true
        }
        
        self.view.addSubview(contactGraphicHouse)
        contactGraphicHouse.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 48).isActive = true
        contactGraphicHouse.heightAnchor.constraint(equalToConstant: 160).isActive = true
        contactGraphicHouse.sizeToFit()
        switch device {
        case .iphone8:
            contactGraphicHouse.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52).isActive = true
        case .iphoneX:
            contactGraphicHouse.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -72).isActive = true
        }
        
        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 600)
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        containerCenterAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
            gradientHeightAnchor.isActive = true
        }
        
    }
    
    func setupControllers() {
        
        self.view.addSubview(contactDrivewayzController.view)
        self.view.bringSubviewToFront(gradientContainer)
        self.addChild(contactDrivewayzController)
        contactDrivewayzController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contactDrivewayzController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contactDrivewayzController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contactDrivewayzController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func setupTopbar() {
        
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
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
    }
    
    func scrollMinimized() {
        UIView.animate(withDuration: animationIn) {
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
}
