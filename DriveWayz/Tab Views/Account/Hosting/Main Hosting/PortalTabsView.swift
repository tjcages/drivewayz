//
//  PortalTabsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PortalTabsView: UIView {
    
    var earningsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 36
        let image = UIImage(named: "hostEarningsIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        return button
    }()
    
    var availabilityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 30
        let image = UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        return button
    }()
    
    var accountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 30
        let image = UIImage(named: "hostAccountIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        return button
    }()
    
    var earningsLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("Earnings", for: .normal)
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0.0, y: 16.0)
        
        return button
    }()
    
    var availabilityLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("Availability", for: .normal)
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0.0, y: 16.0)
        
        return button
    }()
    
    var accountLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("Account", for: .normal)
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0.0, y: 16.0)
        
        return button
    }()
    
    var totalEarningsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("$45.23", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.backgroundColor = Theme.HOST_GREEN
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        button.alpha = 0
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(earningsButton)
        addSubview(availabilityButton)
        addSubview(accountButton)
        
        earningsButton.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 72, height: 72)
        earningsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        availabilityButton.anchor(top: topAnchor, left: nil, bottom: nil, right: earningsButton.leftAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 56, width: 60, height: 60)
        
        accountButton.anchor(top: topAnchor, left: earningsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 56, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        addSubview(earningsLabel)
        addSubview(availabilityLabel)
        addSubview(accountLabel)
        
        earningsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        earningsLabel.centerXAnchor.constraint(equalTo: earningsButton.centerXAnchor).isActive = true
        earningsLabel.sizeToFit()
        
        availabilityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        availabilityLabel.centerXAnchor.constraint(equalTo: availabilityButton.centerXAnchor).isActive = true
        availabilityLabel.sizeToFit()
        
        accountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        accountLabel.centerXAnchor.constraint(equalTo: accountButton.centerXAnchor).isActive = true
        accountLabel.sizeToFit()
        
        addSubview(totalEarningsButton)
        totalEarningsButton.centerXAnchor.constraint(equalTo: earningsButton.centerXAnchor).isActive = true
        totalEarningsButton.centerYAnchor.constraint(equalTo: earningsButton.bottomAnchor).isActive = true
        totalEarningsButton.widthAnchor.constraint(equalToConstant: 82).isActive = true
        totalEarningsButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
    }
    
    func animate() {
        UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.earningsButton.alpha = 1
            self.availabilityButton.alpha = 1
            self.accountButton.alpha = 1
            self.earningsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.availabilityButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.accountButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            self.earningsButton.tintColor = Theme.DARK_GRAY
            self.availabilityButton.tintColor = Theme.DARK_GRAY
            self.accountButton.tintColor = Theme.DARK_GRAY
            self.layoutIfNeeded()
        }, completion: { (success) in
            //
        })
        delayWithSeconds(animationOut) {
            UIView.animate(withDuration: animationIn, animations: {
                self.earningsLabel.alpha = 1
                self.availabilityLabel.alpha = 1
                self.accountLabel.alpha = 1
                self.earningsLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                self.availabilityLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                self.accountLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                
                self.totalEarningsButton.alpha = 1
                self.totalEarningsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    func minimize(percent: CGFloat) {
        let amount = 1.0 - 0.8 * percent
        self.earningsButton.transform = CGAffineTransform(scaleX: amount, y: amount)
        self.availabilityButton.transform = CGAffineTransform(scaleX: amount, y: amount)
        self.accountButton.transform = CGAffineTransform(scaleX: amount, y: amount)
        self.totalEarningsButton.transform = CGAffineTransform(scaleX: amount, y: amount)
        if percent >= 0 && percent <= 0.4 {
            let percentage = percent/0.4
            self.earningsButton.alpha = 1 - 1 * percentage
            self.availabilityButton.alpha = 1 - 1 * percentage
            self.accountButton.alpha = 1 - 1 * percentage
            self.totalEarningsButton.alpha = 1 - 1 * percentage
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.alpha = 0
            self.earningsButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.availabilityButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.accountButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
            self.earningsButton.alpha = 0
            self.availabilityButton.alpha = 0
            self.accountButton.alpha = 0
            self.earningsButton.tintColor = Theme.WHITE
            self.availabilityButton.tintColor = Theme.WHITE
            self.accountButton.tintColor = Theme.WHITE
            
            self.earningsLabel.alpha = 0
            self.availabilityLabel.alpha = 0
            self.accountLabel.alpha = 0
            self.earningsLabel.transform = CGAffineTransform(translationX: 0.0, y: 16.0)
            self.availabilityLabel.transform = CGAffineTransform(translationX: 0.0, y: 16.0)
            self.accountLabel.transform = CGAffineTransform(translationX: 0.0, y: 16.0)
            
            self.totalEarningsButton.alpha = 0
            self.totalEarningsButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

