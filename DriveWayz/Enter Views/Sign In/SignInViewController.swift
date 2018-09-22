//
//  SignInViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var drivewayzCar: UIImageView = {
        let image = UIImage(named: "DrivewayzCar")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "DRIVEWAYZ"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .light)
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
        button.alpha = 0
        
        return button
    }()
    
    var methodButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create a new account.", for: .normal)
        button.setTitleColor(UIColor(red: 156/255, green: 166/255, blue: 176/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        button.alpha = 0
        
        return button
    }()
    
    var separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 156/255, green: 166/255, blue: 176/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent

        let background = CAGradientLayer().mixColors()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var drivewayzTopAnchor: NSLayoutConstraint!
    var drivewayzCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(drivewayzCar)
        drivewayzCenterAnchor = drivewayzCar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -4)
            drivewayzCenterAnchor.isActive = true
        drivewayzTopAnchor = drivewayzCar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40)
            drivewayzTopAnchor.isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        self.view.addSubview(welcomeLabel)
        welcomeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 35).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: drivewayzCar.bottomAnchor, constant: 5).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(signInButton)
        signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signInButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -140).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        self.view.addSubview(separatorLine)
        separatorLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -80).isActive = true
        
        self.view.addSubview(methodButton)
        methodButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        methodButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 15).isActive = true
        methodButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        methodButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            self.startAnimations()
        }
    }
    
    func startAnimations() {
        UIView.animate(withDuration: 0.3, animations: {
            self.drivewayzTopAnchor.constant = -self.view.frame.height/4
            self.drivewayzCenterAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.welcomeLabel.alpha = 1
                self.signInButton.alpha = 1
                self.methodButton.alpha = 1
            }, completion: { (success) in
                //
            })
        }
    }

}








