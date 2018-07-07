//
//  LoginViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        userEmailTextField.endEditing(true)
        userPasswordTextField.endEditing(true)
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        if((userPassword?.isEmpty)! || (userEmail?.isEmpty)!) {
                
            //Display alert message
            displayAlertMessage(userMessage: "Missing required field")
            return
            
        } else {
        //Send data serverside
            Auth.auth().signIn(withEmail: userEmail!, password: userPassword!, completion: { (user, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                print("Successfully logged in!")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                let myViewController: TabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = myViewController
                appDelegate.window?.makeKeyAndVisible()
                
                
                self.dismiss(animated: true, completion: nil)
                
            })
        
        }
    }

    
    func displayAlertMessage(userMessage: String) {
        let alert = UIAlertController(title: "Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}



