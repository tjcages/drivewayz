//
//  SearchTableViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        createSearchBar()
        
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search.."
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if !isUserLoggedIn {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "loginView", sender: self)
        
        //        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.window?.rootViewController = loginViewController
        //        appDelegate.window?.makeKeyAndVisible()
        
    }
}
