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
    func bringExitButton()
    func hideExitButton()
    func bringNewHostingController()
    func hideHamburger()
    func bringHamburger()
    func changeProfileImage(image: UIImage)
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
    
    var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()

    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 10
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.6
        
        return view
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

    lazy var hostingController: UserHostingViewController = {
        let controller = UserHostingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Hosting"
        controller.delegate = self

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
    
    lazy var upcomingController: UserUpcomingViewController = {
        let controller = UserUpcomingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Upcoming"
        controller.delegate = self
        
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
    
    lazy var userMessagesController: TestMessageViewController = {
        let controller = TestMessageViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Messages"
//        controller.delegate = self
//        controller.moveDelegate = self
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
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.OFF_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var mapCenterAnchor: NSLayoutConstraint!
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!
    
    var statusBarShouldBeHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
        configureOptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().delegate = self
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var mainTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(accountSlideController.view)
        accountSlideController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountSlideController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        accountSlideController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        accountSlideController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(mapController.view)
        mapCenterAnchor = mapController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            mapCenterAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(shadowView)
        self.view.bringSubviewToFront(mapController.view)
        shadowView.leftAnchor.constraint(equalTo: mapController.view.leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: mapController.view.rightAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: mapController.view.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: mapController.view.bottomAnchor).isActive = true
        
        self.view.addSubview(blurView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToMapSwipe(sender:)))
        blurView.addGestureRecognizer(gesture)
        blurView.topAnchor.constraint(equalTo: mapController.view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: mapController.view.bottomAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: mapController.view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: mapController.view.rightAnchor).isActive = true
        
        createHamburgerButton()
        hamburgerButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        self.view.addSubview(hamburgerButton)
        hamburgerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        hamburgerButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        hamburgerButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        switch device {
        case .iphone8:
            hamburgerButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        case .iphoneX:
            hamburgerButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        }
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
    
    func hideHamburger() {
        UIView.animate(withDuration: animationIn) {
            hamburgerButton.alpha = 0
        }
    }
    
    func bringHamburger() {
        UIView.animate(withDuration: animationIn) {
            hamburgerButton.alpha = 1
        }
    }
    
    @objc func profileButtonPressed() {
        self.view.endEditing(true)
        if mapCenterAnchor.constant != 0 {
            self.moveToMap()
            self.accountSlideController.forceSelectBook() 
        } else {
            self.moveToProfile()
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
        self.mapController.view.bringSubviewToFront(self.mapController.fullBackgroundView)
        UIView.animate(withDuration: animationIn, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.shadowView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.mapController.view.layer.cornerRadius = 8
            self.mapController.fullBackgroundView.alpha = 0.2
            hamburgerView1.backgroundColor = Theme.BLACK
            hamburgerView2.backgroundColor = Theme.BLACK
            hamburgerView3.backgroundColor = Theme.BLACK
            self.blurView.alpha = 1
            self.mapCenterAnchor.constant = self.view.frame.width/2 + 60
            hamburgerWidthAnchor.constant = -24
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
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
        self.accountSlideController.forceSelectBook() 
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
        self.accountSlideController.forceSelectBook()
    }
    
    func moveToMap() {
        self.delegate?.bringStatusBar()
        self.mapCenterAnchor.constant = 0
        hamburgerWidthAnchor.constant = -28
        UIView.animate(withDuration: animationOut, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.shadowView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.mapController.view.layer.cornerRadius = 0
            self.mapController.fullBackgroundView.alpha = 0
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mapController.view.bringSubviewToFront(self.mapController.mainBarController.view)
            self.mapController.view.bringSubviewToFront(self.mapController.currentBottomController.view)
            if eventsAreAllowed == true {
                self.mapController.eventsControllerHidden()
            }
        }
    }
    
    func openProfileOptions() {
        self.mapCenterAnchor.constant = phoneWidth * 1.3
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeProfileOptions() {
        self.mapCenterAnchor.constant = self.view.frame.width/2 + 60
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
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
        openProfileOptions()
        UIView.animate(withDuration: 0.1, animations: {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.exitButton.tintColor = Theme.DARK_GRAY
                self.view.layoutIfNeeded()
            }) { (success) in
                delayWithSeconds(animationIn, completion: {
                    self.delegate?.bringStatusBar()
                    self.delegate?.defaultStatusBar()
                })
            }
        }
    }
    
    func closeAccountView() {
        closeProfileOptions()
        self.delegate?.hideStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 0
            self.gradientContainer.alpha = 0
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
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.exitButton.tintColor = Theme.WHITE
        }
    }
    
    func defaultContentStatusBar() {
        self.delegate?.defaultStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.exitButton.tintColor = Theme.DARK_GRAY
        }
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
            self.gradientContainer.alpha = 1
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
    
    func changeProfileImage(image: UIImage) {
        self.accountSlideController.profileImageView.image = image
    }
    
}


////// Bring Controllers
extension TabViewController {
    
    func bringUpcomingController() {
        self.view.addSubview(upcomingController.view)
        self.view.bringSubviewToFront(exitButton)
        upcomingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        upcomingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        upcomingAnchor = upcomingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            upcomingAnchor.isActive = true
        upcomingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 1
            self.gradientContainer.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
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
        messagesAnchor = userMessagesController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            messagesAnchor.isActive = true
        userMessagesController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 1
            self.gradientContainer.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
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
        hostingAnchor = hostingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            hostingAnchor.isActive = true
        hostingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 1
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.hostingController.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0.0), animated: false)
            self.hostingController.tabBarButtonPressed(sender: self.hostingController.reservationsTabButton)
            UIView.animate(withDuration: animationIn, animations: {
                self.hostingAnchor.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.hostingController.openTabBar()
            })
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
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.bringSubviewToFront(self.exitButton)
            self.becomeHostController.startAnimations()
            UIView.animate(withDuration: animationIn, animations: {
                self.becomeHostController.view.alpha = 1
            }, completion: { (success) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.delegate?.defaultStatusBar()
                    UIView.animate(withDuration: animationIn, animations: {
                        self.exitButton.tintColor = Theme.DARK_GRAY
                        self.exitButton.alpha = 1
                        self.gradientContainer.alpha = 1
                        self.newParkingAnchor.constant = 0
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
        vehicleAnchor = vehicleController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            vehicleAnchor.isActive = true
        vehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 1
            self.gradientContainer.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.vehicleAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringAnalyticsController() {
//        self.view.addSubview(analController.view)
//        self.view.bringSubviewToFront(exitButton)
//        analController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        analController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
//        analController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        analControllerAnchor = analController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
//        analControllerAnchor.isActive = true
//        self.view.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + animationIn) {
//            UIView.animate(withDuration: animationIn, animations: {
//                self.exitButton.alpha = 1
//                self.gradientContainer.alpha = 1
//                self.analControllerAnchor.constant = 0
//                self.view.layoutIfNeeded()
//            }, completion: { (success) in
//            })
//        }
    }
    
    func bringCouponsController() {
//        self.view.addSubview(self.couponController.view)
//        self.view.bringSubviewToFront(exitButton)
//        self.addChild(couponController)
//        self.couponController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.couponController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        self.couponController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.couponController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
//        self.couponController.view.alpha = 0
//        self.view.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            UIView.animate(withDuration: animationIn, animations: {
//                self.couponController.view.alpha = 1
//            })
//        }
    }
    
    func bringContactUsController() {
//        self.view.addSubview(self.contactController.view)
//        self.view.bringSubviewToFront(exitButton)
//        self.addChild(contactController)
//        self.contactController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.contactController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        self.contactController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.contactController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
//        self.contactController.view.alpha = 0
//        self.view.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            UIView.animate(withDuration: animationIn, animations: {
//                self.contactController.view.alpha = 1
//            })
//        }
    }
    
    func bringBankAccountController() {
        self.view.addSubview(self.bankAccountController.view)
//        self.view.bringSubviewToFront(exitButton)
//        self.addChild(bankAccountController)
//        self.bankAccountController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.bankAccountController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.bankAccountController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        bankAccountCenterAnchor = self.bankAccountController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
//        bankAccountCenterAnchor.isActive = true
//        self.view.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            UIView.animate(withDuration: animationIn, animations: {
//                self.bankAccountCenterAnchor.constant = 0
//                self.view.layoutIfNeeded()
//            })
//        }
    }
    
    func bringSettingsController(image: UIImage, name: String) {
        self.view.addSubview(userSettingsController.view)
        self.addChild(userSettingsController)
        self.view.bringSubviewToFront(exitButton)
        userSettingsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userSettingsController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        settingsAnchor = userSettingsController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            settingsAnchor.isActive = true
        userSettingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 1
            self.gradientContainer.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.settingsAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringHelpController() {
        self.view.addSubview(helpController.view)
        self.addChild(helpController)
        self.view.bringSubviewToFront(exitButton)
        helpController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        helpController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        helpAnchor = helpController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: phoneHeight)
            helpAnchor.isActive = true
        helpController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn, animations: {
            self.exitButton.alpha = 1
            self.gradientContainer.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
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
    }
    
    func hideUpcomingController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.upcomingAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }) { (success) in
            self.upcomingController.willMove(toParent: nil)
            self.upcomingController.view.removeFromSuperview()
            self.upcomingController.removeFromParent()
        }
    }
    
    func hideMessagesController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.messagesAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }) { (success) in
            self.userMessagesController.messagesTableView.setContentOffset(.zero, animated: true)
            self.userMessagesController.willMove(toParent: nil)
            self.userMessagesController.view.removeFromSuperview()
            self.userMessagesController.removeFromParent()
        }
    }
    
    func hideHostingController() {
        self.hostingController.closeTabBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.hostingAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }) { (success) in
            self.hostingController.scrollView.setContentOffset(.zero, animated: true)
            self.hostingController.willMove(toParent: nil)
            self.hostingController.view.removeFromSuperview()
            self.hostingController.removeFromParent()
        }
    }
    
    func hideNewHostingController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.newParkingAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.configureParkingController.willMove(toParent: nil)
            self.configureParkingController.view.removeFromSuperview()
            self.configureParkingController.removeFromParent()
        })
    }
    
    func hideVehicleController() {
        UIView.animate(withDuration: animationOut, animations: {
            self.vehicleAnchor.constant = phoneHeight
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
            self.settingsAnchor.constant = phoneHeight
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
            self.helpAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }) { (success) in
            self.helpController.scrollView.setContentOffset(.zero, animated: true)
            self.helpController.willMove(toParent: nil)
            self.helpController.view.removeFromSuperview()
            self.helpController.removeFromParent()
        }
    }
}










