//
//  ExpandedSpotsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedSpotsViewController: UIViewController {
    
    var canShowGate: Bool = false

    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "NUMBER OF SPOTS"
        
        return label
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "1"
        label.font = Fonts.SSPRegularH0
        label.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        label.clipsToBounds = true
        
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var spotNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "SPOT NUMBER"
        
        return label
    }()
    
    var spotNumberValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.text = "1234"
        label.textAlignment = .right
        
        return label
    }()
    
    var numberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var gateCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "GATE CODE"
        
        return label
    }()
    
    var gateCodeValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.text = "N/A"
        label.textAlignment = .right
        
        return label
    }()
    
    var gateLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    var gateBlock: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 2
        view.alpha = 0
        
        return view
    }()
    
    var viewIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "eyeIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setData(hosting: ParkingSpots) {
        if let numberSpots = hosting.numberSpots {
            self.numberLabel.text = numberSpots
        }
        if let spotNumber = hosting.parkingNumber, spotNumber != "" {
            self.spotNumberValue.text = "\(spotNumber)"
        } else {
            self.spotNumberValue.text = "N/A"
        }
        if let gateNumber = hosting.gateNumber, gateNumber != "" {
            self.gateCodeValue.text = "\(gateNumber)"
            self.gateBlock.alpha = 1
            self.viewIcon.alpha = 1
            self.noGateAnchor.isActive = false
            self.yesGateAnchor.isActive = true
            self.view.layoutIfNeeded()
        } else {
            self.gateCodeValue.text = "N/A"
            self.gateBlock.alpha = 0
            self.viewIcon.alpha = 0
            self.noGateAnchor.isActive = true
            self.yesGateAnchor.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    var noGateAnchor: NSLayoutConstraint!
    var yesGateAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(residentialLabel)
        residentialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        residentialLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        residentialLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        residentialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(editInformation)
        editInformation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 4).isActive = true
        numberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(spotNumberLabel)
        spotNumberLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 16).isActive = true
        spotNumberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        spotNumberLabel.sizeToFit()
        
        self.view.addSubview(spotNumberValue)
        spotNumberValue.centerYAnchor.constraint(equalTo: spotNumberLabel.centerYAnchor).isActive = true
        spotNumberValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        spotNumberValue.sizeToFit()
        
        self.view.addSubview(numberLine)
        numberLine.bottomAnchor.constraint(equalTo: spotNumberLabel.bottomAnchor, constant: -4).isActive = true
        numberLine.rightAnchor.constraint(equalTo: spotNumberValue.leftAnchor, constant: -16).isActive = true
        numberLine.leftAnchor.constraint(equalTo: spotNumberLabel.rightAnchor, constant: 16).isActive = true
        numberLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        self.view.addSubview(gateCodeLabel)
        gateCodeLabel.topAnchor.constraint(equalTo: spotNumberLabel.bottomAnchor, constant: 8).isActive = true
        noGateAnchor = gateCodeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12)
            noGateAnchor.isActive = true
        yesGateAnchor = gateCodeLabel.leftAnchor.constraint(equalTo: viewIcon.rightAnchor)
            yesGateAnchor.isActive = false
        gateCodeLabel.sizeToFit()
        
        self.view.addSubview(viewIcon)
        self.view.addSubview(gateCodeValue)
        gateCodeValue.centerYAnchor.constraint(equalTo: gateCodeLabel.centerYAnchor).isActive = true
        gateCodeValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        gateCodeValue.sizeToFit()
        
        self.view.addSubview(gateLine)
        gateLine.bottomAnchor.constraint(equalTo: gateCodeLabel.bottomAnchor, constant: -4).isActive = true
        gateLine.rightAnchor.constraint(equalTo: gateCodeValue.leftAnchor, constant: -16).isActive = true
        gateLine.leftAnchor.constraint(equalTo: gateCodeLabel.rightAnchor, constant: 16).isActive = true
        gateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(gateBlock)
        gateBlock.topAnchor.constraint(equalTo: gateCodeValue.topAnchor, constant: -2).isActive = true
        gateBlock.leftAnchor.constraint(equalTo: gateCodeValue.leftAnchor, constant: -2).isActive = true
        gateBlock.rightAnchor.constraint(equalTo: gateCodeValue.rightAnchor, constant: 2).isActive = true
        gateBlock.bottomAnchor.constraint(equalTo: gateCodeValue.bottomAnchor).isActive = true
        
        viewIcon.centerYAnchor.constraint(equalTo: gateBlock.centerYAnchor).isActive = true
        viewIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4).isActive = true
        viewIcon.widthAnchor.constraint(equalToConstant: 34).isActive = true
        viewIcon.heightAnchor.constraint(equalTo: viewIcon.widthAnchor, constant: -16).isActive = true
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(showGateCode(sender:)))
        tap.minimumPressDuration = 0.0
        viewIcon.addGestureRecognizer(tap)
        
        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: gateCodeValue.bottomAnchor, constant: 28).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    @objc func showGateCode(sender: UILongPressGestureRecognizer) {
        let state = sender.state
        if state == .began {
            self.canShowGate = true
        } else if state == .changed {
            if self.canShowGate == true {
                self.gateBlock.alpha = 0
                self.viewIcon.tintColor = Theme.DARK_GRAY
            }
        } else {
            self.canShowGate = false
            self.gateBlock.alpha = 1
            self.viewIcon.tintColor = Theme.DARK_GRAY
        }
    }

}
