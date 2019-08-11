//
//  ExpandedWalletViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedWalletViewController: UIViewController, handlePayoutOptions {
    
    var delegate: handleHostScrolling?
    var bottomAnchor: CGFloat = 0.0

    lazy var profitsWallet: ProfitsWalletViewController = {
        let controller = ProfitsWalletViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var profitsOptions: ExpandedOptionsWalletViewController = {
        let controller = ExpandedOptionsWalletViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
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
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(profitsOptions.view)
        profitsOptions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsOptions.view.heightAnchor.constraint(equalToConstant: 196).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = profitsOptions.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = profitsOptions.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        profitsOptions.deleteButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        profitsOptions.manageButton.addTarget(self, action: #selector(transferPressed), for: .touchUpInside)

        self.view.addSubview(profitsWallet.view)
        profitsWallet.view.bottomAnchor.constraint(equalTo: profitsOptions.view.topAnchor, constant: -16).isActive = true
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
    
    @objc func transferPressed() {
        if self.profitsWallet.payoutAccount != nil {
            let controller = TransferMoneyViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            let controller = NewBankViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
