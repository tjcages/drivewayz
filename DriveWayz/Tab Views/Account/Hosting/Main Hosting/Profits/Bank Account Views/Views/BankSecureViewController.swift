//
//  BankSecureViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankSecureViewController: UIViewController {
    
    var firstCheck: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Secure"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var firstSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Transfer of your information is encrypted end-to-end"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()

    var secondCheck: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Private"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var secondSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Your credentials will never be made accessible to Drivewayz"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var agreement: UITextView = {
        let agreement = UITextView()
        
        let serviceAttributes: [NSAttributedString.Key: Any] = [
            .link: NSURL(string: "https://stripe.com/us/connect-account/legal")!,
            .foregroundColor: UIColor.blue
        ]
        
        let attributedString = NSMutableAttributedString(string: "By registering your account, you agree to our Services Agreement and the Stripe Connected Account Agreement.")
        attributedString.setAttributes(serviceAttributes, range: NSMakeRange(90, 17))
        
        agreement.attributedText = attributedString
        agreement.isUserInteractionEnabled = true
        agreement.isEditable = false
        agreement.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        agreement.textAlignment = .center
        agreement.translatesAutoresizingMaskIntoConstraints = false
        agreement.font = Fonts.SSPRegularH6
        agreement.backgroundColor = UIColor.clear
        
        return agreement
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(firstCheck)
        firstCheck.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        firstCheck.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        firstCheck.widthAnchor.constraint(equalToConstant: 30).isActive = true
        firstCheck.heightAnchor.constraint(equalTo: firstCheck.widthAnchor).isActive = true
        
        self.view.addSubview(firstLabel)
        firstLabel.leftAnchor.constraint(equalTo: firstCheck.rightAnchor, constant: 12).isActive = true
        firstLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        firstLabel.centerYAnchor.constraint(equalTo: firstCheck.centerYAnchor).isActive = true
        firstLabel.sizeToFit()
        
        self.view.addSubview(firstSubLabel)
        firstSubLabel.leftAnchor.constraint(equalTo: firstLabel.leftAnchor).isActive = true
        firstSubLabel.rightAnchor.constraint(equalTo: firstLabel.rightAnchor).isActive = true
        firstSubLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 4).isActive = true
        firstSubLabel.sizeToFit()
        
        self.view.addSubview(secondCheck)
        secondCheck.topAnchor.constraint(equalTo: firstSubLabel.bottomAnchor, constant: 16).isActive = true
        secondCheck.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        secondCheck.widthAnchor.constraint(equalTo: firstCheck.widthAnchor).isActive = true
        secondCheck.heightAnchor.constraint(equalTo: firstCheck.heightAnchor).isActive = true
        
        self.view.addSubview(secondLabel)
        secondLabel.leftAnchor.constraint(equalTo: secondCheck.rightAnchor, constant: 12).isActive = true
        secondLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        secondLabel.centerYAnchor.constraint(equalTo: secondCheck.centerYAnchor).isActive = true
        secondLabel.sizeToFit()
        
        self.view.addSubview(secondSubLabel)
        secondSubLabel.leftAnchor.constraint(equalTo: secondLabel.leftAnchor).isActive = true
        secondSubLabel.rightAnchor.constraint(equalTo: secondLabel.rightAnchor).isActive = true
        secondSubLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 4).isActive = true
        secondSubLabel.sizeToFit()
        
        self.view.addSubview(agreement)
        agreement.topAnchor.constraint(equalTo: secondSubLabel.bottomAnchor, constant: 92).isActive = true
        agreement.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -24).isActive = true
        agreement.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 24).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
