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

class RegisterViewController: UIViewController, UITextFieldDelegate, setupTermsControl {
    
    var delegate: handleSignInViews?
    
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
    
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
        imageView1.contentMode = UIViewContentMode.scaleAspectFill
        imageView1.clipsToBounds = true
        imageView1.image = background1
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.center = self.view.center
        
        return imageView1
    }()
    
    lazy var title1: UILabel = {
        let label = UILabel()
        label.text = "Save money"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        
        return label
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "We're reinventing the way you think about parking by creating a network of private spots, now made public."
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = false
        
        return label
    }()
    
    lazy var background2: UIView = {
        let background2 = UIImage(named: "background2")
        let imageView2 = UIImageView()
        imageView2.contentMode = UIViewContentMode.scaleAspectFill
        imageView2.clipsToBounds = true
        imageView2.image = background2
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.center = self.view.center
        
        return imageView2
    }()
    
    lazy var title2: UILabel = {
        let label = UILabel()
        label.text = "Save time"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "Don't waste time anymore searching for parking. Just reserve an open spot and avoid the hassle."
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = false
        
        return label
    }()
    
    lazy var background3: UIView = {
        let background3 = UIImage(named: "background3")
        let imageView3 = UIImageView()
        imageView3.contentMode = UIViewContentMode.scaleAspectFill
        imageView3.clipsToBounds = true
        imageView3.image = background3
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        imageView3.center = self.view.center
        
        return imageView3
    }()
    
    lazy var title3: UILabel = {
        let label = UILabel()
        label.text = "Choose Drivewayz"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "One goal, one passion - Smarter Parking."
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 4
        label.adjustsFontForContentSizeCategory = false
        
        return label
    }()
    
    lazy var blurBackground: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.4
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
        container.addGestureRecognizer(gesture1)
        container.addGestureRecognizer(gesture2)
        
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
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        button.alpha = 0
        button.addTarget(self, action: #selector(moveBackController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's start with your phone number"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        
        return label
    }()
    
    var phoneNumberTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 26, weight: .light)
        field.placeholder = "(303) 555-1234"
        field.textAlignment = .right
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.keyboardType = .numberPad
        
        return field
    }()
    
    var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+1"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .light)
        
        return label
    }()
    
    var USAButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "USA")
        button.setImage(origImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var phoneLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 1.5
        
        return view
    }()
    
    var emailTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 26, weight: .light)
        field.placeholder = "drivewayz@example.com"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var nameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 26, weight: .light)
        field.placeholder = "John Appleseed"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .words
        
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 26, weight: .light)
        field.placeholder = "••••••••"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        
        return field
    }()
    
    var repeatPasswordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 26, weight: .light)
        field.placeholder = "••••••••"
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        
        return field
    }()
    
    var errorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Please enter a valid phone number", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.HARMONY_COLOR.withAlphaComponent(0.7)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var termsController: TermsViewController = {
        let controller = TermsViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.title = "Terms"
        controller.view.alpha = 0
        return controller
    }()
    
    var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Login with Facebook", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.addTarget(self, action: #selector(facebookSignUp), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        nameField.delegate = self
        passwordField.delegate = self
        repeatPasswordField.delegate = self
        view.backgroundColor = UIColor.clear
        
        let background = CAGradientLayer().mixColors()
        background.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2)
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
        label1.centerYAnchor.constraint(equalTo: background1.centerYAnchor, constant: 40).isActive = true
        label1.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(label2)
        label2.centerXAnchor.constraint(equalTo: background2.centerXAnchor).isActive = true
        label2.centerYAnchor.constraint(equalTo: background2.centerYAnchor, constant: 40).isActive = true
        label2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(label3)
        label3.centerXAnchor.constraint(equalTo: background3.centerXAnchor).isActive = true
        label3.centerYAnchor.constraint(equalTo: background3.centerYAnchor, constant: 40).isActive = true
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
    var nameCenterAnchor: NSLayoutConstraint!
    var passwordCenterAnchor: NSLayoutConstraint!
    var repeatCenterAnchor: NSLayoutConstraint!
    
    func setupMainView() {
        
        self.view.addSubview(mainView)
        self.view.bringSubview(toFront: container)
        mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mainView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: background3.rightAnchor).isActive = true
        
        self.view.addSubview(registerLabel)
        registerLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 40).isActive = true
        registerLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 12).isActive = true
        registerLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -12).isActive = true
        registerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
        
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        phoneNumberTextField.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 40).isActive = true
        phoneNumberTextField.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -50).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(phoneLine)
        phoneLine.leftAnchor.constraint(equalTo: phoneNumberTextField.leftAnchor).isActive = true
        phoneLine.rightAnchor.constraint(equalTo: phoneNumberTextField.rightAnchor).isActive = true
        phoneLine.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor).isActive = true
        phoneLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        emailCenterAnchor = emailTextField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            emailCenterAnchor.isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(nameField)
        nameField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40).isActive = true
        nameField.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -40).isActive = true
        nameCenterAnchor = nameField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.view.frame.width)
            nameCenterAnchor.isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
    }
    
    var nextButtonCenterAnchor: NSLayoutConstraint!
    var nextButtonWidthAnchor: NSLayoutConstraint!
    var nextButtonHeightAnchor: NSLayoutConstraint!
    var nextButtonTopAnchor: NSLayoutConstraint!
    
    func configurePageControl() {
        
        self.view.bringSubview(toFront: exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = Theme.WHITE
        self.pageControl.pageIndicatorTintColor = Theme.WHITE
        self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
        
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        self.view.addSubview(nextButton)
        nextButtonCenterAnchor = nextButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        nextButtonCenterAnchor.isActive = true
        nextButtonTopAnchor = nextButton.bottomAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 50)
        nextButtonTopAnchor.isActive = true
        nextButtonHeightAnchor = nextButton.heightAnchor.constraint(equalToConstant: 40)
        nextButtonHeightAnchor.isActive = true
        nextButtonWidthAnchor = nextButton.widthAnchor.constraint(equalToConstant: 160)
        nextButtonWidthAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -90).isActive = true
        backButton.bottomAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        facebookLoginButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -30).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
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
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.blurBackground.alpha = 0
                self.pageControl.pageIndicatorTintColor = Theme.WHITE
                self.pageControl.currentPageIndicatorTintColor = Theme.HARMONY_COLOR.withAlphaComponent(0.7)
                let origImage = UIImage(named: "Back")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.exitButton.setImage(tintedImage, for: .normal)
                self.exitButton.tintColor = Theme.BLACK
            }
        } else {
            self.delegate?.lightContentStatusBar()
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.blurBackground.alpha = 0.4
                self.pageControl.pageIndicatorTintColor = Theme.WHITE
                self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
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
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
                self.blurBackground.alpha = 0.4
                self.pageControl.pageIndicatorTintColor = Theme.WHITE
                self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
                let origImage = UIImage(named: "Back")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.exitButton.setImage(tintedImage, for: .normal)
                self.exitButton.tintColor = Theme.WHITE
            }
        }
    }
    
    @objc func moveToNextController(sender: UIButton) {
        if self.phoneNumberTextField.alpha == 1 {
            if self.phoneNumberTextField.text?.count != 14 {
                self.errorButton.setTitle("Please enter a valid phone number", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.errorButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.facebookLoginButton.alpha = 0
                    self.errorButton.alpha = 0
                    self.phoneNumberTextField.alpha = 0
                    self.areaCodeLabel.alpha = 0
                    self.USAButton.alpha = 0
                }) { (success) in
                    self.registerLabel.text = "Enter your email address"
                    self.emailTextField.becomeFirstResponder()
                    UIView.animate(withDuration: 0.3, animations: {
                        self.emailCenterAnchor.constant = 0
                        self.nextButtonCenterAnchor.constant = 50
                        self.backButton.alpha = 1
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else if self.emailTextField.alpha == 1 && self.emailCenterAnchor.constant == 0 {
            guard let email = self.emailTextField.text else { return }
            if !email.contains("@") || !email.contains(".") {
                self.errorButton.setTitle("Please enter a valid email", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.errorButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.errorButton.alpha = 0
                    self.emailTextField.alpha = 0
                }) { (success) in
                    self.nameField.becomeFirstResponder()
                    self.registerLabel.text = "Enter your full name"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.nameCenterAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else if self.nameField.alpha == 1 && self.nameCenterAnchor.constant == 0 {
            guard let name = self.nameField.text else { return }
            if !name.contains(" ") {
                self.errorButton.setTitle("Please enter your full name", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.errorButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.errorButton.alpha = 0
                    self.nameField.alpha = 0
                }) { (success) in
                    self.passwordField.becomeFirstResponder()
                    self.registerLabel.text = "Choose a secure password"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.passwordCenterAnchor.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else if self.passwordField.alpha == 1 && self.passwordCenterAnchor.constant == 0 {
            guard let password = self.passwordField.text else { return }
            if password.count < 8 {
                self.errorButton.setTitle("Needs to be at least 8 characters", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.errorButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.errorButton.alpha = 0
                    self.passwordField.alpha = 0
                }) { (success) in
                    self.repeatPasswordField.becomeFirstResponder()
                    self.registerLabel.text = "Repeat password"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.nextButtonCenterAnchor.constant = 0
                        self.nextButtonTopAnchor.constant = 0
                        self.nextButtonHeightAnchor.constant = 50
                        self.nextButtonWidthAnchor.constant = 240
                        self.nextButton.layer.cornerRadius = 25
                        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .light)
                        self.nextButton.setTitleColor(Theme.WHITE, for: .normal)
                        self.nextButton.backgroundColor = Theme.PRIMARY_DARK_COLOR
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
                UIView.animate(withDuration: 0.2) {
                    self.errorButton.alpha = 1
                }
            } else {
                self.view.endEditing(true)
                self.setupTerms()
            }
        }
    }
    
    @objc func moveBackController(sender: UIButton) {
        if self.emailCenterAnchor.constant == 0 && self.emailTextField.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.emailCenterAnchor.constant = self.view.frame.width
                self.nextButtonCenterAnchor.constant = 0
                self.backButton.alpha = 0
                self.errorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.phoneNumberTextField.becomeFirstResponder()
                self.registerLabel.text = "Let's start with your phone number"
                UIView.animate(withDuration: 0.3, animations: {
                    self.facebookLoginButton.alpha = 1
                    self.phoneNumberTextField.alpha = 1
                    self.areaCodeLabel.alpha = 1
                    self.USAButton.alpha = 1
                })
            }
        } else if self.nameCenterAnchor.constant == 0 && self.nameField.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.nameCenterAnchor.constant = self.view.frame.width
                self.errorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.emailTextField.becomeFirstResponder()
                self.registerLabel.text = "Enter your email address"
                UIView.animate(withDuration: 0.3, animations: {
                    self.emailTextField.alpha = 1
                })
            }
        } else if self.passwordCenterAnchor.constant == 0 && self.passwordField.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.passwordCenterAnchor.constant = self.view.frame.width
                self.errorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.nameField.becomeFirstResponder()
                self.registerLabel.text = "Enter your full name"
                UIView.animate(withDuration: 0.3, animations: {
                    self.nameField.alpha = 1
                })
            }
        } else if self.repeatCenterAnchor.constant == 0 && self.repeatPasswordField.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.repeatCenterAnchor.constant = self.view.frame.width
                self.errorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.passwordField.becomeFirstResponder()
                self.registerLabel.text = "Choose a secure password"
                UIView.animate(withDuration: 0.3, animations: {
                    self.passwordField.alpha = 1
                    self.nextButtonCenterAnchor.constant = 50
                    self.nextButtonTopAnchor.constant = 50
                    self.nextButtonHeightAnchor.constant = 40
                    self.nextButtonWidthAnchor.constant = 160
                    self.nextButton.layer.cornerRadius = 20
                    self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
                    self.nextButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                    self.nextButton.backgroundColor = UIColor.clear
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    func setupTerms() {
        self.view.addSubview(termsController.view)
        self.addChildViewController(termsController)
        termsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        termsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        termsController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.termsController.view.alpha = 1
        }
    }
    
    func agreeToTerms() {
        UIView.animate(withDuration: 0.3, animations: {
            self.termsController.view.alpha = 0
        }) { (success) in
            self.termsController.willMove(toParentViewController: nil)
            self.termsController.view.removeFromSuperview()
            self.termsController.removeFromParentViewController()
        }
        self.signUp()
        self.delegate?.defaultStatusBar()
    }
    
    func signUp() {
        self.view.endEditing(true)
        
        let userProfileUrl: String = ""
        
        guard let phoneNumber = phoneNumberTextField.text, let userEmail = emailTextField.text, let userName = nameField.text, let userPassword = passwordField.text else {
            print("Error")
            return
        }
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.user.uid else {return}
            let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": userName,
                          "email": userEmail,
                          "phone": phoneNumber,
                          "picture": userProfileUrl,
                          "DeviceID": AppDelegate.DEVICEID]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("Successfully logged in!")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                let myViewController: TabViewController = TabViewController()
                myViewController.removeFromParentViewController()
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
    
    func exitButtonSent() {
        self.view.endEditing(true)
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideRegisterPage()
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.exitButtonSent()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" {
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 1
                self.errorButton.alpha = 0
            }
        }
        if textField == self.phoneNumberTextField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
            return false
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
    
    var statusBarStyle: Bool = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarStyle == true {
            return .lightContent
        } else {
            return .default
        }
    }
    


}
