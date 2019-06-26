//
//  MySpotsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostingReservations {
    func darkContentStatusBar()
    func lightContentStatusBar()
    func hostingPreviousPressed(booking: Bookings, parking: ParkingSpots)
    func returnReservationsPressed()
    func hostingExpandedPressed()
    func returnExpandedPressed()
    
    func dismissTransferController()
    func bringTransferCountroller(accountID: String, userFunds: Double)
    func bringNofiticationsController()
    func resetNotificationHeight()
}

class MySpotsViewController: UIViewController {
    
    var delegate: moveControllers?
    var userParking: ParkingSpots?
    var userBookings: [Bookings] = [] {
        didSet {
//            self.bookingsController.monitorPreviousBookings()
        }
    }
    var stringDates: [String] = []
    var dateProfits: [Double] = []
    var emptyProfits: [Double] = []
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
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
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        view.decelerationRate = .fast
        
        return view
    }()
    
    var profitsContainer: MyProfitsViewController = {
        let controller = MyProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var reservationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bookings"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var reservationsContainer: MyOngoingViewController = {
        let controller = MyOngoingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var notificationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notifications"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    lazy var notificationsContainer: MyNotificationsViewController = {
        let controller = MyNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.delegate = self
        
        return controller
    }()
    
    var hostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My parking spaces"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var hostContainer: MySpacesViewController = {
        let controller = MySpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var profitsDateContainer: ProfitsDateViewController = {
        let controller = ProfitsDateViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    var profitsEarningsContainer: ProfitsEarningsViewController = {
        let controller = ProfitsEarningsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var reservationsTableContainer: ReservationsTableViewController = {
        let controller = ReservationsTableViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
//        controller.delegate = self
        
        return controller
    }()
    
    lazy var hostingPreviousContainer: HostingPreviousViewController = {
        let controller = HostingPreviousViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
//        controller.delegate = self
        
        return controller
    }()
    
    lazy var hostingExpandedContainer: HostingExpandedViewController = {
        let controller = HostingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var bankController: NewBankViewController = {
        let controller = NewBankViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.delegate = self
        
        return controller
    }()
    
    lazy var transferController: TransferMoneyViewController = {
        let controller = TransferMoneyViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.clipsToBounds = true
        
        view.backgroundColor = Theme.OFF_WHITE

        setupViews()
        setupControllers()
//        observeSpotData()
    }

    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true

        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1100)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        
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
        
    }
    
    var profitsHeightAnchor: NSLayoutConstraint!
    var profitsDateTopAnchor: NSLayoutConstraint!
    var reservationsTopAnchor: NSLayoutConstraint!
    var hostingPreviousTopAnchor: NSLayoutConstraint!
    var hostingExpandedTopAnchor: NSLayoutConstraint!
    var bankCenterAnchor: NSLayoutConstraint!
    var transferCenterAnchor: NSLayoutConstraint!
    
    var openReservationAnchor: NSLayoutConstraint!
    var closeReservationAnchor: NSLayoutConstraint!
    var openNotificationsAnchor: NSLayoutConstraint!
    var closeNotificationsAnchor: NSLayoutConstraint!
    var notificiationHeightAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(profitsContainer.view)
        profitsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsHeightAnchor = profitsContainer.view.heightAnchor.constraint(equalToConstant: 168)
            profitsHeightAnchor.isActive = true
        profitsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        let profitsTap = UITapGestureRecognizer(target: self, action: #selector(expandProfitsContainer))
        profitsContainer.view.addGestureRecognizer(profitsTap)
        profitsContainer.transferButton.addTarget(self, action: #selector(transferAccountFunds(sender:)), for: .touchUpInside)
        
        self.view.addSubview(reservationsLabel)
        reservationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        reservationsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        reservationsLabel.topAnchor.constraint(equalTo: profitsContainer.view.bottomAnchor, constant: 20).isActive = true
        reservationsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(reservationsContainer.view)
        reservationsContainer.view.topAnchor.constraint(equalTo: reservationsLabel.bottomAnchor, constant: 8).isActive = true
        reservationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        reservationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        openReservationAnchor = reservationsContainer.view.heightAnchor.constraint(equalToConstant: 204)
            openReservationAnchor.isActive = false
        closeReservationAnchor = reservationsContainer.view.heightAnchor.constraint(equalToConstant: 128)
            closeReservationAnchor.isActive = true
        let reservationsTap = UITapGestureRecognizer(target: self, action: #selector(expandReservationsContainer))
        reservationsContainer.view.addGestureRecognizer(reservationsTap)
        
        self.view.addSubview(notificationsLabel)
        notificationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        notificationsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        notificationsLabel.topAnchor.constraint(equalTo: reservationsContainer.view.bottomAnchor, constant: 20).isActive = true
        notificationsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(notificationsContainer.view)
        closeNotificationsAnchor = notificationsContainer.view.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 8)
            closeNotificationsAnchor.isActive = true
        openNotificationsAnchor = notificationsContainer.view.topAnchor.constraint(equalTo: profitsContainer.view.topAnchor)
            openNotificationsAnchor.isActive = false
        notificationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        notificationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        notificiationHeightAnchor = notificationsContainer.view.heightAnchor.constraint(equalToConstant: notificationsContainer.notificationHeightAnchor.constant)
            notificiationHeightAnchor.isActive = true
        
        self.view.addSubview(hostLabel)
        self.view.bringSubviewToFront(gradientContainer)
        self.view.bringSubviewToFront(mainLabel)
        hostLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        hostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        hostLabel.topAnchor.constraint(equalTo: notificationsContainer.view.bottomAnchor, constant: 20).isActive = true
        hostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(hostContainer.view)
        hostContainer.view.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 8).isActive = true
        hostContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        hostContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        hostContainer.view.heightAnchor.constraint(equalToConstant: 192).isActive = true
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(hostingExpandedPressed))
        hostContainer.view.addGestureRecognizer(hostTap)
        
        scrollView.addSubview(profitsDateContainer.view)
        profitsDateTopAnchor = profitsDateContainer.view.topAnchor.constraint(equalTo: profitsContainer.view.bottomAnchor, constant: phoneHeight + 12)
            profitsDateTopAnchor.isActive = true
        profitsDateContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsDateContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsDateContainer.view.heightAnchor.constraint(equalToConstant: 460).isActive = true
        
        scrollView.addSubview(profitsEarningsContainer.view)
        profitsEarningsContainer.view.topAnchor.constraint(equalTo: profitsDateContainer.view.bottomAnchor, constant: 12).isActive = true
        profitsEarningsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsEarningsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsEarningsContainer.view.heightAnchor.constraint(equalToConstant: 142).isActive = true
        
        self.view.addSubview(reservationsTableContainer.view)
        reservationsTopAnchor = reservationsTableContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            reservationsTopAnchor.isActive = true
        reservationsTableContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        reservationsTableContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        reservationsTableContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight - 120).isActive = true
        
        self.view.addSubview(hostingPreviousContainer.view)
        hostingPreviousTopAnchor = hostingPreviousContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            hostingPreviousTopAnchor.isActive = true
        hostingPreviousContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostingPreviousContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostingPreviousContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        
        self.view.addSubview(hostingExpandedContainer.view)
        hostingExpandedTopAnchor = hostingExpandedContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            hostingExpandedTopAnchor.isActive = true
        hostingExpandedContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostingExpandedContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostingExpandedContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        
        self.view.addSubview(bankController.view)
        bankCenterAnchor = bankController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            bankCenterAnchor.isActive = true
        bankController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bankController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        bankController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        self.view.addSubview(transferController.view)
        self.view.bringSubviewToFront(backButton)
        transferCenterAnchor = transferController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            transferCenterAnchor.isActive = true
        transferController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        transferController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        transferController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
    }
    
    @objc func transferAccountFunds(sender: UIButton) {
        self.profitsContainer.transferButton.isUserInteractionEnabled = false
        self.profitsContainer.transferButton.alpha = 0.5
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let account = dictionary["accountID"] as? String {
                        if let userFunds = dictionary["userFunds"] as? Double {
                            self.bringTransferCountroller(accountID: account, userFunds: userFunds)
                        } else {
                            self.sendAlert(title: "Not yet", message: "You must first earn funds by having users park in your spot before you can transfer money to your account!")
                            self.profitsContainer.transferButton.isUserInteractionEnabled = true
                            self.profitsContainer.transferButton.alpha = 1
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
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            self.profitsContainer.transferButton.isUserInteractionEnabled = true
            self.profitsContainer.transferButton.alpha = 1
            self.delegate?.defaultContentStatusBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.backButton.tintColor = Theme.DARK_GRAY
            }, completion: nil)
        }
    }
    
    func bringBankAccountController() {
        self.bankCenterAnchor.constant = 0
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            self.profitsContainer.transferButton.isUserInteractionEnabled = true
            self.profitsContainer.transferButton.alpha = 1
            self.delegate?.defaultContentStatusBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.backButton.tintColor = Theme.DARK_GRAY
            }, completion: nil)
        }
    }

    func dismissTransferController() {
        self.bankCenterAnchor.constant = phoneHeight
        self.transferCenterAnchor.constant = phoneHeight
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            self.profitsContainer.transferButton.isUserInteractionEnabled = true
            self.profitsContainer.transferButton.alpha = 1
            self.delegate?.defaultContentStatusBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Hosted spaces"
                self.backButton.tintColor = Theme.DARK_GRAY
            }, completion: nil)
        }
    }
    
    func bringNofiticationsController() {
        self.openNotificationsAnchor.isActive = true
        self.closeNotificationsAnchor.isActive = false
        self.notificiationHeightAnchor.constant = self.notificationsContainer.notificationsTableView.contentSize.height
        self.scrollView.setContentOffset(.zero, animated: true)
        self.notificationsContainer.notificationsTableView.reloadData()
        self.delegate?.hideExitButton()
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.profitsContainer.view.alpha = 0
            self.reservationsContainer.view.alpha = 0
            self.hostLabel.alpha = 0
            self.hostContainer.view.alpha = 0
            self.notificationsLabel.alpha = 0
            self.reservationsLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Notifications"
                self.backButton.tintColor = Theme.DARK_GRAY
                self.backButton.alpha = 1
            }, completion: nil)
        }
    }

    func dismissNofiticationsController() {
        self.openNotificationsAnchor.isActive = false
        self.closeNotificationsAnchor.isActive = true
        self.resetNotificationHeight()
        self.notificationsContainer.notificationsTableView.reloadData()
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Hosted spaces"
                self.profitsContainer.view.alpha = 1
                self.reservationsContainer.view.alpha = 1
                self.hostLabel.alpha = 1
                self.hostContainer.view.alpha = 1
                self.notificationsLabel.alpha = 1
                self.reservationsLabel.alpha = 1
            }, completion: nil)
        }
    }
    
    func resetNotificationHeight() {
        self.notificiationHeightAnchor.constant = self.notificationsContainer.notificationHeightAnchor.constant
        self.view.layoutIfNeeded()
    }
    
}

extension MySpotsViewController: handleHostingReservations {
    
    func darkContentStatusBar() {
        self.delegate?.defaultContentStatusBar()
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    @objc func backButtonPressed() {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        self.view.endEditing(true)
        self.gradientHeightAnchor.constant = totalHeight
        self.gradientContainer.isHidden = false
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1100)
        self.profitsHeightAnchor.constant = 168
        self.profitsDateTopAnchor.constant = phoneHeight + 24
        self.reservationsTopAnchor.constant = phoneHeight
        self.bankCenterAnchor.constant = phoneHeight
        self.transferCenterAnchor.constant = phoneHeight
        self.dismissNofiticationsController()
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.backButton.alpha = 0
            self.backButton.tintColor = Theme.DARK_GRAY
            self.profitsContainer.transferButton.alpha = 0
            self.profitsDateContainer.view.alpha = 0
            self.profitsEarningsContainer.view.alpha = 0
            self.reservationsTableContainer.view.alpha = 0
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
            self.view.layoutIfNeeded()
        }) { (success) in
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            self.delegate?.defaultContentStatusBar()
            self.delegate?.bringExitButton()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Hosted spaces"
                self.mainLabel.alpha = 1
                self.reservationsContainer.view.alpha = 1
                self.notificationsLabel.alpha = 1
                self.reservationsLabel.alpha = 1
                self.notificationsContainer.view.alpha = 1
                self.profitsContainer.view.alpha = 1
                self.hostContainer.view.alpha = 1
                self.hostLabel.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func expandProfitsContainer() {
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        if self.profitsHeightAnchor.constant == 168 {
            self.profitsHeightAnchor.constant = 96
            self.profitsDateTopAnchor.constant = 12
            self.delegate?.hideExitButton()
            UIView.animate(withDuration: animationOut, animations: {
                self.reservationsContainer.view.alpha = 0
                self.notificationsLabel.alpha = 0
                self.reservationsLabel.alpha = 0
                self.notificationsContainer.view.alpha = 0
                self.hostLabel.alpha = 0
                self.hostContainer.view.alpha = 0
                self.profitsDateContainer.view.alpha = 1
                self.profitsEarningsContainer.view.alpha = 1
                self.profitsContainer.transferButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
                UIView.animate(withDuration: animationOut, animations: {
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1100)
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            self.profitsHeightAnchor.constant = 168
            self.profitsDateTopAnchor.constant = phoneHeight + 24
            UIView.animate(withDuration: animationOut, animations: {
                self.backButton.alpha = 0
                self.profitsContainer.transferButton.alpha = 0
                self.profitsDateContainer.view.alpha = 0
                self.profitsEarningsContainer.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.bringExitButton()
                UIView.animate(withDuration: animationIn, animations: {
                    self.reservationsContainer.view.alpha = 1
                    self.notificationsLabel.alpha = 1
                    self.reservationsLabel.alpha = 1
                    self.notificationsContainer.view.alpha = 1
                    self.hostLabel.alpha = 1
                    self.hostContainer.view.alpha = 1
                })
            }
        }
    }
    
    @objc func expandReservationsContainer() {
        if self.reservationsTopAnchor.constant == phoneHeight {
            self.reservationsTopAnchor.constant = 0
            self.delegate?.hideExitButton()
            self.scrollView.setContentOffset(.zero, animated: true)
            UIView.animate(withDuration: animationOut, animations: {
                self.mainLabel.alpha = 0
                self.backButton.alpha = 1
                self.reservationsTableContainer.view.alpha = 1
                self.profitsContainer.view.alpha = 0
                self.reservationsContainer.view.alpha = 0
                self.notificationsContainer.view.alpha = 0
                self.notificationsLabel.alpha = 0
                self.reservationsLabel.alpha = 0
                self.hostContainer.view.alpha = 0
                self.hostLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.gradientContainer.isHidden = true
                self.scrollView.isScrollEnabled = false
            }
        }
    }
    
    func hostingPreviousPressed(booking: Bookings, parking: ParkingSpots) {
        self.hostingPreviousContainer.setData(booking: booking, parking: parking)
        self.hostingPreviousTopAnchor.constant = -statusHeight
        self.delegate?.defaultContentStatusBar()
        self.delegate?.hideExitButton()
        UIView.animate(withDuration: animationOut) {
            self.backButton.alpha = 0
            self.hostingPreviousContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func returnReservationsPressed() {
        self.hostingPreviousTopAnchor.constant = phoneHeight
        UIView.animate(withDuration: animationOut) {
            self.backButton.alpha = 1
            self.hostingPreviousContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hostingExpandedPressed() {
        self.hostingExpandedTopAnchor.constant = -statusHeight
        self.delegate?.hideExitButton()
        self.scrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationOut) {
            self.profitsContainer.view.alpha = 0
            self.reservationsContainer.view.alpha = 0
            self.notificationsLabel.alpha = 0
            self.reservationsLabel.alpha = 0
            self.notificationsContainer.view.alpha = 0
            self.hostLabel.alpha = 0
            self.hostContainer.view.alpha = 0
            self.hostingExpandedContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func returnExpandedPressed() {
        self.hostingExpandedTopAnchor.constant = phoneHeight
        self.scrollView.isScrollEnabled = true
        self.lightContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.profitsContainer.view.alpha = 1
            self.reservationsContainer.view.alpha = 1
            self.notificationsLabel.alpha = 1
            self.reservationsLabel.alpha = 1
            self.notificationsContainer.view.alpha = 1
            self.hostLabel.alpha = 1
            self.hostContainer.view.alpha = 1
            self.hostingExpandedContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }
        self.delegate?.bringExitButton()
    }
    
    func openCurrentReservation() {
        self.openReservationAnchor.isActive = true
        self.closeReservationAnchor.isActive = false
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeCurrentReservation() {
        self.openReservationAnchor.isActive = false
        self.closeReservationAnchor.isActive = true
        self.reservationsContainer.reservationLabel.text = "Previous booking"
        self.reservationsContainer.reservationLabel.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.7)
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}


extension MySpotsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
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
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.delegate?.defaultContentStatusBar()
        self.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
        }
    }
    
    func scrollMinimized() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.backgroundCircle.alpha = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
