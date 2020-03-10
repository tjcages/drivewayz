//
//  TestHostProfitsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostScrolling {
    func makeScrollViewScroll(_ scrollView: UIScrollView)
    func makeScrollViewEnd(_ scrollView: UIScrollView)
    
    func closeBackground()
}

protocol handlePaymentTransfers {
    func transferInformation(payout: Payouts)
    func transferOptions()
    func closeBackground()
}

class HostProfitsViewController: UIViewController {
    
    var delegate: handleHostingControllers?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Earnings"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.isPagingEnabled = true
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var fullBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -100, width: phoneWidth, height: phoneHeight * 2))
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.4)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.frame
        view.addSubview(blurredEffectView)
        
        return view
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    lazy var profitsOrganizer: ProfitsOrganizerViewController = {
        let controller = ProfitsOrganizerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.setupViews()
        
        return controller
    }()
    
    lazy var profitsWallet: WalletViewController = {
        let controller = WalletViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var profitsChart: ChartViewController = {
        let controller = ChartViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var profitsRefund: TransferViewController = {
        let controller = TransferViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    func observeData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.profitsWallet.setData(userID: userID)
        self.profitsChart.observeData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        setupViews()
        setupControllers()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -phoneWidth).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        scrollView.contentSize = CGSize(width: phoneWidth * 3, height: phoneHeight - 180)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupControllers() {
        
        scrollView.addSubview(profitsWallet.view)
        profitsWallet.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        profitsWallet.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        profitsWallet.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        profitsWallet.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        profitsWallet.profitsOptions.transactionsButton.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        profitsWallet.profitsOptions.editButton.addTarget(self, action: #selector(changePaymentMethod), for: .touchUpInside)
        profitsWallet.profitsOptions.lockButton.addTarget(self, action: #selector(reportProfitsIssue), for: .touchUpInside)
        
        scrollView.addSubview(profitsChart.view)
        profitsChart.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        profitsChart.view.leftAnchor.constraint(equalTo: profitsWallet.view.rightAnchor).isActive = true
        profitsChart.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        profitsChart.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(profitsRefund.view)
        profitsRefund.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        profitsRefund.view.leftAnchor.constraint(equalTo: profitsChart.view.rightAnchor).isActive = true
        profitsRefund.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        profitsRefund.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        profitsRefund.profitsPayments.transferDelegate = self
        profitsRefund.profitsRefund.transferButton.addTarget(self, action: #selector(transferOptions), for: .touchUpInside)
        
        self.view.addSubview(profitsOrganizer.view)
        profitsOrganizer.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profitsOrganizer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        profitsOrganizer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        profitsOrganizer.view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        profitsOrganizer.firstOption.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        profitsOrganizer.secondOption.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        profitsOrganizer.thirdOption.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        
        profitsWallet.profitsOptions.manageButton.addTarget(self, action: #selector(openProfitsPressed), for: .touchUpInside)
        let firstTap = UITapGestureRecognizer(target: self, action: #selector(openProfitsBalance))
        profitsWallet.profitsWallet.view.addGestureRecognizer(firstTap)
        let secondTap = UITapGestureRecognizer(target: self, action: #selector(openProfitsBalance))
        profitsWallet.secondProfitsWallet.view.addGestureRecognizer(secondTap)
        profitsWallet.profitsOptions.linkButton.addTarget(self, action: #selector(linkPaymentMethod), for: .touchUpInside)
        
        self.view.addSubview(dimmingView)
        dimmingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(fullBackgroundView)
        fullBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fullBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fullBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func closeBackground() {
        self.delegate?.openTabBar()
        UIView.animate(withDuration: animationOut) {
            self.fullBackgroundView.alpha = 0
            self.dimmingView.alpha = 0
        }
    }
    
    @objc func backButtonPressed() {
        self.scrollExpanded()
        let title = self.mainLabel.text
        if title == "Payout method" {
            self.profitsWallet.closePaymentMethod()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = ""
                self.backButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.openTabBar()
                UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainLabel.text = "Earnings"
                    self.profitsOrganizer.view.alpha = 1
                }) { (success) in
                    self.delegate?.bringExitButton()
                }
            }
        }
    }
    
    @objc func moveOrganizer(sender: UIButton) {
        if sender == self.profitsOrganizer.firstOption {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if sender == self.profitsOrganizer.secondOption || sender == self.profitsWallet.profitsOptions.transactionsButton {
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0), animated: true)
        } else {
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0), animated: true)
        }
    }
    
}

// Transfer extensions
extension HostProfitsViewController: handlePaymentTransfers {
    
    // Open options to transfer for each payout
    func transferInformation(payout: Payouts) {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            let controller = TransfersInformationViewController()
            controller.transferView.payout = payout
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
            controller.transitStatus()
        }
    }
    
    @objc func transferOptions() {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            let controller = TransfersInformationViewController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
            controller.transitOptions()
        }
    }
    
}

// Wallet extensions
extension HostProfitsViewController {
    
    func firstPaymentTapped(tabBar: Bool) {
        self.profitsWallet.firstPaymentTapped()
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if tabBar { self.delegate?.openTabBar() }
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Earnings"
                self.profitsOrganizer.view.alpha = 1
            }) { (success) in
                self.delegate?.bringExitButton()
            }
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Accounts")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    if let account = dictionary["accountID"] as? String, let accountID = self.profitsWallet.profitsWallet.payoutAccount?.accountID {
                        if account != accountID {
                            if let secondaryAccount = dictionary["secondaryAccountID"] as? String {
                                ref.updateChildValues(["accountID": secondaryAccount, "secondaryAccountID": account])
                            }
                        }
                    }
                }
            })
        }
    }
    
    func secondPaymentTapped() {
        self.profitsWallet.secondPaymentTapped()
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.openTabBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Earnings"
                self.profitsOrganizer.view.alpha = 1
            }) { (success) in
                self.delegate?.bringExitButton()
            }
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Accounts")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    if let secondaryAccount = dictionary["secondaryAccountID"] as? String {
                        if let account = dictionary["accountID"] as? String {
                            ref.updateChildValues(["accountID": secondaryAccount, "secondaryAccountID": account])
                        }
                    }
                }
            })
        }
    }
    
    @objc func changePaymentMethod() {
        self.delegate?.closeTabBar()
        self.profitsWallet.changePaymentMethod()
        self.scrollExpanded()
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.hideExitButton()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Payout method"
                self.backButton.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func linkPaymentMethod() {
        self.delegate?.closeTabBar()
        if self.profitsWallet.profitsWallet.accountLabel.text != "NO ACCOUNT LINKED" {
            self.firstPaymentTapped(tabBar: false)
        }
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 1
        }) { (success) in
            let controller = PayoutOptionsViewController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            controller.profitsWallet.totalEarnings.text = self.profitsWallet.profitsWallet.totalEarnings.text
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func openProfitsPressed() {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 1
        }) { (success) in
            let controller = ExpandedWalletViewController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            if self.profitsWallet.profitsWallet.view.alpha == 1 {
                controller.profitsWallet.accountNumber.text = self.profitsWallet.profitsWallet.accountNumber.text
                controller.profitsWallet.payoutAccount = self.profitsWallet.profitsWallet.payoutAccount
                controller.profitsWallet.totalEarnings.text = self.profitsWallet.profitsWallet.totalEarnings.text
            } else if self.profitsWallet.secondProfitsWallet.view.alpha == 1 {
                controller.profitsWallet.accountNumber.text = self.profitsWallet.secondProfitsWallet.accountNumber.text
                controller.profitsWallet.payoutAccount = self.profitsWallet.secondProfitsWallet.payoutAccount
                controller.profitsWallet.totalEarnings.text = self.profitsWallet.secondProfitsWallet.totalEarnings.text
                let background = CAGradientLayer().customColor(topColor: Theme.DarkGreen, bottomColor: Theme.LightGreen)
                background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.63)
                background.zPosition = -10
                controller.profitsWallet.container.layer.addSublayer(background)
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func openProfitsBalance(sender: UITapGestureRecognizer) {
        if self.mainLabel.text == "Payout method" {
            if sender.view == self.profitsWallet.profitsWallet.view {
                self.firstPaymentTapped(tabBar: true)
            } else if sender.view == self.profitsWallet.secondProfitsWallet.view {
                self.secondPaymentTapped()
            }
        } else {
            self.delegate?.closeTabBar()
            UIView.animate(withDuration: animationIn, animations: {
                self.fullBackgroundView.alpha = 1
            }) { (success) in
                let controller = ExpandedWalletViewController()
                controller.delegate = self
                controller.modalPresentationStyle = .overFullScreen
                if sender.view == self.profitsWallet.secondProfitsWallet.view {
                    let background = CAGradientLayer().customColor(topColor: Theme.DarkGreen, bottomColor: Theme.LightGreen)
                    background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.63)
                    background.zPosition = -10
                    controller.profitsWallet.container.layer.addSublayer(background)
                    controller.profitsWallet.accountNumber.text = self.profitsWallet.secondProfitsWallet.accountNumber.text
                    controller.profitsWallet.payoutAccount = self.profitsWallet.secondProfitsWallet.payoutAccount
                    controller.profitsWallet.totalEarnings.text = self.profitsWallet.secondProfitsWallet.totalEarnings.text
                } else {
                    controller.profitsWallet.accountNumber.text = self.profitsWallet.profitsWallet.accountNumber.text
                    controller.profitsWallet.payoutAccount = self.profitsWallet.profitsWallet.payoutAccount
                    controller.profitsWallet.totalEarnings.text = self.profitsWallet.profitsWallet.totalEarnings.text
                }
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @objc func reportProfitsIssue() {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            let controller = TransfersInformationViewController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            
            controller.receiveButton.setTitle("Wallet balance is incorrect", for: .normal)
            controller.incorrectButton.setTitle("Account information is incorrect", for: .normal)
            controller.transitButton.setTitle("Transfer my money", for: .normal)
            
            self.present(controller, animated: true, completion: nil)
            controller.transitOptions()
        }
    }
    
}


extension HostProfitsViewController: UIScrollViewDelegate, handleHostScrolling {
    
    func resetScrolls() {
        self.profitsWallet.scrollView.setContentOffset(.zero, animated: true)
        self.profitsChart.scrollView.setContentOffset(.zero, animated: true)
        self.profitsRefund.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainLabel.text == "Payout method" {
            self.backButtonPressed()
        }
        let translation = scrollView.contentOffset.x
        self.profitsOrganizer.translation = translation
        let percentage = translation/phoneWidth
        let isInteger = floor(percentage) == percentage
        if isInteger {
            self.scrollExpanded()
        }
    }
    
    func makeScrollViewScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation >= 20 && self.profitsOrganizer.view.alpha == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.profitsOrganizer.view.alpha = 0
                }
            } else if translation <= 20 && self.profitsOrganizer.view.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.profitsOrganizer.view.alpha = 1
                }
            }
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func makeScrollViewEnd(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        self.resetScrolls()
        UIView.animate(withDuration: animationOut, animations: {
            self.profitsOrganizer.view.alpha = 1
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in

        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.profitsOrganizer.view.alpha = 0
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dismissAll() {
        delayWithSeconds(0.4) {
            self.closeBackground()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}
