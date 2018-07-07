//
//  ViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
    }
    
    @objc func handleLogout() {
        self.performSegue(withIdentifier: "loginView", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//    override func viewDidAppear(_ animated: Bool) {
//        
//        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
//        
//        if !isUserLoggedIn {
//            self.performSegue(withIdentifier: "loginView", sender: self)
//        }
//    }
}

