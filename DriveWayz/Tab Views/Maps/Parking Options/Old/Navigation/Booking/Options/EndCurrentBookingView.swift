//
//  EndCurrentBookingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EndCurrentBookingView: UIViewController {
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "checkCircleIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var iconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap here to end booking"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Confirm you have moved your vehicle"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DarkRed
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(askToEndReservation))
        view.addGestureRecognizer(tap)

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(iconView)
        view.addSubview(iconButton)
        iconButton.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 32, height: 32)
        iconButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1.5).isActive = true
        
        iconView.anchor(top: iconButton.topAnchor, left: iconButton.leftAnchor, bottom: iconButton.bottomAnchor, right: view.rightAnchor, paddingTop: -8, paddingLeft: -12, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        
        view.addSubview(bottomView)
        bottomView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 3)
        
    }
    
    @objc func askToEndReservation() {
        let alertController = UIAlertController(title: "Are you sure?", message: "You are confirming that your vehicle has been removed from the parking space.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            self.endReservation()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func endReservation() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            ref.child("CurrentBooking").observeSingleEvent(of: .childAdded) { (snapshot) in
                let key = snapshot.key
                let bookingRef = Database.database().reference().child("UserBookings").child(key)
                bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        if let parkingID = dictionary["parkingID"] as? String {
                            let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                            parkingRef.child("CurrentBooking").removeValue()
                            ref.child("CurrentBooking").removeValue()
                            timerStarted = false
                            if bookingTimer != nil {
                                bookingTimer!.invalidate()
                            }
                        }
                    }
                })
            }
        }
    }

}
