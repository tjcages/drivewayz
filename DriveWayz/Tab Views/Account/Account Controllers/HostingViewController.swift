//
//  HostingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/17/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleCurrentParking {
    func changeCurrentView(height: CGFloat)
    func bringNewHostingController()
    func hideNewHostingController()
}

class HostingViewController: UIViewController, handleCurrentParking, controlsBankAccount {
    

    var delegate: controlsAccountOptions?
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Make EASY money renting out your driveway while helping people in your community find cheap and easy parking."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 4
        label.textAlignment = .center
        
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var userCurrentController: CurrentViewController = {
        let controller = CurrentViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Current"
        controller.delegate = self
        
        return controller
    }()
    
    lazy var userHostingController: UserParkingViewController = {
        let controller = UserParkingViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Parking"
        controller.delegate = self
        controller.bankDelegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        setupViews()
        addCurrentParking()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userParkingTopAnchor: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: container.frame.width, height: 0)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        scrollView.addSubview(userCurrentController.view)
        userCurrentController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userCurrentController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        userCurrentController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -10).isActive = true
        currentHeightAnchor = userCurrentController.view.heightAnchor.constraint(equalToConstant: 0)
            currentHeightAnchor?.isActive = true
        userCurrentController.view.alpha = 0
        
        scrollView.addSubview(userHostingController.view)
        userHostingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userHostingController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        userParkingTopAnchor = userHostingController.view.topAnchor.constraint(equalTo: userCurrentController.view.bottomAnchor, constant: 80)
            userParkingTopAnchor.isActive = true
        userHostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    var currentHeightAnchor: NSLayoutConstraint?
    lazy var currentSize = CGSize(width: container.frame.width, height: 1300)
    
    func changeCurrentView(height: CGFloat) {
        self.userParkingTopAnchor.constant = 10
        self.userCurrentController.view.alpha = 1
        self.currentHeightAnchor?.constant = height
        if height >= 300 {
            scrollView.contentSize = CGSize(width: container.frame.width, height: 1800)
            currentSize = scrollView.contentSize
        } else if height >= 200 {
            scrollView.contentSize = CGSize(width: container.frame.width, height: 1600)
            currentSize = scrollView.contentSize
            self.userCurrentController.view.alpha = 1
            self.userParkingTopAnchor.constant = 10
            self.informationLabel.alpha = 0
        } else if height == 0 {
            scrollView.contentSize = CGSize(width: container.frame.width, height: 0)
            currentSize = scrollView.contentSize
            self.userCurrentController.view.alpha = 0
            self.userParkingTopAnchor.constant = 10
            self.informationLabel.alpha = 1
            self.userCurrentController.setupNoView()
        } else {
            scrollView.contentSize = CGSize(width: container.frame.width, height: 1500)
            currentSize = scrollView.contentSize
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.informationLabel.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.hideHostingController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.closeAccountView()
        }
    }
    
    func addCurrentParking() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser).child("Parking")
        ref.observe(.childAdded) { (snapshot) in
            self.changeCurrentView(height: 200)
        }
    }
    
    func bringNewHostingController() {
        self.delegate?.hideHostingController()
        self.delegate?.bringNewHostingController(parkingImage: .noImage)
    }
    
    func hideNewHostingController() {
        self.delegate?.hideHostingController()
        self.delegate?.bringHostingController()
    }
    
    func setupBankAccount() {
        self.delegate?.bringBankAccountController()
    }

}
