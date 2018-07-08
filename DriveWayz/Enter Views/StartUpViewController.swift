//
//  StartUpViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/22/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class StartUpViewController: UIViewController {
    
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
    
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
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "Find parking conveniently and easily. We provide options that have until now been unavailable."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        
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
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "Don't waste time anymore searching for parking. Just reserve an open spot and avoid the hassle."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        
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
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "DriveWayz offers cheaper options compared to current places and reduces the stress that comes along with it."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 4
        
        return label
    }()
    
    lazy var blurBackground: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.6
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
    
    var driveWayz: UIImageView = {
        let image = UIImage(named: "DriveWayz")
        let driveWayz = UIImageView()
        driveWayz.image = image
        driveWayz.translatesAutoresizingMaskIntoConstraints = false
        return driveWayz
    }()
    
    var loginButton: UIButton = {
       let loginButton = UIButton()
        loginButton.setTitle("Log in", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        loginButton.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        loginButton.tintColor = Theme.PRIMARY_COLOR
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return loginButton
    }()
    
    var registerButton: UIButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        registerButton.backgroundColor = UIColor.clear
        registerButton.tintColor = Theme.PRIMARY_COLOR
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderWidth = 1
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return registerButton
    }()
    
    var orLabel: UILabel = {
        let orLabel = UILabel()
        orLabel.text = "or"
        orLabel.textColor = UIColor.white
        orLabel.textAlignment = .center
        orLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        return orLabel
    }()
    
    var line: UIView = {
       let line = UIView()
        line.backgroundColor = UIColor.white
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var line2: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.white
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var userEmailTextField: MadokaTextField = {
        
        let login = MadokaTextField()
        login.placeholderColor = Theme.DARK_GRAY
        login.borderColor = Theme.WHITE
        login.placeholder = ""
        login.textColor = Theme.WHITE
        login.font = UIFont.systemFont(ofSize: 18, weight: .light)
        login.alpha = 0
        login.translatesAutoresizingMaskIntoConstraints = false
        login.autocapitalizationType = .none
        login.clearButtonMode = .whileEditing
        login.spellCheckingType = .no
    
        return login
    }()
    
    var userEmailIcon: UIImageView = {
        let image = UIImage(named: "email")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        return imageView
    }()
    
    var userPasswordTextField: MadokaTextField = {
        
        let password = MadokaTextField()
        password.placeholderColor = Theme.DARK_GRAY
        password.borderColor = Theme.WHITE
        password.placeholder = ""
        password.textColor = Theme.WHITE
        password.font = UIFont.systemFont(ofSize: 18, weight: .light)
        password.alpha = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.clearButtonMode = .whileEditing
        
        return password
    }()
    
    var userPasswordIcon: UIImageView = {
        let image = UIImage(named: "password")
        let userPasswordIcon = UIImageView(image: image)
        userPasswordIcon.contentMode = .scaleAspectFit
        userPasswordIcon.translatesAutoresizingMaskIntoConstraints = false
        userPasswordIcon.alpha = 0
        
        return userPasswordIcon
    }()
    
    var NewUserFirstNameTextField: MadokaTextField = {
        
        let name = MadokaTextField()
        name.placeholderColor = Theme.WHITE
        name.borderColor = Theme.WHITE
        name.placeholder = "First Name"
        name.textColor = Theme.WHITE
        name.font = UIFont.systemFont(ofSize: 18, weight: .light)
        name.alpha = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        name.clearButtonMode = .whileEditing
        
        return name
    }()
    
    var NewUserLastNameTextField: MadokaTextField = {
        
        let name = MadokaTextField()
        name.placeholderColor = Theme.WHITE
        name.borderColor = Theme.WHITE
        name.placeholder = "Last Name"
        name.textColor = Theme.WHITE
        name.font = UIFont.systemFont(ofSize: 18, weight: .light)
        name.alpha = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        name.clearButtonMode = .whileEditing
        
        return name
    }()
    
    var NewUserEmailTextField: MadokaTextField = {
        
        let email = MadokaTextField()
        email.placeholderColor = Theme.WHITE
        email.borderColor = Theme.WHITE
        email.placeholder = "Email"
        email.textColor = Theme.WHITE
        email.font = UIFont.systemFont(ofSize: 18, weight: .light)
        email.alpha = 0
        email.translatesAutoresizingMaskIntoConstraints = false
        email.autocapitalizationType = .none
        email.clearButtonMode = .whileEditing
        
        return email
    }()
    
    var NewUserPasswordTextField: MadokaTextField = {
        
        let password = MadokaTextField()
        password.placeholderColor = Theme.WHITE
        password.borderColor = Theme.WHITE
        password.placeholder = "Password"
        password.textColor = Theme.WHITE
        password.font = UIFont.systemFont(ofSize: 18, weight: .light)
        password.alpha = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.clearButtonMode = .whileEditing
        
        return password
    }()
    
    var NewUserRepeatPasswordTextField: MadokaTextField = {
        
        let password = MadokaTextField()
        password.placeholderColor = Theme.WHITE
        password.borderColor = Theme.WHITE
        password.placeholder = "Repeat Password"
        password.textColor = Theme.WHITE
        password.font = UIFont.systemFont(ofSize: 18, weight: .light)
        password.alpha = 0
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.clearButtonMode = .whileEditing
        
        return password
    }()
    
    var backIcon: UIButton = {
       let backIcon = UIButton()
        let image = UIImage(named: "Expand")
        backIcon.setImage(image, for: .normal)
        backIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
        backIcon.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        backIcon.tintColor = Theme.PRIMARY_COLOR
        backIcon.alpha = 0
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        
        return backIcon
    }()
    
    var forgotPassword: UIButton = {
        let forgot = UIButton()
        forgot.setTitle("Forgot Password?", for: .normal)
        forgot.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        forgot.titleLabel?.textColor = UIColor.white
        forgot.alpha = 0
        forgot.backgroundColor = UIColor.clear
        forgot.translatesAutoresizingMaskIntoConstraints = false
        forgot.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        
        return forgot
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        configurePageControl()
        setupLoginAndRegister()
        setupLogin()
        setupRegister()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var driveWayzTopAnchor: NSLayoutConstraint!
    var backgroundLeftAnchor: NSLayoutConstraint!
    
    func setupBackground() {
        
        view.addSubview(background1)
        background1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundLeftAnchor = background1.leftAnchor.constraint(equalTo: view.leftAnchor)
        backgroundLeftAnchor.isActive = true
        background1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        background1.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(background2)
        background2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        background2.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        background2.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        background2.leftAnchor.constraint(equalTo: background1.rightAnchor).isActive = true
        
        view.addSubview(background3)
        background3.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        background3.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        background3.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        background3.leftAnchor.constraint(equalTo: background2.rightAnchor).isActive = true
        
        view.addSubview(blurBackground)
        blurBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(label1)
        label1.centerXAnchor.constraint(equalTo: background1.centerXAnchor).isActive = true
        label1.centerYAnchor.constraint(equalTo: background1.centerYAnchor, constant: -25).isActive = true
        label1.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(label2)
        label2.centerXAnchor.constraint(equalTo: background2.centerXAnchor).isActive = true
        label2.centerYAnchor.constraint(equalTo: background2.centerYAnchor, constant: -25).isActive = true
        label2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(label3)
        label3.centerXAnchor.constraint(equalTo: background3.centerXAnchor).isActive = true
        label3.centerYAnchor.constraint(equalTo: background3.centerYAnchor, constant: -25).isActive = true
        label3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label3.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(container)
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(driveWayz)
        driveWayz.centerXAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive = true
        driveWayzTopAnchor = driveWayz.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        driveWayzTopAnchor.isActive = true
        driveWayz.heightAnchor.constraint(equalToConstant: 70).isActive = true
        driveWayz.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    var loginButtonCenterAnchor: NSLayoutConstraint!
    var registerButtonCenterAnchor: NSLayoutConstraint!
    var backIconTopAnchor: NSLayoutConstraint!
    
    func setupLoginAndRegister() {
        
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButtonCenterAnchor = loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150)
        loginButtonCenterAnchor.isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButtonCenterAnchor = registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 250)
        registerButtonCenterAnchor.isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(orLabel)
        orLabel.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: 200).isActive = true
        orLabel.centerXAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        orLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(line)
        line.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.rightAnchor.constraint(equalTo: orLabel.leftAnchor, constant: 4).isActive = true
        
        view.addSubview(line2)
        line2.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        line2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line2.leftAnchor.constraint(equalTo: orLabel.rightAnchor, constant: 2).isActive = true
        
        view.addSubview(backIcon)
        backIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backIconTopAnchor = backIcon.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30)
        backIconTopAnchor.isActive = true
        backIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    var userEmailHeightAnchor: NSLayoutConstraint!
    
    func setupLogin() {
        
        view.addSubview(userEmailTextField)
        userEmailHeightAnchor = userEmailTextField.topAnchor.constraint(equalTo: driveWayz.bottomAnchor, constant: 20)
        userEmailHeightAnchor.isActive = true
        userEmailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        userEmailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        userEmailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(userEmailIcon)
        userEmailIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userEmailIcon.centerYAnchor.constraint(equalTo: userEmailTextField.centerYAnchor, constant: -4).isActive = true
        userEmailIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userEmailIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(userPasswordTextField)
        userPasswordTextField.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 20).isActive = true
        userPasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        userPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        userPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(userPasswordIcon)
        userPasswordIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userPasswordIcon.centerYAnchor.constraint(equalTo: userPasswordTextField.centerYAnchor, constant: -4).isActive = true
        userPasswordIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        userPasswordIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(forgotPassword)
        forgotPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPassword.topAnchor.constraint(equalTo: backIcon.bottomAnchor, constant: 20).isActive = true
        forgotPassword.widthAnchor.constraint(equalToConstant: 200).isActive = true
        forgotPassword.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setupRegister() {
        
        view.addSubview(NewUserFirstNameTextField)
        
        NewUserFirstNameTextField.topAnchor.constraint(equalTo: driveWayz.bottomAnchor, constant: 25).isActive = true
        NewUserFirstNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        NewUserFirstNameTextField.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -8).isActive = true
        NewUserFirstNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(NewUserLastNameTextField)
        
        NewUserLastNameTextField.centerYAnchor.constraint(equalTo: NewUserFirstNameTextField.centerYAnchor).isActive = true
        NewUserLastNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        NewUserLastNameTextField.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 8).isActive = true
        NewUserLastNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(NewUserEmailTextField)
        
        NewUserEmailTextField.topAnchor.constraint(equalTo: NewUserFirstNameTextField.bottomAnchor, constant: 25).isActive = true
        NewUserEmailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        NewUserEmailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        NewUserEmailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(NewUserPasswordTextField)
        
        NewUserPasswordTextField.topAnchor.constraint(equalTo: NewUserEmailTextField.bottomAnchor, constant: 25).isActive = true
        NewUserPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        NewUserPasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        NewUserPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(NewUserRepeatPasswordTextField)
        
        NewUserRepeatPasswordTextField.topAnchor.constraint(equalTo: NewUserPasswordTextField.bottomAnchor, constant: 25).isActive = true
        NewUserRepeatPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        NewUserRepeatPasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        NewUserRepeatPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = 3
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
        pageControl.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: -40).isActive = true
    }
    
    @objc func loginButtonPressed() {
        
        if self.userPasswordTextField.alpha == 0 {
            self.loginButtonCenterAnchor.constant = 50
            self.backIconTopAnchor.constant = -60
            UIView.animate(withDuration: 0.3, animations: {
                self.backIcon.alpha = 1
                self.registerButton.alpha = 0
                self.orLabel.alpha = 0
                self.line.alpha = 0
                self.line2.alpha = 0
                self.pageControl.alpha = 0
                self.label1.alpha = 0
                self.label2.alpha = 0
                self.label3.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.userEmailTextField.alpha = 1
                    self.userEmailIcon.alpha = 1
                    self.userPasswordTextField.alpha = 1
                    self.userPasswordIcon.alpha = 1
                    self.forgotPassword.alpha = 1
                    self.userEmailHeightAnchor.constant = 25
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {

                    }, completion: { _ in
                        print("Chain Animation Ended")
                    })
                })
            })
        } else {
            
            userEmailTextField.endEditing(true)
            userPasswordTextField.endEditing(true)
            
            let userEmail = userEmailTextField.text
            let userPassword = userPasswordTextField.text
            
            if((userPassword?.isEmpty)! || (userEmail?.isEmpty)!) {
                
                //Display alert message
                displayAlertMessage(userMessage: "Missing required field")
                return
                
            } else {
                
                //Send data serverside
                Auth.auth().signIn(withEmail: userEmail!, password: userPassword!, completion: { (user, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    UIView.animate(withDuration: 0.2) {
                        self.userEmailTextField.alpha = 0
                        self.userEmailIcon.alpha = 0
                        self.userPasswordTextField.alpha = 0
                        self.userPasswordIcon.alpha = 0
                        self.forgotPassword.alpha = 0
                    }
                    
                    print("Successfully logged in!")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let myViewController: TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = myViewController
                    appDelegate.window?.makeKeyAndVisible()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
            }
        }
    }
    
    @objc func registerButtonPressed() {
        
        if self.NewUserPasswordTextField.alpha == 0 {
            self.driveWayzTopAnchor.constant = 50
            self.registerButtonCenterAnchor.constant = 150
            UIView.animate(withDuration: 0.3, animations: {
                self.backIcon.alpha = 1
                self.loginButton.alpha = 0
                self.orLabel.alpha = 0
                self.line.alpha = 0
                self.line2.alpha = 0
                self.pageControl.alpha = 0
                self.label1.alpha = 0
                self.label2.alpha = 0
                self.label3.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.NewUserFirstNameTextField.alpha = 1
                    self.NewUserLastNameTextField.alpha = 1
                    self.NewUserEmailTextField.alpha = 1
                    self.NewUserPasswordTextField.alpha = 1
                    self.NewUserRepeatPasswordTextField.alpha = 1
                }, completion: nil)
            })
        } else {
            
            NewUserEmailTextField.endEditing(true)
            NewUserPasswordTextField.endEditing(true)
            NewUserRepeatPasswordTextField.endEditing(true)
            NewUserFirstNameTextField.endEditing(true)
            NewUserLastNameTextField.endEditing(true)
            
            let userProfile: String = ""
            let userBio: String = ""
            
            guard let userName = NewUserFirstNameTextField.text, let userLastName = NewUserLastNameTextField.text, let userEmail = NewUserEmailTextField.text, let userPassword = NewUserPasswordTextField.text, let userRepeatPassword = NewUserRepeatPasswordTextField.text else {
                print("Error")
                return
            }
            
            //Check if passwords match
            if userPassword != userRepeatPassword {
                
                //Display alert message
                displayAlertMessage(userMessage: "Passwords do not match")
                return
                
            }
            
            if userName == "" || userLastName == "" || userEmail == "" || userPassword == "" || userRepeatPassword == "" {
                displayAlertMessage(userMessage: "Missing Credentials")
                return
            }
            
            Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.NewUserFirstNameTextField.alpha = 0
                    self.NewUserLastNameTextField.alpha = 0
                    self.NewUserEmailTextField.alpha = 0
                    self.NewUserPasswordTextField.alpha = 0
                    self.NewUserRepeatPasswordTextField.alpha = 0
                }, completion: nil)
                
                guard let uid = user?.user.uid else {return}
                let name = userName + " " + userLastName
                
                let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
                let usersReference = ref.child("users").child(uid)
                let values = ["name": name,
                              "email": userEmail,
                              "picture": userProfile,
                              "bio": userBio]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    print("Successfully logged in!")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let myViewController: TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = myViewController
                    appDelegate.window?.makeKeyAndVisible()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
            })
        }
    }
    
    @objc func backToMain() {
        self.driveWayzTopAnchor.constant = 100
        self.loginButtonCenterAnchor.constant = 150
        self.registerButtonCenterAnchor.constant = 250
        self.backIconTopAnchor.constant = 300
        UIView.animate(withDuration: 0.3, animations: {
            self.backIcon.alpha = 0
            self.userEmailTextField.alpha = 0
            self.userEmailIcon.alpha = 0
            self.userPasswordTextField.alpha = 0
            self.userPasswordIcon.alpha = 0
            self.forgotPassword.alpha = 0
            self.NewUserFirstNameTextField.alpha = 0
            self.NewUserLastNameTextField.alpha = 0
            self.NewUserEmailTextField.alpha = 0
            self.NewUserPasswordTextField.alpha = 0
            self.NewUserRepeatPasswordTextField.alpha = 0
            self.loginButton.alpha = 1
            self.registerButton.alpha = 1
            self.orLabel.alpha = 1
            self.line.alpha = 1
            self.line2.alpha = 1
            self.pageControl.alpha = 1
            self.label1.alpha = 1
            self.label2.alpha = 1
            self.label3.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.backIconTopAnchor.constant = 30
        })
    }
    
    func displayAlertMessage(userMessage: String) {
        let alert = UIAlertController(title: "Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func backgroundSwippedLeft() {
        if self.backgroundLeftAnchor.constant == (-self.view.frame.width) * 2 {
            return
        } else {
            self.pageControl.currentPage = self.pageControl.currentPage + 1
            self.backgroundLeftAnchor.constant = self.backgroundLeftAnchor.constant - self.view.frame.width
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func backgroundSwippedRight() {
        if self.backgroundLeftAnchor.constant == 0 {
            return
        } else {
            self.backgroundLeftAnchor.constant = self.backgroundLeftAnchor.constant + self.view.frame.width
            self.pageControl.currentPage = self.pageControl.currentPage - 1
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func forgotPasswordAction() {
        if userEmailTextField.text == "" {
            displayAlertMessage(userMessage: "Please enter a valid email address.")
        } else {
            displayAlertMessage(userMessage: "Password reset email sent.")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
