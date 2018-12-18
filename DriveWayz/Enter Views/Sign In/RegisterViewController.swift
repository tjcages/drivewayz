//
//  RegisterViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyJSON
import Firebase
import NVActivityIndicatorView

class RegisterViewController: UIViewController, UITextFieldDelegate, setupTermsControl {
    
    var delegate: handleSignInViews?
    var verificationCode: String?
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballTrianglePath, color: Theme.HARMONY_RED, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
        page.numberOfPages = 4
        page.currentPage = 0
        page.tintColor = Theme.WHITE
        page.pageIndicatorTintColor = Theme.WHITE
        page.currentPageIndicatorTintColor = Theme.PACIFIC_BLUE
        page.translatesAutoresizingMaskIntoConstraints = false
        page.isUserInteractionEnabled = false
        
        return page
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Back")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return button
    }()
    
    lazy var background1: UIView = {
        let background1 = UIImage(named: "background1")
        let imageView1 = UIImageView()
        imageView1.contentMode = UIView.ContentMode.scaleAspectFill
        imageView1.clipsToBounds = true
        imageView1.image = background1
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.center = self.view.center
        
        return imageView1
    }()
    
    lazy var title1: UILabel = {
        let label = UILabel()
        label.text = "Save money"
        label.font = Fonts.SSPSemiBoldH2
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "We're reinventing the way you think about parking by creating a network of private spots, now made public."
        label.font = Fonts.SSPLightH5
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var background2: UIView = {
        let background2 = UIImage(named: "background2")
        let imageView2 = UIImageView()
        imageView2.contentMode = UIView.ContentMode.scaleAspectFill
        imageView2.clipsToBounds = true
        imageView2.image = background2
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.center = self.view.center
        
        return imageView2
    }()
    
    lazy var title2: UILabel = {
        let label = UILabel()
        label.text = "Save time"
        label.font = Fonts.SSPSemiBoldH2
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "Stop wasting your time searching for a parking spot. Simply reserve a driveway and avoid the hassle."
        label.font = Fonts.SSPLightH5
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var background3: UIView = {
        let background3 = UIImage(named: "background3")
        let imageView3 = UIImageView()
        imageView3.contentMode = UIView.ContentMode.scaleAspectFill
        imageView3.clipsToBounds = true
        imageView3.image = background3
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        imageView3.center = self.view.center
        
        return imageView3
    }()
    
    lazy var title3: UILabel = {
        let label = UILabel()
        label.text = "Choose Drivewayz"
        label.font = Fonts.SSPSemiBoldH2
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "One Goal, One Passion - Smarter Parking."
        label.font = Fonts.SSPLightH5
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 4
        label.adjustsFontForContentSizeCategory = false
        label.alpha = 0
        
        return label
    }()
    
    lazy var blurBackground: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    lazy var container: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        let gesture1 = UISwipeGestureRecognizer(target: self, action: #selector(backgroundSwippedRight))
        gesture1.direction = .right
        let gesture2 = UISwipeGestureRecognizer(target: self, action: #selector(backgroundSwippedLeft))
        gesture2.direction = .left
        let gesture3 = UISwipeGestureRecognizer(target: self, action: #selector(exitButtonSent))
        gesture3.direction = .down
        container.addGestureRecognizer(gesture1)
        container.addGestureRecognizer(gesture2)
        container.addGestureRecognizer(gesture3)
        
        return container
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.SEA_BLUE, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.SEA_BLUE.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.titleLabel?.font = Fonts.SSPLightH4
        button.alpha = 0
        button.addTarget(self, action: #selector(moveToNextController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.titleLabel?.font = Fonts.SSPLightH4
        button.alpha = 0
        button.addTarget(self, action: #selector(moveBackController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var registerLabel: UITextView = {
        let label = UITextView()
        label.text = "Let's start with your name"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH2
        label.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        label.clipsToBounds = false
        label.isEditable = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var phoneNumberTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "(303) 555-1234"
        field.textAlignment = .right
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.keyboardType = .numberPad
        
        return field
    }()
    
    var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+1"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH2
        label.alpha = 0
        
        return label
    }()
    
    var USAButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "USA")
        button.setImage(origImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    var phoneLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var verificationTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "• • • • • •"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.keyboardType = .numberPad
        
        return field
    }()
    
    var emailTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "drivewayz@example.com"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var nameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "John Appleseed"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .words
        
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "••••••••"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        
        return field
    }()
    
    var repeatPasswordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "••••••••"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        
        return field
    }()
    
    var errorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Please enter your full name", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.7)
        button.titleLabel?.font = Fonts.SSPLightH2
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Sign in with Facebook", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.addTarget(self, action: #selector(facebookSignUp), for: .touchUpInside)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "or"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.backgroundColor = Theme.WHITE
        label.alpha = 0
        
        return label
    }()
    
    var orLine: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = 0
        
        return line
    }()
    
    var emailAndPasswordOption: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Sign up with email and password", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(signUpWithEmail(sender:)), for: .touchUpInside)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        verificationTextField.delegate = self
        emailTextField.delegate = self
        nameField.delegate = self
        passwordField.delegate = self
        repeatPasswordField.delegate = self
        view.backgroundColor = UIColor.clear
        
        let background = CAGradientLayer().mixColors()
        background.frame = CGRect(x: 0, y: self.view.frame.height-140, width: self.view.frame.width, height: 140)
        background.zPosition = -10
        mainView.layer.insertSublayer(background, at: 0)
        
        setupBackground()
        configurePageControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var driveWayzTopAnchor: NSLayoutConstraint!
    var backgroundLeftAnchor: NSLayoutConstraint!
    
    func setupBackground() {
        
        self.view.addSubview(background1)
        background1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundLeftAnchor = background1.leftAnchor.constraint(equalTo: view.leftAnchor)
        backgroundLeftAnchor.isActive = true
        background1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        background1.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(background2)
        background2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        background2.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        background2.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        background2.leftAnchor.constraint(equalTo: background1.rightAnchor).isActive = true
        
        self.view.addSubview(background3)
        background3.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        background3.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        background3.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        background3.leftAnchor.constraint(equalTo: background2.rightAnchor).isActive = true
        
        self.view.addSubview(blurBackground)
        blurBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(label1)
        label1.centerXAnchor.constraint(equalTo: background1.centerXAnchor).isActive = true
        label1.centerYAnchor.constraint(equalTo: background1.centerYAnchor, constant: 160).isActive = true
        label1.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(label2)
        label2.centerXAnchor.constraint(equalTo: background2.centerXAnchor).isActive = true
        label2.centerYAnchor.constraint(equalTo: background2.centerYAnchor, constant: 160).isActive = true
        label2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(label3)
        label3.centerXAnchor.constraint(equalTo: background3.centerXAnchor).isActive = true
        label3.centerYAnchor.constraint(equalTo: background3.centerYAnchor, constant: 160).isActive = true
        label3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(title1)
        title1.centerXAnchor.constraint(equalTo: background1.centerXAnchor).isActive = true
        title1.bottomAnchor.constraint(equalTo: label1.topAnchor, constant: 0).isActive = true
        title1.widthAnchor.constraint(equalToConstant: 300).isActive = true
        title1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(title2)
        title2.centerXAnchor.constraint(equalTo: background2.centerXAnchor).isActive = true
        title2.bottomAnchor.constraint(equalTo: label2.topAnchor, constant: 0).isActive = true
        title2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        title2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(title3)
        title3.centerXAnchor.constraint(equalTo: background3.centerXAnchor).isActive = true
        title3.bottomAnchor.constraint(equalTo: label3.topAnchor, constant: 0).isActive = true
        title3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        title3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(exitButton)
        self.setupMainView()
    }
    
    var emailCenterAnchor: NSLayoutConstraint!
    var verificationCenterAnchor: NSLayoutConstraint!
    var phoneNumberCenterAnchor: NSLayoutConstraint!
    var passwordCenterAnchor: NSLayoutConstraint!
    var repeatCenterAnchor: NSLayoutConstraint!
    var fieldLineWidthAnchor: NSLayoutConstraint!
    
    func setupMainView() {
        
        self.view.addSubview(mainView)
        self.view.bringSubviewToFront(container)
        mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mainView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: background3.rightAnchor).isActive = true
        
        self.view.addSubview(registerLabel)
        registerLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 30).isActive = true
        registerLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 12).isActive = true
        registerLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -12).isActive = true
        registerLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(USAButton)
        USAButton.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        USAButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 40).isActive = true
        USAButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        USAButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(areaCodeLabel)
        areaCodeLabel.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        areaCodeLabel.leftAnchor.constraint(equalTo: USAButton.rightAnchor, constant: 10).isActive = true
        areaCodeLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -40).isActive = true
        areaCodeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(nameField)
        nameField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        nameField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        nameField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(phoneLine)
        phoneLine.centerXAnchor.constraint(equalTo: nameField.centerXAnchor).isActive = true
        fieldLineWidthAnchor = phoneLine.widthAnchor.constraint(equalTo: nameField.widthAnchor)
            fieldLineWidthAnchor.isActive = true
        phoneLine.topAnchor.constraint(equalTo: nameField.bottomAnchor).isActive = true
        phoneLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(verificationTextField)
        verificationTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        verificationTextField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        verificationCenterAnchor = verificationTextField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            verificationCenterAnchor.isActive = true
        verificationTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        emailCenterAnchor = emailTextField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            emailCenterAnchor.isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        phoneNumberTextField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -80).isActive = true
        phoneNumberCenterAnchor = phoneNumberTextField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            phoneNumberCenterAnchor.isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        passwordField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        passwordCenterAnchor = passwordField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            passwordCenterAnchor.isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(repeatPasswordField)
        repeatPasswordField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        repeatPasswordField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        repeatCenterAnchor = repeatPasswordField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            repeatCenterAnchor.isActive = true
        repeatPasswordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(errorButton)
        errorButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        errorButton.widthAnchor.constraint(equalTo: phoneNumberTextField.widthAnchor, constant: 20).isActive = true
        errorButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10).isActive = true
        errorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        loadingActivity.topAnchor.constraint(equalTo: phoneLine.bottomAnchor, constant: 20).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    var nextButtonCenterAnchor: NSLayoutConstraint!
    var nextButtonWidthAnchor: NSLayoutConstraint!
    var nextButtonHeightAnchor: NSLayoutConstraint!
    var nextButtonTopAnchor: NSLayoutConstraint!
    
    func configurePageControl() {
        
        self.view.bringSubviewToFront(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        self.view.addSubview(pageControl)
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        self.view.addSubview(nextButton)
        nextButtonCenterAnchor = nextButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        nextButtonCenterAnchor.isActive = true
        nextButtonTopAnchor = nextButton.bottomAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 60)
        nextButtonTopAnchor.isActive = true
        nextButtonHeightAnchor = nextButton.heightAnchor.constraint(equalToConstant: 40)
        nextButtonHeightAnchor.isActive = true
        nextButtonWidthAnchor = nextButton.widthAnchor.constraint(equalToConstant: 160)
        nextButtonWidthAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -90).isActive = true
        backButton.bottomAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        facebookLoginButton.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(orLine)
        orLine.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        orLine.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        orLine.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 40).isActive = true
        orLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(orLabel)
        orLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        orLabel.centerYAnchor.constraint(equalTo: orLine.centerYAnchor).isActive = true
        orLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(emailAndPasswordOption)
        emailAndPasswordOption.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        emailAndPasswordOption.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        emailAndPasswordOption.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 10).isActive = true
        emailAndPasswordOption.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func backgroundSwippedLeft() {
        if self.backgroundLeftAnchor.constant == (-self.view.frame.width) * 3 {
            return
        } else {
            self.pageControl.currentPage = self.pageControl.currentPage + 1
            self.backgroundLeftAnchor.constant = self.backgroundLeftAnchor.constant - self.view.frame.width
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
        if self.pageControl.currentPage == 3 {
            self.delegate?.defaultStatusBar()
            UIView.animate(withDuration: animationIn) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.blurBackground.alpha = 0
                self.pageControl.pageIndicatorTintColor = Theme.WHITE
                self.pageControl.currentPageIndicatorTintColor = Theme.HARMONY_RED.withAlphaComponent(0.7)
                let origImage = UIImage(named: "Back")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.exitButton.setImage(tintedImage, for: .normal)
                self.exitButton.tintColor = Theme.BLACK
            }
        } else {
            self.delegate?.lightContentStatusBar()
            UIView.animate(withDuration: animationIn) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.blurBackground.alpha = 0.4
                self.pageControl.pageIndicatorTintColor = Theme.WHITE
                self.pageControl.currentPageIndicatorTintColor = Theme.PACIFIC_BLUE
                let origImage = UIImage(named: "Back")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.exitButton.setImage(tintedImage, for: .normal)
                self.exitButton.tintColor = Theme.WHITE
            }
        }
    }
    
    @objc func backgroundSwippedRight() {
        if self.backgroundLeftAnchor.constant == 0 {
            self.exitButtonSent()
            return
        } else {
            self.backgroundLeftAnchor.constant = self.backgroundLeftAnchor.constant + self.view.frame.width
            self.pageControl.currentPage = self.pageControl.currentPage - 1
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
        if self.pageControl.currentPage != 3 {
            self.delegate?.lightContentStatusBar()
            UIView.animate(withDuration: animationIn) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.blurBackground.alpha = 0.4
                self.pageControl.pageIndicatorTintColor = Theme.WHITE
                self.pageControl.currentPageIndicatorTintColor = Theme.PACIFIC_BLUE
                let origImage = UIImage(named: "Back")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.exitButton.setImage(tintedImage, for: .normal)
                self.exitButton.tintColor = Theme.WHITE
            }
        }
    }
    
    @objc func moveToNextController(sender: UIButton) {
        if self.nameField.alpha == 1 {
            guard let name = self.nameField.text else { return }
            if !name.contains(" ") {
                self.errorButton.setTitle("Please enter your full name", for: .normal)
                UIView.animate(withDuration: animationIn) {
                    self.errorButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: animationIn, animations: {
                    self.errorButton.alpha = 0
                    self.nameField.alpha = 0
                    self.facebookLoginButton.alpha = 0
                    self.loadingActivity.alpha = 0
                    self.loadingActivity.alpha = 1
                }) { (success) in
                    self.view.endEditing(true)
                    self.nextButton.setTitle("Send Code", for: .normal)
                    self.registerLabel.text = "Please enter your phone number for verification"
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: animationIn, animations: {
                        self.phoneNumberCenterAnchor.constant = -10
                        self.areaCodeLabel.alpha = 1
                        self.USAButton.alpha = 1
                        self.nextButtonCenterAnchor.constant = 50
                        self.backButton.alpha = 1
                        self.emailAndPasswordOption.alpha = 1
                        self.orLine.alpha = 1
                        self.orLabel.alpha = 1
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else if self.phoneNumberCenterAnchor.constant == -10 && self.phoneNumberTextField.alpha == 1 {
            if self.phoneNumberTextField.text?.count != 14 {
                self.errorButton.setTitle("Please enter a valid phone number", for: .normal)
                UIView.animate(withDuration: animationIn) {
                    self.errorButton.alpha = 1
                }
            } else {
                if self.emailTextField.alpha == 0 {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.errorButton.alpha = 0
                        self.phoneNumberTextField.alpha = 0
                        self.areaCodeLabel.alpha = 0
                        self.USAButton.alpha = 0
                    }) { (success) in
                        self.passwordField.becomeFirstResponder()
                        self.registerLabel.text = "Choose a secure password"
                        UIView.animate(withDuration: animationIn, animations: {
                            self.passwordCenterAnchor.constant = 0
                            self.view.layoutIfNeeded()
                        })
                    }
                } else {
                    self.loadingActivity.startAnimating()
                    UIView.animate(withDuration: animationIn) {
                        self.loadingActivity.alpha = 1
                    }
                    guard var phoneNumber = self.phoneNumberTextField.text else { return }
                    phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                    phoneNumber = "+1" + phoneNumber.replacingOccurrences(of: "-", with: "")
                    self.nextButton.isUserInteractionEnabled = false
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            self.sendAlert(message: error.localizedDescription)
                            self.nextButton.isUserInteractionEnabled = true
                            UIView.animate(withDuration: animationIn, animations: {
                                self.loadingActivity.alpha = 0
                            })
                            self.loadingActivity.stopAnimating()
                            return
                        }
                        self.nextButton.isUserInteractionEnabled = true
                        self.verificationCode = verificationID
                        UIView.animate(withDuration: animationIn, animations: {
                            self.facebookLoginButton.alpha = 0
                            self.errorButton.alpha = 0
                            self.phoneNumberTextField.alpha = 0
                            self.areaCodeLabel.alpha = 0
                            self.USAButton.alpha = 0
                            self.orLine.alpha = 0
                            self.orLabel.alpha = 0
                            self.emailAndPasswordOption.alpha = 0
                            self.loadingActivity.alpha = 0
                        }) { (success) in
                            self.loadingActivity.stopAnimating()
                            let number = self.phoneNumberTextField.text
                            self.view.endEditing(true)
                            UIView.animate(withDuration: animationIn, animations: {
                                self.verificationCenterAnchor.constant = 0
                                self.fieldLineWidthAnchor.constant = -self.phoneNumberTextField.frame.width/2 - 20
                                self.view.layoutIfNeeded()
                            })
                            self.registerLabel.text = "Enter the six digit verification code sent to \(number!)"
                            self.nextButton.setTitle("Confirm", for: .normal)
                        }
                    }
                }
            }
        } else if self.emailCenterAnchor.constant == 0 && self.emailTextField.alpha == 1 {
            guard let email = self.emailTextField.text else { return }
            if !email.contains("@") || !email.contains(".") {
                self.errorButton.setTitle("Please enter a valid email", for: .normal)
                UIView.animate(withDuration: animationIn) {
                    self.errorButton.alpha = 1
                }
            } else {
                self.phoneNumberCenterAnchor.constant = self.view.frame.width
                self.phoneNumberTextField.alpha = 1
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: animationIn, animations: {
                    self.errorButton.alpha = 0
                    self.emailTextField.alpha = 0
                }) { (success) in
                    self.phoneNumberTextField.becomeFirstResponder()
                    self.registerLabel.text = "Please enter your phone number"
//                    self.registerLabel.text = "Choose a secure password"
                    UIView.animate(withDuration: animationIn, animations: {
                        self.phoneNumberCenterAnchor.constant = -10
                        self.USAButton.alpha = 1
                        self.areaCodeLabel.alpha = 1
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else if self.passwordCenterAnchor.constant == 0 && self.passwordField.alpha == 1 {
            guard let password = self.passwordField.text else { return }
            if password.count < 8 {
                self.errorButton.setTitle("Needs to be at least 8 characters", for: .normal)
                UIView.animate(withDuration: animationIn) {
                    self.errorButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: animationIn, animations: {
                    self.errorButton.alpha = 0
                    self.passwordField.alpha = 0
                }) { (success) in
                    self.repeatPasswordField.becomeFirstResponder()
                    self.registerLabel.text = "Repeat password"
                    UIView.animate(withDuration: animationIn, animations: {
                        self.nextButtonCenterAnchor.constant = 0
                        self.nextButtonTopAnchor.constant = 15
                        self.nextButtonHeightAnchor.constant = 50
                        self.nextButtonWidthAnchor.constant = 240
                        self.nextButton.layer.cornerRadius = 25
                        self.nextButton.titleLabel?.font = Fonts.SSPLightH2
                        self.nextButton.setTitleColor(Theme.WHITE, for: .normal)
                        self.nextButton.backgroundColor = Theme.SEA_BLUE
                        self.backButton.alpha = 1
                        self.repeatCenterAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    })
                    self.nextButton.setTitle("Register Account", for: .normal)
                }
            }
        } else if self.repeatPasswordField.alpha == 1 && self.repeatCenterAnchor.constant == 0 {
            guard let password = self.passwordField.text else { return }
            guard let repeatPass = self.repeatPasswordField.text else { return }
            if password != repeatPass {
                self.errorButton.setTitle("The passwords don't match", for: .normal)
                UIView.animate(withDuration: animationIn) {
                    self.errorButton.alpha = 1
                }
            } else {
                self.view.endEditing(true)
                self.setupTerms()
            }
        }
    }
    
    @objc func moveBackController(sender: UIButton) {
        if self.phoneNumberCenterAnchor.constant == -10 && self.phoneNumberTextField.alpha == 1 {
            if self.emailTextField.alpha == 0 {
                UIView.animate(withDuration: animationIn, animations: {
                    self.phoneNumberCenterAnchor.constant = self.view.frame.width
                    self.USAButton.alpha = 0
                    self.areaCodeLabel.alpha = 0
                    self.errorButton.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.emailTextField.becomeFirstResponder()
                    self.registerLabel.text = "Enter your email address"
                    UIView.animate(withDuration: animationIn, animations: {
                        self.emailTextField.alpha = 1
                    })
                }
            } else {
                UIView.animate(withDuration: animationIn, animations: {
                    self.phoneNumberCenterAnchor.constant = self.view.frame.width
                    self.USAButton.alpha = 0
                    self.areaCodeLabel.alpha = 0
                    self.nextButtonCenterAnchor.constant = 0
                    self.backButton.alpha = 0
                    self.errorButton.alpha = 0
                    self.emailAndPasswordOption.alpha = 0
                    self.orLine.alpha = 0
                    self.orLabel.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.nameField.becomeFirstResponder()
                    self.nextButton.setTitle("Next", for: .normal)
                    self.registerLabel.text = "Let's start with your name"
                    UIView.animate(withDuration: animationIn, animations: {
                        self.nameField.alpha = 1
                        self.facebookLoginButton.alpha = 1
                    })
                }
            }
        } else if self.emailCenterAnchor.constant == 0 && self.emailTextField.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.emailCenterAnchor.constant = self.view.frame.width
                self.errorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.view.endEditing(true)
                self.nextButton.setTitle("Send Code", for: .normal)
                self.registerLabel.text = "Please enter your phone number for verification"
                UIView.animate(withDuration: animationIn, animations: {
                    self.phoneNumberCenterAnchor.constant = -10
                    self.phoneNumberTextField.alpha = 1
                    self.orLine.alpha = 1
                    self.orLabel.alpha = 1
                    self.emailAndPasswordOption.alpha = 1
                    self.areaCodeLabel.alpha = 1
                    self.USAButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else if self.verificationCenterAnchor.constant == 0 && self.verificationTextField.alpha == 1 {
            self.loadingActivity.stopAnimating()
            UIView.animate(withDuration: animationIn, animations: {
                self.verificationCenterAnchor.constant = self.view.frame.width
                self.fieldLineWidthAnchor.constant = 0
                self.errorButton.alpha = 0
                self.loadingActivity.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.view.endEditing(true)
                self.nextButton.setTitle("Send Code", for: .normal)
                self.registerLabel.text = "Please enter your phone number for verification"
                self.verificationTextField.text = ""
                UIView.animate(withDuration: animationIn, animations: {
                    self.phoneNumberTextField.alpha = 1
                    self.areaCodeLabel.alpha = 1
                    self.USAButton.alpha = 1
                    self.orLine.alpha = 1
                    self.orLabel.alpha = 1
                    self.emailAndPasswordOption.alpha = 1
                })
            }
        } else if self.passwordCenterAnchor.constant == 0 && self.passwordField.alpha == 1 {
            UIView.animate(withDuration: animationIn, animations: {
                self.passwordCenterAnchor.constant = self.view.frame.width
                self.errorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.phoneNumberTextField.becomeFirstResponder()
                self.registerLabel.text = "Please enter your phone number for verification"
                UIView.animate(withDuration: animationIn, animations: {
                    self.phoneNumberTextField.alpha = 1
                    self.USAButton.alpha = 1
                    self.areaCodeLabel.alpha = 1
                })
            }
        } else if self.repeatCenterAnchor.constant == 0 && self.repeatPasswordField.alpha == 1 {
            self.loadingActivity.stopAnimating()
            UIView.animate(withDuration: animationIn, animations: {
                self.repeatCenterAnchor.constant = self.view.frame.width
                self.errorButton.alpha = 0
                self.loadingActivity.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.passwordField.becomeFirstResponder()
                self.registerLabel.text = "Choose a secure password"
                UIView.animate(withDuration: animationIn, animations: {
                    self.passwordField.alpha = 1
                    self.nextButtonCenterAnchor.constant = 50
                    self.nextButtonTopAnchor.constant = 60
                    self.nextButtonHeightAnchor.constant = 40
                    self.nextButtonWidthAnchor.constant = 160
                    self.nextButton.layer.cornerRadius = 20
                    self.nextButton.titleLabel?.font = Fonts.SSPLightH3
                    self.nextButton.setTitleColor(Theme.SEA_BLUE, for: .normal)
                    self.nextButton.backgroundColor = UIColor.clear
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    @objc func signUpWithEmail(sender: UIButton) {
        UIView.animate(withDuration: animationIn, animations: {
            self.errorButton.alpha = 0
            self.phoneNumberTextField.alpha = 0
            self.USAButton.alpha = 0
            self.areaCodeLabel.alpha = 0
            self.orLine.alpha = 0
            self.orLabel.alpha = 0
            self.emailAndPasswordOption.alpha = 0
        }) { (success) in
            self.emailTextField.becomeFirstResponder()
            UIView.animate(withDuration: animationIn, animations: {
                self.phoneNumberTextField.alpha = 0
                self.USAButton.alpha = 0
                self.areaCodeLabel.alpha = 0
                self.emailCenterAnchor.constant = 0
                self.fieldLineWidthAnchor.constant = 0
                self.nextButtonCenterAnchor.constant = 50
                self.backButton.alpha = 1
                self.view.layoutIfNeeded()
            })
            self.registerLabel.text = "Enter your email address"
            self.nextButton.setTitle("Next", for: .normal)
        }
    }
    
    func setupTerms() {
//        self.view.addSubview(termsController.view)
//        self.addChild(termsController)
//        termsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        termsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        termsController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
//        self.view.layoutIfNeeded()
//        self.loadingActivity.startAnimating()
//        UIView.animate(withDuration: animationIn) {
//            self.termsController.view.alpha = 1
//            self.loadingActivity.alpha = 1
//        }
    }
    
    func agreeToTerms() {
        UIView.animate(withDuration: animationIn, animations: {
//            self.termsController.view.alpha = 0
        }) { (success) in
//            self.termsController.willMove(toParent: nil)
//            self.termsController.view.removeFromSuperview()
//            self.termsController.removeFromParent()
        }
        self.signUp(withEmail: true)
        self.delegate?.defaultStatusBar()
    }
    
    func registerWithPhoneNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            guard let userVerification = self.verificationTextField.text?.replacingOccurrences(of: " ", with: "") else { return }
            if userVerification.count == 6 {
                self.view.endEditing(true)
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationCode!, verificationCode: userVerification)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        if let error = error {
                            UIView.animate(withDuration: animationIn, animations: {
                                self.loadingActivity.alpha = 0
                            })
                            self.loadingActivity.stopAnimating()
                            self.sendAlert(message: error.localizedDescription)
                            self.verificationTextField.becomeFirstResponder()
                            return
                        }
                        guard let uid = authResult?.user.uid else { return }
                        guard let phoneNumber = self.phoneNumberTextField.text, let userName = self.nameField.text else { return }
                        let userEmail = ""
                        let userProfileUrl = ""
                        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
                        let usersReference = ref.child("users").child(uid)
                        let values = ["name": userName,
                                      "email": userEmail,
                                      "phone": "+1 " + phoneNumber,
                                      "picture": userProfileUrl,
                                      "DeviceID": AppDelegate.DEVICEID]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                self.sendAlert(message: (err?.localizedDescription)!)
                                return
                            }
                            UIView.animate(withDuration: animationIn, animations: {
                                self.loadingActivity.alpha = 0
                            })
                            self.loadingActivity.stopAnimating()
                            print("Successfully logged in!")
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.set("\(userName)", forKey: "userName")
                            UserDefaults.standard.synchronize()
                            
                            let myViewController: TabViewController = TabViewController()
                            myViewController.removeFromParent()
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = myViewController
                            appDelegate.window?.makeKeyAndVisible()
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        })
                    }
                }
            } else {
                UIView.animate(withDuration: animationIn, animations: {
                    self.loadingActivity.alpha = 0
                })
                self.loadingActivity.stopAnimating()
            }
        }
    }
    
    func signUp(withEmail: Bool) {
        self.view.endEditing(true)
        let userProfileUrl: String = ""
        guard let phoneNumber = phoneNumberTextField.text, var userEmail = emailTextField.text, let userName = nameField.text, var userPassword = passwordField.text else {
            print("Error")
            return
        }
        if withEmail == false {
            let randomString = String.random()
            userEmail = randomString + "@drivewayz.com"
            userPassword = self.verificationCode!
        }
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error != nil {
                self.sendAlert(message: (error?.localizedDescription)!)
                return
            }
            guard let uid = user?.user.uid else {return}
            let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": userName,
                          "email": userEmail,
                          "phone": "+1 " + phoneNumber,
                          "picture": userProfileUrl,
                          "DeviceID": AppDelegate.DEVICEID]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    self.sendAlert(message: (err?.localizedDescription)!)
                    return
                }
                UIView.animate(withDuration: animationIn, animations: {
                    self.loadingActivity.alpha = 0
                })
                self.loadingActivity.stopAnimating()
                print("Successfully logged in!")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set("\(userName)", forKey: "userName")
                UserDefaults.standard.synchronize()
                
                let myViewController: TabViewController = TabViewController()
                myViewController.removeFromParent()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = myViewController
                appDelegate.window?.makeKeyAndVisible()
                
                self.dismiss(animated: true, completion: nil)
                
            })
        })
    }
    
    @objc func facebookSignUp() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                let access = accessToken
                let accessTok = access.authenticationToken
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
                                    UserDefaults.standard.set("\(name)", forKey: "userName")
                                    UserDefaults.standard.synchronize()
                                    
                                    let myViewController: TabViewController = TabViewController()
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = myViewController
                                    appDelegate.window?.makeKeyAndVisible()
                                    
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func exitButtonSent() {
        self.view.endEditing(true)
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideRegisterPage()
        UIView.animate(withDuration: animationIn) {
            self.blurBackground.alpha = 0
            self.title1.alpha = 0
            self.title2.alpha = 0
            self.title3.alpha = 0
            self.label1.alpha = 0
            self.label2.alpha = 0
            self.label3.alpha = 0
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.exitButtonSent()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" {
            UIView.animate(withDuration: animationIn) {
                self.nextButton.alpha = 1
                self.errorButton.alpha = 0
            }
        }
        if textField == self.phoneNumberTextField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if fullString.count == 14 {
                self.view.endEditing(true)
            }
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
            return false
        } else if textField == self.verificationTextField {
            guard let fullString = textField.text else { return false }
            if fullString.count == 10 {
                self.loadingActivity.startAnimating()
                UIView.animate(withDuration: animationIn) {
                    self.loadingActivity.alpha = 1
                }
                self.registerWithPhoneNumber()
            } else {
                self.loadingActivity.stopAnimating()
                UIView.animate(withDuration: animationIn) {
                    self.loadingActivity.alpha = 0
                }
            }
            if fullString.count < 11 {
                let  char = string.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                if !(isBackSpace == -92) {
                    textField.text = fullString + " "
                } else {
                    guard let string = textField.text else { return false }
                    textField.text = String(string.dropLast())
                }
                return true
            } else if range.length == 1 {
                UIView.animate(withDuration: animationIn, animations: {
                    self.loadingActivity.alpha = 0
                })
                self.loadingActivity.stopAnimating()
                guard let string = textField.text else { return false }
                textField.text = String(string.dropLast())
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: animationIn, animations: {
                self.blurBackground.alpha = 0.5
                self.title1.alpha = 1
                self.title2.alpha = 1
                self.title3.alpha = 1
                self.label1.alpha = 1
                self.label2.alpha = 1
                self.label3.alpha = 1
            }, completion: { (success) in
                //
            })
        }
    }
    
    var statusBarStyle: Bool = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarStyle == true {
            return .lightContent
        } else {
            return .default
        }
    }
    


}


extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}
