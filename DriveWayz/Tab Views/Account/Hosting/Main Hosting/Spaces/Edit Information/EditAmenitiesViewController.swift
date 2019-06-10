//
//  EditAmenitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EditAmenitiesViewController: UIViewController {

    var delegate: handleHostEditing?
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK.withAlphaComponent(0.95), bottomColor: Theme.BLACK.withAlphaComponent(0.87))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth - 24, height: phoneHeight - 48)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
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
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: 140, height: 55)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.layer.cornerRadius = 55/2
        button.clipsToBounds = true
        
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
        label.text = "Edit the amenities"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH1
        
        return label
    }()
    
    lazy var amenitiesController: AmenitiesParkingViewController = {
        let controller = AmenitiesParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 12).isActive = true
        container.heightAnchor.constraint(equalToConstant: phoneHeight * 3/4).isActive = true
        
        container.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkingLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        container.addSubview(amenitiesController.view)
        amenitiesController.view.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor, constant: 12).isActive = true
        amenitiesController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24).isActive = true
        amenitiesController.view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        amenitiesController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        
        container.addSubview(darkBlurView)
        darkBlurView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        darkBlurView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        darkBlurView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.closeAmenities()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.closeAmenities()
    }

}
