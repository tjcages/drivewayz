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
    func dismissActiveController()
    
    func moveToProfile()
    func moveToMap()
    func lightContentStatusBar()
    func defaultContentStatusBar()
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
    func bringSettingsController()
    func bringHelpController()
    func bringFeedbackController()
    func bringAnalyticsController()
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
    
    var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 16
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
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

    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
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
        
    }
    
    func moveToProfile() {
        self.delegate?.hideStatusBar()
        self.mapController.purchaseButtonSwipedDown()
        self.mapController.view.bringSubviewToFront(self.mapController.fullBackgroundView)
        self.mapCenterAnchor.constant = self.view.frame.width/2 + 60
        hamburgerWidthAnchor.constant = -24
        UIView.animate(withDuration: animationIn, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.shadowView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.mapController.view.layer.cornerRadius = 16
            self.mapController.fullBackgroundView.alpha = 0.2
            hamburgerButton.alpha = 0
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
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
            hamburgerButton.alpha = 1
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
    
    func openAccountView() {
        openProfileOptions()
        UIView.animate(withDuration: 0.1, animations: {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            delayWithSeconds(animationIn, completion: {
                self.delegate?.bringStatusBar()
                self.delegate?.defaultStatusBar()
            })
        }
    }
    
    func closeAccountView() {
        closeProfileOptions()
        self.delegate?.hideStatusBar()
        delayWithSeconds(animationIn) {
            UIView.animate(withDuration: animationIn, animations: {
                self.gradientContainer.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.defaultStatusBar()
            }
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
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
        self.accountSlideController.forceSelectBook() 
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
        self.accountSlideController.forceSelectBook()
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
    
    func dismissActiveController() {
        self.closeAccountView()
        self.moveToProfile()
    }
    
    func changeProfileImage(image: UIImage) {
        self.accountSlideController.profileImageView.image = image
    }
    
}


////// Bring Controllers
extension TabViewController {
    
    func bringUpcomingController() {
        let controller = UserUpcomingViewController()
        controller.delegate = self
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(controller, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringHostingController() {
        let controller = UserHostingViewController()
        controller.delegate = self
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(controller, animated: true) {
                controller.openTabBar()
                controller.setData()
                UIView.animate(withDuration: animationIn) {
//                    controller.backButton.alpha = 1 /////////////////////////////////////////////////////
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringNewHostingController() {
        let controller = ConfigureParkingViewController()
        controller.delegate = self
        controller.moveDelegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.startHostingController.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringVehicleController() {
        let controller = UserVehicleViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringSettingsController() {
        let controller = UserSettingsViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringHelpController() {
        let controller = UserHelpViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringFeedbackController() {
        let controller = UserContactViewController()
        controller.delegate = self
        controller.context = "Feedback"
        controller.mainLabel.text = "Give feedback"
        controller.informationLabel.text = "Please reach out to us if you have any suggestions, questions, or concerns"
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringAnalyticsController() {
        let controller = AnalyticsViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func handleLogout() {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        let myViewController: SignInViewController = SignInViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = myViewController
        appDelegate.window?.makeKeyAndVisible()
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
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    func defaultContentStatusBar() {
        self.delegate?.defaultStatusBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}








