//
//  RegisterViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        userEmailTextField.endEditing(true)
        userPasswordTextField.endEditing(true)
        userRepeatPasswordTextField.endEditing(true)
        userNameTextField.endEditing(true)
        
        let userProfile: String = ""
        let userBio: String = ""
        
        guard let userName = userNameTextField.text, let userEmail = userEmailTextField.text, let userPassword = userPasswordTextField.text, let userRepeatPassword = userRepeatPasswordTextField.text else {
            print("Error")
            return
        }
        
        //Check if passwords match
        if userPassword != userRepeatPassword {
            
            //Display alert message
            displayAlertMessage(userMessage: "Passwords do not match")
            return
            
        }
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in

            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.user.uid else {return}
            
            let ref = Database.database().reference(fromURL: "https://collegefeed-de9f0.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": userName,
                          "email": userEmail,
                          "picture": userProfile,
                          "bio": userBio]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                
            })

            
        })
    }
    
    
    func displayAlertMessage(userMessage: String) {
        let alert = UIAlertController(title: "Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func exitRegisterPageButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}





















