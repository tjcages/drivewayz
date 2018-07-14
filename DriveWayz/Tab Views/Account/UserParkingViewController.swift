//
//  UserParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class UserParkingViewController: UIViewController {
    
    lazy var addAParkingSpot: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Theme.PRIMARY_COLOR
        button.setTitle("Parking Spot", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 20
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let addButton = UIButton(type: .custom)
        let image = UIImage(named: "Plus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(tintedImage, for: .normal)
        addButton.tintColor = Theme.WHITE
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.borderColor = Theme.WHITE.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 15
        addButton.addTarget(self, action:#selector(addAParkingButtonPressed(sender:)), for: .touchUpInside)
        button.addSubview(addButton)
        
        addButton.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -8).isActive = true
        addButton.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -6).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return button
    }()
    
    var newParkingPage: UIView!
    var addParkingButton: UIButton!
    var addParkingLabel: UILabel!
    var currentParkingImageView: UIImageView!
    var parkingInfo: UILabel!
    var parkingLicenseInfo: UILabel!
    var blurparkingInfoView: UIVisualEffectView!
    var blurparkingWidthConstraint: NSLayoutConstraint!
    
    func setupParkingDisplay() {
        newParkingPage = UIView()
        newParkingPage.backgroundColor = UIColor.white
        newParkingPage.translatesAutoresizingMaskIntoConstraints = false
        newParkingPage.layer.shadowColor = UIColor.darkGray.cgColor
        newParkingPage.layer.shadowOffset = CGSize(width: 0, height: 0)
        newParkingPage.layer.shadowOpacity = 0.8
        newParkingPage.layer.cornerRadius = 20
        newParkingPage.layer.shadowRadius = 3
        
        addParkingButton = UIButton(type: .custom)
        let image = UIImage(named: "Plus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        addParkingButton.setImage(tintedImage, for: .normal)
        addParkingButton.tintColor = Theme.DARK_GRAY
        addParkingButton.translatesAutoresizingMaskIntoConstraints = false
        addParkingButton.layer.borderColor = Theme.DARK_GRAY.cgColor
        addParkingButton.layer.borderWidth = 1
        addParkingButton.layer.cornerRadius = 20
        addParkingButton.addTarget(self, action:#selector(addAParkingButtonPressed(sender:)), for: .touchUpInside)
        newParkingPage.addSubview(addParkingButton)
        
        addParkingButton.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 8).isActive = true
        addParkingButton.bottomAnchor.constraint(equalTo: newParkingPage.bottomAnchor, constant: -4).isActive = true
        addParkingButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addParkingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addParkingLabel = UILabel()
        addParkingLabel.text = "Add a new Parking Spot"
        addParkingLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addParkingLabel.textColor = Theme.DARK_GRAY
        addParkingLabel.translatesAutoresizingMaskIntoConstraints = false
        addParkingLabel.contentMode = .center
        newParkingPage.addSubview(addParkingLabel)
        newParkingPage.bringSubview(toFront: addParkingLabel)
        
        addParkingLabel.leftAnchor.constraint(equalTo: addParkingButton.rightAnchor, constant: 8).isActive = true
        addParkingLabel.centerYAnchor.constraint(equalTo: addParkingButton.centerYAnchor).isActive = true
        addParkingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addParkingLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        currentParkingImageView = UIImageView()
        currentParkingImageView.translatesAutoresizingMaskIntoConstraints = false
        currentParkingImageView.contentMode = .scaleAspectFill
        currentParkingImageView.backgroundColor = UIColor.white
        currentParkingImageView.clipsToBounds = true
        currentParkingImageView.layer.cornerRadius = 20
        newParkingPage.addSubview(currentParkingImageView)
        newParkingPage.bringSubview(toFront: currentParkingImageView)
        
        currentParkingImageView.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 8).isActive = true
        currentParkingImageView.topAnchor.constraint(equalTo: newParkingPage.topAnchor, constant: 48).isActive = true
        currentParkingImageView.rightAnchor.constraint(equalTo: newParkingPage.rightAnchor, constant: -8).isActive = true
        currentParkingImageView.bottomAnchor.constraint(equalTo: newParkingPage.bottomAnchor, constant: -8).isActive = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurparkingInfoView = UIVisualEffectView(effect: blurEffect)
        blurparkingInfoView.alpha = 0.8
        blurparkingInfoView.layer.cornerRadius = 10
        blurparkingInfoView.clipsToBounds = true
        blurparkingInfoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurparkingInfoView.translatesAutoresizingMaskIntoConstraints = false
        currentParkingImageView.addSubview(blurparkingInfoView)
        
        blurparkingInfoView.topAnchor.constraint(equalTo: currentParkingImageView.topAnchor).isActive = true
        blurparkingInfoView.leftAnchor.constraint(equalTo: currentParkingImageView.leftAnchor).isActive = true
        blurparkingWidthConstraint = blurparkingInfoView.widthAnchor.constraint(equalToConstant: 300)
        blurparkingWidthConstraint.isActive = true
        blurparkingInfoView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        parkingInfo = UILabel()
        parkingInfo.text = "Vehicle Info"
        parkingInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        parkingInfo.textColor = Theme.WHITE
        parkingInfo.translatesAutoresizingMaskIntoConstraints = false
        parkingInfo.contentMode = .left
        parkingInfo.numberOfLines = 3
        currentParkingImageView.addSubview(parkingInfo)
        currentParkingImageView.bringSubview(toFront: parkingInfo)
        
        parkingInfo.leftAnchor.constraint(equalTo: currentParkingImageView.leftAnchor, constant: 8).isActive = true
        parkingInfo.topAnchor.constraint(equalTo: currentParkingImageView.topAnchor, constant: -8).isActive = true
        parkingInfo.widthAnchor.constraint(equalTo: currentParkingImageView.widthAnchor, constant: -80).isActive = true
        parkingInfo.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        parkingLicenseInfo = UILabel()
        parkingLicenseInfo.text = "License Plate"
        parkingLicenseInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        parkingLicenseInfo.textColor = Theme.WHITE
        parkingLicenseInfo.translatesAutoresizingMaskIntoConstraints = false
        parkingLicenseInfo.contentMode = .left
        currentParkingImageView.addSubview(parkingLicenseInfo)
        currentParkingImageView.bringSubview(toFront: parkingLicenseInfo)
        
        parkingLicenseInfo.leftAnchor.constraint(equalTo: currentParkingImageView.leftAnchor, constant: 8).isActive = true
        parkingLicenseInfo.topAnchor.constraint(equalTo: currentParkingImageView.topAnchor, constant: 8).isActive = true
        parkingLicenseInfo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        parkingLicenseInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.OFF_WHITE
        
        startUpActivity()
        fetchUserAndSetupParking()
        setupParkingDisplay()
        
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
    var blurSquare: UIVisualEffectView!
    
    func startUpActivity() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurSquare = UIVisualEffectView(effect: blurEffect)
        blurSquare.layer.cornerRadius = 15
        blurSquare.alpha = 1
        blurSquare.clipsToBounds = true
        blurSquare.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(blurSquare)
        blurSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurSquare.widthAnchor.constraint(equalToConstant: 120).isActive = true
        blurSquare.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(startActivityIndicatorView)
        
        startActivityIndicatorView.centerXAnchor.constraint(equalTo: blurSquare.centerXAnchor).isActive = true
        startActivityIndicatorView.centerYAnchor.constraint(equalTo: blurSquare.centerYAnchor).isActive = true
        startActivityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        startActivityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.startActivityIndicatorView.startAnimating()
        
    }

    var parkingPageHeightAnchorSmall: NSLayoutConstraint!
    var parkingPageHeightAnchorTall: NSLayoutConstraint!
    
    func setupParkingView() {
        
        self.view.addSubview(newParkingPage)
        self.view.sendSubview(toBack: newParkingPage)
        
        newParkingPage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        newParkingPage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        newParkingPage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        parkingPageHeightAnchorSmall = newParkingPage.heightAnchor.constraint(equalToConstant: 90)
        parkingPageHeightAnchorTall = newParkingPage.heightAnchor.constraint(equalToConstant: 280)
        
        newParkingPage.addSubview(addAParkingSpot)
        
        if parking > 0 {
            parkingPageHeightAnchorTall.isActive = true
            parkingPageHeightAnchorSmall.isActive = false
            self.addParkingLabel.removeFromSuperview()
            self.addParkingButton.removeFromSuperview()
        } else {
            parkingPageHeightAnchorSmall.isActive = true
            parkingPageHeightAnchorTall.isActive = false
            self.currentParkingImageView.isHidden = true
            self.blurparkingInfoView.isHidden = true
            self.parkingInfo.isHidden = true
            self.parkingLicenseInfo.isHidden = true
        }
        
        newParkingPage.bringSubview(toFront: addAParkingSpot)
        
        addAParkingSpot.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        addAParkingSpot.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        addAParkingSpot.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        addAParkingSpot.heightAnchor.constraint(equalToConstant: 40).isActive = false
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    func fetchUserAndSetupParking() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var userParkingID: String!
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                userParkingID = dictionary["parkingID"] as? String
                if userParkingID != nil {
                    parking = parking + 1
                } else { parking = 0 }
            
                if userParkingID != nil {
                    Database.database().reference().child("parking").child(userParkingID).observeSingleEvent(of: .value, with: { (snap) in
                        if let dictionary = snap.value as? [String:AnyObject] {
                            let parkingAddress = dictionary["parkingAddress"] as? String
                            let parkingImageURL = dictionary["parkingImageURL"] as? String
                            
                            if parkingImageURL == nil {
                                self.currentParkingImageView.image = UIImage(named: "profileprofile")
                            } else {
                                self.currentParkingImageView.loadImageUsingCacheWithUrlString(parkingImageURL!)
                            }
                            
                            let text = parkingAddress!
                            self.parkingInfo.text = text
                            self.parkingLicenseInfo.text = ""
                            let width = self.estimatedFrameForText(text: text).width + 4
                            self.blurparkingInfoView.frame.size.width = width
                        }
                    }, withCancel: nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1)), execute: {
                self.setupParkingView()
                self.startActivityIndicatorView.stopAnimating()
                self.blurSquare.alpha = 0
            })
        }, withCancel: nil)
        return
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    @objc func addAParkingButtonPressed(sender: UIButton) {
//        self.view.bringSubview(toFront: visualBlurEffect)
//        self.setupAddAParkingView()
//        self.view.bringSubview(toFront: addANewParkingView)
//        addANewParkingView.center = self.view.center
//        addANewParkingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//        addANewParkingView.alpha = 0
//        UIView.animate(withDuration: 0.4) {
//            self.visualBlurEffect.effect = self.effect
//            self.addANewParkingView.alpha = 1
//            self.addANewParkingView.transform = CGAffineTransform.identity
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
