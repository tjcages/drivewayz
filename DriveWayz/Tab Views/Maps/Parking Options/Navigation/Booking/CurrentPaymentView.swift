//
//  CurrentPaymentView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentPaymentView: UIViewController {
    
    var delegate: handleCurrentBooking?
    
    var creditCardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discover 3519"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7/20/19, 11:01 PM"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var paymentAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$27.91"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(paymentOptionsPressed))
        view.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    @objc func paymentOptionsPressed() {
        self.delegate?.paymentOptionsPressed()
    }
    
    func setupViews() {
        
        view.addSubview(creditCardLabel)
        view.addSubview(dateLabel)
        view.addSubview(paymentAmountLabel)
        
        creditCardLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        creditCardLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        creditCardLabel.sizeToFit()
        
        dateLabel.topAnchor.constraint(equalTo: creditCardLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: creditCardLabel.leftAnchor).isActive = true
        dateLabel.sizeToFit()
        
        paymentAmountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        paymentAmountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        paymentAmountLabel.sizeToFit()
        
    }

}
