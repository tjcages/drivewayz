//
//  HostingExpandedViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostEditing {
    func resetParking()
}

class HostingExpandedViewController: UIViewController, handleHostEditing {
    
    var delegate: changeExpandedInformation?
    var selectedParking: ParkingSpots?
    var statusBarColor = true
    var height: CGFloat = 0
    
    lazy var expandedImages: ExpandedImageViewController = {
        let controller = ExpandedImageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedInformation: ExpandedInformationViewController = {
        let controller = ExpandedInformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedCost: ExpandedCostViewController = {
        let controller = ExpandedCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    lazy var expandedNumber: ExpandedSpotsViewController = {
        let controller = ExpandedSpotsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedAmenities: ExpandedAmenitiesViewController = {
        let controller = ExpandedAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedOptions: HostingOptionsViewController = {
        let controller = HostingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setData(hosting: ParkingSpots) {
        self.selectedParking = hosting
        expandedInformation.setData(hosting: hosting)
        expandedCost.setData(hosting: hosting)
        expandedNumber.setData(hosting: hosting)
        expandedAmenities.setData(hosting: hosting)
        expandedImages.setData(hosting: hosting)
        setupViews()
    }
    
    var expandedInformationAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(expandedInformation.view)
        expandedInformation.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        expandedInformation.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedInformation.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedInformationAnchor = expandedInformation.view.heightAnchor.constraint(equalToConstant: expandedInformation.height)
            expandedInformationAnchor.isActive = true
        
        self.view.addSubview(expandedCost.view)
        expandedCost.view.topAnchor.constraint(equalTo: expandedInformation.view.bottomAnchor).isActive = true
        expandedCost.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedCost.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedCost.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(expandedNumber.view)
        expandedNumber.view.topAnchor.constraint(equalTo: expandedCost.view.bottomAnchor).isActive = true
        expandedNumber.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedNumber.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedNumber.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(expandedAmenities.view)
        expandedAmenities.view.topAnchor.constraint(equalTo: expandedNumber.view.bottomAnchor).isActive = true
        expandedAmenities.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedAmenities.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedAmenities.view.heightAnchor.constraint(equalToConstant: 215).isActive = true
        
        self.view.addSubview(expandedOptions.view)
        expandedOptions.view.topAnchor.constraint(equalTo: expandedAmenities.view.bottomAnchor, constant: 20).isActive = true
        expandedOptions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        expandedOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        expandedOptions.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        expandedOptions.seeAvailability.addTarget(self, action: #selector(openAvailability), for: .touchUpInside)
        expandedOptions.seeCalendar.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        expandedOptions.deleteSpot.addTarget(self, action: #selector(deleteSpotPressed), for: .touchUpInside)
        expandedInformation.editInformation.addTarget(self, action: #selector(openInformation), for: .touchUpInside)
        expandedCost.editInformation.addTarget(self, action: #selector(openCost), for: .touchUpInside)
        expandedNumber.editInformation.addTarget(self, action: #selector(openSpots), for: .touchUpInside)
        expandedAmenities.editInformation.addTarget(self, action: #selector(openAmenities), for: .touchUpInside)
        
        height = expandedInformation.height + 100 + 200 + 215 + 800
    }
    
    @objc func deleteSpotPressed() {
        let alertController = UIAlertController(title: "Are you sure?", message: "This action cannot be undone. Any earnings in your wallet will be inaccessible.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                let parkingID = snapshot.key
                let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                parkingRef.child("Location").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if let city = dictionary["cityAddress"] as? String {
                            let cityRef = Database.database().reference().child("ParkingLocations").child(city).child(parkingID)
                            cityRef.removeValue()
                            parkingRef.removeValue()
                            ref.removeValue()
                            self.navigationController?.popViewController(animated: true)
                            self.delegate?.backButtonPressed()
                            self.dismiss(animated: true, completion: {
                                
                            })
                        }
                    }
                })
            }
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetParking() {
        self.delegate?.resetParking()
    }
    
}

extension HostingExpandedViewController {
    
    @objc func openAvailability() {
        let controller = EditAvailabilityViewController()
        controller.delegate = self
        if let hosting = self.selectedParking {
            controller.setData(parking: hosting)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func openCalendar() {
        let controller = EditCalendarViewController()
        controller.delegate = self
        controller.setupPreviousAvailability()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func openInformation() {
        let controller = EditInformationViewController()
        controller.delegate = self
        if let hosting = self.selectedParking {
            controller.setData(parking: hosting)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func openCost() {
        let controller = EditCostViewController()
        controller.delegate = self
        if let hosting = self.selectedParking {
            controller.setData(parking: hosting)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func openSpots() {
        let controller = EditSpotsViewController()
        controller.delegate = self
        if let hosting = self.selectedParking {
            controller.setData(parking: hosting)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func openAmenities() {
        let controller = EditAmenitiesViewController()
        controller.delegate = self
        if let hosting = self.selectedParking {
            controller.setData(parking: hosting)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
