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

let mapTutorialController = MapTutorialView()

protocol moveControllers {
    func dismissActiveController()
    func backToOnboarding()
    
    func moveToProfile()
    func moveToMap()
    func lightContentStatusBar()
    func defaultContentStatusBar()
    func bringNewHostingController()
    func bringHostingController()
    func hideHamburger()
    func bringHamburger()
    func hideProfile()
    func bringProfile()
}

protocol controlsNewParking {
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
    func bringSettingsController()
    func bringHelpController()
    func bringFeedbackController()
    func bringAnalyticsController()
}

var tabDimmingView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Theme.BLACK
    view.alpha = 0
    
    return view
}()

let loadingline: DashingLine = {
    let view = DashingLine()
    view.position = CGPoint(x: phoneWidth/2 - 64, y: phoneHeight/2)
    view.strokeColor = Theme.WHITE.cgColor
    view.travelDistance = 128
    view.defaultWidth = 3
    view.defaultColor = Theme.WHITE
    
    return view
}()

var loadingTabView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    view.translatesAutoresizingMaskIntoConstraints = false
    view.alpha = 0
    
    return view
}()

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
        view.layer.cornerRadius = 32
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: -3, height: 3)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.16
        
        return view
    }()
    
    lazy var mapController: MapKitViewController = {
        let controller = MapKitViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.accountDelegate = self
        controller.delegate = self
        
        return controller
    }()
    
    lazy var accountSlideController: AccountSlideViewController = {
        let controller = AccountSlideViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.moveDelegate = self
        
        return controller
    }()

    lazy var blackContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    lazy var hamburgerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hamburger")
        button.setImage(image, for: .normal)
        button.alpha = 0
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.16
        button.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    var profileIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "profile_guy1")
        button.setImage(image, for: .normal)
        button.alpha = 0
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.16
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    var mapCenterAnchor: NSLayoutConstraint!
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!
    
    var statusBarShouldBeHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        NotificationCenter.default.addObserver(self, selector: #selector(monitorCurrentParking), name: NSNotification.Name(rawValue: "userBookingStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNewListing), name: NSNotification.Name(rawValue: "dismissNewListing"), object: nil)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var mainTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(accountSlideController.view)
        accountSlideController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountSlideController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        accountSlideController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        accountSlideController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        view.addSubview(shadowView)
        view.addSubview(mapController.view)
        view.addSubview(tabDimmingView)
        
        mapCenterAnchor = mapController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            mapCenterAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        shadowView.anchor(top: mapController.view.topAnchor, left: mapController.view.leftAnchor, bottom: mapController.view.bottomAnchor, right: mapController.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tabDimmingView.anchor(top: mapController.view.topAnchor, left: mapController.view.leftAnchor, bottom: mapController.view.bottomAnchor, right: mapController.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(blurView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToMapSwipe(sender:)))
        blurView.addGestureRecognizer(gesture)
        blurView.anchor(top: mapController.view.topAnchor, left: mapController.view.leftAnchor, bottom: mapController.view.bottomAnchor, right: mapController.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(blackContainer)
        blackContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(hamburgerButton)
        view.addSubview(profileIcon)
        
        // Each should actually have 40px images but increase size for easier touchability
        hamburgerButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: mapController.view.leftAnchor, bottom: nil, right: nil, paddingTop: -2, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 65, height: 65)

        profileIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: mapController.view.rightAnchor, paddingTop: -2, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 65, height: 65)
        
        view.addSubview(loadingTabView)
        loadingTabView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        loadingTabView.layer.addSublayer(loadingline)
        
    }
    
    func checkOpens() {
        var opens = UserDefaults.standard.integer(forKey: "numberOfOpens")
        if opens <= 1 {
//            opens += 1
            UserDefaults.standard.set(opens, forKey: "numberOfOpens")
            UserDefaults.standard.synchronize()
            
            mapController.setupWelcomeBanner()
        }
    }
    
    @objc func monitorCurrentParking() {
        if BookedState == .currentlyBooked {
            mapController.mainViewState = .currentBooking
        } else if BookedState == .reserved {
            mapController.mainViewState = .mainBar
        } else {
            mapController.mainViewState = .none
        }
    }
    
    func moveToProfile() {
        delegate?.hideStatusBar()
        mapCenterAnchor.constant = phoneWidth - 120
        let scale: CGFloat = 0.9
        UIView.animate(withDuration: animationIn, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.shadowView.transform = CGAffineTransform(scaleX: scale, y: scale)
            tabDimmingView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.mapController.view.layer.cornerRadius = 32
            tabDimmingView.layer.cornerRadius = 32
            tabDimmingView.alpha = 0.2
            self.hamburgerButton.alpha = 0
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func moveToMap() {
        delegate?.bringStatusBar()
        mapCenterAnchor.constant = 0
        bringHamburger()
        UIView.animate(withDuration: animationOut, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.shadowView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            tabDimmingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.mapController.view.layer.cornerRadius = 0
            tabDimmingView.layer.cornerRadius = 0
            tabDimmingView.alpha = 0
            self.hamburgerButton.alpha = 1
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func openAccountView() {
        openProfileOptions()
        UIView.animate(withDuration: 0.1, animations: {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func closeAccountView() {
        closeProfileOptions()
        delegate?.hideStatusBar()
        delayWithSeconds(animationIn) {
            UIView.animate(withDuration: animationIn, animations: {
                self.blackContainer.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.defaultStatusBar()
            }
        }
    }
    
    func backToOnboarding() {
        delegate?.backToOnboarding()
    }
    
    @objc func dismissNewListing() {
        dismiss(animated: true) {
            self.bringHostingController()
        }
    }
    
    @objc func profileButtonPressed() {
        view.endEditing(true)
        hideHamburger()
        moveToProfile()
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
    
}


////// Bring Controllers
extension TabViewController {
    
    func bringUpcomingController() {
        let controller = UserUpcomingViewController()
//        controller.delegate = self
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
        }) { (success) in
            self.present(controller, animated: true) {
                UIView.animate(withDuration: animationIn) {
//                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringHostingController() {
        let controller = HostPortalController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringNewHostingController() {
        let controller = HostOnboardingController()
        controller.delegate = self
//        controller.moveDelegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.presentationController?.delegate = controller
//        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringSettingsController() {
        let controller = UserSettingsViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringHelpController() {
        let controller = TESTHelpViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
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
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
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
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.blackContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func hideHamburger() {
        UIView.animate(withDuration: animationIn) {
            self.hamburgerButton.alpha = 0
        }
    }
    
    func bringHamburger() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.hamburgerButton.alpha = 1
            self.profileIcon.alpha = 1
        }, completion: nil)
    }
    
    func hideProfile() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.profileIcon.alpha = 0
        }, completion: nil)
    }
    
    func bringProfile() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.profileIcon.alpha = 1
        }, completion: nil)
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

func startLoadingAnimation() {
    loadingTabView.alpha = 1
    loadingline.animate()
}

func endLoadingAnimation() {
    loadingTabView.alpha = 0
    loadingline.endAnimate()
}
