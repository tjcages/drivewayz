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
    
    var delegate: handleNewHosting?
    var hostDelegate: handleHostEditing?

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var optionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Options"
        
        return label
    }()
    
    var seeAvailability: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit availability", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(editAvailabilityPressed), for: .touchUpInside)
//        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.2).cgColor
//        button.layer.borderWidth = 0.5
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
        button.addTarget(self, action: #selector(editAvailabilityPressed), for: .touchUpInside)
        
        return button
    }()
    
    var lineView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var markUnavailable: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Make spot unavailable", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
//        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.2).cgColor
//        button.layer.borderWidth = 0.5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandUnavailableButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(editAvailabilityPressed), for: .touchUpInside)//////
        
        return button
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var addSpot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add a new parking spot", for: .normal)
        button.setTitleColor(Theme.BLACK.withAlphaComponent(0.3), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(bringNewHostingController), for: .touchUpInside)
//        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.2).cgColor
//        button.layer.borderWidth = 0.5
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
//        button.addTarget(self, action: #selector(editAvailabilityPressed), for: .touchUpInside)/////////
        
        return button
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var deleteSpot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete parking spot", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
//        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.2).cgColor
//        button.layer.borderWidth = 0.5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandDeleteButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(editAvailabilityPressed), for: .touchUpInside)//////
        
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
        expandAvailabilityButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandAvailabilityButton.centerYAnchor.constraint(equalTo: seeAvailability.centerYAnchor).isActive = true
        expandAvailabilityButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandAvailabilityButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        container.addSubview(lineView1)
//        lineView1.topAnchor.constraint(equalTo: seeAvailability.bottomAnchor).isActive = true
//        lineView1.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
//        lineView1.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
//        lineView1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(markUnavailable)
        markUnavailable.topAnchor.constraint(equalTo: seeAvailability.bottomAnchor).isActive = true
        markUnavailable.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        markUnavailable.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        markUnavailable.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandUnavailableButton)
        expandUnavailableButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandUnavailableButton.centerYAnchor.constraint(equalTo: markUnavailable.centerYAnchor).isActive = true
        expandUnavailableButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandUnavailableButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        container.addSubview(lineView2)
//        lineView2.topAnchor.constraint(equalTo: markUnavailable.bottomAnchor).isActive = true
//        lineView2.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
//        lineView2.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
//        lineView2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(addSpot)
        addSpot.topAnchor.constraint(equalTo: markUnavailable.bottomAnchor).isActive = true
        addSpot.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        addSpot.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        addSpot.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandSpotButton)
        expandSpotButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandSpotButton.centerYAnchor.constraint(equalTo: addSpot.centerYAnchor).isActive = true
        expandSpotButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandSpotButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        container.addSubview(lineView4)
//        lineView4.topAnchor.constraint(equalTo: addSpot.bottomAnchor).isActive = true
//        lineView4.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
//        lineView4.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
//        lineView4.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(deleteSpot)
        deleteSpot.topAnchor.constraint(equalTo: addSpot.bottomAnchor).isActive = true
        deleteSpot.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        deleteSpot.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        deleteSpot.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandDeleteButton)
        expandDeleteButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandDeleteButton.centerYAnchor.constraint(equalTo: deleteSpot.centerYAnchor).isActive = true
        expandDeleteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandDeleteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    @objc func editAvailabilityPressed() {
//        self.hostDelegate?.setupEditingCalendar()
    }
    
    @objc func makeSpotUnavailable() {
        if markUnavailable.titleLabel?.text == "Make spot unavailable" {
            let ref = Database.database().reference().child("ParkingUnavailability")
//            ref.updateChildValues([""])
        }
    }
    
    @objc func bringNewHostingController() {
//        self.delegate?.bringNewHostingController()
    }
    
}
