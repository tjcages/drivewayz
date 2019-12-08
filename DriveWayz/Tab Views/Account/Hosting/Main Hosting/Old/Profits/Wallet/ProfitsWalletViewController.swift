//
//  ProfitsWalletViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsWalletViewController: UIViewController {
    
    var payoutAccount: PayoutAccount?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.DarkPink, bottomColor: Theme.LightPink)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.63)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()

    var gooGraphic: UIImageView = {
        let image = UIImage(named: "gooGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var totalEarnings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = ""
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var datesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.6)
        label.text = "CURRENT BALANCE"
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.6)
        label.text = "NO ACCOUNT LINKED"
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .right
        
        return label
    }()
    
    var accountNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.6)
        label.text = "• • • •"
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var bankIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        let image = UIImage(named: "bankIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 35
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return button
    }()
    
    func setData(accountID: String) {
        let ref = Database.database().reference().child("PayoutAccounts").child(accountID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.payoutAccount = PayoutAccount(dictionary: dictionary)
                if let accountNumber = self.payoutAccount?.accountNumber {
                    self.accountNumber.text = "• • • • \(accountNumber)"
                    self.accountLabel.text = "ACCOUNT"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        container.addSubview(gooGraphic)
        gooGraphic.widthAnchor.constraint(equalToConstant: 360).isActive = true
        gooGraphic.heightAnchor.constraint(equalToConstant: 360).isActive = true
        gooGraphic.centerXAnchor.constraint(equalTo: container.leftAnchor, constant: 40).isActive = true
        gooGraphic.centerYAnchor.constraint(equalTo: container.topAnchor, constant: 80).isActive = true
        
        self.view.addSubview(datesLabel)
        datesLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24).isActive = true
        datesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        datesLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        datesLabel.sizeToFit()
        
        self.view.addSubview(totalEarnings)
        totalEarnings.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 0).isActive = true
        totalEarnings.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        totalEarnings.sizeToFit()
        
        self.view.addSubview(transferButton)
        transferButton.centerYAnchor.constraint(equalTo: datesLabel.centerYAnchor).isActive = true
        transferButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 6).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 24).isActive = true

        self.view.addSubview(bankIcon)
        bankIcon.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        bankIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24).isActive = true
        bankIcon.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bankIcon.widthAnchor.constraint(equalTo: bankIcon.heightAnchor).isActive = true
        
        self.view.addSubview(accountLabel)
        accountLabel.centerYAnchor.constraint(equalTo: bankIcon.centerYAnchor, constant: -10).isActive = true
        accountLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        accountLabel.sizeToFit()
        
        self.view.addSubview(accountNumber)
        accountNumber.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 2).isActive = true
        accountNumber.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        accountNumber.sizeToFit()
        
    }

}
