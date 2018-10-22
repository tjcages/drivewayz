//
//  SignInViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleSignInViews {
    func hideLoginPage()
    func hideRegisterPage()
    func lightContentStatusBar()
    func defaultStatusBar()
}

class SignInViewController: UIViewController, handleSignInViews {
    
    var delegate: handleStatusBarHide?
    
    lazy var background5: UIView = {
        let background5 = UIImage(named: "background5")
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.center = self.view.center
        
        return imageView
    }()
    
    lazy var blurBackground: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.4
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var drivewayzCar: UIImageView = {
        let image = UIImage(named: "DrivewayzCar")
        let flip = UIImage(cgImage: (image?.cgImage)!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var drivewayzLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivewayz"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: .light)
        label.textAlignment = .center
        
        return label
    }()
    
    var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
        button.alpha = 0
        button.addTarget(self, action: #selector(signInButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create a new account", for: .normal)
//        button.setTitleColor(UIColor(red: 156/255, green: 166/255, blue: 176/255, alpha: 1), for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        button.alpha = 0
        button.addTarget(self, action: #selector(methodButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var separatorLine: UIView = {
        let line = UIView()
//        line.backgroundColor = UIColor(red: 156/255, green: 166/255, blue: 176/255, alpha: 1)
        line.backgroundColor = Theme.DARK_GRAY
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    lazy var registerController: RegisterViewController = {
        let controller = RegisterViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        self.addChild(controller)
        return controller
    }()
    
    lazy var loginController: LoginViewController = {
        let controller = LoginViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        self.addChild(controller)
        return controller
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.alpha = 0
        
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var drivewayzTopAnchor: NSLayoutConstraint!
    var phoneNumberAnchor: NSLayoutConstraint!
    var separatorLineAnchor: NSLayoutConstraint!
    var phoneLineAnchor: NSLayoutConstraint!
    var whiteViewTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(background5)
        background5.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        background5.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        background5.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background5.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(blurBackground)
        blurBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blurBackground.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(drivewayzCar)
        drivewayzCar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        drivewayzTopAnchor = drivewayzCar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40)
            drivewayzTopAnchor.isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        self.view.addSubview(drivewayzLabel)
        drivewayzLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
        drivewayzLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 35).isActive = true
        drivewayzLabel.topAnchor.constraint(equalTo: drivewayzCar.bottomAnchor, constant: -20).isActive = true
        drivewayzLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(whiteView)
        whiteView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        whiteViewTopAnchor = whiteView.heightAnchor.constraint(equalToConstant: 10)
            whiteViewTopAnchor.isActive = true
        
        self.view.addSubview(signInButton)
        signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        signInButton.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 10).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(separatorLine)
        separatorLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        separatorLineAnchor = separatorLine.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15)
            separatorLineAnchor.isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -80).isActive = true
        
        self.view.addSubview(registerButton)
        registerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        registerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 5).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: whiteView.topAnchor, constant: -5).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(registerController.view)
        registerController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        registerController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        registerController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        registerController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(loginController.view)
        loginController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loginController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loginController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loginController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            self.startAnimations()
        }
    }
    
    func startAnimations() {
        UIView.animate(withDuration: 0.3, animations: {
            self.drivewayzTopAnchor.constant = -self.view.frame.height/3
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.signInButton.alpha = 1
                self.registerButton.alpha = 1
                switch device {
                case .iphone8:
                    self.whiteViewTopAnchor.constant = 170
                case .iphoneX:
                    self.whiteViewTopAnchor.constant = 200
                }
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                //
            })
        }
    }
    
    @objc func signInButtonPressed(sender: UIButton) {
        self.whiteViewTopAnchor.constant = self.view.frame.height + 20
        UIView.animate(withDuration: 0.3, animations: {
            self.signInButton.alpha = 0
            self.registerButton.alpha = 0
            self.separatorLine.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultStatusBar()
            UIView.animate(withDuration: 0.2, animations: {
                self.loginController.view.alpha = 1
            }, completion: { (success) in

            })
        }
    }
    
    @objc func methodButtonPressed(sender: UIButton) {
        self.whiteViewTopAnchor.constant = self.view.frame.height + 20
        UIView.animate(withDuration: 0.3, animations: {
            self.signInButton.alpha = 0
            self.registerButton.alpha = 0
            self.separatorLine.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.registerController.view.alpha = 1
            }) { (success) in
                self.registerController.animate()
                if self.registerController.pageControl.currentPage == 3 {
                    self.delegate?.defaultStatusBar()
                } else {
                    self.delegate?.lightContentStatusBar()
                }
            }
        }
    }
    
    func hideLoginPage() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loginController.view.alpha = 0
        }) { (success) in
            self.whiteViewTopAnchor.constant = 170
            UIView.animate(withDuration: 0.3, animations: {
                self.signInButton.alpha = 1
                self.registerButton.alpha = 1
                self.separatorLine.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideRegisterPage() {
        UIView.animate(withDuration: 0.2, animations: {
            self.registerController.view.alpha = 0
        }) { (success) in
            self.whiteViewTopAnchor.constant = 170
            UIView.animate(withDuration: 0.3, animations: {
                self.signInButton.alpha = 1
                self.registerButton.alpha = 1
                self.separatorLine.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    func defaultStatusBar() {
        self.delegate?.defaultStatusBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}








