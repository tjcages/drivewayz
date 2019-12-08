//
//  DeleteListingHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DeleteListingHelpView: UIViewController {

    var delegate: HelpMenuDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 2.5
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Delete listing"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 40
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        
        return view
    }()

    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "945 Diamond Street"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subSpotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2-Car Residential"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Are you sure you want to delete this listing? All information will be removed permanently."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 4
        
        return label
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change availability settings", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
        
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.HARMONY_RED
        button.setTitle("Delete Listing", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        setupListing()
        setupContainer()
    }
    
    var panBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(mainButton)
        panBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            panBottomAnchor.isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    func setupListing() {
        
        view.addSubview(settingsButton)
        view.addSubview(informationLabel)
        
        settingsButton.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        settingsButton.sizeToFit()
        
        informationLabel.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -20).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: settingsButton.leftAnchor).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(spotIcon)
        view.addSubview(spotLabel)
        view.addSubview(subSpotLabel)
        
        spotIcon.anchor(top: nil, left: view.leftAnchor, bottom: informationLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 64, height: 64)
        
        spotLabel.bottomAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: 4).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 16).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        spotLabel.sizeToFit()
        
        subSpotLabel.topAnchor.constraint(equalTo: spotLabel.bottomAnchor, constant: 0).isActive = true
        subSpotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 16).isActive = true
        subSpotLabel.sizeToFit()
        
    }
    
    func setupContainer() {
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: spotIcon.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
    }
    
    @objc func mainButtonPressed() {
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
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                }
            })
        }
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.panBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.panBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.panBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
