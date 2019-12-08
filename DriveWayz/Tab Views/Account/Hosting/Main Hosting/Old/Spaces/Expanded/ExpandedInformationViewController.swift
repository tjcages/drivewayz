//
//  ExpandedInformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedInformationViewController: UIViewController {
    
    var height: CGFloat = 0

    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Residential  |  Driveway"
        
        return label
    }()
    
    var messageLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.backgroundColor = UIColor.clear
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var destinationLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.text = "Listed on 1/19/2019"
        label.font = Fonts.SSPRegularH5
        label.backgroundColor = UIColor.clear
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setData(hosting: ParkingSpots) {
        if let primaryType = hosting.mainType, let secondaryType = hosting.secondaryType, let hostMessage = hosting.hostMessage, let overallAddress = hosting.overallAddress {
            self.residentialLabel.text = "\(primaryType.uppercased())  |  \(secondaryType.capitalizingFirstLetter())"
            self.messageLabel.text = hostMessage
            self.destinationLabel.text = overallAddress
        }
        setupViews()
    }
    
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
        
        self.view.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: -4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        messageLabel.sizeToFit()
        
        self.view.addSubview(destinationLabel)
        destinationLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4).isActive = true
        destinationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        destinationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        destinationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 20).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        height = 120 + messageLabel.text.height(withConstrainedWidth: self.view.frame.width - 40, font: Fonts.SSPRegularH5)
        
    }

}
