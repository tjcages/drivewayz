//
//  PageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

var rightArrow: UIButton!
var leftArrow: UIButton!

protocol moveControllers {
    func moveToProfile()
    func moveToMap()
    func lightContentStatusBar()
    func defaultContentStatusBar()
    func changeMainLabel(text: String)
    func moveMainLabel(percent: CGFloat)
    func bringExitButton()
    func hideExitButton()
    func moveAccount(percent: CGFloat)
    func animateAccount()
}

protocol controlsNewParking {
    func setupNewParking(parkingImage: ParkingImage)
    func removeNewParkingView()
    func removeNewVehicleView()
    func moveTopProfile()
    func moveToMap()
}

protocol controlsAccountOptions {
    func openAccountView()
    func closeAccountView()
    
    func moveToMap()
    func bringUpcomingController()
    func bringHostingController()
    func bringNewHostingController()
    func bringVehicleController()
    func bringAnalyticsController()
    func bringCouponsController()
    func bringContactUsController()
    func bringBankAccountController()
    func bringMessagesController()
    func bringSettingsController(image: UIImage, name: String)
    func bringHelpController()
    
    func hideUpcomingController()
    func hideHostingController()
    func hideNewHostingController()
    func hideVehicleController()
    func hideAnalyticsController()
    func hideCouponsController()
    func hideContactUsController()
    func hideBankAccountController()
    func hideMessagesController()
    func hideSettingsController()
    func hideHelpController()
}

class TabViewController: UIViewController, UNUserNotificationCenterDelegate, controlsAccountOptions, moveControllers {
    
    var swipe: Int = 1
    var delegate: handleStatusBarHide?
    
    enum emailConfirmation {
        case confirmed
        case unconfirmed
    }
    var emailConfirmed: emailConfirmation = .unconfirmed
    
    lazy var fullBlurView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    lazy var purpleGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.alpha = 0
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Analytics"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH0
        label.alpha = 0
        
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var mapController: MapKitViewController = {
        let controller = MapKitViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Map"
        controller.vehicleDelegate = self
        controller.delegate = self
        return controller
    }()
    
    lazy var accountSlideController: AccountSlideViewController = {
        let controller = AccountSlideViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Profile"
        controller.delegate = self
        controller.moveDelegate = self
        return controller
    }()
    
    lazy var hostingController: MainHostViewController = {
        let controller = MainHostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Hosting"
        controller.delegate = self
        controller.moveDelegate = self
        return controller
    }()
    
    lazy var configureParkingController: ConfigureParkingViewController = {
        let controller = ConfigureParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Save Parking"
        controller.delegate = self
        controller.moveDelegate = self
        return controller
    }()
    
    lazy var becomeHostController: BecomeHostViewController = {
        let controller = BecomeHostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Become Host"
//        controller.delegate = self
        return controller
    }()
    
    lazy var vehicleController: UserVehicleViewController = {
        let controller = UserVehicleViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Vehicle"
        controller.delegate = self
        return controller
    }()
    
    lazy var upcomingController: UpcomingViewController = {
        let controller = UpcomingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Upcoming"
        
        return controller
    }()
    
    lazy var contactController: ContactUsViewController = {
        let controller = ContactUsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Contact Us!"
        controller.view.alpha = 0
        controller.delegate = self
        return controller
    }()
    
    lazy var couponController: CouponsViewController = {
        let controller = CouponsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Coupons"
        controller.view.alpha = 0
        controller.delegate = self
        return controller
    }()
    
    lazy var analController: AnalyticsViewController = {
        let controller = AnalyticsViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Analytics"
        controller.delegate = self
        return controller
    }()
    
    lazy var bankAccountController: BankAccountViewController = {
        let controller = BankAccountViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Bank Account"
        controller.delegate = self
        return controller
    }()
    
    lazy var userMessagesController: UserMessagesViewController = {
        let controller = UserMessagesViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Messages"
        controller.delegate = self
        controller.moveDelegate = self
        return controller
    }()
    
    lazy var userSettingsController: UserSettingsViewController = {
        let controller = UserSettingsViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Settings"
        controller.delegate = self
        return controller
    }()
    
    lazy var helpController: HelpViewController = {
        let controller = HelpViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Help"
        controller.delegate = self
        return controller
    }()
    
    var mapControllerAnchor: NSLayoutConstraint!
    var accountControllerAnchor: NSLayoutConstraint!
    var mapCenterAnchor: NSLayoutConstraint!
    var profileCenterAnchor: NSLayoutConstraint!
    
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!
    
    var statusBarShouldBeHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
        configureOptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().delegate = self
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var accountControllerWidthAnchor: NSLayoutConstraint!
    var accountControllerHeightAnchor: NSLayoutConstraint!
    var mainTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(mapController.view)
        mapControllerAnchor = mapController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        mapControllerAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(fullBlurView)
        fullBlurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fullBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        fullBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        fullBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(blurView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToMapSwipe(sender:)))
        blurView.addGestureRecognizer(gesture)
        blurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(accountSlideController.view)
        accountControllerAnchor = accountSlideController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.width)
            accountControllerAnchor.isActive = true
        accountControllerWidthAnchor = accountSlideController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            accountControllerWidthAnchor.isActive = true
        accountSlideController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        accountControllerHeightAnchor = accountSlideController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor)
            accountControllerHeightAnchor.isActive = true
        
        self.view.addSubview(purpleGradient)
        purpleGradient.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purpleGradient.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purpleGradient.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        purpleGradient.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            mainTopAnchor = mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 62)
                mainTopAnchor.isActive = true
        case .iphoneX:
            mainTopAnchor = mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 72)
                mainTopAnchor.isActive = true
        }
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
    }
    
    func removeTabView() {
        UIView.animate(withDuration: animationOut, animations: {
            self.containerHeightAnchor.constant = 80
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func bringTabView() {
        UIView.animate(withDuration: animationIn, animations: {
            self.containerHeightAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func moveToProfile() {
        self.delegate?.hideStatusBar()
        self.mapController.purchaseButtonSwipedDown()
        self.mapController.eventsControllerHidden()
        self.mapController.takeAwayEvents()
        UIView.animate(withDuration: animationIn, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            switch device {
            case .iphone8:
                self.mapController.view.layer.cornerRadius = 5
            case .iphoneX:
                self.mapController.view.layer.cornerRadius = 18
            }
            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
            self.accountControllerAnchor.constant = -self.view.frame.width/3.5
            self.mapControllerAnchor.constant = 0
            if self.accountSlideController.hostMarkShouldShow == true {
                self.accountSlideController.hostingMark.alpha = 1
            } else {
                self.accountSlideController.hostingMark.alpha = 0
            }
            if self.accountSlideController.upcomingMarkShouldShow == true {
                self.accountSlideController.upcomingMark.alpha = 1
            } else {
                self.accountSlideController.upcomingMark.alpha = 0
            }
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    var lastPanned: CGFloat = 0
    
    func moveAccount(percent: CGFloat) {
        self.accountControllerAnchor.constant = self.accountControllerAnchor.constant + percent*self.view.frame.width/3.5
        if self.accountControllerAnchor.constant >= -self.view.frame.width/3.5 {
            self.accountControllerAnchor.constant = -self.view.frame.width/3.5
        } else if self.accountControllerAnchor.constant <= -self.view.frame.width {
            self.accountControllerAnchor.constant = -self.view.frame.width
        }
        self.lastPanned = self.accountControllerAnchor.constant
        let percent = 1+self.view.frame.width/3.5/self.lastPanned
        self.fullBlurView.alpha = 0.4 * (1 - percent)
        let add = 0.05 * percent
        self.mapController.view.transform = CGAffineTransform(scaleX: 0.95 + add, y: 0.95 + add)
        self.view.layoutIfNeeded()
    }
    
    func animateAccount() {
        UIView.animate(withDuration: animationIn) {
            if self.lastPanned <= -190 {
                self.moveToMap()
            } else {
                self.moveToProfile()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
    }
    
    func moveToMap() {
        self.delegate?.bringStatusBar()
        switch solar {
        case .day:
            self.defaultContentStatusBar()
        case .night:
            self.lightContentStatusBar()
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.mapController.view.layer.cornerRadius = 0
            self.fullBlurView.alpha = 0
            self.blurView.alpha = 0
            self.mapControllerAnchor.constant = 0
            self.accountControllerAnchor.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
            if eventsAreAllowed == true {
                self.mapController.eventsControllerHidden()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleLogout() {
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()

        let myViewController: SignInViewController = SignInViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = myViewController
        appDelegate.window?.makeKeyAndVisible()
    }

    var hostingAnchor: NSLayoutConstraint!
    var newParkingAnchor: NSLayoutConstraint!
    var vehicleAnchor: NSLayoutConstraint!
    var newVehicleAnchor: NSLayoutConstraint!
    var analControllerAnchor: NSLayoutConstraint!
    var upcomingAnchor: NSLayoutConstraint!
    var messagesAnchor: NSLayoutConstraint!
    var bankAccountCenterAnchor: NSLayoutConstraint!
    var settingsAnchor: NSLayoutConstraint!
    var helpAnchor: NSLayoutConstraint!
    
    func refreshSpots() {
        self.mapController.observeUserParkingSpots()
    }
    
    func openAccountView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.accountControllerAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.accountSlideController.profileImageView.alpha = 0
                self.accountSlideController.profileName.alpha = 0
                self.accountSlideController.profileLine.alpha = 0
                self.accountSlideController.optionsTableView.alpha = 0
                self.accountSlideController.purpleGradient.alpha = 0
                self.accountSlideController.settingsSelect.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.bringStatusBar()
                self.delegate?.lightContentStatusBar()
            }
        }
    }
    
    func closeAccountView() {
        self.delegate?.hideStatusBar()
        self.accountControllerAnchor.constant = -self.view.frame.width/3.5
        UIView.animate(withDuration: animationIn, animations: {
            self.purpleGradient.alpha = 0
            self.exitButton.alpha = 0
            self.accountSlideController.profileImageView.alpha = 1
            self.accountSlideController.profileName.alpha = 1
            self.accountSlideController.profileLine.alpha = 1
            self.accountSlideController.optionsTableView.alpha = 1
            self.accountSlideController.purpleGradient.alpha = 1
            self.accountSlideController.settingsSelect.alpha = 1
            if self.accountSlideController.hostMarkShouldShow == true {
                self.accountSlideController.hostingMark.alpha = 1
            } else {
                self.accountSlideController.hostingMark.alpha = 0
            }
            if self.accountSlideController.upcomingMarkShouldShow == true {
                self.accountSlideController.upcomingMark.alpha = 1
            } else {
                self.accountSlideController.upcomingMark.alpha = 0
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultStatusBar()
        }
    }
    
    func moveMainLabel(percent: CGFloat) {
        if percent <= 1 && percent >= 0 {
            let scale = 0.8 + (1-percent)/5
            self.mainLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            switch device {
            case .iphone8:
                mainTopAnchor.constant = 62 - (percent * 38)
            case .iphoneX:
                mainTopAnchor.constant = 72 - (percent * 36)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func changeMainLabel(text: String) {
        self.mainLabel.text = text
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    func defaultContentStatusBar() {
        self.delegate?.defaultStatusBar()
    }
    
    func configureOptions() {
        guard let currentUser = Auth.auth().currentUser?.email else { return }
        let ref = Database.database().reference().child("ConfirmedEmails")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String] {
                let count = dictionary.count
                for i in 0..<count {
                    let email = dictionary[i]
                    if email == currentUser {
                        self.emailConfirmed = .confirmed
//                        self.analyticsButton.alpha = 1
                        return
                    } else {
                        self.emailConfirmed = .unconfirmed
//                        self.analyticsButton.alpha = 0
                    }
                }
            }
        }
    }
    
    func hideExitButton() {
        UIView.animate(withDuration: animationIn) {
            self.exitButton.alpha = 0
        }
    }
    
    func bringExitButton() {
        UIView.animate(withDuration: animationOut) {
            self.exitButton.alpha = 1
        }
    }
    
    @objc func analyticsPressed(sender: UIButton) {
        self.openAccountView()
        self.bringAnalyticsController()
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.closeAccountView()
        self.removeAll()
    }
    
}


////// Bring Controllers
extension TabViewController {
    
    func bringUpcomingController() {
        self.view.addSubview(upcomingController.view)
        self.view.bringSubviewToFront(exitButton)
        upcomingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        upcomingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        upcomingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        upcomingAnchor = upcomingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        upcomingAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "Your bookings"
            UIView.animate(withDuration: animationIn) {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.upcomingAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringMessagesController() {
        self.view.addSubview(userMessagesController.view)
        self.view.bringSubviewToFront(exitButton)
        userMessagesController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userMessagesController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        userMessagesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messagesAnchor = userMessagesController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        messagesAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "Messages"
            UIView.animate(withDuration: animationIn) {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.messagesAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringHostingController() {
        self.view.addSubview(hostingController.view)
        self.view.bringSubviewToFront(exitButton)
        hostingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        hostingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        hostingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hostingAnchor = hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        hostingAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "My parking spots"
            UIView.animate(withDuration: animationIn) {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.hostingAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringNewHostingController() {
        self.view.layoutIfNeeded()
        self.view.addSubview(configureParkingController.view)
        self.addChild(configureParkingController)
        configureParkingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newParkingAnchor = configureParkingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
        newParkingAnchor.isActive = true
        configureParkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        configureParkingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(becomeHostController.view)
        self.view.bringSubviewToFront(exitButton)
        self.becomeHostController.view.alpha = 0
        self.addChild(becomeHostController)
        becomeHostController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        becomeHostController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        becomeHostController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        becomeHostController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mainLabel.alpha = 0
            self.mainLabel.text = "Become a host"
            self.view.bringSubviewToFront(self.exitButton)
            self.becomeHostController.startAnimations()
            UIView.animate(withDuration: animationIn, animations: {
                self.becomeHostController.view.alpha = 1
            }, completion: { (success) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.purpleGradient.alpha = 0
                        self.exitButton.alpha = 1
                        self.newParkingAnchor.constant = 0
                        self.mainLabel.alpha = 1
                        self.view.layoutIfNeeded()
                    })
                }
            })
        }
    }
    
    func bringVehicleController() {
        self.view.addSubview(vehicleController.view)
        self.view.bringSubviewToFront(exitButton)
        vehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        vehicleController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        vehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vehicleAnchor = vehicleController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        vehicleAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "Vehicle"
            UIView.animate(withDuration: animationIn) {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.vehicleAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringAnalyticsController() {
        self.view.addSubview(analController.view)
        self.view.bringSubviewToFront(exitButton)
        analController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        analController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        analController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        analControllerAnchor = analController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        analControllerAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "Analytics"
            UIView.animate(withDuration: animationIn, animations: {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.analControllerAnchor.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
            })
        }
    }
    
    func bringCouponsController() {
        self.view.addSubview(self.couponController.view)
        self.view.bringSubviewToFront(exitButton)
        self.addChild(couponController)
        self.couponController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.couponController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.couponController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.couponController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.couponController.view.alpha = 0
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.couponController.view.alpha = 1
            })
        }
    }
    
    func bringContactUsController() {
        self.view.addSubview(self.contactController.view)
        self.view.bringSubviewToFront(exitButton)
        self.addChild(contactController)
        self.contactController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.contactController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.contactController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.contactController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.contactController.view.alpha = 0
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.contactController.view.alpha = 1
            })
        }
    }
    
    func bringBankAccountController() {
        self.view.addSubview(self.bankAccountController.view)
        self.view.bringSubviewToFront(exitButton)
        self.addChild(bankAccountController)
        self.bankAccountController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.bankAccountController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bankAccountController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bankAccountCenterAnchor = self.bankAccountController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        bankAccountCenterAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: animationIn, animations: {
                self.bankAccountCenterAnchor.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func bringSettingsController(image: UIImage, name: String) {
        self.view.addSubview(userSettingsController.view)
        self.view.bringSubviewToFront(exitButton)
        userSettingsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userSettingsController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        userSettingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        settingsAnchor = userSettingsController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
            settingsAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "Settings"
            self.userSettingsController.profileImageView.image = image
            self.userSettingsController.profileName.text = name
            UIView.animate(withDuration: animationIn) {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.settingsAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringHelpController() {
        self.view.addSubview(helpController.view)
        self.view.bringSubviewToFront(exitButton)
        helpController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        helpController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        helpController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        helpAnchor = helpController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
            helpAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
            self.mainLabel.text = "Help"
            UIView.animate(withDuration: animationIn) {
                self.purpleGradient.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.helpAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
}


////// Remove Controllers
extension TabViewController {
    
    @objc func removeAll() {
        if upcomingAnchor != nil {
            self.hideUpcomingController()
        }
        if messagesAnchor != nil {
            self.hideMessagesController()
        }
        if hostingAnchor != nil {
            self.hideHostingController()
        }
        if vehicleAnchor != nil {
            self.hideVehicleController()
        }
        if newParkingAnchor != nil {
            self.hideNewHostingController()
        }
        if analControllerAnchor != nil {
            self.hideAnalyticsController()
        }
        if bankAccountCenterAnchor != nil {
            self.hideBankAccountController()
        }
        if settingsAnchor != nil {
            self.hideSettingsController()
        }
        if helpAnchor != nil {
            self.hideHelpController()
        }
        hideCouponsController()
        hideContactUsController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.moveMainLabel(percent: 0)
        }
    }
    
    func hideUpcomingController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.upcomingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.upcomingController.willMove(toParent: nil)
            self.upcomingController.view.removeFromSuperview()
            self.upcomingController.removeFromParent()
        }
    }
    
    func hideMessagesController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.messagesAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.userMessagesController.scrollView.setContentOffset(.zero, animated: true)
            self.userMessagesController.willMove(toParent: nil)
            self.userMessagesController.view.removeFromSuperview()
            self.userMessagesController.removeFromParent()
        }
    }
    
    func hideHostingController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.hostingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
//            self.hostingController.scrollView.setContentOffset(.zero, animated: true)
            self.hostingController.willMove(toParent: nil)
            self.hostingController.view.removeFromSuperview()
            self.hostingController.removeFromParent()
        }
    }
    
    func hideNewHostingController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.newParkingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.configureParkingController.willMove(toParent: nil)
            self.configureParkingController.view.removeFromSuperview()
            self.configureParkingController.removeFromParent()
        })
    }
    
    func hideVehicleController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.vehicleAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.vehicleController.scrollView.setContentOffset(.zero, animated: true)
            self.vehicleController.willMove(toParent: nil)
            self.vehicleController.view.removeFromSuperview()
            self.vehicleController.removeFromParent()
        }
    }
    
    func hideAnalyticsController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.analControllerAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.closeAccountView()
            self.analController.willMove(toParent: nil)
            self.analController.view.removeFromSuperview()
            self.analController.removeFromParent()
        }
    }
    
    func hideCouponsController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.couponController.view.alpha = 0
            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
        }) { (success) in
            self.couponController.willMove(toParent: nil)
            self.couponController.view.removeFromSuperview()
            self.couponController.removeFromParent()
            self.closeAccountView()
        }
    }
    
    func hideContactUsController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.contactController.view.alpha = 0
            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
        }) { (success) in
            self.contactController.willMove(toParent: nil)
            self.contactController.view.removeFromSuperview()
            self.contactController.removeFromParent()
            self.closeAccountView()
        }
    }
    
    func hideBankAccountController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.bankAccountCenterAnchor.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
            self.bankAccountController.willMove(toParent: nil)
            self.bankAccountController.view.removeFromSuperview()
            self.bankAccountController.removeFromParent()
        }
    }
    
    func hideSettingsController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.settingsAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.userSettingsController.scrollView.setContentOffset(.zero, animated: true)
            self.userSettingsController.willMove(toParent: nil)
            self.userSettingsController.view.removeFromSuperview()
            self.userSettingsController.removeFromParent()
        }
    }
    
    func hideHelpController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.helpAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.helpController.scrollView.setContentOffset(.zero, animated: true)
            self.helpController.willMove(toParent: nil)
            self.helpController.view.removeFromSuperview()
            self.helpController.removeFromParent()
        }
    }
}










