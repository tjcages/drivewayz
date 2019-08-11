//
//  HostingOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

class HostingOptionsViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var optionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "OPTIONS"
        
        return label
    }()
    
    var seeAvailability: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit availability", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandAvailabilityButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var seeCalendar: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit calendar", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandCalanderButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var markUnavailable: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Make spot unavailable", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(makeSpotUnavailable), for: .touchUpInside)
        
        return button
    }()
    
    var expandUnavailableButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var addSpot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add a new parking spot", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.3), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(bringNewHostingController), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandSpotButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    var deleteSpot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete parking spot", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(optionsLabel)
        optionsLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        optionsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        optionsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        optionsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(seeAvailability)
        seeAvailability.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 8).isActive = true
        seeAvailability.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        seeAvailability.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        seeAvailability.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandAvailabilityButton)
        expandAvailabilityButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandAvailabilityButton.centerYAnchor.constraint(equalTo: seeAvailability.centerYAnchor).isActive = true
        expandAvailabilityButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandAvailabilityButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(seeCalendar)
        seeCalendar.topAnchor.constraint(equalTo: seeAvailability.bottomAnchor).isActive = true
        seeCalendar.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        seeCalendar.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        seeCalendar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandCalanderButton)
        expandCalanderButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandCalanderButton.centerYAnchor.constraint(equalTo: seeCalendar.centerYAnchor).isActive = true
        expandCalanderButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandCalanderButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(markUnavailable)
        markUnavailable.topAnchor.constraint(equalTo: seeCalendar.bottomAnchor).isActive = true
        markUnavailable.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        markUnavailable.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        markUnavailable.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandUnavailableButton)
        expandUnavailableButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandUnavailableButton.centerYAnchor.constraint(equalTo: markUnavailable.centerYAnchor).isActive = true
        expandUnavailableButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandUnavailableButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(addSpot)
        addSpot.topAnchor.constraint(equalTo: markUnavailable.bottomAnchor).isActive = true
        addSpot.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        addSpot.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        addSpot.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandSpotButton)
        expandSpotButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        expandSpotButton.centerYAnchor.constraint(equalTo: addSpot.centerYAnchor).isActive = true
        expandSpotButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandSpotButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(deleteSpot)
        deleteSpot.topAnchor.constraint(equalTo: addSpot.bottomAnchor).isActive = true
        deleteSpot.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        deleteSpot.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        deleteSpot.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func makeSpotUnavailable() {
        if markUnavailable.titleLabel?.text == "Make spot unavailable" {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                let parkingID = snapshot.key
                let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                let timestamp = Date().timeIntervalSince1970
                parkingRef.updateChildValues(["ParkingUnavailability": timestamp])
                self.markUnavailable.setTitle("Make spot available", for: .normal)
                self.markUnavailable.setTitleColor(Theme.BLUE, for: .normal)
            }
        } else {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                let parkingID = snapshot.key
                let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("ParkingUnavailability")
                parkingRef.removeValue()
                self.markUnavailable.setTitle("Make spot unavailable", for: .normal)
                self.markUnavailable.setTitleColor(Theme.DARK_GRAY, for: .normal)
                
            }
        }
    }
    
    @objc func bringNewHostingController() {
//        self.delegate?.bringNewHostingController()
    }
    
}
