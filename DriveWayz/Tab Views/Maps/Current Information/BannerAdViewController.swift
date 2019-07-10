//
//  BannerAdViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/5/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
//import FirebaseInvites

class BannerAdViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
//        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    var bannerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    var googleSignInButton: GIDSignInButton = {
       let button = GIDSignInButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(inviteTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        setData()
        setupViews()
    }
    
    func setData() {
        let ref = Database.database().reference().child("BannerAds")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let imageURL = dictionary["inviteFriends"] as? String {
                    self.bannerImageView.loadImageUsingCacheWithUrlString(imageURL)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func setupViews() {
        self.view.addSubview(bannerImageView)
        bannerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bannerImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bannerImageView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        self.view.addSubview(bannerContainer)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(inviteTapped(_:)))
        bannerContainer.addGestureRecognizer(gesture)
        bannerContainer.centerXAnchor.constraint(equalTo: bannerImageView.centerXAnchor).isActive = true
        bannerContainer.centerYAnchor.constraint(equalTo: bannerImageView.centerYAnchor).isActive = true
        bannerContainer.widthAnchor.constraint(equalTo: bannerImageView.widthAnchor).isActive = true
        bannerContainer.heightAnchor.constraint(equalTo: bannerImageView.heightAnchor).isActive = true
    }

    @objc func inviteTapped(_ sender: AnyObject) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
    }
    
    func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
        if let error = error {
            print("Failed: " + error.localizedDescription)
        } else {
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("users").child(currentUser).child("Coupons")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if (dictionary["invite10"] as? String) != nil {
                        let alert = UIAlertController(title: "Sorry!", message: "You can only get one 10% off coupon for sharing.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    } else {
                        ref.updateChildValues(["invite10": "10% off coupon!"])
                        let alert = UIAlertController(title: "Thanks for sharing!", message: "You have successfully invited your friend and recieved a 10% off coupon for your next rental!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        guard let prevUser = Auth.auth().currentUser else {return}
        prevUser.linkAndRetrieveData(with: credential) { (authResult, error) in
//            if let invite = Invites.inviteDialog() {
//                invite.setInviteDelegate(self)
//            
//                invite.setMessage("Check out Drivewayz! The best new way to find parking. \n -\(GIDSignIn.sharedInstance().currentUser.profile.name!)")
//                invite.setTitle("Drivewayz")
//                //            invite.setDeepLink("app_url")
//                invite.setCallToActionText("Install!")
//                invite.open()
//            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
