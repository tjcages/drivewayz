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
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 3
        label.textAlignment = .center
        
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        //        view.clipsToBounds = true
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
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
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
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
        UIView.animate(withDuration: animationIn) {
            self.userUpcomingController.view.alpha = 1
            self.informationLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideUpcomingViewController() {
        self.upcomingViewHeightAnchor?.constant = 70
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 0)
        UIView.animate(withDuration: animationIn) {
            self.userUpcomingController.view.alpha = 0
            self.informationLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

}
