//
//  PaymentMethodsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe

class PaymentMethodsCell: UITableViewCell {
    
    var paymentCardTextField = STPPaymentCardTextField()
    var paymentMethod: PaymentMethod? {
        didSet {
            let params = STPCardParams()
            if let method = self.paymentMethod {
                if let cardNumber = method.last4 {
                    mainLabel.text = "•••• \(cardNumber)"
                }
                if let brand = method.brand?.lowercased() {
                    let methodStyle = CardType(dictionary: brand)
                    if let prefix = methodStyle.prefix {
                        params.number = prefix
                    }
                }
                paymentCardTextField.cardParams = STPPaymentMethodCardParams(cardSourceParams: params)
                if let image = paymentCardTextField.brandImage {
                    iconButton.setImage(image, for: .normal)
                }
                if method.defaultCard {
                    defaultButton.alpha = 1
                } else {
                    defaultButton.alpha = 0
                }
            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.alpha = 0
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var newCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add payment method", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var defaultButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN.withAlphaComponent(0.2)
        button.setTitle("Default", for: .normal)
        button.setTitleColor(Theme.GREEN, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 25/2
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25/2
        button.backgroundColor = Theme.GREEN
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.alpha = 0
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(iconButton)
        addSubview(plusButton)
        addSubview(mainLabel)
        addSubview(arrowButton)
        addSubview(newCardButton)
        addSubview(defaultButton)
        addSubview(checkmark)
        
        iconButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        iconButton.heightAnchor.constraint(equalTo: iconButton.widthAnchor).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        mainLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        newCardButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        newCardButton.leftAnchor.constraint(equalTo: plusButton.rightAnchor, constant: 12).isActive = true
        newCardButton.sizeToFit()
        
        defaultButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        defaultButton.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 12).isActive = true
        defaultButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        defaultButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        checkmark.rightAnchor.constraint(equalTo: arrowButton.rightAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
    }
    
    func newCard() {
        newCardButton.alpha = 1
        plusButton.alpha = 1
        defaultButton.alpha = 0
        iconButton.alpha = 0
        mainLabel.alpha = 0
        arrowButton.alpha = 0
    }
    
    func oldCard() {
        newCardButton.alpha = 0
        plusButton.alpha = 0
        iconButton.alpha = 1
        mainLabel.alpha = 1
        arrowButton.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


