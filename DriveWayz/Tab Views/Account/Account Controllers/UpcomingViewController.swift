//
//  UpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleUpcomingConrollers {
    func openRecentController()
    func closeRecentController()
}

class UpcomingViewController: UIViewController, handleUpcomingConrollers {
    
    var delegate: moveControllers?
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Bookings"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    lazy var parkingTableController: UserUpcomingViewController = {
        let controller = UserUpcomingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var recentController: UserRecentViewController = {
        let controller = UserRecentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var recentTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        self.view.addSubview(parkingTableController.view)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        }
        
        parkingTableController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingTableController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        parkingTableController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingTableController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(recentController.view)
        recentTopAnchor = recentController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            recentTopAnchor.isActive = true
        recentController.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        recentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        recentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }
    
    func openRecentController() {
        self.delegate?.hideExitButton()
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.recentTopAnchor.constant = -statusHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func closeRecentController() {
        self.delegate?.bringExitButton()
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.recentTopAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }
    }
    
}
