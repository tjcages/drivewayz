//
//  NavigationInformationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationInformationView: UIViewController {
    
    var canShowGate: Bool = false

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var imageViews: NavigationImagesView = {
        let controller = NavigationImagesView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    var spotNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPSemiBoldH5
        label.text = "SPOT NUMBER"
        
        return label
    }()
    
    var spotNumberValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
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
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPSemiBoldH5
        label.text = "GATE CODE"
        
        return label
    }()
    
    var gateCodeValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
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
        button.alpha = 0
        
        return button
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 10
        
        return label
    }()
    
    var listedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var listedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Listed on 1/19/2019"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    func setData(hosting: ParkingSpots) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupMessages()
        setupCodes()
        setupNumber()
    }
    
    func setupViews() {
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 520).isActive = true
        
        container.addSubview(imageViews.view)
        imageViews.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageViews.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        imageViews.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        imageViews.view.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
    }
    
    func setupMessages() {
        
        self.view.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: imageViews.view.bottomAnchor, constant: 16).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        messageLabel.sizeToFit()
        
        self.view.addSubview(listedView)
        self.view.addSubview(listedLabel)
        listedLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32).isActive = true
        listedLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        listedLabel.sizeToFit()
        
        listedView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        listedView.topAnchor.constraint(equalTo: listedLabel.topAnchor, constant: -8).isActive = true
        listedView.rightAnchor.constraint(equalTo: listedLabel.rightAnchor, constant: 12).isActive = true
        listedView.bottomAnchor.constraint(equalTo: listedLabel.bottomAnchor, constant: 8).isActive = true
        
    }
    
    var noGateAnchor: NSLayoutConstraint!
    var yesGateAnchor: NSLayoutConstraint!
    
    func setupCodes() {
        
        self.view.addSubview(gateCodeLabel)
        gateCodeLabel.topAnchor.constraint(equalTo: listedView.bottomAnchor, constant: 16).isActive = true
        noGateAnchor = gateCodeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
            noGateAnchor.isActive = true
        yesGateAnchor = gateCodeLabel.leftAnchor.constraint(equalTo: viewIcon.rightAnchor)
            yesGateAnchor.isActive = false
        gateCodeLabel.sizeToFit()
        
        self.view.addSubview(viewIcon)
        self.view.addSubview(gateCodeValue)
        gateCodeValue.centerYAnchor.constraint(equalTo: gateCodeLabel.centerYAnchor).isActive = true
        gateCodeValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
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
        
    }
    
    func setupNumber() {
        
        self.view.addSubview(spotNumberLabel)
        spotNumberLabel.topAnchor.constraint(equalTo: gateCodeLabel.bottomAnchor, constant: 8).isActive = true
        spotNumberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        spotNumberLabel.sizeToFit()
        
        self.view.addSubview(spotNumberValue)
        spotNumberValue.centerYAnchor.constraint(equalTo: spotNumberLabel.centerYAnchor).isActive = true
        spotNumberValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        spotNumberValue.sizeToFit()
        
        self.view.addSubview(numberLine)
        numberLine.bottomAnchor.constraint(equalTo: spotNumberLabel.bottomAnchor, constant: -4).isActive = true
        numberLine.rightAnchor.constraint(equalTo: spotNumberValue.leftAnchor, constant: -16).isActive = true
        numberLine.leftAnchor.constraint(equalTo: spotNumberLabel.rightAnchor, constant: 16).isActive = true
        numberLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
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
    
    func haveGateCode() {
        self.gateBlock.alpha = 1
        self.viewIcon.alpha = 1
        self.noGateAnchor.isActive = false
        self.yesGateAnchor.isActive = true
        self.view.layoutIfNeeded()
    }
    
    func noGateCode() {
        self.gateCodeValue.text = "N/A"
        self.gateBlock.alpha = 0
        self.viewIcon.alpha = 0
        self.noGateAnchor.isActive = true
        self.yesGateAnchor.isActive = false
        self.view.layoutIfNeeded()
    }
    
}
