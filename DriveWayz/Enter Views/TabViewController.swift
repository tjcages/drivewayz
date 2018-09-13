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
    func setupNewVehicle(vehicleStatus: VehicleStatus)
    func removeNewVehicleView()
    func moveTopProfile()
    func moveToMap()
}

class TabViewController: UIViewController, UNUserNotificationCenterDelegate, moveControllers, controlsNewParking {
    
    var swipe: Int = 1
    
    var pin: UILabel = {
        let label = UILabel()
        label.text = "▾"
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        controller.delegate = self
        return controller
    }()
    
    lazy var walkthroughController: WalkthroughViewController = {
        let controller = WalkthroughViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Walkthrough"
        controller.view.alpha = 0
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
        controller.parkingDelegate = self
//        controller.viewDelegate = self
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
    
    var mapControllerAnchor: NSLayoutConstraint!
    var accountControllerAnchor: NSLayoutConstraint!
    var mapCenterAnchor: NSLayoutConstraint!
    var profileCenterAnchor: NSLayoutConstraint!
    
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.statusBarStyle = .default
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
        fetchUser()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().delegate = self
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(mapController.view)
        mapControllerAnchor = mapController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        mapControllerAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(accountController.view)
        accountControllerAnchor = accountController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width)
        accountControllerAnchor.isActive = true
        accountController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        accountController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        accountController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
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
        
//        self.view.addSubview(pin)
//        pin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        pin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 6).isActive = true
//        pin.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        pin.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
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
        UIApplication.shared.statusBarStyle = .lightContent
        if mapControllerAnchor.constant == 0 {
//            self.containerLeftAnchor.constant = 0
//            self.containerRightAnchor.constant = -self.view.frame.width/3
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.statusBarStyle = .lightContent
                self.accountControllerAnchor.constant = 0
                self.mapControllerAnchor.constant = -self.view.frame.width
//                self.mapCenterAnchor.constant = self.view.frame.width/4
//                self.profileCenterAnchor.constant = self.view.frame.width/2
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
    }
    
    func moveToMap() {
        UIApplication.shared.statusBarStyle = .default
        if accountControllerAnchor.constant == 0 {
//            self.containerLeftAnchor.constant = self.view.frame.width/3
//            self.containerRightAnchor.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.statusBarStyle = .default
                self.mapControllerAnchor.constant = 0
                self.accountControllerAnchor.constant = self.view.frame.width
//                self.mapCenterAnchor.constant = self.view.frame.width/2
//                self.profileCenterAnchor.constant = self.view.frame.width*3/4
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func handleLogout() {
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        let myViewController: StartUpViewController = StartUpViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = myViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userVehicleID = dictionary["Vehicle"] as? [String:AnyObject]
                let userParkingID = dictionary["Parking"] as? [String:AnyObject]
                
                if userVehicleID == nil && userParkingID == nil {
                    
                    self.view.addSubview(self.walkthroughController.view)
                    self.walkthroughController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                    self.walkthroughController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                    self.walkthroughController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    self.walkthroughController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.walkthroughController.view.alpha = 1
                    })
                    
                }
            }
        }, withCancel: nil)
        return
    }

    var parkingAnchor: NSLayoutConstraint!
    
    func setupNewParking(parkingImage: ParkingImage) {
        switch parkingImage {
        case .yesImage:
            
            self.newParkingController.view.removeFromSuperview()
            self.view.layoutIfNeeded()

            self.view.addSubview(saveParkingController.view)
            self.addChildViewController(saveParkingController)
            saveParkingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            parkingAnchor = saveParkingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            parkingAnchor.isActive = true
            saveParkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            saveParkingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.parkingAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    UIApplication.shared.statusBarStyle = .default
                })
            }
        default:
            
            self.view.addSubview(newParkingController.view)
            self.addChildViewController(newParkingController)
            newParkingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            parkingAnchor = newParkingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            parkingAnchor.isActive = true
            newParkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            newParkingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.parkingAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    UIApplication.shared.statusBarStyle = .default
                })
            }
            
        }
    }
    
    func removeNewParkingView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.parkingAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.saveParkingController.view.removeFromSuperview()
            self.newParkingController.view.removeFromSuperview()
            self.accountController.scrollToTop()
//            UIApplication.shared.statusBarStyle = .lightContent
        })
    }
    
    var vehicleAnchor: NSLayoutConstraint!
    
    func setupNewVehicle(vehicleStatus: VehicleStatus) {
        switch vehicleStatus {
        case .yesVehicle:
            
            self.newVehicleController.view.removeFromSuperview()
            
        case .noVehicle:
            
            self.view.addSubview(newVehicleController.view)
            self.addChildViewController(newVehicleController)
            newVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            vehicleAnchor = newVehicleController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            vehicleAnchor.isActive = true
            newVehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            newVehicleController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.vehicleAnchor.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    UIApplication.shared.statusBarStyle = .default
                })
            }
            
        }
    }
    
    func removeNewVehicleView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.vehicleAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.newVehicleController.view.removeFromSuperview()
            self.accountController.scrollToTop()
//            UIApplication.shared.statusBarStyle = .lightContent
        })
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
    
}
















