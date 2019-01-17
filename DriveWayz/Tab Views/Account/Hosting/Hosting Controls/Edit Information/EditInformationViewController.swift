//
//  EditInformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditInformationViewController: UIViewController {

    var delegate: handleHostEditing?
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 48, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var darkBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLACK.withAlphaComponent(0), bottomColor: Theme.BLACK.withAlphaComponent(0.8))
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 72)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit the parking type"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH1
        
        return label
    }()
    
    lazy var typeController: ParkingTypeViewController = {
        let controller = ParkingTypeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var optionsController: ParkingOptionsViewController = {
        let controller = ParkingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var messageController: SpotsMessageViewController = {
        let controller = SpotsMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK.withAlphaComponent(0.95), bottomColor: Theme.BLACK.withAlphaComponent(0.87))
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.typeController.view.alpha = 1
        self.optionsController.view.alpha = 0
        self.messageController.view.alpha = 0
        self.nextButton.setTitle("NEXT", for: .normal)
    }
    
    func setupViews() {
        
        self.view.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(typeController.view)
        typeController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 12).isActive = true
        typeController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        typeController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        typeController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(optionsController.view)
        optionsController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 12).isActive = true
        optionsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        optionsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        optionsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(messageController.view)
        messageController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 24).isActive = true
        messageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        messageController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        }
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        self.view.addSubview(darkBlurView)
        self.view.bringSubviewToFront(nextButton)
        darkBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        darkBlurView.topAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
    }
    
    @objc func nextButtonPressed(sender: UIButton) {
        if typeController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.typeController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.optionsController.view.alpha = 1
                })
            }
        } else if optionsController.view.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.optionsController.view.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.messageController.view.alpha = 1
                })
                self.nextButton.setTitle("SAVE", for: .normal)
                self.view.layoutIfNeeded()
            }
        } else if messageController.view.alpha == 1 {
            //
            self.delegate?.hideEditingInformation()
            delayWithSeconds(2) {
                self.typeController.view.alpha = 1
                self.optionsController.view.alpha = 1
                self.messageController.view.alpha = 1
            }
            //
        }
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.hideEditingInformation()
        delayWithSeconds(0.6) {
            self.typeController.view.alpha = 1
            self.optionsController.view.alpha = 1
            self.messageController.view.alpha = 1
        }
    }

}
