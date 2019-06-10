//
//  OnboardingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyJSON

protocol handleOnboardingControllers {
    func dismissMobileNumber()
    func moveToMainController()
}

class OnboardingViewController: UIViewController {
    
    var delegate: handleSignIn?
    var statusDelegate: handleStatusBarHide?
    var lastTranslation: CGFloat = 0.0
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var circularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 1400/2
        view.clipsToBounds = true
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        label.text = "Smarter Parking"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.text = "Generate Lorem Ipsum placeholder text for use in your graphic, print."
        label.numberOfLines = 2
        
        return label
    }()
    
    var centerSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var leftSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var rightSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Enter mobile number", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var socialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH6
        label.text = "Or connect with a social network"
        label.textAlignment = .center
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
        return view
    }()
    
    var firstImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        
        return view
    }()
    
    var secondImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        
        return view
    }()
    
    var thirdImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        
        return view
    }()
    
    lazy var mobileNumberController: MobileNumberViewController = {
        let controller = MobileNumberViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var facebookButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "FacebookIcon")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonDidCompleteLogin), for: .touchUpInside)
        button.alpha = 0.9
        
        return button
    }()
    
    var googlePlusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "GooglePlusIcon")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        setupViews()
        setupLabels()
        setupSelection()
        setupButtons()
        setupControllers()
    }
    
    func setupViews() {
        
        self.view.addSubview(viewContainer)
        viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        viewContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(circularView)
        circularView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        circularView.widthAnchor.constraint(equalToConstant: 1400).isActive = true
        circularView.heightAnchor.constraint(equalTo: circularView.widthAnchor).isActive = true
        switch device {
        case .iphone8:
            circularView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -360).isActive = true
        case .iphoneX:
            circularView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -380).isActive = true
        }
        
    }
    
    var mainLabelCenterAnchor: NSLayoutConstraint!
    
    func setupLabels() {
        
        self.view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: 20).isActive = true
        mainLabelCenterAnchor = mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            mainLabelCenterAnchor.isActive = true
        mainLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: -12).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: mainLabel.rightAnchor).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var centerSelectionHeightAnchor: NSLayoutConstraint!
    var leftSelectionHeightAnchor: NSLayoutConstraint!
    var rightSelectionHeightAnchor: NSLayoutConstraint!
    
    func setupSelection() {
        
        self.view.addSubview(centerSelectionLine)
        centerSelectionLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        centerSelectionLine.bottomAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 42).isActive = true
        centerSelectionLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
        centerSelectionHeightAnchor = centerSelectionLine.heightAnchor.constraint(equalToConstant: 18)
            centerSelectionHeightAnchor.isActive = true
        
        self.view.addSubview(leftSelectionLine)
        leftSelectionLine.rightAnchor.constraint(equalTo: centerSelectionLine.leftAnchor, constant: -6).isActive = true
        leftSelectionLine.bottomAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 42).isActive = true
        leftSelectionLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftSelectionHeightAnchor = leftSelectionLine.heightAnchor.constraint(equalToConstant: 28)
            leftSelectionHeightAnchor.isActive = true
        
        self.view.addSubview(rightSelectionLine)
        rightSelectionLine.leftAnchor.constraint(equalTo: centerSelectionLine.rightAnchor, constant: 6).isActive = true
        rightSelectionLine.bottomAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 42).isActive = true
        rightSelectionLine.widthAnchor.constraint(equalToConstant: 10).isActive = true
        rightSelectionHeightAnchor = rightSelectionLine.heightAnchor.constraint(equalToConstant: 18)
            rightSelectionHeightAnchor.isActive = true
        
        self.view.bringSubviewToFront(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth * 3, height: phoneHeight)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        circularView.addSubview(firstImageView)
        firstImageView.bottomAnchor.constraint(equalTo: circularView.bottomAnchor).isActive = true
        firstImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        firstImageView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        circularView.addSubview(secondImageView)
        secondImageView.bottomAnchor.constraint(equalTo: circularView.bottomAnchor).isActive = true
        secondImageView.leftAnchor.constraint(equalTo: firstImageView.rightAnchor).isActive = true
        secondImageView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
        circularView.addSubview(thirdImageView)
        thirdImageView.bottomAnchor.constraint(equalTo: circularView.bottomAnchor).isActive = true
        thirdImageView.leftAnchor.constraint(equalTo: secondImageView.rightAnchor).isActive = true
        thirdImageView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        thirdImageView.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
    }
    
    func setupButtons() {
        
        self.view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: centerSelectionLine.bottomAnchor, constant: 28).isActive = true
        mainButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(socialLabel)
        socialLabel.leftAnchor.constraint(equalTo: mainButton.leftAnchor).isActive = true
        socialLabel.rightAnchor.constraint(equalTo: mainButton.rightAnchor).isActive = true
        socialLabel.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 20).isActive = true
        socialLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(facebookButton)
        facebookButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -6).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        facebookButton.heightAnchor.constraint(equalTo: facebookButton.widthAnchor).isActive = true
        facebookButton.topAnchor.constraint(equalTo: socialLabel.bottomAnchor, constant: 12).isActive = true
        
        self.view.addSubview(googlePlusButton)
        googlePlusButton.leftAnchor.constraint(equalTo: facebookButton.rightAnchor, constant: 12).isActive = true
        googlePlusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        googlePlusButton.heightAnchor.constraint(equalTo: googlePlusButton.widthAnchor).isActive = true
        googlePlusButton.topAnchor.constraint(equalTo: socialLabel.bottomAnchor, constant: 12).isActive = true
        
    }
    
    var mobileNumberTopAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        self.view.addSubview(mobileNumberController.view)
        mobileNumberController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mobileNumberController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mobileNumberTopAnchor = mobileNumberController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            mobileNumberTopAnchor.isActive = true
        mobileNumberController.view.heightAnchor.constraint(equalToConstant: phoneHeight).isActive = true
        
    }

    @objc func mainButtonPressed() {
        self.mobileNumberTopAnchor.constant = 0
        self.mobileNumberController.backButton.alpha = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mobileNumberController.phoneNumberTextField.becomeFirstResponder()
            self.statusDelegate?.defaultStatusBar()
            self.statusDelegate?.bringStatusBar()
            UIView.animate(withDuration: animationIn, animations: {
                self.mobileNumberController.backButton.alpha = 1
            })
        }
    }
    
    func moveToMainController() {
        self.delegate?.moveToMainController()
        print("Successfully logged in!")
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize
    }
    
}


extension OnboardingViewController: handleOnboardingControllers {
    
    func dismissMobileNumber() {
        self.statusDelegate?.lightContentStatusBar()
        self.statusDelegate?.hideStatusBar()
        self.mobileNumberTopAnchor.constant = phoneHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
}


extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        if translation >= 0 && translation <= phoneWidth {
            let percentage = translation/phoneWidth
            self.leftSelectionHeightAnchor.constant = 28 - 10 * percentage
            self.centerSelectionHeightAnchor.constant = 18 + 10 * percentage
            self.leftSelectionLine.backgroundColor = Theme.BLUE.withAlphaComponent(1 - 0.8 * percentage)
            self.centerSelectionLine.backgroundColor = Theme.BLUE.withAlphaComponent(0.2 + 0.8 * percentage)
            self.mainLabel.alpha = 1 - percentage
            self.subLabel.alpha = 1 - percentage
            self.mainLabelCenterAnchor.constant = -phoneWidth/2 * percentage
        } else if translation >= phoneWidth && translation <= phoneWidth * 2 {
            let percentage = translation/phoneWidth - 1.0
            self.centerSelectionHeightAnchor.constant = 28 - 10 * percentage
            self.rightSelectionHeightAnchor.constant = 18 + 10 * percentage
            self.centerSelectionLine.backgroundColor = Theme.BLUE.withAlphaComponent(1 - 0.8 * percentage)
            self.rightSelectionLine.backgroundColor = Theme.BLUE.withAlphaComponent(0.2 + 0.8 * percentage)
            self.mainLabel.alpha = 1 - percentage
            self.subLabel.alpha = 1 - percentage
            self.mainLabelCenterAnchor.constant = -phoneWidth/2 * percentage
        }
        self.lastTranslation = translation
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.mainLabelCenterAnchor.constant = 0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 1
            self.subLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
}


extension OnboardingViewController {
    
    @objc func loginButtonDidCompleteLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .success(_, _, _):
                let access = AccessToken.current
                guard let accessTok = access?.authenticationToken else {return}
                
                let credentials = FacebookAuthProvider.credential(withAccessToken: accessTok)
                Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let userID = user?.user.uid
                    GraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(1000).height(1000)"]).start { (connection, results) in
                        switch results {
                        case .failed(let error):
                            print(error)
                        case .success(response: let graphResponse):
                            if let dictionary = graphResponse.dictionaryValue {
                                let json = JSON(dictionary)
                                let email = json["email"].string!
                                let name = json["name"].string!
                                let pictureObject = json["picture"].dictionary!
                                let pictureData = pictureObject["data"]?.dictionary!
                                let pictureUrl = pictureData!["url"]?.string!
                                
                                let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
                                let usersReference = ref.child("users").child(userID!)
                                let values = ["name": name,
                                              "email": email,
                                              "picture": pictureUrl!,
                                              "DeviceID": AppDelegate.DEVICEID]
                                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                    if err != nil {
                                        print(err!)
                                        return
                                    }
                                    print("Successfully logged in!")
                                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                    UserDefaults.standard.synchronize()
                                    self.delegate?.moveToMainController()
                                    
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                        }
                    }
                }
            case .cancelled:
                print("User canceled Facebook Login")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out of Facebook")
    }
    
    
    
    
}
