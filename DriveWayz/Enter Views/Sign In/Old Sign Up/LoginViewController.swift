//
//  LoginViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyJSON
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: handleSignInViews?
    var verificationCode: String?
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.HARMONY_RED, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Back")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return button
    }()
    
    lazy var emailButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "email")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        button.alpha = 1
        
        return button
    }()
    
    lazy var passwordButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "password")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        button.alpha = 1
        
        return button
    }()
    
    lazy var emailChooseButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "email")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        button.alpha = 1
        button.addTarget(self, action: #selector(emailPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var phoneChooseButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "phone")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        button.alpha = 1
        button.addTarget(self, action: #selector(phoneNumberPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var loginLabel: UITextView = {
        let label = UITextView()
        label.text = "Please choose a sign in method"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH2
        label.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        label.clipsToBounds = false
        label.isEditable = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var emailTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "email"
        field.textAlignment = .left
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        field.alpha = 1
        
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPLightH2
        field.placeholder = "password"
        field.textAlignment = .left
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_RED
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.alpha = 1
        
        return field
    }()
    
    var emailLine: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = 1
        
        return line
    }()
    
    var passwordLine: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = 1
        
        return line
    }()
    
    var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.7)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = Fonts.SSPLightH2
        button.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send Code", for: .normal)
        button.setTitleColor(Theme.SEA_BLUE, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.SEA_BLUE.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.titleLabel?.font = Fonts.SSPLightH2
        button.alpha = 0
        button.addTarget(self, action: #selector(moveToNextController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Expand", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.titleLabel?.font = Fonts.SSPLightH3
        button.alpha = 0
        button.addTarget(self, action: #selector(moveBackController(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Login with Facebook", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.addTarget(self, action: #selector(handleCustomFacebookLogin), for: .touchUpInside)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var choosePhoneNumber: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("phone number", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH2
        button.addTarget(self, action: #selector(phoneNumberPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var chooseEmail: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("email and password", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH2
        button.addTarget(self, action: #selector(emailPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "or"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.backgroundColor = Theme.WHITE
        
        return label
    }()
    
    var orLine: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
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
        view.alpha = 0
        
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
    
    var errorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Please enter a valid phone number", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.7)
        button.titleLabel?.font = Fonts.SSPLightH4
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        verificationTextField.delegate = self
        
        let background = CAGradientLayer().mixColors()
        background.frame = CGRect(x: 0, y: self.view.frame.height-140, width: self.view.frame.width, height: 140)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swippedRight))
        gesture.direction = .right
        view.addGestureRecognizer(gesture)
        
        let gesture2 = UISwipeGestureRecognizer(target: self, action: #selector(swippedRight))
        gesture2.direction = .down
        view.addGestureRecognizer(gesture2)
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var emailCenterAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        self.view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 60).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        loginLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 0).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        emailCenterAnchor = emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width*1.5)
            emailCenterAnchor.isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(emailButton)
        emailButton.rightAnchor.constraint(greaterThanOrEqualTo: emailTextField.leftAnchor, constant: -12).isActive = true
        emailButton.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 17.5).isActive = true
        emailButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(emailLine)
        emailLine.leftAnchor.constraint(equalTo: emailButton.leftAnchor).isActive = true
        emailLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        emailLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40).isActive = true
        passwordField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        passwordField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(passwordButton)
        passwordButton.rightAnchor.constraint(greaterThanOrEqualTo: passwordField.leftAnchor, constant: -12).isActive = true
        passwordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor).isActive = true
        passwordButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        passwordButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(passwordLine)
        passwordLine.leftAnchor.constraint(equalTo: passwordButton.leftAnchor).isActive = true
        passwordLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        passwordLine.topAnchor.constraint(equalTo: passwordField.bottomAnchor).isActive = true
        passwordLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(confirmButton)
        confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        facebookLoginButton.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(choosePhoneNumber)
        choosePhoneNumber.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 60).isActive = true
        choosePhoneNumber.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        choosePhoneNumber.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        choosePhoneNumber.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(phoneChooseButton)
        phoneChooseButton.topAnchor.constraint(equalTo: choosePhoneNumber.bottomAnchor, constant: 10).isActive = true
        phoneChooseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        phoneChooseButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        phoneChooseButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(orLine)
        orLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        orLine.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        orLine.topAnchor.constraint(equalTo: phoneChooseButton.bottomAnchor, constant: 45).isActive = true
        orLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(chooseEmail)
        chooseEmail.topAnchor.constraint(equalTo: orLine.bottomAnchor, constant: 35).isActive = true
        chooseEmail.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        chooseEmail.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        chooseEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(emailChooseButton)
        emailChooseButton.topAnchor.constraint(equalTo: chooseEmail.bottomAnchor, constant: 10).isActive = true
        emailChooseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emailChooseButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        emailChooseButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(orLabel)
        orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        orLabel.centerYAnchor.constraint(equalTo: orLine.centerYAnchor).isActive = true
        orLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setupPhoneField()
    }
    
    var phoneNumberCenterAnchor: NSLayoutConstraint!
    var fieldLineWidthAnchor: NSLayoutConstraint!
    var verificationCenterAnchor: NSLayoutConstraint!
    var nextButtonCenterAnchor: NSLayoutConstraint!
    var nextButtonWidthAnchor: NSLayoutConstraint!
    var nextButtonHeightAnchor: NSLayoutConstraint!
    var nextButtonTopAnchor: NSLayoutConstraint!
    
    func setupPhoneField() {
        
        self.view.addSubview(USAButton)
        USAButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 40).isActive = true
        USAButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        USAButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        USAButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(areaCodeLabel)
        areaCodeLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 40).isActive = true
        areaCodeLabel.leftAnchor.constraint(equalTo: USAButton.rightAnchor, constant: 10).isActive = true
        areaCodeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        areaCodeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 40).isActive = true
        phoneNumberTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        phoneNumberCenterAnchor = phoneNumberTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            phoneNumberCenterAnchor.isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(phoneLine)
        phoneLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fieldLineWidthAnchor = phoneLine.widthAnchor.constraint(equalTo: phoneNumberTextField.widthAnchor)
            fieldLineWidthAnchor.isActive = true
        phoneLine.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor).isActive = true
        phoneLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.topAnchor.constraint(equalTo: phoneLine.bottomAnchor, constant: 20).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        self.view.addSubview(verificationTextField)
        verificationTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 40).isActive = true
        verificationTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        verificationCenterAnchor = verificationTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            verificationCenterAnchor.isActive = true
        verificationTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(nextButton)
        nextButtonCenterAnchor = nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            nextButtonCenterAnchor.isActive = true
        nextButtonTopAnchor = nextButton.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50)
            nextButtonTopAnchor.isActive = true
        nextButtonHeightAnchor = nextButton.heightAnchor.constraint(equalToConstant: 40)
            nextButtonHeightAnchor.isActive = true
        nextButtonWidthAnchor = nextButton.widthAnchor.constraint(equalToConstant: 160)
            nextButtonWidthAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -90).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    @objc func loginButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        
        let userEmail = emailTextField.text
        let userPassword = passwordField.text
        
        if (userPassword?.isEmpty)! {
            displayAlertMessage(userMessage: "Missing password field.", title: "Error")
            return
        }
        if (userEmail?.isEmpty)! {
            displayAlertMessage(userMessage: "Missing email field.", title: "Error")
            return
        } else {
            
            //Send data serverside
            Auth.auth().signIn(withEmail: userEmail!, password: userPassword!, completion: { (user, error) in
                
                if error != nil {
                    self.displayAlertMessage(userMessage: (error?.localizedDescription)!, title: "Error")
                    return
                }
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let value = ["DeviceID": AppDelegate.DEVICEID] as [String:Any]
                let ref = Database.database().reference().child("users").child(uid)
                ref.updateChildValues(value)
                
                print("Successfully logged in!")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                let myViewController: TabViewController = TabViewController()
                myViewController.removeFromParent()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = myViewController
                appDelegate.window?.makeKeyAndVisible()
                
                self.dismiss(animated: true, completion: nil)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        if let name = dictionary["name"] as? String {
                            UserDefaults.standard.set("\(name)", forKey: "userName")
                            UserDefaults.standard.synchronize()
                        }
                    }
                })
                
            })
            
        }
    }
    
    @objc func handleCustomFacebookLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.displayAlertMessage(userMessage: error.localizedDescription, title: "Error")
            case .cancelled:
                print("User canceled Facebook login")
            case .success( _, _, let accessToken):
                let access = accessToken
                let accessTok = access.authenticationToken
                
                GraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(1000).height(1000)"]).start { (connection, results) in
                    switch results {
                    case .failed(let error):
                        self.displayAlertMessage(userMessage: error.localizedDescription, title: "Error")
                    case .success(response: let graphResponse):
                        if let dictionary = graphResponse.dictionaryValue {
                            let json = JSON(dictionary)
                            let email = json["email"].string!
                            let pictureObject = json["picture"].dictionary!
                            let pictureData = pictureObject["data"]?.dictionary!
                            let pictureUrl = pictureData!["url"]?.string!
                            
                            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTok)
                            Auth.auth().fetchSignInMethods(forEmail: email, completion: { (list, error) in
                                if error != nil {
                                    print(error!)
                                    return
                                }
                                if list != nil {
                                    Auth.auth().signInAndRetrieveData(with: credentials) { (sign, err) in
                                        if err != nil {
                                            print(err!)
                                            return
                                        }
                                        
                                        guard let uid = Auth.auth().currentUser?.uid else {return}
                                        let value = ["DeviceID": AppDelegate.DEVICEID, "picture": pictureUrl!] as [String:Any]
                                        let ref = Database.database().reference().child("users").child(uid)
                                        ref.updateChildValues(value)
                                        
                                        print("Successfully logged in!")
                                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                        UserDefaults.standard.synchronize()
                                        
                                        let myViewController: TabViewController = TabViewController()
                                        myViewController.removeFromParent()
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.window?.rootViewController = myViewController
                                        appDelegate.window?.makeKeyAndVisible()
                                        
                                        self.dismiss(animated: true, completion: nil)
                                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let dictionary = snapshot.value as? [String:AnyObject] {
                                                if let name = dictionary["name"] as? String {
                                                    UserDefaults.standard.set("\(name)", forKey: "userName")
                                                    UserDefaults.standard.synchronize()
                                                }
                                            }
                                        })
                                    }
                                } else {
                                    self.displayAlertMessage(userMessage: "Please REGISTER with your Facebook account before attempting to login.", title: "Alert!")
                                    let loginManager = LoginManager()
                                    loginManager.logOut()
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @objc func phoneNumberPressed(sender: UIButton) {
        UIView.animate(withDuration: animationIn, animations: {
            self.choosePhoneNumber.alpha = 0
            self.chooseEmail.alpha = 0
            self.orLabel.alpha = 0
            self.orLine.alpha = 0
            self.facebookLoginButton.alpha = 0
            self.phoneChooseButton.alpha = 0
            self.emailChooseButton.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.nextButtonCenterAnchor.constant = 50
                self.nextButton.alpha = 1
                self.backButton.alpha = 1
                self.phoneNumberCenterAnchor.constant = -20
                self.USAButton.alpha = 1
                self.areaCodeLabel.alpha = 1
                self.phoneLine.alpha = 1
                self.view.layoutIfNeeded()
            })
            self.loginLabel.text = "Sign with phone number and verification"
        }
    }
    
    @objc func emailPressed(sender: UIButton) {
        UIView.animate(withDuration: animationIn, animations: {
            self.choosePhoneNumber.alpha = 0
            self.chooseEmail.alpha = 0
            self.orLabel.alpha = 0
            self.orLine.alpha = 0
            self.facebookLoginButton.alpha = 0
            self.phoneChooseButton.alpha = 0
            self.emailChooseButton.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.emailCenterAnchor.constant = 50
                self.confirmButton.alpha = 1
                self.view.layoutIfNeeded()
            })
            self.loginLabel.text = "Sign with email and password"
        }
    }

    @objc func moveToNextController(sender: UIButton) {
        if self.phoneNumberCenterAnchor.constant == -20 && self.phoneNumberTextField.alpha == 1 {
            if self.phoneNumberTextField.text?.count != 14 {
                self.errorButton.setTitle("Please enter a valid phone number", for: .normal)
                UIView.animate(withDuration: animationIn) {
                    self.errorButton.alpha = 1
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
                        self.displayAlertMessage(userMessage: error.localizedDescription, title: "Error")
                        self.nextButton.isUserInteractionEnabled = true
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
                        self.loginLabel.text = "Enter the six digit verification code sent to \(number!)"
                        self.nextButton.setTitle("Confirm", for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func moveBackController(sender: UIButton) {
        if self.verificationCenterAnchor.constant == 0 && self.verificationTextField.alpha == 1 {
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
                self.loginLabel.text = "Please enter your phone number for verification"
                self.verificationTextField.text = ""
                UIView.animate(withDuration: animationIn, animations: {
                    self.phoneNumberTextField.alpha = 1
                    self.areaCodeLabel.alpha = 1
                    self.USAButton.alpha = 1
                })
            }
        } else if self.phoneNumberCenterAnchor.constant == -20 && self.phoneNumberTextField.alpha == 1 {
            self.loadingActivity.stopAnimating()
            UIView.animate(withDuration: animationIn, animations: {
                self.phoneNumberCenterAnchor.constant = self.view.frame.width
                self.areaCodeLabel.alpha = 0
                self.USAButton.alpha = 0
                self.phoneLine.alpha = 0
                self.nextButton.alpha = 0
                self.backButton.alpha = 0
                self.errorButton.alpha = 0
                self.loadingActivity.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.view.endEditing(true)
                self.nextButton.setTitle("Send Code", for: .normal)
                self.loginLabel.text = "Please choose a sign in method"
                self.verificationTextField.text = ""
                UIView.animate(withDuration: animationIn, animations: {
                    self.choosePhoneNumber.alpha = 1
                    self.chooseEmail.alpha = 1
                    self.orLine.alpha = 1
                    self.orLabel.alpha = 1
                    self.facebookLoginButton.alpha = 1
                    self.phoneChooseButton.alpha = 1
                    self.emailChooseButton.alpha = 1
                })
            }
        }
    }
    
    func displayAlertMessage(userMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func exitButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideLoginPage()
        self.loginLabel.text = "Please choose a sign in method"
        self.animate()
    }
    
    @objc func swippedRight() {
        self.view.endEditing(true)
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideLoginPage()
        self.loginLabel.text = "Please choose a sign in method"
        self.animate()
    }
    
    func animate() {
        UIView.animate(withDuration: animationIn, animations: {
            self.emailCenterAnchor.constant = self.view.frame.width * 1.5
            self.phoneNumberCenterAnchor.constant = self.view.frame.width
            self.USAButton.alpha = 0
            self.phoneLine.alpha = 0
            self.areaCodeLabel.alpha = 0
            self.nextButton.alpha = 0
            self.backButton.alpha = 0
            self.confirmButton.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.chooseEmail.alpha = 1
                self.choosePhoneNumber.alpha = 1
                self.orLabel.alpha = 1
                self.orLine.alpha = 1
                self.facebookLoginButton.alpha = 1
                self.phoneChooseButton.alpha = 1
                self.emailChooseButton.alpha = 1
            })
        }
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
                            self.displayAlertMessage(userMessage: error.localizedDescription, title: "Error")
                            self.verificationTextField.becomeFirstResponder()
                            return
                        }
                        UIView.animate(withDuration: animationIn, animations: {
                            self.loadingActivity.alpha = 0
                        })
                        self.loadingActivity.stopAnimating()
                        print("Successfully logged in!")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        let myViewController: TabViewController = TabViewController()
                        myViewController.removeFromParent()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = myViewController
                        appDelegate.window?.makeKeyAndVisible()
                        
                        self.dismiss(animated: true, completion: nil)
                        if let uid = authResult?.user.uid {
                            let ref = Database.database().reference().child("users").child(uid)
                            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String:AnyObject] {
                                    if let name = dictionary["name"] as? String {
                                        UserDefaults.standard.set("\(name)", forKey: "userName")
                                        UserDefaults.standard.synchronize()
                                    }
                                }
                            })
                        }
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
    
}
