//
//  UserParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class UserParkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parkingDelegate: controlsNewParking?
    var viewDelegate: controlsAccountViews?
    
    var newParkingPage: UIView = {
        let newParkingPage = UIView()
        newParkingPage.backgroundColor = UIColor.white
        newParkingPage.translatesAutoresizingMaskIntoConstraints = false
        newParkingPage.layer.shadowColor = UIColor.darkGray.cgColor
        newParkingPage.layer.shadowOffset = CGSize(width: 1, height: 1)
        newParkingPage.layer.shadowOpacity = 0.8
        newParkingPage.layer.cornerRadius = 10
        newParkingPage.layer.shadowRadius = 1
        
        return newParkingPage
    }()
    
    var addParkingButton: UIButton = {
        let addParkingButton = UIButton(type: .custom)
        let image = UIImage(named: "Plus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        addParkingButton.setImage(tintedImage, for: .normal)
        addParkingButton.tintColor = Theme.DARK_GRAY
        addParkingButton.translatesAutoresizingMaskIntoConstraints = false
        addParkingButton.layer.borderColor = Theme.DARK_GRAY.cgColor
        addParkingButton.layer.borderWidth = 1
        addParkingButton.layer.cornerRadius = 20
        addParkingButton.addTarget(self, action:#selector(addAParkingButtonPressed(sender:)), for: .touchUpInside)
        
        return addParkingButton
    }()
    
    var addParkingLabel: UILabel = {
        let addParkingLabel = UILabel()
        addParkingLabel.text = "Add a new Parking Spot"
        addParkingLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addParkingLabel.textColor = Theme.DARK_GRAY
        addParkingLabel.translatesAutoresizingMaskIntoConstraints = false
        addParkingLabel.textAlignment = .center
        
        return addParkingLabel
    }()
    
    var currentParkingImageView: UIImageView = {
        let currentParkingImageView = UIImageView()
        currentParkingImageView.translatesAutoresizingMaskIntoConstraints = false
        currentParkingImageView.contentMode = .scaleAspectFill
        currentParkingImageView.backgroundColor = UIColor.white
        currentParkingImageView.clipsToBounds = true
        
        return currentParkingImageView
    }()
    
    var parkingInfo: UITextView = {
        let label = UITextView()
        label.text = "Parking Info"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var parkingCost: UITextField = {
        let label = UITextField()
        label.text = "Cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var parkingDate: UITextField = {
        let label = UITextField()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.isUserInteractionEnabled = false
        
        return label
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
    
    var Edits = ["Make unavailable", "Edit hourly cost", "Edit availability", "Retake picture", "Delete host spot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.OFF_WHITE
        editingTableView.delegate = self
        editingTableView.dataSource = self

        fetchUserAndSetupParking()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
    func setupNoParkingDisplay() {
        
        newParkingPage.addSubview(addParkingButton)
        addParkingButton.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 8).isActive = true
        addParkingButton.bottomAnchor.constraint(equalTo: newParkingPage.bottomAnchor, constant: -4).isActive = true
        addParkingButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addParkingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        newParkingPage.addSubview(addParkingLabel)
        addParkingLabel.centerXAnchor.constraint(equalTo: newParkingPage.centerXAnchor).isActive = true
        addParkingLabel.centerYAnchor.constraint(equalTo: addParkingButton.centerYAnchor).isActive = true
        addParkingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addParkingLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    func setupParkingDisplay() {
        
        newParkingPage.addSubview(parkingInfo)
        parkingInfo.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 15).isActive = true
        parkingInfo.topAnchor.constraint(equalTo: newParkingPage.topAnchor, constant: 0).isActive = true
        parkingInfo.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor, constant: -40).isActive = true
        parkingInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        newParkingPage.addSubview(parkingCost)
        parkingCost.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 25).isActive = true
        parkingCost.topAnchor.constraint(equalTo: parkingInfo.bottomAnchor, constant: 5).isActive = true
        parkingCost.widthAnchor.constraint(equalToConstant: 100).isActive = true
        parkingCost.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        newParkingPage.addSubview(parkingDate)
        parkingDate.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor, constant: 25).isActive = true
        parkingDate.topAnchor.constraint(equalTo: parkingCost.bottomAnchor, constant: 5).isActive = true
        parkingDate.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor, constant: -20).isActive = true
        parkingDate.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        newParkingPage.addSubview(line)
        line.topAnchor.constraint(equalTo: parkingDate.bottomAnchor, constant: 5).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: newParkingPage.centerXAnchor).isActive = true
        
        newParkingPage.addSubview(currentParkingImageView)
        currentParkingImageView.leftAnchor.constraint(equalTo: newParkingPage.leftAnchor).isActive = true
        currentParkingImageView.topAnchor.constraint(equalTo: parkingDate.bottomAnchor, constant: 290).isActive = true
        currentParkingImageView.rightAnchor.constraint(equalTo: newParkingPage.rightAnchor).isActive = true
        currentParkingImageView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
    }
    
    func setupEditing() {
        
        self.view.addSubview(editingContainer)
        editingContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        editingContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        editingContainer.topAnchor.constraint(equalTo: newParkingPage.bottomAnchor, constant: 10).isActive = true
        editingContainer.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        editingContainer.addSubview(editingTableView)
        editingTableView.leftAnchor.constraint(equalTo: editingContainer.leftAnchor, constant: 5).isActive = true
        editingTableView.rightAnchor.constraint(equalTo: editingContainer.rightAnchor, constant: -5).isActive = true
        editingTableView.topAnchor.constraint(equalTo: editingContainer.topAnchor, constant: 5).isActive = true
        editingTableView.bottomAnchor.constraint(equalTo: editingContainer.bottomAnchor, constant: -5).isActive = true
        
    }

    var parkingPageHeightAnchorSmall: NSLayoutConstraint!
    var parkingPageHeightAnchorTall: NSLayoutConstraint!
    
    func setupParkingView() {
        
        self.view.addSubview(newParkingPage)
        self.view.sendSubview(toBack: newParkingPage)
        
        newParkingPage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        newParkingPage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        newParkingPage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingPageHeightAnchorSmall = newParkingPage.heightAnchor.constraint(equalToConstant: 50)
        parkingPageHeightAnchorTall = newParkingPage.heightAnchor.constraint(equalToConstant: 680)
        
        if parking > 0 {
            parkingPageHeightAnchorTall.isActive = true
            parkingPageHeightAnchorSmall.isActive = false
            setupParkingDisplay()
            setupEditing()
            self.viewDelegate?.setupParkingViewControllers(parkingStatus: ParkingStatus.yesParking)
        } else {
            parkingPageHeightAnchorSmall.isActive = true
            parkingPageHeightAnchorTall.isActive = false
            setupNoParkingDisplay()
            self.viewDelegate?.setupParkingViewControllers(parkingStatus: ParkingStatus.noParking)
        }
        
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
                            let parkingCost = dictionary["parkingCost"] as? String
                            let timestamp = dictionary["timestamp"] as? TimeInterval
                            
                            if parkingImageURL == nil {
                                self.currentParkingImageView.image = UIImage(named: "profileprofile")
                            } else {
                                self.currentParkingImageView.loadImageUsingCacheWithUrlString(parkingImageURL!)
                            }
                            
                            self.parkingInfo.text = parkingAddress!
                            self.parkingCost.text = parkingCost!
                            
                            let date = Date(timeIntervalSince1970: timestamp!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale.current
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            let stringDate = dateFormatter.string(from: date)
                            
                            self.parkingDate.text = "Hosting since:  \(stringDate)"
                        }
                    }, withCancel: nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1)), execute: {
                self.setupParkingView()
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
        parkingDelegate?.setupNewParking(parkingImage: ParkingImage.noImage)
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
            sendAlert(message: "Are you sure you want to permanently delete your spot? You will lose all untransfered funds.", tag: 1)
        } else if indexPath.row == (Edits.count-2) {
            sendAlert(message: "Are you sure you want to retake your spot's picture? This picture will be available to all users.", tag: 2)
        } else if indexPath.row == (Edits.count-3) {
            sendAlert(message: "Are you sure you want to change your spot's availibility? This will take place immediately.", tag: 3)
        } else if indexPath.row == (Edits.count-4) {
            sendAlert(message: "Are you sure you want to change the cost per hour of your spot? This will only take place if the spot is vacated.", tag: 4)
        } else if indexPath.row == (Edits.count-5) {
            sendAlert(message: "Are you sure you'd like to make your spot unavailable for a while? You will need to manually set it back to available.", tag: 5)
        }
    }
    
    func sendAlert(message: String, tag: Int) {
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (true) in
            let userId = Auth.auth().currentUser?.uid
            let userRef = Database.database().reference().child("users").child(userId!)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let parkingID = dictionary["parkingID"] as? String
                    let userParkingRef = Database.database().reference().child("user-parking").child(parkingID!)
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    
                    if tag == 1 {
                        userRef.child("parkingID").removeValue()
                        userRef.child("parkingImageURL").removeValue()
                        userRef.child("payments").removeValue()
                        userRef.child("userFunds").removeValue()
                        userRef.child("hostHours").removeValue()
                        userParkingRef.removeValue()
                        parkingRef.removeValue()
                        parking = 0
                        self.newParkingPage.removeFromSuperview()
                        self.editingContainer.removeFromSuperview()
                        self.parkingInfo.removeFromSuperview()
                        self.parkingCost.removeFromSuperview()
                        self.parkingDate.removeFromSuperview()
                        self.currentParkingImageView.removeFromSuperview()
                        self.setupParkingView()
                        self.view.layoutIfNeeded()
                        
                    } else if tag == 2 {
                        
                    } else if tag == 3 {
                        
                    } else if tag == 4 {
                        
                    } else if tag == 5 {
                        
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
