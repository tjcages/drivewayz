//
//  HelpViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleHelpControllers {
    func moveToContact()
}

class HelpViewController: UIViewController, handleHelpControllers {
    
    var delegate: moveControllers?
    var options: [String] = ["Contact Drivewayz", "Review last booking", "Someone is in my spot"]
    var optionsSub: [String] = ["", "", ""]
    var optionsImages: [UIImage] = [UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Help"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    lazy var optionsController: HelpOptionsViewController = {
        let controller = HelpOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var contactDrivewayzController: ContactDrivewayzViewController = {
        let controller = ContactDrivewayzViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
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
        
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(bringBackMain))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
        setupControllers()
        setupTopbar()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var contactDrivewayzAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
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
        
        scrollView.addSubview(optionsController.view)
        optionsController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        optionsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        optionsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        optionsController.view.heightAnchor.constraint(equalToConstant: 264).isActive = true
        
        self.view.addSubview(contactDrivewayzController.view)
        self.view.bringSubviewToFront(gradientContainer)
        self.addChild(contactDrivewayzController)
        contactDrivewayzController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contactDrivewayzController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contactDrivewayzController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contactDrivewayzAnchor = contactDrivewayzController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            contactDrivewayzAnchor.isActive = true
        
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
        self.bringBackMain()
    }
    
    @objc func bringBackMain() {
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.delegate?.hideExitButton()
            self.contactDrivewayzAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
            self.delegate?.defaultContentStatusBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Help"
            }, completion: nil)
        }
    }
    
    func moveToContact() {
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.delegate?.hideExitButton()
            self.backButton.alpha = 1
            self.contactDrivewayzAnchor.constant = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.lightContentStatusBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Contact Drivewayz"
            }, completion: nil)
        }
    }
    
}


extension HelpViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            if self.backgroundCircle.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.gradientContainer.layer.shadowOpacity = 0
                    self.backgroundCircle.alpha = 1
                }
            }
            if self.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                self.scrollExpanded()
            }
        } else if translation >= 40 && self.backgroundCircle.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.gradientContainer.layer.shadowOpacity = 0.2
                self.backgroundCircle.alpha = 0
            }
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                self.scrollMinimized()
            }
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.delegate?.defaultContentStatusBar()
        self.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
        }
    }
    
    func scrollMinimized() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
}
