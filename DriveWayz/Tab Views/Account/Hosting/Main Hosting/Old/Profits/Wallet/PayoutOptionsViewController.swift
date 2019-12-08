//
//  PayoutOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handlePayoutOptions {
    func dismissAll()
}

class PayoutOptionsViewController: UIViewController, handlePayoutOptions {
    
    var delegate: handleHostScrolling?
    var bottomAnchor: CGFloat = 0.0

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var bankButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Add bank account", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(bankPressed), for: .touchUpInside)
        
        return button
    }()
    
    var debitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Add debit card", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(debitPressed), for: .touchUpInside)
        
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 8
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    lazy var profitsWallet: ProfitsWalletViewController = {
        let controller = ProfitsWalletViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.accountLabel.text = "ADD A NEW ACCOUNT"
        
        return controller
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(deleteButton)
        self.view.addSubview(container)
        deleteButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = deleteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = deleteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        
        container.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -16).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        container.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        container.addSubview(bankButton)
        bankButton.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        bankButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        bankButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        bankButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(debitButton)
        debitButton.topAnchor.constraint(equalTo: bankButton.bottomAnchor).isActive = true
        debitButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        debitButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        debitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(firstLine)
        firstLine.centerYAnchor.constraint(equalTo: bankButton.bottomAnchor).isActive = true
        firstLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        self.view.addSubview(profitsWallet.view)
        profitsWallet.view.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        profitsWallet.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsWallet.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        profitsWallet.view.heightAnchor.constraint(equalToConstant: phoneWidth * 0.63).isActive = true
        
        self.view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: profitsWallet.view.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
    }
    
    @objc func bankPressed() {
        let controller = NewBankViewController()
//        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func debitPressed() {
        
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                self.dismissView()
            }
        } else if state == .ended {
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                self.dismissView()
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        self.delegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissAll() {
        delayWithSeconds(0.4) {
            self.delegate?.closeBackground()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
}
