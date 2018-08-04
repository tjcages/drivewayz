//
//  DelegateViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/31/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class DelegateViewController: UIViewController {
    
    lazy var tabController: TabViewController = {
        let controller = TabViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Tab"
        return controller
    }()
    
    lazy var loginController: StartUpViewController = {
        let controller = StartUpViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Start"
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.OFF_WHITE

//        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.moveToTab()
//            }
//        }
//        else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.moveToLogin()
//            }
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToTab() {
        setupTabView()
        UIView.animate(withDuration: 0.3, animations: {
            self.tabViewAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.removeLoginView()
        }
    }
    
    func moveToLogin() {
        setupLoginView()
        UIView.animate(withDuration: 0.3, animations: {
            self.loginViewAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.removeTabView()
        }
    }
    
    var tabViewAnchor:NSLayoutConstraint!
    func setupTabView() {
        self.view.addSubview(tabController.view)
//        self.addChildViewController(tabController)
        tabController.willMove(toParentViewController: self)
        tabController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        tabViewAnchor = tabController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            tabViewAnchor.isActive = true
        tabController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tabController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    var loginViewAnchor:NSLayoutConstraint!
    func setupLoginView() {
        self.view.addSubview(loginController.view)
//        self.addChildViewController(loginController)
        loginController.willMove(toParentViewController: self)
        loginController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        loginViewAnchor = loginController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height)
            loginViewAnchor.isActive = true
        loginController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loginController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    func removeTabView() {
        tabController.willMove(toParentViewController: nil)
        tabController.view.removeFromSuperview()
        tabController.removeFromParentViewController()
    }
    
    func removeLoginView() {
        loginController.willMove(toParentViewController: nil)
        loginController.view.removeFromSuperview()
        loginController.removeFromParentViewController()
    }

}







