//
//  UpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleUpcomingParking {
    func bringUpcomingViewController()
    func hideUpcomingViewController()
}

class UpcomingViewController: UIViewController, handleUpcomingParking {

    var delegate: controlsAccountOptions?
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Here you will be able to see all upcoming parking reservations that you have made."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 3
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
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var userUpcomingController: UserUpcomingViewController = {
        let controller = UserUpcomingViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Upcoming"
        controller.delegate = self
        return controller
    }()
    
    lazy var recentController: UserRecentViewController = {
        let controller = UserRecentViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Recent"
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var upcomingViewHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 40).isActive = true
        container.heightAnchor.constraint(equalToConstant: self.view.frame.height - 160).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        
        container.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 0)
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
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
        
        scrollView.addSubview(userUpcomingController.view)
        userUpcomingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userUpcomingController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        userUpcomingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        upcomingViewHeightAnchor = userUpcomingController.view.heightAnchor.constraint(equalToConstant: 70)
            upcomingViewHeightAnchor?.isActive = true
        
        scrollView.addSubview(recentController.view)
        recentController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        recentController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        recentController.view.topAnchor.constraint(equalTo: userUpcomingController.view.bottomAnchor, constant: 10).isActive = true
        recentController.view.heightAnchor.constraint(equalToConstant: 190).isActive = true
        
    }
    
    func bringUpcomingViewController() {
        self.upcomingViewHeightAnchor?.constant = 480
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
        UIView.animate(withDuration: 0.3) {
            self.userUpcomingController.view.alpha = 1
            self.informationLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideUpcomingViewController() {
        self.upcomingViewHeightAnchor?.constant = 70
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 0)
        UIView.animate(withDuration: 0.3) {
            self.userUpcomingController.view.alpha = 0
            self.informationLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.hideUpcomingController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.closeAccountView()
        }
    }

}
