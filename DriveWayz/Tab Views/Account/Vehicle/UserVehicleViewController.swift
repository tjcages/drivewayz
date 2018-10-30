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

    enum UserState {
        case current
        case none
    }
    var userState: UserState = UserState.current

    var delegate: handleNewVehicle?
    var vehicles: Int = 0
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter in some basic vehicle information. This information will only be available to hosts that you are currently parking with."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 4
        label.textAlignment = .center
        
        return label
    }()
    
    var newVehiclePage: UIView = {
        let newVehiclePage = UIView()
        newVehiclePage.backgroundColor = UIColor.white
        newVehiclePage.translatesAutoresizingMaskIntoConstraints = false
        newVehiclePage.layer.shadowColor = Theme.DARK_GRAY.cgColor
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
        addButton.alpha = 0
        
        return addButton
    }()
    
    var addLabel: UILabel = {
        let addLabel = UILabel()
        addLabel.text = "Add a new Vehicle"
        addLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addLabel.textColor = Theme.DARK_GRAY
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        addLabel.textAlignment = .center
        addLabel.alpha = 0
        addLabel.isUserInteractionEnabled = true
        
        return addLabel
    }()
    
    var vehicleInfo: UILabel = {
        let vehicleInfo = UILabel()
        vehicleInfo.text = "Vehicle Info"
        vehicleInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        vehicleInfo.textColor = Theme.DARK_GRAY
        vehicleInfo.translatesAutoresizingMaskIntoConstraints = false
        vehicleInfo.contentMode = .left
        vehicleInfo.alpha = 0
        
        return vehicleInfo
    }()
    
    var vehicleLicenseInfo: UILabel = {
        let vehicleLicenseInfo = UILabel()
        vehicleLicenseInfo.text = "License Plate"
        vehicleLicenseInfo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        vehicleLicenseInfo.textColor = Theme.SEA_BLUE
        vehicleLicenseInfo.translatesAutoresizingMaskIntoConstraints = false
        vehicleLicenseInfo.contentMode = .left
        vehicleLicenseInfo.alpha = 0
        
        return vehicleLicenseInfo
    }()
    
    var editingContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 1)
        container.layer.shadowOpacity = 0.8
        container.layer.cornerRadius = 10
        container.layer.shadowRadius = 1
        container.alpha = 0
        
        return container
    }()
    
    var editingTableView: UITableView = {
        let editing = UITableView()
        editing.translatesAutoresizingMaskIntoConstraints = false
        editing.backgroundColor = UIColor.clear
        editing.isScrollEnabled = false
        editing.alpha = 0
        
        return editing
    }()
    
    var Edits = ["Delete vehicle"]
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editingTableView.delegate = self
        self.editingTableView.dataSource = self
        self.view.backgroundColor = UIColor.clear
        
        startUpActivity()
        setupVehicleView()
        fetchUserAndSetupVehicles()
    }
    
    var checkVehicle: Bool = true
    
    func fetchUserAndSetupVehicles() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(uid).child("Vehicle")
        ref.observe(.childAdded) { (snapshot) in
            self.checkVehicle = false
            let userVehicleID = snapshot.value as? String
            if userVehicleID != nil {
                self.vehicles = self.vehicles + 1
            } else { self.vehicles = 0 }
            
            if userVehicleID != nil {
                Database.database().reference().child("vehicles").child(userVehicleID!).observeSingleEvent(of: .value, with: { (snap) in
                    if let dictionary = snap.value as? [String:AnyObject] {
                        let vehicleMake = dictionary["vehicleMake"] as? String
                        let vehicleModel = dictionary["vehicleModel"] as? String
                        let vehicleYear = dictionary["vehicleYear"] as? String
                        let vehicleLicensePlate = dictionary["vehicleLicensePlate"] as? String
                        
                        let text = vehicleYear! + " " + vehicleMake! + " " + vehicleModel!
                        self.vehicleInfo.text = text
                        self.vehicleLicenseInfo.text = vehicleLicensePlate!
                        
                        self.setupCurrentViews(state: .current)
                        self.startActivityIndicatorView.stopAnimating()
                        self.blurSquare.alpha = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.addLabel.alpha = 0
                            self.addButton.alpha = 0
                        }
                        return
                    }
                }, withCancel: nil)
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.setupCurrentViews(state: .none)
            return
        }
        if self.checkVehicle == true {
            self.setupCurrentViews(state: .none)
            self.startActivityIndicatorView.stopAnimating()
            self.blurSquare.alpha = 0
            return
        }
    }
    
    var blurSquare: UIVisualEffectView!
    
    func startUpActivity() {
        
        let blurEffect = UIBlurEffect(style: .light)
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
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(newVehiclePage)
        newVehiclePage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        newVehiclePage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        newVehiclePage.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 10).isActive = true
        vehiclePageHeightAnchorSmall = newVehiclePage.heightAnchor.constraint(equalToConstant: 50)
            vehiclePageHeightAnchorSmall.isActive = false
        vehiclePageHeightAnchorTall = newVehiclePage.heightAnchor.constraint(equalToConstant: 80)
            vehiclePageHeightAnchorTall.isActive = true
        
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addAVehicleButtonTapped(sender:)))
        addLabel.addGestureRecognizer(gesture)
        
        newVehiclePage.addSubview(vehicleInfo)
        vehicleInfo.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 20).isActive = true
        vehicleInfo.topAnchor.constraint(equalTo: newVehiclePage.topAnchor, constant: 10).isActive = true
        vehicleInfo.widthAnchor.constraint(equalTo: newVehiclePage.widthAnchor, constant: -20).isActive = true
        vehicleInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        newVehiclePage.addSubview(vehicleLicenseInfo)
        vehicleLicenseInfo.leftAnchor.constraint(equalTo: newVehiclePage.leftAnchor, constant: 20).isActive = true
        vehicleLicenseInfo.topAnchor.constraint(equalTo: vehicleInfo.bottomAnchor, constant: 0).isActive = true
        vehicleLicenseInfo.widthAnchor.constraint(equalTo: newVehiclePage.widthAnchor, constant: -20).isActive = true
        vehicleLicenseInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
    
    func setupCurrentViews(state: UserState) {
        self.removeViews()
        switch state {
        case .current:
            self.setupCurrent()
        case .none:
            self.setupNoView()
        }
    }
    
    func removeViews() {
        self.addLabel.alpha = 0
        self.addButton.alpha = 0
        self.vehicleInfo.alpha = 0
        self.vehicleLicenseInfo.alpha = 0
        self.editingContainer.alpha = 0
        self.editingTableView.alpha = 0
    }
    
    func setupCurrent() {
        self.informationLabel.text = "Your current vehicle information. This information will only be available to hosts that you are currently parking with."
        UIView.animate(withDuration: 0.3, animations: {
            self.vehiclePageHeightAnchorSmall.isActive = false
            self.vehiclePageHeightAnchorTall.isActive = true
            self.addLabel.alpha = 0
            self.addButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.vehicleInfo.alpha = 1
                self.vehicleLicenseInfo.alpha = 1
                self.editingContainer.alpha = 1
                self.editingTableView.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                //
            }
        }
    }
    
    func setupNoView() {
        self.informationLabel.text = "Please enter in some basic vehicle information. This information will only be available to hosts that you are currently parking with."
        UIView.animate(withDuration: 0.3, animations: {
            self.vehiclePageHeightAnchorSmall.isActive = true
            self.vehiclePageHeightAnchorTall.isActive = false
            self.vehicleInfo.alpha = 0
            self.vehicleLicenseInfo.alpha = 0
            self.editingContainer.alpha = 0
            self.editingTableView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.addLabel.alpha = 1
                self.addButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                
            }
        }
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
            cell.textLabel?.textColor = Theme.HARMONY_RED
        } else {
            cell.textLabel?.textColor = Theme.SEA_BLUE
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
            let vehicleRef = Database.database().reference().child("users").child(userId!).child("Vehicle")
            vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let vehicleID = dictionary["vehicleID"] as? String
                    let vehicle = Database.database().reference().child("vehicles")
                    vehicle.child(vehicleID!).removeValue()
                }
            })
            let userRef = Database.database().reference().child("users").child(userId!)
            userRef.child("vehicleID").removeValue()
            userRef.child("vehicleImageURL").removeValue()
            userRef.child("Vehicle").removeValue()
            let userVehicleRef = Database.database().reference().child("user-vehicles")
            userVehicleRef.child(userId!).removeValue()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addAVehicleButtonPressed(sender: UIButton) {
        self.delegate?.bringNewVehicle()
    }
    
    @objc func addAVehicleButtonTapped(sender: UITapGestureRecognizer) {
        self.delegate?.bringNewVehicle()
    }
    
}
