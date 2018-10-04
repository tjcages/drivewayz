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
    func moveTopProfile()
    func moveToMap()
    func showTabController()
    func hideTabController()
}

protocol controlsNewParking {
    func setupNewParking(parkingImage: ParkingImage)
    func removeNewParkingView()
    func bringNewVehicleController(vehicleStatus: VehicleStatus)
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
    func bringNewHostingController(parkingImage: ParkingImage)
    func bringVehicleController()
    func bringNewVehicleController(vehicleStatus: VehicleStatus)
    func bringAnalyticsController()
    func bringCouponsController()
    func bringContactUsController()
    func bringTermsController()
    func bringBankAccountController()
    
    func hideUpcomingController()
    func hideHostingController()
    func hideNewHostingController()
    func hideVehicleController()
    func hideNewVehicleController()
    func hideAnalyticsController()
    func hideCouponsController()
    func hideContactUsController()
    func hideTermsController()
    func hideBankAccountController()
}

class TabViewController: UIViewController, UNUserNotificationCenterDelegate, moveControllers, controlsAccountOptions {
    
    var swipe: Int = 1
    var delegate: handleStatusBarHide?
    
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    lazy var container: UIView = {
        let containerBar = UIView()
        containerBar.translatesAutoresizingMaskIntoConstraints = false
        containerBar.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0
        let gestureProfile = UISwipeGestureRecognizer(target: self, action: #selector(moveToProfileSwipe(sender:)))
        gestureProfile.direction = .left
        containerBar.addGestureRecognizer(gestureProfile)
        let gestureMap = UISwipeGestureRecognizer(target: self, action: #selector(moveToMapSwipe(sender:)))
        gestureMap.direction = .right
        containerBar.addGestureRecognizer(gestureMap)
        containerBar.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true

        return containerBar
    }()
    
    var profile: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "account")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToProfileTap(sender:)), for: .touchUpInside)
        button.backgroundColor = Theme.PRIMARY_DARK_COLOR
        button.alpha = 0.9
        button.layer.cornerRadius = 25
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.8
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        
        return button
    }()
    
    var map: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "notification")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRIMARY_DARK_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToMapTap(sender:)), for: .touchUpInside)
        button.backgroundColor = Theme.OFF_WHITE
        button.alpha = 0.9
        button.layer.cornerRadius = 25
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.8
        
        return button
    }()
    
    lazy var mapController: MapKitViewController = {
        let controller = MapKitViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Map"
        controller.delegate = self
        controller.vehicleDelegate = self
        return controller
    }()
    
    lazy var accountController: AccountViewController = {
        let controller = AccountViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Profile"
//        controller.delegate = self
        return controller
    }()
    
    lazy var accountSlideController: AccountSlideViewController = {
        let controller = AccountSlideViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Profile"
        controller.moveDelegate = self
        controller.delegate = self
        return controller
    }()
    
    lazy var walkthroughController: WalkthroughViewController = {
        let controller = WalkthroughViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Walkthrough"
        controller.view.alpha = 0
//        controller.delegate = self
        return controller
    }()
    
    lazy var hostingController: HostingViewController = {
        let controller = HostingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Hosting"
        controller.delegate = self
        return controller
    }()
    
    lazy var newParkingController: AddANewParkingSpotViewController = {
        let controller = AddANewParkingSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "New Parking"
        controller.delegate = self
        return controller
    }()
    
    lazy var saveParkingController: ConfigureParkingViewController = {
        let controller = ConfigureParkingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Save Parking"
        controller.delegate = self
        return controller
    }()
    
    lazy var vehicleController: VehicleViewController = {
        let controller = VehicleViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Vehicle"
        controller.delegate = self
        return controller
    }()
    
    lazy var newVehicleController: AddANewVehicleViewController = {
        let controller = AddANewVehicleViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "New Vehicle"
        controller.delegate = self
        
        return controller
    }()
    
    lazy var upcomingController: UpcomingViewController = {
        let controller = UpcomingViewController()
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
    
    lazy var termsController: TermsViewController = {
        let controller = TermsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Terms"
        controller.view.alpha = 0
        controller.delegateOptions = self
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
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Analytics"
        controller.delegate = self
        return controller
    }()
    
    lazy var bankAccountController: BankAccountViewController = {
        let controller = BankAccountViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Bank Account"
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
    
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.applicationIconBadgeNumber = 0
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if Auth.auth().currentUser?.uid == nil {
//                self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
//            }
//        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
        fetchUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().delegate = self
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var accountControllerWidthAnchor: NSLayoutConstraint!
    var accountControllerHeightAnchor: NSLayoutConstraint!
    
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
        accountControllerAnchor = accountSlideController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            accountControllerAnchor.isActive = true
        accountControllerWidthAnchor = accountSlideController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            accountControllerWidthAnchor.isActive = true
        accountSlideController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        accountControllerHeightAnchor = accountSlideController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor)
            accountControllerHeightAnchor.isActive = true
        
        accountController.view.addSubview(map)
        map.rightAnchor.constraint(equalTo: accountController.view.rightAnchor, constant: -10).isActive = true
        map.widthAnchor.constraint(equalToConstant: 50).isActive = true
        map.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switch device {
        case .iphone8:
            map.topAnchor.constraint(equalTo: accountController.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            map.topAnchor.constraint(equalTo: accountController.view.topAnchor, constant: 45).isActive = true
        }
        
        mapController.view.addSubview(profile)
        profile.rightAnchor.constraint(equalTo: mapController.view.rightAnchor, constant: -10).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switch device {
        case .iphone8:
            profile.topAnchor.constraint(equalTo: mapController.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            profile.topAnchor.constraint(equalTo: mapController.view.topAnchor, constant: 45).isActive = true
        }
        
    }
    
    func removeTabView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerHeightAnchor.constant = 80
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func bringTabView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerHeightAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    @objc func moveToProfileTap(sender: UIButton) {
        moveTopProfile()
    }
    
    @objc func moveToProfileSwipe(sender: UITapGestureRecognizer) {
        moveTopProfile()
    }
    
    func moveTopProfile() {
        self.delegate?.hideStatusBar()
        self.mapController.purchaseButtonSwipedDown()
        UIView.animate(withDuration: 0.3, animations: {
            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
            self.accountControllerAnchor.constant = self.view.frame.width/3.5
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
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
    }
    
    func moveToMap() {
        self.delegate?.bringStatusBar()
        UIView.animate(withDuration: 0.3, animations: {
            self.fullBlurView.alpha = 0
            self.blurView.alpha = 0
            self.mapControllerAnchor.constant = 0
            self.accountControllerAnchor.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
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
    
    func fetchUser() {
        let isUserSeenWalkthrough: Bool = UserDefaults.standard.bool(forKey: "userSeenWalkthrough")
        if isUserSeenWalkthrough == false {
            self.view.addSubview(self.walkthroughController.view)
            self.walkthroughController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.walkthroughController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            self.walkthroughController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.walkthroughController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.walkthroughController.view.alpha = 1
            })
            UserDefaults.standard.set(true, forKey: "userSeenWalkthrough")
            UserDefaults.standard.synchronize()
        } else {
            return
        }
    }

    var hostingAnchor: NSLayoutConstraint!
    var newParkingAnchor: NSLayoutConstraint!
    var vehicleAnchor: NSLayoutConstraint!
    var newVehicleAnchor: NSLayoutConstraint!
    var analControllerAnchor: NSLayoutConstraint!
    var upcomingAnchor: NSLayoutConstraint!
    var bankAccountCenterAnchor: NSLayoutConstraint!
    
    func refreshSpots() {
        self.mapController.observeUserParkingSpots()
    }
    
    func hideTabController() {
        UIView.animate(withDuration: 0.2) {
            self.map.alpha = 0
            self.profile.alpha = 0
        }
    }
    
    func showTabController() {
        UIView.animate(withDuration: 0.2) {
            self.map.alpha = 1
            self.profile.alpha = 1
        }
    }
    
    
    func bringTermsController() {
        self.view.addSubview(self.termsController.view)
        self.addChildViewController(termsController)
        self.termsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.termsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.termsController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.termsController.view.alpha = 0
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.termsController.view.alpha = 1
            })
        }
    }
    
    func bringUpcomingController() {
        self.view.addSubview(upcomingController.view)
        upcomingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        upcomingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        upcomingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        upcomingAnchor = upcomingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
            upcomingAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.accountSlideController.mainLabel.text = "Reservations"
            UIView.animate(withDuration: 0.3) {
                self.accountSlideController.mainLabel.alpha = 1
                self.upcomingAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringHostingController() {
        self.view.addSubview(hostingController.view)
        hostingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        hostingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        hostingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hostingAnchor = hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
            hostingAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.accountSlideController.mainLabel.text = "Hosting"
            UIView.animate(withDuration: 0.3) {
                self.accountSlideController.mainLabel.alpha = 1
                self.hostingAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringNewHostingController(parkingImage: ParkingImage) {
        switch parkingImage {
        case .yesImage:
            self.newParkingController.view.removeFromSuperview()
            self.view.layoutIfNeeded()
            self.view.addSubview(saveParkingController.view)
            self.addChildViewController(saveParkingController)
            saveParkingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            newParkingAnchor = saveParkingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            newParkingAnchor.isActive = true
            saveParkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            saveParkingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.accountSlideController.mainLabel.text = "New Host"
                UIView.animate(withDuration: 0.3, animations: {
                    self.newParkingAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    UIApplication.shared.statusBarStyle = .default
                })
            }
        default:
            self.view.addSubview(newParkingController.view)
            self.addChildViewController(newParkingController)
            newParkingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            newParkingAnchor = newParkingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            newParkingAnchor.isActive = true
            newParkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            newParkingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.newParkingAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    UIApplication.shared.statusBarStyle = .default
                })
            }
        }
    }
    
    func bringVehicleController() {
        self.view.addSubview(vehicleController.view)
        vehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        vehicleController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        vehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vehicleAnchor = vehicleController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
            vehicleAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.accountSlideController.mainLabel.text = "Vehicle"
            UIView.animate(withDuration: 0.3) {
                self.accountSlideController.mainLabel.alpha = 1
                self.vehicleAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bringNewVehicleController(vehicleStatus: VehicleStatus) {
        switch vehicleStatus {
        case .yesVehicle:
            self.newVehicleController.view.removeFromSuperview()
        case .noVehicle:
            self.view.addSubview(newVehicleController.view)
            self.addChildViewController(newVehicleController)
            newVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            newVehicleAnchor = newVehicleController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            newVehicleAnchor.isActive = true
            newVehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            newVehicleController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.accountSlideController.mainLabel.text = "New Vehicle"
                UIView.animate(withDuration: 0.3, animations: {
                    self.accountSlideController.mainLabel.alpha = 1
                    self.newVehicleAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    UIApplication.shared.statusBarStyle = .default
                })
            }
        }
    }
    
    func bringAnalyticsController() {
        self.view.addSubview(analController.view)
        analController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        analController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        analController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        analControllerAnchor = analController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
            analControllerAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.accountSlideController.mainLabel.text = "Analytics"
            UIView.animate(withDuration: 0.3, animations: {
                self.accountSlideController.mainLabel.alpha = 1
                self.analController.driveWayzLogo.alpha = 1
                self.analControllerAnchor.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.analController.driveWayzLogo.alpha = 1
                })
            })
        }
    }
    
    func bringCouponsController() {
        self.view.addSubview(self.couponController.view)
        self.addChildViewController(couponController)
        self.couponController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.couponController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.couponController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.couponController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.couponController.view.alpha = 0
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.couponController.view.alpha = 1
            })
        }
    }
    
    func bringContactUsController() {
        self.view.addSubview(self.contactController.view)
        self.addChildViewController(contactController)
        self.contactController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.contactController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.contactController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.contactController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.contactController.view.alpha = 0
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.contactController.view.alpha = 1
            })
        }
    }
    
    func bringBankAccountController() {
        self.view.addSubview(self.bankAccountController.view)
        self.addChildViewController(bankAccountController)
        self.bankAccountController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.bankAccountController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bankAccountController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bankAccountCenterAnchor = self.bankAccountController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            bankAccountCenterAnchor.isActive = true
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.bankAccountCenterAnchor.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //////////////////////
    
    func hideUpcomingController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.mainLabel.alpha = 0
            self.upcomingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.upcomingController.willMove(toParentViewController: nil)
            self.upcomingController.view.removeFromSuperview()
            self.upcomingController.removeFromParentViewController()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideTermsController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.termsController.view.alpha = 0
//            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
        }) { (success) in
            self.termsController.willMove(toParentViewController: nil)
            self.termsController.view.removeFromSuperview()
            self.termsController.removeFromParentViewController()
            self.closeAccountView()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideHostingController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.mainLabel.alpha = 0
            self.hostingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.hostingController.willMove(toParentViewController: nil)
            self.hostingController.view.removeFromSuperview()
            self.hostingController.removeFromParentViewController()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideNewHostingController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.mainLabel.alpha = 0
            self.newParkingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.saveParkingController.view.removeFromSuperview()
            self.newParkingController.view.removeFromSuperview()
            self.accountController.scrollToTop()
        })
    }
    
    func hideVehicleController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.mainLabel.alpha = 0
            self.vehicleAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.vehicleController.willMove(toParentViewController: nil)
            self.vehicleController.view.removeFromSuperview()
            self.vehicleController.removeFromParentViewController()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideNewVehicleController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.mainLabel.alpha = 0
            self.newVehicleAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.newVehicleController.view.removeFromSuperview()
            self.accountController.scrollToTop()
        })
    }
    
    func hideAnalyticsController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.mainLabel.alpha = 0
            self.analController.driveWayzLogo.alpha = 0
            self.analControllerAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.closeAccountView()
            self.analController.willMove(toParentViewController: nil)
            self.analController.view.removeFromSuperview()
            self.analController.removeFromParentViewController()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideCouponsController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.couponController.view.alpha = 0
//            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
        }) { (success) in
            self.couponController.willMove(toParentViewController: nil)
            self.couponController.view.removeFromSuperview()
            self.couponController.removeFromParentViewController()
            self.closeAccountView()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideContactUsController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contactController.view.alpha = 0
//            self.fullBlurView.alpha = 0.4
            self.blurView.alpha = 1
        }) { (success) in
            self.contactController.willMove(toParentViewController: nil)
            self.contactController.view.removeFromSuperview()
            self.contactController.removeFromParentViewController()
            self.closeAccountView()
            self.accountSlideController.setHomeIndex()
        }
    }
    
    func hideBankAccountController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.bankAccountCenterAnchor.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
            self.bankAccountController.willMove(toParentViewController: nil)
            self.bankAccountController.view.removeFromSuperview()
            self.bankAccountController.removeFromParentViewController()
        }
    }
    
    func openAccountView() {
        self.accountControllerAnchor.constant = self.view.frame.width/3
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.accountControllerAnchor.constant = -5
            self.accountControllerWidthAnchor.constant = 0
            self.accountControllerHeightAnchor.constant = 20
            UIView.animate(withDuration: 0.3, animations: {
                self.accountSlideController.profileImageView.alpha = 0
                self.accountSlideController.profileName.alpha = 0
                self.accountSlideController.profileLine.alpha = 0
                self.accountSlideController.termsLine.alpha = 0
                self.accountSlideController.optionsTableView.alpha = 0
                self.accountSlideController.termsTableView.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func closeAccountView() {
        self.delegate?.hideStatusBar()
        self.accountControllerAnchor.constant = self.view.frame.width/3.5
        self.accountControllerWidthAnchor.constant = 0
        self.accountControllerHeightAnchor.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.accountSlideController.profileImageView.alpha = 1
            self.accountSlideController.profileName.alpha = 1
            self.accountSlideController.profileLine.alpha = 1
            self.accountSlideController.termsLine.alpha = 1
            self.accountSlideController.optionsTableView.alpha = 1
            self.accountSlideController.termsTableView.alpha = 1
            self.accountSlideController.addButton.alpha = 1
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
            //
        }
    }
    
}
















