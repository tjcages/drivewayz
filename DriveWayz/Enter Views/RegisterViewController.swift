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
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var confirmRegister: UIView!
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        confirmRegister.layer.cornerRadius = 10
        dismissButton.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        dismissButton.layer.borderWidth = 1
    }
    
    func animateIn() {
        self.view.bringSubview(toFront: visualEffectView)
        self.view.addSubview(confirmRegister)
        confirmRegister.center = self.view.center
        confirmRegister.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        confirmRegister.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.confirmRegister.alpha = 1
            self.confirmRegister.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmRegister.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.confirmRegister.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
                self.confirmRegister.removeFromSuperview()
                self.view.sendSubview(toBack: self.visualEffectView)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        userEmailTextField.endEditing(true)
        userPasswordTextField.endEditing(true)
        userRepeatPasswordTextField.endEditing(true)
        userNameTextField.endEditing(true)
        userLastNameTextField.endEditing(true)
        
        let userProfile: String = ""
        let userBio: String = ""
        
        guard let userName = userNameTextField.text, let userLastName = userLastNameTextField.text, let userEmail = userEmailTextField.text, let userPassword = userPasswordTextField.text, let userRepeatPassword = userRepeatPasswordTextField.text else {
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
            let name = userName + " " + userLastName
            
            let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name,
                          "email": userEmail,
                          "picture": userProfile,
                          "bio": userBio]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("Successfully logged in!")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                let myViewController: TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = myViewController
                appDelegate.window?.makeKeyAndVisible()
                
                self.dismiss(animated: true, completion: nil)
                
            })
        })
        animateOut()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        animateOut()
    }
    
    
    func setupBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
        
        let background = CAGradientLayer().blueColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        self.view.layer.insertSublayer(background, at: 0)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        animateIn()
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





















