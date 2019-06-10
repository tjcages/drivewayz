//
//  ParkingCouponViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ParkingCouponViewController: UIViewController {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Looking for cheaper parking options?"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earn discounts and rewards to use towards your next booking!"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        
        return label
    }()
    
    var codeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var codeTextfield: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = "Enter code"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "Expand")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: -6, left: -4, bottom: -2, right: -4)
        
        return button
    }()
    
    var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        label.font = Fonts.SSPRegularH4
        label.text = "or"
        label.textAlignment = .center
        
        return label
    }()
    
    var leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var inviteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.setTitle("Invite a friend", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.4
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        codeTextfield.delegate = self
        
        setupButtons()
        setupTextfield()
    }
    
    func setupButtons() {
        
        self.view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        self.view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(inviteButton)
        inviteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -48).isActive = true
        inviteButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        inviteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        inviteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(orLabel)
        orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        orLabel.bottomAnchor.constraint(equalTo: inviteButton.topAnchor, constant: -24).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        orLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(leftLine)
        leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        leftLine.leftAnchor.constraint(equalTo: inviteButton.leftAnchor).isActive = true
        leftLine.rightAnchor.constraint(equalTo: orLabel.leftAnchor).isActive = true
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(rightLine)
        rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        rightLine.rightAnchor.constraint(equalTo: inviteButton.rightAnchor).isActive = true
        rightLine.leftAnchor.constraint(equalTo: orLabel.rightAnchor).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    var codeTopAnchor: NSLayoutConstraint!
    var codeBottomAnchor: NSLayoutConstraint!
    
    func setupTextfield() {
        
        self.view.addSubview(codeButton)
        codeBottomAnchor = codeButton.bottomAnchor.constraint(equalTo: orLabel.topAnchor, constant: -24)
            codeBottomAnchor.isActive = true
        codeTopAnchor = codeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24)
            codeTopAnchor.isActive = false
        codeButton.leftAnchor.constraint(equalTo: inviteButton.leftAnchor).isActive = true
        codeButton.rightAnchor.constraint(equalTo: inviteButton.rightAnchor).isActive = true
        codeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(codeTextfield)
        codeTextfield.leftAnchor.constraint(equalTo: codeButton.leftAnchor, constant: 16).isActive = true
        codeTextfield.rightAnchor.constraint(equalTo: codeButton.rightAnchor, constant: -16).isActive = true
        codeTextfield.centerYAnchor.constraint(equalTo: codeButton.centerYAnchor).isActive = true
        codeTextfield.sizeToFit()
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: codeButton.rightAnchor, constant: -12).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: codeButton.centerYAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: codeButton.topAnchor, constant: 12).isActive = true
        nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


extension ParkingCouponViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.codeTopAnchor.isActive = true
        self.codeBottomAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.orLabel.alpha = 0
            self.leftLine.alpha = 0
            self.rightLine.alpha = 0
            self.inviteButton.alpha = 0
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.codeTopAnchor.isActive = false
        self.codeBottomAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.orLabel.alpha = 1
            self.leftLine.alpha = 1
            self.rightLine.alpha = 1
            self.inviteButton.alpha = 1
            self.mainLabel.alpha = 1
            self.subLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delayWithSeconds(0.1) {
            UIView.animate(withDuration: animationIn) {
                if textField.text != "" {
                    self.nextButton.backgroundColor = Theme.BLUE
                    self.nextButton.tintColor = Theme.WHITE
                } else {
                    self.nextButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
                    self.nextButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
                }
            }
        }
        return true
    }
    
}
