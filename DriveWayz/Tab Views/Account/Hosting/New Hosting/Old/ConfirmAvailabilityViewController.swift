//
//  ConfirmAvailabilityViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ConfirmAvailabilityViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var popupLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please make sure your parking spot is completely empty for the times specified. Issues with drivers will generally lower your ranking"
        label.numberOfLines = 5
        
        return label
    }()
    
    var availableLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Available"
        
        return label
    }()
    
    var availableDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    var unavailableLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Unavailable"
        
        return label
    }()
    
    var unavailableDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    var popupConfirm: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
//        button.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        
        return button
    }()
    
    var popupBack: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.backgroundColor = Theme.BLACK
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        //        button.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.8)

        setupViews()
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    var unavailableOnlyAnchor: NSLayoutConstraint!
    var unavailableBothAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        containerTopAnchor = container.heightAnchor.constraint(equalToConstant: 0)
            containerTopAnchor.isActive = true
        switch device {
        case .iphone8:
            container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        }
        
        container.addSubview(popupLabel)
        popupLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24).isActive = true
        popupLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24).isActive = true
        popupLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        popupLabel.sizeToFit()
        
        container.addSubview(availableLabel)
        availableLabel.topAnchor.constraint(equalTo: popupLabel.bottomAnchor, constant: 32).isActive = true
        availableLabel.leftAnchor.constraint(equalTo: popupLabel.leftAnchor).isActive = true
        availableLabel.rightAnchor.constraint(equalTo: popupLabel.rightAnchor).isActive = true
        availableLabel.sizeToFit()
        
        container.addSubview(availableDaysLabel)
        availableDaysLabel.topAnchor.constraint(equalTo: availableLabel.bottomAnchor, constant: 8).isActive = true
        availableDaysLabel.leftAnchor.constraint(equalTo: popupLabel.leftAnchor).isActive = true
        availableDaysLabel.rightAnchor.constraint(equalTo: popupLabel.rightAnchor).isActive = true
        availableDaysLabel.sizeToFit()
        
        container.addSubview(unavailableLabel)
        unavailableBothAnchor = unavailableLabel.topAnchor.constraint(equalTo: availableDaysLabel.bottomAnchor, constant: 32)
            unavailableBothAnchor.isActive = true
        unavailableOnlyAnchor = unavailableLabel.topAnchor.constraint(equalTo: popupLabel.bottomAnchor, constant: 32)
            unavailableOnlyAnchor.isActive = false
        unavailableLabel.leftAnchor.constraint(equalTo: popupLabel.leftAnchor).isActive = true
        unavailableLabel.rightAnchor.constraint(equalTo: popupLabel.rightAnchor).isActive = true
        unavailableLabel.sizeToFit()
        
        container.addSubview(unavailableDaysLabel)
        unavailableDaysLabel.topAnchor.constraint(equalTo: unavailableLabel.bottomAnchor, constant: 8).isActive = true
        unavailableDaysLabel.leftAnchor.constraint(equalTo: popupLabel.leftAnchor).isActive = true
        unavailableDaysLabel.rightAnchor.constraint(equalTo: popupLabel.rightAnchor).isActive = true
        unavailableDaysLabel.sizeToFit()
        
        container.addSubview(popupConfirm)
        popupConfirm.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: -phoneWidth/6).isActive = true
        popupConfirm.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 1).isActive = true
        popupConfirm.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 1).isActive = true
        popupConfirm.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(popupBack)
        popupBack.rightAnchor.constraint(equalTo: container.centerXAnchor, constant: -phoneWidth/6).isActive = true
        popupBack.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -1).isActive = true
        popupBack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 1).isActive = true
        popupBack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func bothAvailableAndUnavailable() {
        self.popupLabel.text = "Please make sure your parking spot is completely empty for the times specified. Issues with drivers will generally lower your ranking"
        self.unavailableLabel.alpha = 1
        self.unavailableDaysLabel.alpha = 1
        self.availableLabel.alpha = 1
        self.availableDaysLabel.alpha = 1
        self.unavailableBothAnchor.isActive = true
        self.unavailableOnlyAnchor.isActive = false
        self.view.layoutIfNeeded()
    }
    
    func onlyAvailable() {
        self.popupLabel.text = "Are you sure your parking space will be available every day of the week? \n\nYou can always edit in-app later on"
        self.unavailableLabel.alpha = 0
        self.unavailableDaysLabel.alpha = 0
        self.availableLabel.alpha = 1
        self.availableDaysLabel.alpha = 1
    }
    
    func onlyUnavailable() {
        self.popupLabel.text = "Are you sure your parking space wont be available any days of the week? \n\nYou can always edit in-app later on"
        self.unavailableLabel.alpha = 1
        self.unavailableDaysLabel.alpha = 1
        self.availableLabel.alpha = 0
        self.availableDaysLabel.alpha = 0
        self.unavailableBothAnchor.isActive = false
        self.unavailableOnlyAnchor.isActive = true
        self.view.layoutIfNeeded()
    }
    
    func openContainer() {
        self.containerTopAnchor.constant = 400
        UIView.animate(withDuration: animationIn) {
            self.container.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func closeContainer() {
        self.containerTopAnchor.constant = 0
        UIView.animate(withDuration: animationIn) {
            self.container.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

}
