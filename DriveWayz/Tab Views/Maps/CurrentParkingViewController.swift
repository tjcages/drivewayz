//
//  CurrentParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/13/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class CurrentParkingViewController: UIViewController, UIScrollViewDelegate {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    var parkingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        
        return imageView
    }()
    
    var parkingAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.textAlignment = .center
        
        return label
    }()
    
    var complete: UIButton = {
        let complete = UIButton()
        complete.translatesAutoresizingMaskIntoConstraints = false
        complete.setTitle("Leave parking spot", for: .normal)
        complete.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        complete.backgroundColor = UIColor.clear
        complete.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        complete.layer.borderWidth = 1
        complete.layer.cornerRadius = 10
        complete.addTarget(self, action: #selector(endParking(sender:)), for: .touchUpInside)
        
        return complete
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.DARK_GRAY
        self.scrollView.delegate = self

        setupViews()
        checkCurrentParking()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor, constant: 40).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -40).isActive = true
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        scrollView.addSubview(parkingImage)
        parkingImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        parkingImage.centerXAnchor.constraint(lessThanOrEqualTo: scrollView.centerXAnchor).isActive = true
        parkingImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        parkingImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        scrollView.addSubview(parkingAddress)
        parkingAddress.topAnchor.constraint(equalTo: parkingImage.bottomAnchor, constant: 5).isActive = true
        parkingAddress.centerXAnchor.constraint(equalTo: parkingImage.centerXAnchor).isActive = true
        parkingAddress.widthAnchor.constraint(equalTo: parkingImage.widthAnchor).isActive = true
        parkingAddress.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(complete)
        complete.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        complete.bottomAnchor.constraint(equalTo: parkingAddress.bottomAnchor, constant: 20).isActive = true
        complete.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80).isActive = true
        complete.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func checkCurrentParking() {
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let parkingID = dictionary["parkingID"] as? String
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    parkingRef.observeSingleEvent(of: .value, with: { (pull) in
                        if let pullRef = pull.value as? [String:AnyObject] {
                            let address = pullRef["parkingAddress"] as? String
                            let parkingImageURL = pullRef["parkingImageURL"] as? String
                            
                            if address != "" {
                                self.parkingAddress.text = address
                            }
                            if parkingImageURL == "" {
                                self.parkingImage.image = UIImage(named: "profileprofile")
                            } else {
                                self.parkingImage.loadImageUsingCacheWithUrlString(parkingImageURL!)
                            }
                            
                        }
                    })
                }
            }, withCancel: nil)
            currentRef.observe(.childRemoved, with: { (snapshot) in
                //delete
            }, withCancel: nil)
        } else {
            return
        }
    }
    
    func startCountdown(hours: Int) {
        let seconds: Double = Double(hours * 3600)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            self.endParkingFunc()
        })
    }
    
    @objc func endParking(sender: UIButton) {
        endParkingFunc()
    }
    
    func endParkingFunc() {
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(currentUser!).child("currentParking")
        ref.removeValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
