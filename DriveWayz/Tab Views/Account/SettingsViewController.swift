//
//  SettingsViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToAccount", sender: self)
    }
    
}
