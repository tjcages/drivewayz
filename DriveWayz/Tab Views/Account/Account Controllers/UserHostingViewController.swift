//
//  UserHostingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostingControllers {
    func handleScrollView(translation: CGFloat)
    func handleEndDragging(translation: CGFloat)
    
    func defaultContentStatusBar()
    func lightContentStatusBar()
    func bringExitButton()
    func hideExitButton()
}

class UserHostingViewController: UIViewController {
    
    var delegate: moveControllers?
    
    var userParking: ParkingSpots?
    var userBookings: [Bookings] = [] {
        didSet {
            self.monitorPreviousBookings()
        }
    }
    var stringDates: [String] = []
    var dateProfits: [Double] = []
    var emptyProfits: [Double] = []
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Hosted spaces"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    lazy var profitsController: HostProfitsViewController = {
        let controller = HostProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var bookingsController: HostBookingsViewController = {
        let controller = HostBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var notificationsController: HostNotificationsViewController = {
        let controller = HostNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var spacesController: HostSpacesViewController = {
        let controller = HostSpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var tabBarBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.6)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 0.5))
        line.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.addSubview(line)
        
        return view
    }()
    
    var profitsTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostProfits")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var profitsTabLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earnings"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    var reservationsTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostBooking")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var reservationsTabLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bookings"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    var notificationsTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostNotification")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var notificationsTabLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notifications"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    var spacesTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostSpaces")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var spacesTabLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Spaces"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    lazy var bankController: NewBankViewController = {
        let controller = NewBankViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var transferController: TransferMoneyViewController = {
        let controller = TransferMoneyViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.clipsToBounds = true

        setupViews()
        setupControllers()
        setupTabBar()
        observeSpotData()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        scrollView.contentSize = CGSize(width: phoneWidth * 4, height: phoneHeight)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
                gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
    }
    
    var bankCenterAnchor: NSLayoutConstraint!
    var transferCenterAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(profitsController.view)
        profitsController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        profitsController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        profitsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        profitsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        profitsController.profitsContainer.transferButton.addTarget(self, action: #selector(transferAccountFunds(sender:)), for: .touchUpInside)
        
        scrollView.addSubview(bookingsController.view)
        bookingsController.view.topAnchor.constraint(equalTo: profitsController.view.topAnchor).isActive = true
        bookingsController.view.leftAnchor.constraint(equalTo: profitsController.view.rightAnchor).isActive = true
        bookingsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        bookingsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(notificationsController.view)
        notificationsController.view.topAnchor.constraint(equalTo: profitsController.view.topAnchor).isActive = true
        notificationsController.view.leftAnchor.constraint(equalTo: bookingsController.view.rightAnchor).isActive = true
        notificationsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        notificationsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(spacesController.view)
        spacesController.view.topAnchor.constraint(equalTo: profitsController.view.topAnchor).isActive = true
        spacesController.view.leftAnchor.constraint(equalTo: notificationsController.view.rightAnchor).isActive = true
        spacesController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        spacesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(bankController.view)
        bankCenterAnchor = bankController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            bankCenterAnchor.isActive = true
        bankController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bankController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        bankController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        bankController.dismissButton.addTarget(self, action: #selector(dismissTransferController), for: .touchUpInside)
        
        
        self.view.addSubview(transferController.view)
        transferCenterAnchor = transferController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            transferCenterAnchor.isActive = true
        transferController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        transferController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        transferController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        transferController.backButton.addTarget(self, action: #selector(dismissTransferController), for: .touchUpInside)
        
    }
    
    var tabBarBottomAnchor: NSLayoutConstraint!
    
    func setupTabBar() {
        
        self.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0.0), animated: false)
        
        self.view.addSubview(tabBarBackground)
        tabBarBottomAnchor = tabBarBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
            tabBarBottomAnchor.isActive = true
        tabBarBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tabBarBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            tabBarBackground.heightAnchor.constraint(equalToConstant: 80).isActive = true
        case .iphoneX:
            tabBarBackground.heightAnchor.constraint(equalToConstant: 92).isActive = true
        }
        
        let spacing = (phoneWidth - 40 * 4)/5
        
        tabBarBackground.addSubview(profitsTabButton)
        profitsTabButton.topAnchor.constraint(equalTo: tabBarBackground.topAnchor, constant: 12).isActive = true
        profitsTabButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: spacing).isActive = true
        profitsTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profitsTabButton.heightAnchor.constraint(equalTo: profitsTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(profitsTabLabel)
        profitsTabLabel.centerXAnchor.constraint(equalTo: profitsTabButton.centerXAnchor).isActive = true
        profitsTabLabel.topAnchor.constraint(equalTo: profitsTabButton.bottomAnchor, constant: -2).isActive = true
        profitsTabLabel.sizeToFit()
        
        tabBarBackground.addSubview(reservationsTabButton)
        reservationsTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        reservationsTabButton.leftAnchor.constraint(equalTo: profitsTabButton.rightAnchor, constant: spacing).isActive = true
        reservationsTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        reservationsTabButton.heightAnchor.constraint(equalTo: reservationsTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(reservationsTabLabel)
        reservationsTabLabel.centerXAnchor.constraint(equalTo: reservationsTabButton.centerXAnchor).isActive = true
        reservationsTabLabel.topAnchor.constraint(equalTo: reservationsTabButton.bottomAnchor, constant: -2).isActive = true
        reservationsTabLabel.sizeToFit()
        
        tabBarBackground.addSubview(notificationsTabButton)
        notificationsTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        notificationsTabButton.leftAnchor.constraint(equalTo: reservationsTabButton.rightAnchor, constant: spacing).isActive = true
        notificationsTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        notificationsTabButton.heightAnchor.constraint(equalTo: notificationsTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(notificationsTabLabel)
        notificationsTabLabel.centerXAnchor.constraint(equalTo: notificationsTabButton.centerXAnchor).isActive = true
        notificationsTabLabel.topAnchor.constraint(equalTo: notificationsTabButton.bottomAnchor, constant: -2).isActive = true
        notificationsTabLabel.sizeToFit()
        
        tabBarBackground.addSubview(spacesTabButton)
        spacesTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        spacesTabButton.leftAnchor.constraint(equalTo: notificationsTabButton.rightAnchor, constant: spacing).isActive = true
        spacesTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        spacesTabButton.heightAnchor.constraint(equalTo: spacesTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(spacesTabLabel)
        spacesTabLabel.centerXAnchor.constraint(equalTo: spacesTabButton.centerXAnchor).isActive = true
        spacesTabLabel.topAnchor.constraint(equalTo: spacesTabButton.bottomAnchor, constant: -2).isActive = true
        spacesTabLabel.sizeToFit()
        
    }
    
    @objc func tabBarButtonPressed(sender: UIButton) {
        self.resetTabBar()
        if sender == profitsTabButton {
            self.mainLabel.text = "Your earnings"
            sender.tintColor = Theme.BLUE
            self.profitsTabLabel.textColor = Theme.BLUE
            self.scrollView.setContentOffset(.zero, animated: false)
        } else if sender == reservationsTabButton {
            self.mainLabel.text = "Your bookings"
            sender.tintColor = Theme.BLUE
            self.reservationsTabLabel.textColor = Theme.BLUE
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0.0), animated: false)
        } else if sender == notificationsTabButton {
            self.mainLabel.text = "Your notifications"
            sender.tintColor = Theme.BLUE
            self.notificationsTabLabel.textColor = Theme.BLUE
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0.0), animated: false)
        } else if sender == spacesTabButton {
            self.mainLabel.text = "Your spaces"
            sender.tintColor = Theme.BLUE
            self.spacesTabLabel.textColor = Theme.BLUE
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 3, y: 0.0), animated: false)
        }
        delayWithSeconds(animationIn) {
            self.resetScrolls()
        }
    }
    
    func resetTabBar() {
        self.profitsTabButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.reservationsTabButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.notificationsTabButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.spacesTabButton.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        self.profitsTabLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.reservationsTabLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.notificationsTabLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        self.spacesTabLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
    func openTabBar() {
        self.tabBarBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeTabBar() {
        self.tabBarBottomAnchor.constant = 100
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
}


extension UserHostingViewController: handleBankTransfers {
    
    @objc func transferAccountFunds(sender: UIButton) {
        self.closeTabBar()
        self.delegate?.hideExitButton()
        self.profitsController.profitsContainer.transferButton.isUserInteractionEnabled = false
        self.profitsController.profitsContainer.transferButton.alpha = 0.5
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let account = dictionary["accountID"] as? String {
                        if let userFunds = dictionary["userFunds"] as? Double {
                            self.delegate?.hideExitButton()
                            self.bringTransferCountroller(accountID: account, userFunds: userFunds)
                        } else {
                            self.profitsController.sendAlert(title: "Not yet", message: "You must first earn funds by having users park in your spot before you can transfer money to your account!")
                            self.profitsController.profitsContainer.transferButton.isUserInteractionEnabled = true
                            self.profitsController.profitsContainer.transferButton.alpha = 1
                        }
                    } else {
                        self.bringBankAccountController()
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func bringTransferCountroller(accountID: String, userFunds: Double) {
        self.transferController.setupAccount(accountID: accountID, userFunds: userFunds)
        self.transferCenterAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.profitsController.profitsContainer.transferButton.isUserInteractionEnabled = true
            self.profitsController.profitsContainer.transferButton.alpha = 1
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    @objc func dismissTransferController() {
        self.bankCenterAnchor.constant = phoneHeight
        self.transferCenterAnchor.constant = phoneHeight
        self.scrollView.setContentOffset(.zero, animated: false)
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.openTabBar()
            self.delegate?.bringExitButton()
            self.profitsController.profitsContainer.transferButton.isUserInteractionEnabled = true
            self.profitsController.profitsContainer.transferButton.alpha = 1
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func bringBankAccountController() {
        self.bankCenterAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.profitsController.profitsContainer.transferButton.isUserInteractionEnabled = true
            self.profitsController.profitsContainer.transferButton.alpha = 1
            self.delegate?.defaultContentStatusBar()
        }
    }
    
}


extension UserHostingViewController: handleHostingControllers {
    
    func handleScrollView(translation: CGFloat) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            if self.backgroundCircle.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.gradientContainer.layer.shadowOpacity = 0
                    self.backgroundCircle.alpha = 1
                }
            }
            if self.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                self.scrollExpanded()
            }
        } else if translation >= 40 && self.backgroundCircle.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.gradientContainer.layer.shadowOpacity = 0.2
                self.backgroundCircle.alpha = 0
            }
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                self.scrollMinimized()
            }
        } else if translation <= 0 {
            if mainLabel.alpha == 1 {
                self.gradientHeightAnchor.constant = totalHeight
                self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    func handleEndDragging(translation: CGFloat) {
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.delegate?.defaultContentStatusBar()
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 160
        case .iphoneX:
            self.gradientHeightAnchor.constant = 180
        }
        self.resetScrolls()
        UIView.animate(withDuration: animationIn, animations: {
            self.backgroundCircle.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.mainLabel.textColor = Theme.DARK_GRAY
            self.view.layoutIfNeeded()
        }) { (success) in
            self.resetScrolls()
        }
    }
    
    func resetScrolls() {
        self.profitsController.scrollView.setContentOffset(.zero, animated: false)
        self.bookingsController.scrollView.setContentOffset(.zero, animated: false)
        self.spacesController.scrollView.setContentOffset(.zero, animated: false)
    }
    
    func scrollMinimized() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
    func defaultContentStatusBar() {
        self.delegate?.defaultContentStatusBar()
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    func bringExitButton() {
        self.scrollView.isScrollEnabled = true
        self.delegate?.bringExitButton()
        self.scrollExpanded()
        self.openTabBar()
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideExitButton() {
        self.scrollView.isScrollEnabled = false
        self.delegate?.hideExitButton()
        self.closeTabBar()
        self.gradientHeightAnchor.constant = 0
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}


extension UserHostingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        if translation == 0 {
            self.resetTabBar()
            self.mainLabel.text = "Your earnings"
            self.profitsTabButton.tintColor = Theme.BLUE
            self.profitsTabLabel.textColor = Theme.BLUE
            self.bringMainLabel()
        } else if translation == phoneWidth {
            self.resetTabBar()
            self.mainLabel.text = "Your bookings"
            self.reservationsTabButton.tintColor = Theme.BLUE
            self.reservationsTabLabel.textColor = Theme.BLUE
            self.bringMainLabel()
        } else if translation == phoneWidth * 2 {
            self.resetTabBar()
            self.mainLabel.text = "Your notifications"
            self.notificationsTabButton.tintColor = Theme.BLUE
            self.notificationsTabLabel.textColor = Theme.BLUE
            self.bringMainLabel()
        } else if translation == phoneWidth * 3 {
            self.resetTabBar()
            self.mainLabel.text = "Your spaces"
            self.spacesTabButton.tintColor = Theme.BLUE
            self.spacesTabLabel.textColor = Theme.BLUE
            self.bringMainLabel()
        } else {
            UIView.animate(withDuration: animationIn) {
                self.mainLabel.alpha = 0
            }
        }
    }
    
    func bringMainLabel() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        if translation == 0 {
            self.mainLabel.text = "Your earnings"
        } else if translation == phoneWidth {
            self.mainLabel.text = "Your bookings"
        } else if translation == phoneWidth * 2 {
            self.mainLabel.text = "Your notifications"
        } else if translation == phoneWidth * 3 {
            self.mainLabel.text = "Your spaces"
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 1
        }
    }
    
}
