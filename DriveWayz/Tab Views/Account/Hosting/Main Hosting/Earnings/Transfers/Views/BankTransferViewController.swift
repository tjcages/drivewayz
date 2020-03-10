//
//  BankTransferViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BankTransferViewController: UIViewController {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.textColor = Theme.GREEN
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPExtraLarge
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        return label
    }()
    
    var agreement: UITextView = {
        let agreement = UITextView()
        
        let serviceAttributes: [NSAttributedString.Key: Any] = [
            .link: NSURL(string: "https://stripe.com/connect/account-types")!,
            .foregroundColor: UIColor.blue
        ]
        
        let attributedString = NSMutableAttributedString(string: "Bank transfers will typically be available in you bank account within the next 3 business days.")
        attributedString.setAttributes(serviceAttributes, range: NSMakeRange(79, 16))
        
        agreement.attributedText = attributedString
        agreement.isUserInteractionEnabled = true
        agreement.isEditable = false
        agreement.textColor = Theme.BLACK.withAlphaComponent(0.7)
        agreement.textAlignment = .center
        agreement.translatesAutoresizingMaskIntoConstraints = false
        agreement.font = Fonts.SSPRegularH6
        agreement.backgroundColor = UIColor.clear
        
        return agreement
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(agreement)
        agreement.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        agreement.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: 80).isActive = true
        agreement.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 180).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 32).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
