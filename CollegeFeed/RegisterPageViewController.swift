//
//  RegisterPageViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {


    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = userRepeatPasswordTextField.text
        
        //Check if passwords match
        if userPassword != userRepeatPassword {
            
            //Display alert message
            displayAlertMessage(userMessage: "Passwords do not match")
            return
            
        }
        
        // Send user data to server side
        
        let myUrl = NSURL(string:"http://tjauth.dev:8888/userRegister.php")
        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(userEmail!)&password=\(userPassword!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if let parseJSON = json {
                    let resultValue:String = parseJSON["status"] as! String
                    print("result: \(resultValue)")
                    
                    var isUserRegistered: Bool = false
                    if(resultValue == "Success") { isUserRegistered = true }
                    
                    var messageToDisplay: String = parseJSON["message"] as! String
                    if (!isUserRegistered) { messageToDisplay = parseJSON["message"] as! String }
                    
                    DispatchQueue.main.async(execute: {
                        
                        //Display alert message with confirmation
                        let myAlert = UIAlertController(title: resultValue, message: messageToDisplay, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                            
                            if(resultValue == "Success") {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                        
                    })
                }
                
                
            } catch let error as NSError {
                var err: NSError?
                err = error
                print(err as NSError!)
            }
            
        }
        task.resume()
        
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

    
}




















