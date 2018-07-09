//
//  UserVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class UserVehicleViewController: UIViewController {
    
    var vehicles: Int = 0
    
    lazy var addAVehicle: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Theme.PRIMARY_COLOR
        button.setTitle("Vehicle", for: .normal)
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
        addButton.addTarget(self, action:#selector(addAVehicleButtonPressed(sender:)), for: .touchUpInside)
        //        addButton.addTarget(self, action: #selector(popUpColor(sender:)), for: .touchUpInside)
        button.addSubview(addButton)
        
        addButton.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -8).isActive = true
        addButton.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -6).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return button
    }()
    
    var newVehiclePage: UIView!
    var addButton: UIButton!
    var addLabel: UILabel!
    var currentVehicleImageView: UIImageView!
    var vehicleInfo: UILabel!
    var vehicleLicenseInfo: UILabel!
    var blurInfoView: UIVisualEffectView!
    var blurWidthConstraint: NSLayoutConstraint!
    
    func setupVehicleDisplay() {
        newVehiclePage = UIView()
        newVehiclePage.backgroundColor = UIColor.white
        newVehiclePage.translatesAutoresizingMaskIntoConstraints = false
        newVehiclePage.layer.shadowColor = UIColor.darkGray.cgColor
        newVehiclePage.layer.shadowOffset = CGSize(width: 0, height: 0)
        newVehiclePage.layer.shadowOpacity = 0.8
        newVehiclePage.layer.cornerRadius = 20
        newVehiclePage.layer.shadowRadius = 3
        
        addButton = UIButton(type: .custom)
        let image = UIImage(named: "Plus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(tintedImage, for: .normal)
        addButton.tintColor = Theme.DARK_GRAY
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.borderColor = Theme.DARK_GRAY.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 20
        addButton.addTarget(self, action:#selector(addAVehicleButtonPressed(sender:)), for: .touchUpInside)
        newVehiclePage.addSubview(addButton)
        
        addButton.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 8).isActive = true
        addButton.bottomAnchor.constraint(equalTo: newVehiclePage.bottomAnchor, constant: -4).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addLabel = UILabel()
        addLabel.text = "Add a new Vehicle"
        addLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addLabel.textColor = Theme.DARK_GRAY
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        addLabel.contentMode = .center
        newVehiclePage.addSubview(addLabel)
        newVehiclePage.bringSubview(toFront: addLabel)
        
        addLabel.leftAnchor.constraint(equalTo: addButton.rightAnchor, constant: 8).isActive = true
        addLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
        addLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        currentVehicleImageView = UIImageView()
        currentVehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        currentVehicleImageView.contentMode = .scaleAspectFill
        currentVehicleImageView.backgroundColor = UIColor.white
        currentVehicleImageView.clipsToBounds = true
        currentVehicleImageView.layer.cornerRadius = 20
        newVehiclePage.addSubview(currentVehicleImageView)
        newVehiclePage.bringSubview(toFront: currentVehicleImageView)
        
        currentVehicleImageView.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 8).isActive = true
        currentVehicleImageView.topAnchor.constraint(equalTo: newVehiclePage.topAnchor, constant: 48).isActive = true
        currentVehicleImageView.rightAnchor.constraint(equalTo: newVehiclePage.rightAnchor, constant: -8).isActive = true
        currentVehicleImageView.bottomAnchor.constraint(equalTo: newVehiclePage.bottomAnchor, constant: -8).isActive = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurInfoView = UIVisualEffectView(effect: blurEffect)
        blurInfoView.alpha = 0.8
        blurInfoView.layer.cornerRadius = 10
        blurInfoView.clipsToBounds = true
        blurInfoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurInfoView.translatesAutoresizingMaskIntoConstraints = false
        currentVehicleImageView.addSubview(blurInfoView)
        
        blurInfoView.topAnchor.constraint(equalTo: currentVehicleImageView.topAnchor).isActive = true
        blurInfoView.leftAnchor.constraint(equalTo: currentVehicleImageView.leftAnchor).isActive = true
        blurWidthConstraint = blurInfoView.widthAnchor.constraint(equalToConstant: 300)
        blurWidthConstraint.isActive = true
        blurInfoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        vehicleInfo = UILabel()
        vehicleInfo.text = "Vehicle Info"
        vehicleInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        vehicleInfo.textColor = Theme.WHITE
        vehicleInfo.translatesAutoresizingMaskIntoConstraints = false
        vehicleInfo.contentMode = .left
        currentVehicleImageView.addSubview(vehicleInfo)
        currentVehicleImageView.bringSubview(toFront: vehicleInfo)
        
        vehicleInfo.leftAnchor.constraint(equalTo: currentVehicleImageView.leftAnchor, constant: 8).isActive = true
        vehicleInfo.topAnchor.constraint(equalTo: currentVehicleImageView.topAnchor, constant: -8).isActive = true
        vehicleInfo.widthAnchor.constraint(equalTo: currentVehicleImageView.widthAnchor, constant: -8).isActive = true
        vehicleInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        vehicleLicenseInfo = UILabel()
        vehicleLicenseInfo.text = "License Plate"
        vehicleLicenseInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        vehicleLicenseInfo.textColor = Theme.WHITE
        vehicleLicenseInfo.translatesAutoresizingMaskIntoConstraints = false
        vehicleLicenseInfo.contentMode = .left
        currentVehicleImageView.addSubview(vehicleLicenseInfo)
        currentVehicleImageView.bringSubview(toFront: vehicleLicenseInfo)
        
        vehicleLicenseInfo.leftAnchor.constraint(equalTo: currentVehicleImageView.leftAnchor, constant: 8).isActive = true
        vehicleLicenseInfo.topAnchor.constraint(equalTo: currentVehicleImageView.topAnchor, constant: 8).isActive = true
        vehicleLicenseInfo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        vehicleLicenseInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        fetchUserAndSetupVehicles()
        setupVehicleDisplay()
        
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
    
    var vehiclePageHeightAnchorSmall: NSLayoutConstraint!
    var vehiclePageHeightAnchorTall: NSLayoutConstraint!
    
    func setupVehicleView() {
        
        self.view.addSubview(newVehiclePage)
        self.view.sendSubview(toBack: newVehiclePage)
        
        newVehiclePage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        newVehiclePage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        newVehiclePage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        vehiclePageHeightAnchorSmall = newVehiclePage.heightAnchor.constraint(equalToConstant: 90)
        vehiclePageHeightAnchorTall = newVehiclePage.heightAnchor.constraint(equalToConstant: 260)
        
        newVehiclePage.addSubview(addAVehicle)
        
        if vehicles > 0 {
            vehiclePageHeightAnchorTall.isActive = true
            self.addLabel.removeFromSuperview()
            self.addButton.removeFromSuperview()
        } else {
            vehiclePageHeightAnchorSmall.isActive = true
            self.currentVehicleImageView.isHidden = true
            self.blurInfoView.isHidden = true
            self.vehicleInfo.isHidden = true
            self.vehicleLicenseInfo.isHidden = true
        }
        
        newVehiclePage.bringSubview(toFront: addAVehicle)
        
        addAVehicle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        addAVehicle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        addAVehicle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        addAVehicle.heightAnchor.constraint(equalToConstant: 40).isActive = false
        
    }
    
    func fetchUserAndSetupVehicles() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var userVehicleID: String!
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                userVehicleID = dictionary["vehicleID"] as? String
                if userVehicleID != nil {
                    self.vehicles = self.vehicles + 1
                } else { self.vehicles = 0 }
                
                if userVehicleID != nil {
                    Database.database().reference().child("vehicles").child(userVehicleID).observeSingleEvent(of: .value, with: { (snap) in
                        if let dictionary = snap.value as? [String:AnyObject] {
                            let vehicleMake = dictionary["vehicleMake"] as? String
                            let vehicleModel = dictionary["vehicleModel"] as? String
                            let vehicleYear = dictionary["vehicleYear"] as? String
                            let vehicleLicensePlate = dictionary["vehicleLicensePlate"] as? String
                            let vehicleImageURL = dictionary["vehicleImageURL"] as? String
                            
                            if vehicleImageURL == nil {
                                self.currentVehicleImageView.image = UIImage(named: "profileprofile")
                            } else {
                                self.currentVehicleImageView.loadImageUsingCacheWithUrlString(vehicleImageURL!)
                            }
                            
                            let text = vehicleYear! + " " + vehicleMake! + " " + vehicleModel!
                            self.vehicleInfo.text = text
                            self.vehicleLicenseInfo.text = vehicleLicensePlate!
                            let width = self.estimatedFrameForText(text: text).width + 4
                            self.blurInfoView.frame.size.width = width
                        }
                    }, withCancel: nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1)), execute: {
                self.setupVehicleView()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addAVehicleButtonPressed(sender: UIButton) {
//        self.view.bringSubview(toFront: visualBlurEffect)
//        self.view.addSubview(addANewVehicleView)
//        addANewVehicleView.center = self.view.center
//        addANewVehicleView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//        addANewVehicleView.alpha = 0
//        UIView.animate(withDuration: 0.4) {
//            self.visualBlurEffect.effect = self.effect
//            self.addANewVehicleView.alpha = 1
//            self.addANewVehicleView.transform = CGAffineTransform.identity
//        }
    }
    
    
}
