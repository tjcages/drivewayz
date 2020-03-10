//
//  TransfersStatusViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class TransfersStatusViewController: UIViewController {
    
    // Organize TransfersStatus
    var payout: Payouts? {
        didSet {
            if let timestamp = self.payout?.timestamp, let transferAmount = self.payout?.transferAmount {
                self.payoutValue.text = String(format: "+$%.2f", transferAmount)
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'Initiated 'MM/dd/yyyy' at 'h:mma"
                let dateString = dateFormatter.string(from: date)
                self.initiatedLabel.text = dateString
                
                let nextDate = Date(timeIntervalSince1970: timestamp).addingTimeInterval(3600 * 24 * 3)
                let nextDateFormatter = DateFormatter()
                nextDateFormatter.dateFormat = "'Expected arrival 'MM/dd/yyyy"
                let nextDateString = nextDateFormatter.string(from: nextDate)
                self.arrivalLabel.text = nextDateString
                
                if let accountLabel = self.payout?.accountLabel {
                    self.accountValue.text = "•••• \(accountLabel)"
                }
                if let routingLabel = self.payout?.routingLabel {
                    self.routingValue.text = "•••• \(routingLabel)"
                }
                if let accountType = self.payout?.accountType {
                    self.typeValue.text = "\(accountType)"
                }
                
                if let section = self.payout?.section {
                    if section == .today {
                        self.inTransitButton()
                    } else if section == .yesterday {
                        self.inTransitButton()
                    } else if section == .week {
                        self.madePaymentButton()
                    } else if section == .month {
                        self.madePaymentButton()
                    } else if section == .earlier {
                        self.madePaymentButton()
                    } else {
                        self.madePaymentButton()
                    }
                }
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        setupStatus()
        setupViews()
    }
    
    var paidButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        button.setTitle("Paid", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 15
        button.alpha = 0
        
        return button
    }()
    
    var transitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN.withAlphaComponent(0.2)
        button.setTitle("In transit", for: .normal)
        button.setTitleColor(Theme.GREEN, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    var arrivalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var initiatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    func setupStatus() {
        
        self.view.addSubview(container)
        
        self.view.addSubview(paidButton)
        paidButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        paidButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        paidButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        paidButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(transitButton)
        transitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        transitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        transitButton.widthAnchor.constraint(equalToConstant: 92).isActive = true
        transitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(arrivalLabel)
        arrivalLabel.topAnchor.constraint(equalTo: transitButton.bottomAnchor, constant: 8).isActive = true
        arrivalLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        arrivalLabel.sizeToFit()
        
        self.view.addSubview(initiatedLabel)
        initiatedLabel.topAnchor.constraint(equalTo: arrivalLabel.bottomAnchor, constant: 4).isActive = true
        initiatedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        initiatedLabel.sizeToFit()
        
    }
    
    var payoutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "PAYOUT"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "ACCOUNT"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var routingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "ROUTING"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "ACCOUNT TYPE"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var payoutValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GREEN
        label.text = ""
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var accountValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var routingValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var typeValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var payoutIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "payoutsCash")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK.withAlphaComponent(0.4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var accountIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "payoutsAccount")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK.withAlphaComponent(0.4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var routingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "payoutsRouting")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK.withAlphaComponent(0.4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var typeIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "payoutsType")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK.withAlphaComponent(0.4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var issueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Report issue", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        //        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    func setupViews() {
        
        self.view.addSubview(payoutValue)
        payoutValue.topAnchor.constraint(equalTo: initiatedLabel.bottomAnchor, constant: 24).isActive = true
        payoutValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        payoutValue.sizeToFit()
        
        self.view.addSubview(payoutIcon)
        payoutIcon.centerYAnchor.constraint(equalTo: payoutValue.centerYAnchor).isActive = true
        payoutIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        payoutIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        payoutIcon.widthAnchor.constraint(equalTo: payoutIcon.heightAnchor).isActive = true
        
        self.view.addSubview(payoutLabel)
        payoutLabel.centerYAnchor.constraint(equalTo: payoutValue.centerYAnchor).isActive = true
        payoutLabel.leftAnchor.constraint(equalTo: payoutIcon.rightAnchor, constant: 12).isActive = true
        payoutLabel.sizeToFit()
        
        self.view.addSubview(accountValue)
        accountValue.topAnchor.constraint(equalTo: payoutValue.bottomAnchor, constant: 8).isActive = true
        accountValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        accountValue.sizeToFit()
        
        self.view.addSubview(accountIcon)
        accountIcon.centerYAnchor.constraint(equalTo: accountValue.centerYAnchor).isActive = true
        accountIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        accountIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        accountIcon.widthAnchor.constraint(equalTo: accountIcon.heightAnchor).isActive = true
        
        self.view.addSubview(accountLabel)
        accountLabel.centerYAnchor.constraint(equalTo: accountValue.centerYAnchor).isActive = true
        accountLabel.leftAnchor.constraint(equalTo: accountIcon.rightAnchor, constant: 12).isActive = true
        accountLabel.sizeToFit()
        
        self.view.addSubview(routingValue)
        routingValue.topAnchor.constraint(equalTo: accountValue.bottomAnchor, constant: 8).isActive = true
        routingValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        routingValue.sizeToFit()
        
        self.view.addSubview(routingIcon)
        routingIcon.centerYAnchor.constraint(equalTo: routingValue.centerYAnchor).isActive = true
        routingIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        routingIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        routingIcon.widthAnchor.constraint(equalTo: routingIcon.heightAnchor).isActive = true
        
        self.view.addSubview(routingLabel)
        routingLabel.centerYAnchor.constraint(equalTo: routingValue.centerYAnchor).isActive = true
        routingLabel.leftAnchor.constraint(equalTo: routingIcon.rightAnchor, constant: 12).isActive = true
        routingLabel.sizeToFit()
        
        self.view.addSubview(typeValue)
        typeValue.topAnchor.constraint(equalTo: routingValue.bottomAnchor, constant: 8).isActive = true
        typeValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        typeValue.sizeToFit()
        
        self.view.addSubview(typeIcon)
        typeIcon.centerYAnchor.constraint(equalTo: typeValue.centerYAnchor).isActive = true
        typeIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        typeIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        typeIcon.widthAnchor.constraint(equalTo: typeIcon.heightAnchor).isActive = true
        
        self.view.addSubview(typeLabel)
        typeLabel.centerYAnchor.constraint(equalTo: typeValue.centerYAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: typeIcon.rightAnchor, constant: 12).isActive = true
        typeLabel.sizeToFit()
        
        container.addSubview(issueButton)
        issueButton.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 32).isActive = true
        issueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        issueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        issueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(firstLine)
        firstLine.centerYAnchor.constraint(equalTo: issueButton.topAnchor).isActive = true
        firstLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: issueButton.bottomAnchor).isActive = true
        
    }
    
    func inTransitButton() {
        self.transitButton.alpha = 1
        self.paidButton.alpha = 0
        self.payoutValue.textColor = Theme.GREEN
    }
    
    func madePaymentButton() {
        self.transitButton.alpha = 0
        self.paidButton.alpha = 1
        self.payoutValue.textColor = Theme.BLUE
    }

}
