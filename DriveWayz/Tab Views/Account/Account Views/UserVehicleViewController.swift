//
//  UserVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class UserVehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum VehicleSize {
        case small
        case tall
    }
    
    var vehicleSize: VehicleSize = VehicleSize.small
    var delegate: controlsNewParking?
    var vehicles: Int = 0
    
    var newVehiclePage: UIView = {
        let newVehiclePage = UIView()
        newVehiclePage.backgroundColor = UIColor.white
        newVehiclePage.translatesAutoresizingMaskIntoConstraints = false
        newVehiclePage.layer.shadowColor = UIColor.darkGray.cgColor
        newVehiclePage.layer.shadowOffset = CGSize(width: 0, height: 1)
        newVehiclePage.layer.shadowOpacity = 0.8
        newVehiclePage.layer.cornerRadius = 10
        newVehiclePage.layer.shadowRadius = 1
        
        return newVehiclePage
    }()
    
    var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        let image = UIImage(named: "Plus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(tintedImage, for: .normal)
        addButton.tintColor = Theme.DARK_GRAY
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.borderColor = Theme.DARK_GRAY.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 20
        addButton.addTarget(self, action:#selector(addAVehicleButtonPressed(sender:)), for: .touchUpInside)
        
        return addButton
    }()
    
    var addLabel: UILabel = {
        let addLabel = UILabel()
        addLabel.text = "Add a new Vehicle"
        addLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addLabel.textColor = Theme.DARK_GRAY
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        addLabel.textAlignment = .center
        
        return addLabel
    }()
    
    var currentVehicleImageView: UIImageView = {
        let currentVehicleImageView = UIImageView()
        currentVehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        currentVehicleImageView.contentMode = .scaleAspectFill
        currentVehicleImageView.backgroundColor = UIColor.white
        currentVehicleImageView.clipsToBounds = true
        
        return currentVehicleImageView
    }()
    
    var vehicleInfo: UILabel = {
        let vehicleInfo = UILabel()
        vehicleInfo.text = "Vehicle Info"
        vehicleInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        vehicleInfo.textColor = Theme.DARK_GRAY
        vehicleInfo.translatesAutoresizingMaskIntoConstraints = false
        vehicleInfo.contentMode = .left
        
        return vehicleInfo
    }()
    
    var vehicleLicenseInfo: UILabel = {
        let vehicleLicenseInfo = UILabel()
        vehicleLicenseInfo.text = "License Plate"
        vehicleLicenseInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        vehicleLicenseInfo.textColor = Theme.PRIMARY_DARK_COLOR
        vehicleLicenseInfo.translatesAutoresizingMaskIntoConstraints = false
        vehicleLicenseInfo.contentMode = .left
        
        return vehicleLicenseInfo
    }()
    
    var editingContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.shadowOffset = CGSize(width: 1, height: 1)
        container.layer.shadowOpacity = 0.8
        container.layer.cornerRadius = 10
        container.layer.shadowRadius = 1
        
        return container
    }()
    
    var editingTableView: UITableView = {
        let editing = UITableView()
        editing.translatesAutoresizingMaskIntoConstraints = false
        editing.backgroundColor = UIColor.clear
        editing.isScrollEnabled = false
        
        return editing
    }()
    
    var Edits = ["Delete vehicle"]
    
    func setupVehicleDisplay(vehicleSize: VehicleSize) {
        
        switch vehicleSize {
        case .small:
            
            vehicleInfo.removeFromSuperview()
            vehicleLicenseInfo.removeFromSuperview()
            currentVehicleImageView.removeFromSuperview()
            
            newVehiclePage.addSubview(addButton)
            addButton.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 8).isActive = true
            addButton.bottomAnchor.constraint(equalTo: newVehiclePage.bottomAnchor, constant: -4).isActive = true
            addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            newVehiclePage.addSubview(addLabel)
            addLabel.centerXAnchor.constraint(equalTo: newVehiclePage.centerXAnchor).isActive = true
            addLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
            addLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            addLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
        case .tall:
            
            addButton.removeFromSuperview()
            addLabel.removeFromSuperview()
            
            newVehiclePage.addSubview(vehicleInfo)
            vehicleInfo.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 20).isActive = true
            vehicleInfo.topAnchor.constraint(equalTo: newVehiclePage.topAnchor, constant: 10).isActive = true
            vehicleInfo.widthAnchor.constraint(equalTo: newVehiclePage.widthAnchor, constant: -20).isActive = true
            vehicleInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            newVehiclePage.addSubview(vehicleLicenseInfo)
            vehicleLicenseInfo.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 25).isActive = true
            vehicleLicenseInfo.topAnchor.constraint(equalTo: vehicleInfo.bottomAnchor, constant: 0).isActive = true
            vehicleLicenseInfo.widthAnchor.constraint(equalTo: newVehiclePage.widthAnchor, constant: -20).isActive = true
            vehicleLicenseInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            newVehiclePage.addSubview(currentVehicleImageView)
            currentVehicleImageView.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor).isActive = true
            currentVehicleImageView.topAnchor.constraint(equalTo: vehicleLicenseInfo.bottomAnchor, constant: 20).isActive = true
            currentVehicleImageView.rightAnchor.constraint(equalTo: newVehiclePage.rightAnchor).isActive = true
            currentVehicleImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            
        }
    }
    
    func setupEditing() {
        
        self.view.addSubview(editingContainer)
        editingContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        editingContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        editingContainer.topAnchor.constraint(equalTo: newVehiclePage.bottomAnchor, constant: 10).isActive = true
        editingContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        editingContainer.addSubview(editingTableView)
        editingTableView.leftAnchor.constraint(equalTo: editingContainer.leftAnchor, constant: 5).isActive = true
        editingTableView.rightAnchor.constraint(equalTo: editingContainer.rightAnchor, constant: -5).isActive = true
        editingTableView.topAnchor.constraint(equalTo: editingContainer.topAnchor, constant: 5).isActive = true
        editingTableView.bottomAnchor.constraint(equalTo: editingContainer.bottomAnchor, constant: -5).isActive = true
        
    }
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editingTableView.delegate = self
        self.editingTableView.dataSource = self
        self.view.backgroundColor = Theme.OFF_WHITE
        
        startUpActivity()
        fetchUserAndSetupVehicles()
        
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
        
        newVehiclePage.removeFromSuperview()
        
        self.view.addSubview(newVehiclePage)
        newVehiclePage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        newVehiclePage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        newVehiclePage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
        vehiclePageHeightAnchorSmall = newVehiclePage.heightAnchor.constraint(equalToConstant: 50)
        vehiclePageHeightAnchorTall = newVehiclePage.heightAnchor.constraint(equalToConstant: 360)
    
        if vehicles > 0 {
            vehiclePageHeightAnchorTall.isActive = true
            setupVehicleDisplay(vehicleSize: VehicleSize.tall)
            setupEditing()
        } else {
            vehiclePageHeightAnchorSmall.isActive = true
            setupVehicleDisplay(vehicleSize: VehicleSize.small)
        }
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
                        }
                    }, withCancel: nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1)), execute: {
                self.setupVehicleView()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Edits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Edits[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        
        if indexPath.row == (Edits.count-1) {
            cell.textLabel?.textColor = UIColor.red
        } else {
            cell.textLabel?.textColor = Theme.PRIMARY_DARK_COLOR
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (Edits.count-1) {
            sendAlert(message: "Are you sure you want to permanently delete this vehicle? You need one to purchase parking.", tag: 1)
        }
    }
    
    func sendAlert(message: String, tag: Int) {
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (true) in
            let userId = Auth.auth().currentUser?.uid
            let userRef = Database.database().reference().child("users").child(userId!)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let vehicleID = dictionary["vehicleID"] as? String
                    let vehicleRef = Database.database().reference().child("vehicles").child(vehicleID!)
                    vehicleRef.removeValue()
                    userRef.child("vehicleID").removeValue()
                    userRef.child("vehicleImageURL").removeValue()
                }
                let userVehicleRef = Database.database().reference().child("user-vehicles")
                userVehicleRef.child(userId!).removeValue()
                
                self.newVehiclePage.removeFromSuperview()
                self.editingContainer.removeFromSuperview()
                
                self.fetchUserAndSetupVehicles()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addAVehicleButtonPressed(sender: UIButton) {
        delegate?.setupNewVehicle(vehicleStatus: VehicleStatus.noVehicle)
    }
    
    
}
