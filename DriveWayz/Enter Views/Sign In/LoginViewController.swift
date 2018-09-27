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

class LoginViewController: UIViewController {
    
    var delegate: handleSignInViews?
    
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
        
        return button
    }()
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        
        return label
    }()
    
    var emailTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 24, weight: .light)
        field.placeholder = "email"
        field.textAlignment = .left
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 24, weight: .light)
        field.placeholder = "password"
        field.textAlignment = .left
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = Theme.HARMONY_COLOR
        field.textColor = Theme.BLACK
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        
        return field
    }()
    
    var emailLine: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    var passwordLine: UIView = {
        let line = UIView()
        line.backgroundColor = Theme.DARK_GRAY
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.HARMONY_COLOR.withAlphaComponent(0.7)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .light)
        button.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Login with Facebook", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.addTarget(self, action: #selector(handleCustomFacebookLogin), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer().mixColors()
        background.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2)
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
        loginLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 40).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        loginLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 30).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(emailButton)
        emailButton.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 24).isActive = true
        emailButton.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 17.5).isActive = true
        emailButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(emailLine)
        emailLine.leftAnchor.constraint(equalTo: emailButton.leftAnchor).isActive = true
        emailLine.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        emailLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40).isActive = true
        passwordField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        passwordField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(passwordButton)
        passwordButton.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 24).isActive = true
        passwordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor).isActive = true
        passwordButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        passwordButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(passwordLine)
        passwordLine.leftAnchor.constraint(equalTo: passwordButton.leftAnchor).isActive = true
        passwordLine.rightAnchor.constraint(equalTo: passwordField.rightAnchor).isActive = true
        passwordLine.topAnchor.constraint(equalTo: passwordField.bottomAnchor).isActive = true
        passwordLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        facebookLoginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
                    print(error!)
                    self.displayAlertMessage(userMessage: "The password was incorrect or the account does not exist with this email.", title: "Error")
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
                myViewController.removeFromParentViewController()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = myViewController
                appDelegate.window?.makeKeyAndVisible()
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
        }
    }
    
    @objc func handleCustomFacebookLogin() {
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
                
                GraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(1000).height(1000)"]).start { (connection, results) in
                    switch results {
                    case .failed(let error):
                        print(error)
                    case .success(response: let graphResponse):
                        if let dictionary = graphResponse.dictionaryValue {
                            let json = JSON(dictionary)
                            let email = json["email"].string!
                            
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
                                        let value = ["DeviceID": AppDelegate.DEVICEID] as [String:Any]
                                        let ref = Database.database().reference().child("users").child(uid)
                                        ref.updateChildValues(value)
                                        
                                        print("Successfully logged in!")
                                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                        UserDefaults.standard.synchronize()
                                        
                                        let myViewController: TabViewController = TabViewController()
                                        myViewController.removeFromParentViewController()
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.window?.rootViewController = myViewController
                                        appDelegate.window?.makeKeyAndVisible()
                                        
                                        self.dismiss(animated: true, completion: nil)
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
    
    func displayAlertMessage(userMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

    @objc func exitButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideLoginPage()
    }
    
    @objc func swippedRight() {
        self.view.endEditing(true)
        self.delegate?.lightContentStatusBar()
        self.delegate?.hideLoginPage()
    }
    
}
