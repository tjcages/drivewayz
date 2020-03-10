//
//  TransfersInformationViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol changeTransferOptions {
    func changeOptionsHeight(amount: CGFloat)
    func dismissView()
}

class TransfersInformationViewController: UIViewController {

    var delegate: handlePaymentTransfers?
    var bottomAnchor: CGFloat = 0.0
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    var issueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Have a different issue", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(optionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var receiveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Did not receive payment", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(optionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var incorrectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Payout information is incorrect", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(optionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var transitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Why is my payout in transit?", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(optionsPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var thirdLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var fourthLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var fifthLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
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
    
    lazy var transferView: TransfersStatusViewController = {
        let controller = TransfersStatusViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var transferOptions: TransfersOptionsViewController = {
        let controller = TransfersOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        setupLines()
        setupController()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(dimView)
        self.view.addSubview(container)
        
        self.view.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        
        container.addSubview(issueButton)
        issueButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16).isActive = true
        issueButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        issueButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        issueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(receiveButton)
        receiveButton.bottomAnchor.constraint(equalTo: issueButton.topAnchor).isActive = true
        receiveButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        receiveButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        receiveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(incorrectButton)
        incorrectButton.bottomAnchor.constraint(equalTo: receiveButton.topAnchor).isActive = true
        incorrectButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        incorrectButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        incorrectButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(transitButton)
        transitButton.bottomAnchor.constraint(equalTo: incorrectButton.topAnchor).isActive = true
        transitButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        transitButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        transitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func setupLines() {
        
        container.addSubview(firstLine)
        firstLine.centerYAnchor.constraint(equalTo: issueButton.bottomAnchor).isActive = true
        firstLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.addSubview(secondLine)
        secondLine.centerYAnchor.constraint(equalTo: receiveButton.bottomAnchor).isActive = true
        secondLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        secondLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        secondLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.addSubview(thirdLine)
        thirdLine.centerYAnchor.constraint(equalTo: incorrectButton.bottomAnchor).isActive = true
        thirdLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        thirdLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        thirdLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.addSubview(fourthLine)
        fourthLine.centerYAnchor.constraint(equalTo: transitButton.bottomAnchor).isActive = true
        fourthLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        fourthLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        fourthLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.addSubview(fifthLine)
        fifthLine.centerYAnchor.constraint(equalTo: transitButton.topAnchor).isActive = true
        fifthLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        fifthLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        fifthLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
    }
    
    var transferOptionsHeightAnchor: NSLayoutConstraint!
    var containerNormalAnchor: NSLayoutConstraint!
    var containerOptionsAnchor: NSLayoutConstraint!
    var pullButtonStatusAnchor: NSLayoutConstraint!
    var pullButtonOptionsAnchor: NSLayoutConstraint!
    
    func setupController() {
        
        self.view.addSubview(transferView.view)
        transferView.view.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16).isActive = true
        transferView.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        transferView.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        transferView.view.heightAnchor.constraint(equalToConstant: 350).isActive = true
        transferView.issueButton.addTarget(self, action: #selector(transitOptions), for: .touchUpInside)
        
        self.view.addSubview(transferOptions.view)
        transferOptions.view.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16).isActive = true
        transferOptions.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        transferOptions.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        transferOptionsHeightAnchor = transferOptions.view.heightAnchor.constraint(equalToConstant: 274)
            transferOptionsHeightAnchor.isActive = true
        
        self.view.addSubview(pullButton)
        pullButtonStatusAnchor = pullButton.bottomAnchor.constraint(equalTo: transferView.view.topAnchor, constant: -16)
            pullButtonStatusAnchor.isActive = true
        pullButtonOptionsAnchor = pullButton.bottomAnchor.constraint(equalTo: transitButton.topAnchor, constant: -16)
            pullButtonOptionsAnchor.isActive = false
        pullButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        container.bottomAnchor.constraint(equalTo: issueButton.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        containerNormalAnchor = container.topAnchor.constraint(equalTo: transitButton.topAnchor)
            containerNormalAnchor.isActive = true
        containerOptionsAnchor = container.topAnchor.constraint(equalTo: transferOptions.view.topAnchor)
            containerOptionsAnchor.isActive = false
        
    }
    
    func transitStatus() {
        self.pullButtonOptionsAnchor.isActive = false
        self.pullButtonStatusAnchor.isActive = true
        UIView.animate(withDuration: animationIn) {
            self.transferView.view.alpha = 1
            self.transferOptions.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func transitOptions() {
        self.pullButtonOptionsAnchor.isActive = true
        self.pullButtonStatusAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.transferView.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func optionsPressed(sender: UIButton) {
        // Determine which payout issue the user is experiencing
        guard let title = sender.titleLabel?.text else { return }
        if title == "Why is my payout in transit?" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[0]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[0]
            self.transferOptions.mainButton.alpha = 0
            self.transferOptionsHeightAnchor.constant = 282
            self.transferOptions.noMessage()
        } else if title == "Payout information is incorrect" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[1]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[1]
            self.transferOptionsHeightAnchor.constant = 315
            self.transferOptions.mainButton.alpha = 1
            self.transferOptions.noMessage()
        } else if title == "Did not receive payment" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[2]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[2]
            self.transferOptionsHeightAnchor.constant = 316
            self.transferOptions.mainButton.alpha = 1
            self.transferOptions.noMessage()
        } else if title == "Have a different issue" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[3]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[3]
            self.transferOptionsHeightAnchor.constant = 276
            self.transferOptions.mainButton.alpha = 0
            self.transferOptions.typingMessage()
        } else if title == "Transfer my money" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[4]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[4]
            self.transferOptionsHeightAnchor.constant = 212
            self.transferOptions.mainButton.alpha = 0
            self.transferOptions.noMessage()
        } else if title == "Account information is incorrect" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[5]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[5]
            self.transferOptionsHeightAnchor.constant = 316
            self.transferOptions.mainButton.alpha = 1
            self.transferOptions.noMessage()
        } else if title == "Wallet balance is incorrect" {
            self.transferOptions.mainLabel.text = self.transferOptions.mainArray[6]
            self.transferOptions.subLabel.text = self.transferOptions.subArray[6]
            self.transferOptionsHeightAnchor.constant = 262
            self.transferOptions.mainButton.alpha = 1
            self.transferOptions.noMessage()
        }
        
        self.containerNormalAnchor.isActive = false
        self.containerOptionsAnchor.isActive = true
        UIView.animate(withDuration: animationOut, animations: {
            self.transferView.view.alpha = 0
            self.pullButton.alpha = 0
            self.transitButton.alpha = 0
            self.incorrectButton.alpha = 0
            self.receiveButton.alpha = 0
            self.issueButton.alpha = 0
            self.secondLine.alpha = 0
            self.thirdLine.alpha = 0
            self.fourthLine.alpha = 0
            self.fifthLine.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.cancelButton.setTitle("Back", for: .normal)
            UIView.animate(withDuration: animationOut, animations: {
                self.transferOptions.view.alpha = 1
            })
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
        self.view.endEditing(true)
        if self.containerNormalAnchor.isActive == true {
            self.delegate?.closeBackground()
            self.dismiss(animated: true, completion: nil)
        } else {
            self.containerNormalAnchor.isActive = true
            self.containerOptionsAnchor.isActive = false
            self.transferOptionsHeightAnchor.constant = 274
            UIView.animate(withDuration: animationOut, animations: {
                self.transferOptions.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.cancelButton.setTitle("Cancel", for: .normal)
                UIView.animate(withDuration: animationOut, animations: {
                    self.transitButton.alpha = 1
                    self.incorrectButton.alpha = 1
                    self.receiveButton.alpha = 1
                    self.issueButton.alpha = 1
                    self.secondLine.alpha = 1
                    self.thirdLine.alpha = 1
                    self.fourthLine.alpha = 1
                    self.fifthLine.alpha = 1
                    self.pullButton.alpha = 1
                })
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension TransfersInformationViewController: changeTransferOptions {
    
    func changeOptionsHeight(amount: CGFloat) {
        self.transferOptionsHeightAnchor.constant = self.transferOptionsHeightAnchor.constant + amount
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}
