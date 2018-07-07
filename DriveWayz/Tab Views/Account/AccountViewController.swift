//
//  AccountViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

// Firebase services
var database: Database!
var storage: Storage!

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var loginController: LoginViewController?
    
    let cellId = "cellId"
    var users = [Users]()

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    
        var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        loadProfileImage()
        fetchUserAndSetup()

    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
        
//        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    guard let profileImageURL = url?.absoluteString else {
                        print("Error finding image url:", error!)
                        return
                    }
                    let values = ["picture": profileImageURL]
                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                })
            })
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUserAndSetup() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                let userEmail = dictionary["email"] as? String
                let userPicture = dictionary["picture"] as? String
                
                if userPicture == "" {
                    self.profileImageView.image = UIImage(named: "profileprofile")
                } else {
                    self.profileImageView.loadImageUsingCacheWithUrlString(userPicture!)
                }
                
                self.profileName.text = userName
                self.profileEmail.text = userEmail
            }
        }, withCancel: nil)
        return 
    }
  
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://collegefeed-de9f0.firebaseio.com/")
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
            
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //let loginController = LoginViewController()
        
        present(viewController, animated: true, completion: nil)
    }
    
    func loadProfileImage() {
        profileImageView.image = UIImage(named: "profileprofile")
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.init(red: 89/255, green: 89/255, blue: 89/255, alpha: 1).cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }

    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}

}
