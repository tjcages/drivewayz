//
//  ExpandedAmenitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedAmenitiesViewController: UIViewController {

    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "AMENITIES"
        
        return label
    }()
    
    var coveredView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "home-1")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE.withAlphaComponent(0.89)
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    var coveredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        label.text = "Covered Parking"
        label.textAlignment = .center
        
        return label
    }()
    
    var chargingView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "home-1")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE.withAlphaComponent(0.9)
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    var chargingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        label.text = "Charging Station"
        label.textAlignment = .center
        
        return label
    }()
    
    var gatedView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "home-1")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE.withAlphaComponent(0.9)
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    var gatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        label.text = "Gated Spot"
        label.textAlignment = .center
        
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.PURPLE.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(residentialLabel)
        residentialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        residentialLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        residentialLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        residentialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(editInformation)
        editInformation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(coveredView)
        coveredView.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 14).isActive = true
        coveredView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        coveredView.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 24 * 4 + 16)/3).isActive = true
        coveredView.heightAnchor.constraint(equalTo: coveredView.widthAnchor).isActive = true
        
        self.view.addSubview(coveredLabel)
        coveredLabel.topAnchor.constraint(equalTo: coveredView.bottomAnchor, constant: 4).isActive = true
        coveredLabel.centerXAnchor.constraint(equalTo: coveredView.centerXAnchor).isActive = true
        coveredLabel.widthAnchor.constraint(equalTo: coveredView.widthAnchor).isActive = true
        coveredLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(chargingView)
        chargingView.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 14).isActive = true
        chargingView.leftAnchor.constraint(equalTo: coveredView.rightAnchor, constant: 12).isActive = true
        chargingView.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 24 * 4 + 16)/3).isActive = true
        chargingView.heightAnchor.constraint(equalTo: coveredView.widthAnchor).isActive = true
        
        self.view.addSubview(chargingLabel)
        chargingLabel.topAnchor.constraint(equalTo: chargingView.bottomAnchor, constant: 4).isActive = true
        chargingLabel.centerXAnchor.constraint(equalTo: chargingView.centerXAnchor).isActive = true
        chargingLabel.widthAnchor.constraint(equalTo: chargingView.widthAnchor).isActive = true
        chargingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(gatedView)
        gatedView.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 14).isActive = true
        gatedView.leftAnchor.constraint(equalTo: chargingView.rightAnchor, constant: 12).isActive = true
        gatedView.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 24 * 4 + 16)/3).isActive = true
        gatedView.heightAnchor.constraint(equalTo: coveredView.widthAnchor).isActive = true
        
        self.view.addSubview(gatedLabel)
        gatedLabel.topAnchor.constraint(equalTo: gatedView.bottomAnchor, constant: 4).isActive = true
        gatedLabel.centerXAnchor.constraint(equalTo: gatedView.centerXAnchor).isActive = true
        gatedLabel.widthAnchor.constraint(equalTo: gatedView.widthAnchor).isActive = true
        gatedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
//        self.view.addSubview(lineView)
//        lineView.topAnchor.constraint(equalTo: coveredView.bottomAnchor, constant: 48).isActive = true
//        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }

}
