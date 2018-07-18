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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.OFF_WHITE

        fetchUserAndSetupParking()
        setupParkingDisplay()
        
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
    func setupParkingDisplay() {
        
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
        currentParkingImageView.topAnchor.constraint(equalTo: parkingDate.bottomAnchor, constant: 300).isActive = true
        currentParkingImageView.rightAnchor.constraint(equalTo: newParkingPage.rightAnchor).isActive = true
        currentParkingImageView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        let line1 = UIView()
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        newParkingPage.addSubview(line1)
        line1.topAnchor.constraint(equalTo: currentParkingImageView.topAnchor, constant: -10).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line1.widthAnchor.constraint(equalTo: newParkingPage.widthAnchor).isActive = true
        line1.centerXAnchor.constraint(equalTo: newParkingPage.centerXAnchor).isActive = true
        
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
        parkingPageHeightAnchorTall = newParkingPage.heightAnchor.constraint(equalToConstant: 700)
        
        if parking > 0 {
            parkingPageHeightAnchorTall.isActive = true
            parkingPageHeightAnchorSmall.isActive = false
            self.addParkingLabel.removeFromSuperview()
            self.addParkingButton.removeFromSuperview()
        } else {
            parkingPageHeightAnchorSmall.isActive = true
            parkingPageHeightAnchorTall.isActive = false
            self.currentParkingImageView.isHidden = true
            self.parkingInfo.isHidden = true
            self.parkingCost.isHidden = true
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
        UIView.animate(withDuration: 0.3) {
            newParkingController.view.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
