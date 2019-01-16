//
//  ExpandedInformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedInformationViewController: UIViewController {

    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "RESIDENTIAL  |  Driveway"
        
        return label
    }()
    
    var spotLocatingLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1065 University Ave. Boulder, CO"
        label.font = Fonts.SSPRegularH2
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var messageLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "A secure and affordable parking spot in the heart of downtown Boulder. A quick 5 minute walk to Pearl St. makes this a great location whether you are shopping for the day or have a meeting in the busy area."
        label.font = Fonts.SSPRegularH5
        label.backgroundColor = UIColor.clear
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        
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
        residentialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        residentialLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        residentialLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        residentialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(editInformation)
        editInformation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(spotLocatingLabel)
        spotLocatingLabel.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 4).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: messageLabel.text.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPRegularH5) + 24).isActive = true
        
        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }

}
