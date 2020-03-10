//
//  SettingsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import Stripe
import Cosmos
import FirebaseFirestore

protocol changeSettingsHandler {
    func observePayments()
    func changeEmail(text: String)
    func changePhone(text: String)
    func changeName(text: String)
    func changeProfileImage(image: UIImage)
    
    func changePaymentHeight(amount: CGFloat)
    func changeVehicleHeight(amount: CGFloat)
    
    func moveToAbout()
    func editSettings(title: String, subtitle: String)
    func handleLogout()
}

class UserSettingsViewController: UIViewController, changeSettingsHandler {
    
    var delegate: moveControllers?
    var currentUser: Users? {
        didSet {
            if let user = self.currentUser {
                if let name = user.name {
                    self.accountController.nameLabel.text = name
                }
                if let userPicture = user.picture {
                    if userPicture == "" {
                        self.accountController.profileImageView.image = UIImage(named: "background4")
                    } else {
                        self.accountController.profileImageView.loadImageUsingCacheWithUrlString(userPicture) { (bool) in
                            self.gradientController.loadingLine.endAnimating()
                            if !bool {
                                self.accountController.profileImageView.image = UIImage(named: "background4")
                            }
                        }
                    }
                }
                if let email = user.email {
                    self.credentialsController.optionsSub[1] = email
                } else { self.credentialsController.optionsSub[1] = "No email" }
                if let phone = user.phone {
                    self.credentialsController.optionsSub[0] = phone
                } else { self.credentialsController.optionsSub[0] = "No phone number" }
            }
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 1200
        controller.scrollView.isHidden = true
        controller.setExitButton()
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    lazy var accountController: AccountSettingsView = {
        let controller = AccountSettingsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        let tap = UITapGestureRecognizer(target: self, action: #selector(accountPressed))
        controller.view.addGestureRecognizer(tap)
        
        return controller
    }()
    
    lazy var credentialsController: CredentialsSettingsView = {
        let controller = CredentialsSettingsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var paymentController: PaymentMethodsView = {
        let controller = PaymentMethodsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var vehicleController: VehicleMethodsView = {
        let controller = VehicleMethodsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var otherController: OtherSettingsView = {
        let controller = OtherSettingsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        self.addChild(controller)
        
        return controller
    }()
    
    let accountViewController = AccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.clipsToBounds = true
        
        setupViews()
        
        observeUserInformation()
        observePayments()
        observeVehicles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text != "Settings" {
            gradientController.setMainLabel(text: "Settings")
        }
    }
    
    var paymentHeightAnchor: NSLayoutConstraint!
    var vehicleHeightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        scrollView.addSubview(accountController.view)
        scrollView.addSubview(credentialsController.view)
        
        scrollView.addSubview(paymentController.view)
        scrollView.addSubview(vehicleController.view)
        
        scrollView.addSubview(otherController.view)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1200)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        accountController.view.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 104)
        
        credentialsController.view.anchor(top: accountController.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 167)
        
        paymentController.view.anchor(top: credentialsController.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        paymentHeightAnchor = paymentController.view.heightAnchor.constraint(equalToConstant: 0)
            paymentHeightAnchor.isActive = true
        
        vehicleController.view.anchor(top: paymentController.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        vehicleHeightAnchor = vehicleController.view.heightAnchor.constraint(equalToConstant: 0)
            vehicleHeightAnchor.isActive = true
        
        otherController.view.anchor(top: vehicleController.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 335)
        
    }
    
    @objc func accountPressed() {
        accountViewController.delegate = self
        accountViewController.currentUser = currentUser
        accountViewController.profileImageView.image = accountController.profileImageView.image
        navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    func changePaymentHeight(amount: CGFloat) {
        paymentHeightAnchor.constant = amount
    }
    
    func changeVehicleHeight(amount: CGFloat) {
        vehicleHeightAnchor.constant = amount
    }
    
    func editSettings(title: String, subtitle: String) {
        let controller = EditSettingsViewController()
        controller.delegate = self
        controller.currentUser = currentUser
        controller.setData(title: title, subtitle: subtitle)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func observeUserInformation() {
        gradientController.loadingLine.alpha = 1
        gradientController.loadingLine.startAnimating()
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    let user = Users(dictionary: dictionary)
                    user.id = snapshot.key
                    self.currentUser = user
                    self.accountViewController.currentUser = user
                    
                    self.gradientController.loadingLine.endAnimating()
                }
            }
        }
    }
    
    func observePayments() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("sources")
        db.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.paymentController.paymentMethods = []
            for document in documents {
                let dataDescription = document.data()
                let paymentMethod = PaymentMethod(dictionary: dataDescription)
                self.paymentController.paymentMethods.append(paymentMethod)
            }
            self.gradientController.loadingLine.alpha = 0
            self.gradientController.loadingLine.endAnimating()
        }
    }
    
    func observeVehicles() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles")
        db.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.vehicleController.vehicleMethods = []
            for document in documents {
                let dataDescription = document.data()
                let vehicleMethod = Vehicles(dictionary: dataDescription)
                self.vehicleController.vehicleMethods.append(vehicleMethod)
            }
            self.gradientController.loadingLine.alpha = 0
            self.gradientController.loadingLine.endAnimating()
        }
    }

    @objc func backButtonPressed() {
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func popAboutUs() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func moveToAbout() {
        let controller = TESTHelpViewController()
        controller.gradientController.mainLabel.text = "About Us"
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        controller.gradientController.backButton.setImage(image, for: .normal)
        controller.gradientController.backButton.addTarget(self, action: #selector(popAboutUs), for: .touchUpInside)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleLogout() {
        let alert = UIAlertController(title: "Log out?", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                let loginManager = LoginManager()
                loginManager.logOut()
            } catch let logoutError {
                print(logoutError)
            }
            
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            self.delegate?.backToOnboarding()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func changeEmail(text: String) {
        credentialsController.optionsSub[1] = text
        observeUserInformation()
    }
    
    func changePhone(text: String) {
        credentialsController.optionsSub[0] = text
        observeUserInformation()
    }
    
    func changeName(text: String) {
        accountController.nameLabel.text = text
        observeUserInformation()
    }
    
    func changeProfileImage(image: UIImage) {
        accountController.profileImageView.image = image
//        delegate?.changeProfileImage(image: image)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension UserSettingsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientHeight - percent * 60
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            } else if translation <= -60 {
                gradientController.backButton.sendActions(for: .touchUpInside)
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        gradientController.gradientHeightAnchor.constant = gradientHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
