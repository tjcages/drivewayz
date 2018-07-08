//
//  LoginViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    let transition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        setupBackground()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.80
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
        
        let background = UIImage(named: "background")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = self.view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
//        let background = CAGradientLayer().redColor()
//        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        background.zPosition = -10
//        self.view.layer.insertSublayer(background, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! RegisterViewController
        secondViewController.transitioningDelegate = self
        secondViewController.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = registerButton.center
        transition.circleColor = UIColor.white
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = registerButton.center
        transition.circleColor = UIColor.white
        return transition
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
                
                let myViewController: TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
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
    
    @IBAction func registerButtonPressed(_ sender: Any) {
//        self.view.alpha = 0
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}



