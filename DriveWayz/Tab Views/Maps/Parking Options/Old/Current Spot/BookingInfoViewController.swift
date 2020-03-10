//
//  BookingMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class BookingInfoViewController: UIViewController {
    
    var messageHeight: CGFloat = 0.0
    var message: String = "" {
        didSet {
            self.hostMessageLabel.text = self.message
            self.messageHeight = self.message.height(withConstrainedWidth: phoneWidth - 60, font: Fonts.SSPRegularH5) + 32
            if self.messageHeight >= 28 {
                self.moreButton.alpha = 1
            } else {
                self.moreButton.alpha = 0
            }
            self.setupViews()
        }
    }
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Host message"
        
        return label
    }()
    
    var hostMessageLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.isUserInteractionEnabled = false
        label.isEditable = false
        
        return label
    }()
    
    var moreButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("more", for: .normal)
        label.setTitleColor(Theme.BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .right
        label.clipsToBounds = true
        label.alpha = 0
        
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0), bottomColor: Theme.WHITE)
        background.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: -CGFloat.pi/2))
        background.frame = CGRect(x: 0, y: 0, width: 35, height: 22)
        background.zPosition = -10
        label.layer.addSublayer(background)
        
        let background2 = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE, bottomColor: Theme.WHITE)
        background2.frame = CGRect(x: 35, y: 0, width: 100, height: 22)
        background2.zPosition = -10
        label.layer.addSublayer(background2)
        
        return label
    }()
    
    var lessButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Show less", for: .normal)
        label.setTitleColor(Theme.BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .left
        label.alpha = 0
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.text = "Listed on 1/19/2019"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var dateLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var spotNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Spot number"
        
        return label
    }()
    
    var spotNumberValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.text = "N/A"
        label.textAlignment = .right
        
        return label
    }()
    
    var numberLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var amenitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Amenities"
        
        return label
    }()
    
    lazy var currentAmenitiesController: CurrentAmenitiesViewController = {
        let controller = CurrentAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.clipsToBounds = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
    }
    
    var messageLabelHeightAnchor: NSLayoutConstraint!
    var messageLabelRightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(hostMessageLabel)
        hostMessageLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive = true
        hostMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        messageLabelRightAnchor = hostMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60)
            messageLabelRightAnchor.isActive = true
        messageLabelHeightAnchor = hostMessageLabel.heightAnchor.constraint(equalToConstant: 50)
            messageLabelHeightAnchor.isActive = true
        
        self.view.addSubview(moreButton)
        moreButton.bottomAnchor.constraint(equalTo: hostMessageLabel.bottomAnchor).isActive = true
        moreButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.view.addSubview(lessButton)
        lessButton.topAnchor.constraint(equalTo: hostMessageLabel.bottomAnchor, constant: -20).isActive = true
        lessButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lessButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lessButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.view.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: hostMessageLabel.bottomAnchor, constant: 8).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.sizeToFit()
        
        self.view.addSubview(dateLine)
        dateLine.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 2).isActive = true
        dateLine.rightAnchor.constraint(equalTo: dateLabel.leftAnchor, constant: -16).isActive = true
        dateLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        dateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(spotNumberLabel)
        spotNumberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        spotNumberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotNumberLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotNumberLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(spotNumberValue)
        spotNumberValue.topAnchor.constraint(equalTo: spotNumberLabel.bottomAnchor).isActive = true
        spotNumberValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotNumberValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
        spotNumberValue.sizeToFit()
        
        self.view.addSubview(numberLine)
        numberLine.centerYAnchor.constraint(equalTo: spotNumberValue.centerYAnchor).isActive = true
        numberLine.rightAnchor.constraint(equalTo: spotNumberValue.leftAnchor, constant: -16).isActive = true
        numberLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        numberLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(currentAmenitiesController.view)
        currentAmenitiesController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        currentAmenitiesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentAmenitiesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentAmenitiesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.view.addSubview(amenitiesLabel)
        amenitiesLabel.bottomAnchor.constraint(equalTo: currentAmenitiesController.view.topAnchor, constant: -8).isActive = true
        amenitiesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        amenitiesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        amenitiesLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
}
