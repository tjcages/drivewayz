//
//  MySpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class MySpacesViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var spaceImageView: UIImageView = {
        let button = UIImageView()
        let image = UIImage(named: "background3")
        button.image = image
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return button
    }()
    
    var spaceTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "One-Car Drivewayz on University Avenue"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1.40 per hour"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Listed on 04/01/2019"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPLightH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 1
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 20
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.BLUE
        view.settings.emptyBorderColor = UIColor.clear
        view.settings.filledBorderColor = Theme.BLUE
        view.settings.emptyColor = UIColor.clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.9"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var expandButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(spaceImageView)
        spaceImageView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        spaceImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        spaceImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        spaceImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        container.addSubview(spaceTitle)
        spaceTitle.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        spaceTitle.rightAnchor.constraint(equalTo: spaceImageView.leftAnchor, constant: -12).isActive = true
        spaceTitle.topAnchor.constraint(equalTo: spaceImageView.topAnchor).isActive = true
        spaceTitle.sizeToFit()
        
        container.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: spaceTitle.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        dateLabel.topAnchor.constraint(equalTo: spaceTitle.bottomAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(line)
        line.topAnchor.constraint(equalTo: spaceImageView.bottomAnchor, constant: 20).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        priceLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(stars)
        stars.leftAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -2).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -2).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 4).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(expandButton)
        expandButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        expandButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 28).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
    }

}
