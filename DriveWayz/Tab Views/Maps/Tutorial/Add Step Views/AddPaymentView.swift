//
//  AddPaymentView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AddPaymentView: UIViewController {
    
    var currentPaymentMethod: PaymentMethod? {
        didSet {
            if let paymentMethod = self.currentPaymentMethod {
                if let cardNumber = paymentMethod.last4 {
                    mainLabel.text = "•••• •••• •••• \(cardNumber)"
                }
                if let name = paymentMethod.name, let month = paymentMethod.month, let year = paymentMethod.year, let brand = paymentMethod.brand {
                    subLabel.text = "\(name)\n\(brand) \(month)/\(year)"
                }
            } else {
                mainLabel.text = "Add payment method"
                subLabel.text = "All payment information is securely processed with Stripe."
            }
        }
    }
    
    var checkmark: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 15)
        check.checkmarkColor = Theme.DARK_GRAY
        check.checkedBorderColor = UIColor.clear
        check.isUserInteractionEnabled = false
        check.backgroundColor = lineColor
        check.layer.cornerRadius = 15
        check.clipsToBounds = true
        
        return check
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add payment method"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "All payment information is securely processed with Stripe."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 3
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(checkmark)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        checkmark.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        checkmark.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: checkmark.topAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: checkmark.rightAnchor, constant: 16).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        subLabel.sizeToFit()
        
    }

    func completed() {
        UIView.animate(withDuration: animationOut) {
            self.checkmark.backgroundColor = Theme.BLUE
            self.checkmark.checkmarkColor = Theme.WHITE
            self.view.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
            self.view.layer.shadowColor = UIColor.clear.cgColor
            self.view.layoutIfNeeded()
        }
    }
    
    func incomplete() {
        UIView.animate(withDuration: animationOut) {
            self.checkmark.backgroundColor = lineColor
            self.checkmark.checkmarkColor = Theme.DARK_GRAY
            self.view.backgroundColor = Theme.WHITE
            self.view.layer.shadowColor = Theme.DARK_GRAY.cgColor
            self.view.layoutIfNeeded()
        }
    }
    
}
