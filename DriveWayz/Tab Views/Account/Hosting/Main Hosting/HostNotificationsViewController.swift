//
//  HostNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostNotifications {
    func resetNotificationHeight()
    func bringNofiticationsController()
}

class HostNotificationsViewController: UIViewController {

    var delegate: handleHostingControllers?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var notificationsContainer: MyNotificationsViewController = {
        let controller = MyNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }

    var notificiationHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 842)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(notificationsContainer.view)
        notificationsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 2).isActive = true
        notificationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        notificationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        notificiationHeightAnchor = notificationsContainer.view.heightAnchor.constraint(equalToConstant: notificationsContainer.notificationHeightAnchor.constant)
            notificiationHeightAnchor.isActive = true
        
    }
    
}


extension HostNotificationsViewController: handleHostNotifications {

    func bringNofiticationsController() {
        
    }
    
    func dismissNofiticationsController() {
        
    }
    
    func resetNotificationHeight() {
        self.notificiationHeightAnchor.constant = self.notificationsContainer.notificationHeightAnchor.constant
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: self.notificiationHeightAnchor.constant + 180)
        
        self.view.layoutIfNeeded()
    }
    
}


extension HostNotificationsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        self.delegate?.handleScrollView(translation: translation)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.delegate?.handleEndDragging(translation: translation)
    }
    
}
