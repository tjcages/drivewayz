//
//  CurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

var checkPreviousUser: Bool = true

class CurrentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum UserState {
        case previous
        case current
        case none
    }
    var userState: UserState = UserState.current
    var delegate: handleCurrentParking?
    
    var current: UIView = {
        let current = UIView()
        current.translatesAutoresizingMaskIntoConstraints = false
        current.layer.cornerRadius = 15
        current.alpha = 0
        current.layer.shadowColor = Theme.DARK_GRAY.cgColor
        current.layer.shadowOffset = CGSize(width: 0, height: 1)
        current.layer.shadowRadius = 1
        current.layer.shadowOpacity = 0.8
        
        return current
    }()
    
    var alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Current"
        label.textColor = Theme.WHITE
        label.textAlignment = .right
        label.alpha = 0
        label.font = Fonts.SSPSemiBoldH5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var mark: UIImageView = {
        let mark = UIImageView()
        mark.image = UIImage(named: "Mark")
        mark.image = mark.image!.withRenderingMode(.alwaysTemplate)
        mark.tintColor = Theme.WHITE
        mark.alpha = 0
        mark.translatesAutoresizingMaskIntoConstraints = false
        
        return mark
    }()
    
    var currentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.8
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 1
        
        return view
    }()
    
    var userName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.SEA_BLUE
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userVehicleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userLicenseLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var fromToLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.PACIFIC_BLUE
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.SEA_BLUE
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userLabel: UILabel = {
        let label = UILabel()
        label.text = "User:"
        label.font = Fonts.SSPRegularH6
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var vehicleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vehicle:"
        label.font = Fonts.SSPRegularH6
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var licenseLabel: UILabel = {
        let label = UILabel()
        label.text = "License plate:"
        label.font = Fonts.SSPRegularH6
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Payed:"
        label.font = Fonts.SSPRegularH6
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var editingTableView: UITableView = {
        let editing = UITableView()
        editing.translatesAutoresizingMaskIntoConstraints = false
        editing.backgroundColor = UIColor.clear
        editing.isScrollEnabled = false
//        editing.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.5).cgColor
//        editing.layer.borderWidth = 0.5
//        editing.layer.cornerRadius = 10
        editing.alpha = 0
        
        return editing
    }()
    
    var noCurrentLabel: UILabel = {
        let label = UILabel()
        label.text = "There are no people currently parked in your spot."
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        line.alpha = 0
        return line
    }()
    
    var line2: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        line.alpha = 0
        return line
    }()
    
    var Edits: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear

        editingTableView.delegate = self
        editingTableView.dataSource = self

        setupViews()
        getParkingInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getParkingInfo() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("Parking")
        ref.observe(.childAdded) { (snapshot) in
            if let parking = snapshot.value as? String {
                self.observeCurrent(parkingID: parking)
            }
        }
    }
    
    func observeCurrent(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID).child("Current")
        ref.observe(.childAdded, with: { (snapshot) in
            if let available = snapshot.value as? String {
                if available == "Unavailable" {
                    self.setupCurrentViews(state: .none)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.setupNoView()
                    }
                    return
                } else {
                    checkPreviousUser = false
                    let user = snapshot.value as? String
                    self.setData(newUser: user!)
                    self.setupCurrentViews(state: .current)
                }
            } else {
                checkPreviousUser = false
                let user = snapshot.value as? String
                self.setData(newUser: user!)
                self.setupCurrentViews(state: .current)
            }
        }, withCancel: nil)
        ref.observe(.childRemoved) { (snapshot) in
            self.setupCurrentViews(state: .previous)
        }
        if checkPreviousUser == true {
            let previousRef = Database.database().reference().child("parking").child(parkingID)
            previousRef.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let current = dictionary["Current"] as? [String:AnyObject] {
                        if current["Unavailable"] != nil {
                            self.setupCurrentViews(state: .none)
                            return
                        }
                    } else {
                        if let previousUser = dictionary["previousUser"] as? String {
                            self.setData(newUser: previousUser)
                            self.setupCurrentViews(state: .previous)
                        } else {
                            self.setupCurrentViews(state: .none)
                        }
                        if let previousCost = dictionary["previousCost"] as? Int {
                            let doublePay: String = String(format: "%.2f", Double(previousCost))
                            self.userPaymentLabel.text = "$\(doublePay)"
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func setData(newUser: String) {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("Parking")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let parkingID = dictionary["parkingID"] as? String {
                    let userRef = Database.database().reference().child("users").child(newUser)
                    userRef.observeSingleEvent(of: .value, with: { (last) in
                        if let info = last.value as? [String:AnyObject] {
                            let name = info["name"] as? String
                            var fullName = name?.split(separator: " ")
                            let firstName: String = String(fullName![0])
                            self.userName.text = firstName
                            let currentRef = userRef.child("currentParking").child(parkingID)
                            currentRef.observeSingleEvent(of: .value, with: { (current) in
                                if let currentDict = current.value as? [String:AnyObject] {
                                    let cost = currentDict["cost"] as? Double
                                    let formattedCost = String(format: "%.2f", cost!)
                                    self.userPaymentLabel.text = "$\(formattedCost)"
                                    let hours = currentDict["hours"] as? Int
                                    let seconds = Double(hours! * 3600)
                                    let timestamp = currentDict["timestamp"] as? Double
                                    
                                    let myTimeInterval = TimeInterval(timestamp!)
                                    let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                                    let formatter = DateFormatter()
                                    formatter.timeZone = TimeZone.current
                                    formatter.dateFormat = "h:mm"
                                    let dateString = formatter.string(from: time as Date)
                                    
                                    let endTimeInterval = TimeInterval((timestamp! + seconds))
                                    let endTime = NSDate(timeIntervalSince1970: TimeInterval(endTimeInterval))
                                    let endFormatter = DateFormatter()
                                    endFormatter.timeZone = TimeZone.current
                                    endFormatter.dateFormat = "HH:mm"
                                    let endDateString = endFormatter.string(from: endTime as Date)
                                    
                                    self.fromToLabel.text = "From \(dateString) to \(endDateString)"
                                }
                            })
                            if let vehicleDictionary = info["Vehicle"] as? [String:AnyObject] {
                                let vehicleID = vehicleDictionary["vehicleID"] as? String
                                let vehicleRef = Database.database().reference().child("vehicles").child(vehicleID!)
                                vehicleRef.observeSingleEvent(of: .value, with: { (vehicles) in
                                    if let vehicle = vehicles.value as? [String:AnyObject] {
                                        let vehicleYear = vehicle["vehicleYear"] as! String
                                        let vehicleMake = vehicle["vehicleMake"] as! String
                                        let vehicleModel = vehicle["vehicleModel"] as! String
                                        let vehicleColor = vehicle["vehicleColor"] as! String
                                        let vehicleLicense = vehicle["vehicleLicensePlate"] as? String
                                        let vehicleInformation = "\(vehicleColor) \(vehicleYear) \(vehicleMake) \(vehicleModel)"
                                        self.userVehicleLabel.text = vehicleInformation
                                        self.userLicenseLabel.text = vehicleLicense
                                    }
                                })
                            }
                            self.Edits = ["Vehicle left", "Not the correct vehicle", "Message \(firstName)", "Report \(firstName)"]
                            self.editingTableView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    func setupCurrentViews(state: UserState) {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
        switch state {
        case .current:
            self.setupCurrent()
            self.delegate?.changeCurrentView(height: 475)
        case .previous:
            self.setupPreviousViews()
            self.delegate?.changeCurrentView(height: 275)
        case .none:
            self.setupNoView()
            self.delegate?.changeCurrentView(height: 100)
        }
    }
    
    var containerHeight: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    var alertInsetAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(current)
        current.backgroundColor = Theme.PACIFIC_BLUE
        current.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        current.heightAnchor.constraint(equalToConstant: 30).isActive = true
        current.widthAnchor.constraint(equalToConstant: 100).isActive = true
        current.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        current.addSubview(alertLabel)
        alertInsetAnchor = alertLabel.centerXAnchor.constraint(equalTo: current.centerXAnchor, constant: -10)
            alertInsetAnchor.isActive = true
        alertLabel.centerYAnchor.constraint(equalTo: current.centerYAnchor).isActive = true
        alertLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        alertLabel.widthAnchor.constraint(equalTo: current.widthAnchor, constant: -10).isActive = true
        
        current.addSubview(mark)
        mark.leftAnchor.constraint(equalTo: current.leftAnchor, constant: 5).isActive = true
        mark.centerYAnchor.constraint(equalTo: current.centerYAnchor).isActive = true
        mark.heightAnchor.constraint(equalToConstant: 20).isActive = true
        mark.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(currentContainer)
        containerTopAnchor = currentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
            containerTopAnchor.isActive = true
        currentContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        currentContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        containerHeight = currentContainer.heightAnchor.constraint(equalToConstant: 405)
            containerHeight.isActive = true
        
        currentContainer.addSubview(noCurrentLabel)
        noCurrentLabel.centerXAnchor.constraint(equalTo: currentContainer.centerXAnchor).isActive = true
        noCurrentLabel.centerYAnchor.constraint(equalTo: currentContainer.centerYAnchor).isActive = true
        noCurrentLabel.widthAnchor.constraint(equalTo: currentContainer.widthAnchor).isActive = true
        noCurrentLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        currentContainer.addSubview(userLabel)
        userLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        userLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        userLabel.topAnchor.constraint(equalTo: currentContainer.topAnchor, constant: 5).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(vehicleLabel)
        vehicleLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        vehicleLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        vehicleLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5).isActive = true
        vehicleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(licenseLabel)
        licenseLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        licenseLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        licenseLabel.topAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: 5).isActive = true
        licenseLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(line)
        line.centerYAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 17.5).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.widthAnchor.constraint(equalTo: currentContainer.widthAnchor, constant: -40).isActive = true
        line.centerXAnchor.constraint(equalTo: currentContainer.centerXAnchor).isActive = true
        
        currentContainer.addSubview(paymentLabel)
        paymentLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        paymentLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        paymentLabel.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 60).isActive = true
        paymentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(line2)
        line2.centerYAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 17.5).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line2.widthAnchor.constraint(equalTo: currentContainer.widthAnchor, constant: -40).isActive = true
        line2.centerXAnchor.constraint(equalTo: currentContainer.centerXAnchor).isActive = true
        
        currentContainer.addSubview(userName)
        userName.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        userName.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        userName.centerYAnchor.constraint(equalTo: userLabel.centerYAnchor).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(userVehicleLabel)
        userVehicleLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        userVehicleLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        userVehicleLabel.centerYAnchor.constraint(equalTo: vehicleLabel.centerYAnchor).isActive = true
        userVehicleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(userLicenseLabel)
        userLicenseLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        userLicenseLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        userLicenseLabel.centerYAnchor.constraint(equalTo: licenseLabel.centerYAnchor).isActive = true
        userLicenseLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(fromToLabel)
        fromToLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        fromToLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        fromToLabel.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 35).isActive = true
        fromToLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(userPaymentLabel)
        userPaymentLabel.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 20).isActive = true
        userPaymentLabel.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        userPaymentLabel.centerYAnchor.constraint(equalTo: paymentLabel.centerYAnchor).isActive = true
        userPaymentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentContainer.addSubview(editingTableView)
        editingTableView.leftAnchor.constraint(equalTo: currentContainer.leftAnchor, constant: 10).isActive = true
        editingTableView.rightAnchor.constraint(equalTo: currentContainer.rightAnchor, constant: -20).isActive = true
        editingTableView.topAnchor.constraint(equalTo: line2.bottomAnchor, constant: 17.5).isActive = true
        editingTableView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
    }
    
    func setupPreviousViews() {
        UIView.animate(withDuration: 0.3, animations: {
            self.current.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            self.current.alpha = 1
            self.alertLabel.alpha = 1
            self.editingTableView.alpha = 0
            self.line.alpha = 1
            self.line2.alpha = 0
            self.noCurrentLabel.alpha = 0
            self.mark.alpha = 0
            self.alertLabel.text = "Previous"
            self.containerTopAnchor.constant = 80
            self.userLabel.alpha = 1
            self.vehicleLabel.alpha = 1
            self.licenseLabel.alpha = 1
            self.paymentLabel.alpha = 1
            self.editingTableView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.containerTopAnchor.constant = 80
                self.containerHeight.constant = 205
                self.alertLabel.textAlignment = .center
                self.alertInsetAnchor.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setupCurrent() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerTopAnchor.constant = 80
            self.containerHeight.constant = 405
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.current.backgroundColor = Theme.PACIFIC_BLUE
                self.current.alpha = 1
                self.alertLabel.alpha = 1
                self.editingTableView.alpha = 1
                self.line.alpha = 1
                self.line2.alpha = 1
                self.noCurrentLabel.alpha = 0
                self.mark.alpha = 1
                self.userLabel.alpha = 1
                self.vehicleLabel.alpha = 1
                self.licenseLabel.alpha = 1
                self.paymentLabel.alpha = 1
                self.editingTableView.alpha = 1
                self.alertLabel.text = "Current"
                self.alertLabel.textAlignment = .right
                self.alertInsetAnchor.constant = -10
                self.containerHeight.constant = 405
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setupNoView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.userLabel.alpha = 0
            self.vehicleLabel.alpha = 0
            self.licenseLabel.alpha = 0
            self.paymentLabel.alpha = 0
            self.editingTableView.alpha = 0
            self.line.alpha = 0
            self.line2.alpha = 0
            self.current.alpha = 0
            self.alertLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.containerHeight.constant = 80
                self.current.alpha = 0
                self.containerTopAnchor.constant = 40
                self.noCurrentLabel.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Edits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Edits[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .left
//        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 160)
        
        if indexPath.row == (Edits.count-1) {
            cell.textLabel?.textColor = Theme.HARMONY_RED
        } else {
            cell.textLabel?.textColor = Theme.DARK_GRAY
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
