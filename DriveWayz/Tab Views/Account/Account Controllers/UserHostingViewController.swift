//
//  UserHostingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostingControllers {
    func defaultContentStatusBar()
    func lightContentStatusBar()
    func bringExitButton()
    func hideExitButton()
    
    func moveToProfits()
    func moveToBookings()
    func moveToInbox()
    func moveToNotifications()
    func moveToSpaces()
    
    func openTabBar()
    func closeTabBar()
}

class UserHostingViewController: UIViewController {
    
    var delegate: moveControllers?
    var statusBarColor = true
    var spacing: CGFloat = 0.0
    var previousSelection: CGFloat = 0.0
    var previousSelectionCenter: CGFloat = 0.0
    
    var userParking: ParkingSpots?
//    var userBookings: [Bookings] = [] {
//        didSet {
//            self.monitorPreviousBookings()
//        }
//    }
    var stringDates: [String] = []
    var dateProfits: [Double] = []
    var emptyProfits: [Double] = []
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.isScrollEnabled = false
        
        return view
    }()
    
    lazy var profitsController: HostProfitsViewController = {
        let controller = HostProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var bookingsController: HostBookingsViewController = {
        let controller = HostBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var inboxController: HostInboxViewController = {
        let controller = HostInboxViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var notificationsController: HostNotificationsViewController = {
        let controller = HostNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var spacesController: HostSpacesViewController = {
        let controller = HostSpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var tabBarBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 0.75))
        line.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        view.addSubview(line)
        
        return view
    }()
    
    var tabBarSelector: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var profitsTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostProfits")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var profitsTabSelected: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostProfitsSelected")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var reservationsTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostBooking")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var reservationTabSelected: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostBookingSelected")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var inboxTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostInbox")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var inboxTabSelected: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostInboxSelected")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var notificationsTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostNotification")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var notificationsTabSelected: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostNofiticationSelected")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.alpha = 0
        
        return button
    }()
    
    var spacesTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostSpaces")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        return button
    }()
    
    var spacesTabSelected: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tabBarButtonPressed(sender:)), for: .touchUpInside)
        let origImage = UIImage(named: "hostSpacesSelected")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE.withAlphaComponent(0.4)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.alpha = 0
        
        return button
    }()
    
    func setData() {
        self.profitsController.observeData()
        self.bookingsController.observeData()
        self.notificationsController.observeData()
        self.spacesController.observeData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true

        setupViews()
        setupControllers()
        setupTabBar()
        monitorForDeletion()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {

        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth * 5, height: phoneHeight)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }
    
    var tabBarBottomAnchor: NSLayoutConstraint!
    var selectionLineCenterAnchor: NSLayoutConstraint!
    
    func setupTabBar() {
        
        self.view.addSubview(tabBarBackground)
        tabBarBottomAnchor = tabBarBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
        tabBarBottomAnchor.isActive = true
        tabBarBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tabBarBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            tabBarBackground.heightAnchor.constraint(equalToConstant: 64).isActive = true
        case .iphoneX:
            tabBarBackground.heightAnchor.constraint(equalToConstant: 76).isActive = true
        }
        
        spacing = (phoneWidth - 40 * 5)/6
        
        tabBarBackground.addSubview(profitsTabSelected)
        profitsTabSelected.topAnchor.constraint(equalTo: tabBarBackground.topAnchor, constant: 12).isActive = true
        profitsTabSelected.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: spacing).isActive = true
        profitsTabSelected.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profitsTabSelected.heightAnchor.constraint(equalTo: profitsTabSelected.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(profitsTabButton)
        profitsTabButton.topAnchor.constraint(equalTo: tabBarBackground.topAnchor, constant: 12).isActive = true
        profitsTabButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: spacing).isActive = true
        profitsTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profitsTabButton.heightAnchor.constraint(equalTo: profitsTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(reservationTabSelected)
        reservationTabSelected.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        reservationTabSelected.leftAnchor.constraint(equalTo: profitsTabButton.rightAnchor, constant: spacing).isActive = true
        reservationTabSelected.widthAnchor.constraint(equalToConstant: 40).isActive = true
        reservationTabSelected.heightAnchor.constraint(equalTo: reservationTabSelected.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(reservationsTabButton)
        reservationsTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        reservationsTabButton.leftAnchor.constraint(equalTo: profitsTabButton.rightAnchor, constant: spacing).isActive = true
        reservationsTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        reservationsTabButton.heightAnchor.constraint(equalTo: reservationsTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(inboxTabSelected)
        inboxTabSelected.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        inboxTabSelected.leftAnchor.constraint(equalTo: reservationsTabButton.rightAnchor, constant: spacing).isActive = true
        inboxTabSelected.widthAnchor.constraint(equalToConstant: 40).isActive = true
        inboxTabSelected.heightAnchor.constraint(equalTo: inboxTabSelected.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(inboxTabButton)
        inboxTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        inboxTabButton.leftAnchor.constraint(equalTo: reservationsTabButton.rightAnchor, constant: spacing).isActive = true
        inboxTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        inboxTabButton.heightAnchor.constraint(equalTo: inboxTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(notificationsTabSelected)
        notificationsTabSelected.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        notificationsTabSelected.leftAnchor.constraint(equalTo: inboxTabButton.rightAnchor, constant: spacing).isActive = true
        notificationsTabSelected.widthAnchor.constraint(equalToConstant: 40).isActive = true
        notificationsTabSelected.heightAnchor.constraint(equalTo: notificationsTabSelected.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(notificationsTabButton)
        notificationsTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        notificationsTabButton.leftAnchor.constraint(equalTo: inboxTabButton.rightAnchor, constant: spacing).isActive = true
        notificationsTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        notificationsTabButton.heightAnchor.constraint(equalTo: notificationsTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(spacesTabSelected)
        spacesTabSelected.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        spacesTabSelected.leftAnchor.constraint(equalTo: notificationsTabButton.rightAnchor, constant: spacing).isActive = true
        spacesTabSelected.widthAnchor.constraint(equalToConstant: 40).isActive = true
        spacesTabSelected.heightAnchor.constraint(equalTo: spacesTabSelected.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(spacesTabButton)
        spacesTabButton.topAnchor.constraint(equalTo: profitsTabButton.topAnchor).isActive = true
        spacesTabButton.leftAnchor.constraint(equalTo: notificationsTabButton.rightAnchor, constant: spacing).isActive = true
        spacesTabButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        spacesTabButton.heightAnchor.constraint(equalTo: spacesTabButton.widthAnchor).isActive = true
        
        tabBarBackground.addSubview(tabBarSelector)
        tabBarSelector.centerYAnchor.constraint(equalTo: tabBarBackground.topAnchor).isActive = true
        selectionLineCenterAnchor = tabBarSelector.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: spacing + 20)
            selectionLineCenterAnchor.isActive = true
        tabBarSelector.heightAnchor.constraint(equalToConstant: 6).isActive = true
        tabBarSelector.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 3, y: 0.0), animated: false)
        
        delayWithSeconds(2) {
//            self.delegate?.lightContentStatusBar()
            self.openTabBar()
        }
        
    }
    
    var bankCenterAnchor: NSLayoutConstraint!
    var transferCenterAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(profitsController.view)
        profitsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profitsController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        profitsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        profitsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(bookingsController.view)
        bookingsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bookingsController.view.leftAnchor.constraint(equalTo: profitsController.view.rightAnchor).isActive = true
        bookingsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        bookingsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(inboxController.view)
        inboxController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        inboxController.view.leftAnchor.constraint(equalTo: bookingsController.view.rightAnchor).isActive = true
        inboxController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        inboxController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(notificationsController.view)
        notificationsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        notificationsController.view.leftAnchor.constraint(equalTo: inboxController.view.rightAnchor).isActive = true
        notificationsController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        notificationsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(spacesController.view)
        spacesController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        spacesController.view.leftAnchor.constraint(equalTo: notificationsController.view.rightAnchor).isActive = true
        spacesController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        spacesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
    }
    
    @objc func tabBarButtonPressed(sender: UIButton) {
        UIView.animate(withDuration: animationIn) {
            self.resetTabBar()
            if sender == self.profitsTabButton {
                sender.tintColor = Theme.BLUE
                self.profitsTabSelected.alpha = 1
                self.scrollView.setContentOffset(.zero, animated: false)
                self.selectionLineCenterAnchor.constant = self.spacing - 5
            } else if sender == self.reservationsTabButton {
                sender.tintColor = Theme.BLUE
                self.reservationTabSelected.alpha = 1
                self.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0.0), animated: false)
                self.selectionLineCenterAnchor.constant = self.spacing * 2 + 35
            } else if sender == self.inboxTabButton {
                sender.tintColor = Theme.BLUE
                self.inboxTabSelected.alpha = 1
                self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0.0), animated: false)
                self.selectionLineCenterAnchor.constant = self.spacing * 3 + 75
            } else if sender == self.notificationsTabButton {
                sender.tintColor = Theme.BLUE
                self.notificationsTabSelected.alpha = 1
                self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 3, y: 0.0), animated: false)
                self.selectionLineCenterAnchor.constant = self.spacing * 4 + 115
            } else if sender == self.spacesTabButton {
                sender.tintColor = Theme.BLUE
                self.spacesTabSelected.alpha = 1
                self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 4, y: 0.0), animated: false)
                self.selectionLineCenterAnchor.constant = self.spacing * 5 + 155
            }
            delayWithSeconds(animationIn) {
                self.resetScrolls()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func resetTabBar() {
        self.profitsTabButton.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        self.reservationsTabButton.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        self.inboxTabButton.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        self.notificationsTabButton.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        self.spacesTabButton.tintColor = Theme.LIGHT_GRAY.withAlphaComponent(0.8)
        self.profitsTabSelected.alpha = 0
        self.reservationTabSelected.alpha = 0
        self.inboxTabSelected.alpha = 0
        self.notificationsTabSelected.alpha = 0
        self.spacesTabSelected.alpha = 0
    }
    
    func openTabBar() {
        self.tabBarBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut) {
            self.exitButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func closeTabBar() {
        self.tabBarBottomAnchor.constant = 100
        UIView.animate(withDuration: animationOut) {
            self.exitButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

extension UserHostingViewController: handleHostingControllers {

    func resetScrolls() {
        self.profitsController.profitsChart.scrollView.setContentOffset(.zero, animated: true)
        self.profitsController.profitsRefund.scrollView.setContentOffset(.zero, animated: true)
        self.profitsController.profitsWallet.scrollView.setContentOffset(.zero, animated: true)
        self.bookingsController.upcomingBookings.scrollView.setContentOffset(.zero, animated: true)
        self.bookingsController.previousBookings.scrollView.setContentOffset(.zero, animated: true)
        self.bookingsController.hostCalendar.scrollView.setContentOffset(.zero, animated: true)
        self.inboxController.messagesTable.setContentOffset(.zero, animated: true)
        self.notificationsController.scrollView.setContentOffset(.zero, animated: true)
        self.spacesController.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func moveToProfits() {
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func moveToBookings() {
        self.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0), animated: true)
    }
    
    func moveToInbox() {
        self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0), animated: true)
    }
    
    func moveToNotifications() {
        self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 3, y: 0), animated: true)
    }
    
    func moveToSpaces() {
        self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 4, y: 0), animated: true)
    }
    
    func bringExitButton() {
        UIView.animate(withDuration: animationIn) {
            self.exitButton.alpha = 1
        }
    }
    
    func hideExitButton() {
        UIView.animate(withDuration: animationIn) {
            self.exitButton.alpha = 0
        }
    }
    
}


extension UserHostingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            self.bookingsController.hostCalendar.closeScheduleView()
            if self.profitsController.mainLabel.text == "Payout method" { self.profitsController.backButtonPressed() }
            let translation = scrollView.contentOffset.x
            let percentage = (translation - self.previousSelection)/phoneWidth
            let difference = (self.spacing * 2 + 35) - (self.spacing - 5)
            self.selectionLineCenterAnchor.constant = self.previousSelectionCenter + percentage * difference
            self.view.layoutIfNeeded()
            self.resetScrolls()
            UIView.animate(withDuration: animationIn) {
                if translation == 0 {
                    self.resetTabBar()
                    self.profitsTabButton.tintColor = Theme.BLUE
                    self.profitsTabSelected.alpha = 1
                    self.selectionLineCenterAnchor.constant = self.spacing - 5
                    self.previousSelection = 0
                    self.previousSelectionCenter = self.selectionLineCenterAnchor.constant
                } else if translation == phoneWidth {
                    self.resetTabBar()
                    self.reservationsTabButton.tintColor = Theme.BLUE
                    self.reservationTabSelected.alpha = 1
                    self.selectionLineCenterAnchor.constant = self.spacing * 2 + 35
                    self.previousSelection = phoneWidth
                    self.previousSelectionCenter = self.selectionLineCenterAnchor.constant
                } else if translation == phoneWidth * 2 {
                    self.resetTabBar()
                    self.inboxTabButton.tintColor = Theme.BLUE
                    self.inboxTabSelected.alpha = 1
                    self.selectionLineCenterAnchor.constant = self.spacing * 3 + 75
                    self.previousSelection = phoneWidth * 2
                    self.previousSelectionCenter = self.selectionLineCenterAnchor.constant
                } else if translation == phoneWidth * 3 {
                    self.resetTabBar()
                    self.notificationsTabButton.tintColor = Theme.BLUE
                    self.notificationsTabSelected.alpha = 1
                    self.selectionLineCenterAnchor.constant = self.spacing * 4 + 115
                    self.previousSelection = phoneWidth * 3
                    self.previousSelectionCenter = self.selectionLineCenterAnchor.constant
                } else if translation == phoneWidth * 4 {
                    self.resetTabBar()
                    self.spacesTabButton.tintColor = Theme.BLUE
                    self.spacesTabSelected.alpha = 1
                    self.selectionLineCenterAnchor.constant = self.spacing * 5 + 155
                    self.previousSelection = phoneWidth * 4
                    self.previousSelectionCenter = self.selectionLineCenterAnchor.constant
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.profitsController.profitsChart.loadingLine.endAnimating()
        self.bookingsController.loadingLine.endAnimating()
        self.inboxController.loadingLine.endAnimating()
        self.notificationsController.loadingLine.endAnimating()
        self.spacesController.loadingLine.endAnimating()
        
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {

        }
    }
    
    func monitorForDeletion() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
        ref.observe(.childRemoved) { (snapshot) in
            self.backButtonPressed()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func lightContentStatusBar() {
        self.statusBarColor = true
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func defaultContentStatusBar() {
        self.statusBarColor = false
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarColor == true {
            return .lightContent
        } else {
            return .default
        }
    }
    
}
