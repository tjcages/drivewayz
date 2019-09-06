//
//  CurrentTripView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentTripView: UIViewController {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trip Route"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Residential 2 Car Driveway"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var parkingSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "University Avenue"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var parkingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "map-pin")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var navigateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start navigation", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        
        return button
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Folsom Field"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var destinationSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2400 Colorado Ave"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var destinationIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7
        view.layer.borderColor = Theme.DARK_GRAY.cgColor
        view.layer.borderWidth = 1.2
        
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.layer.cornerRadius = 3
        dot.layer.borderColor = Theme.DARK_GRAY.cgColor
        dot.layer.borderWidth = 1.2
        
        view.addSubview(dot)
        dot.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dot.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dot.heightAnchor.constraint(equalTo: dot.widthAnchor).isActive = true
        dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY
        
        view.addSubview(line)
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -0.6).isActive = true
        line.heightAnchor.constraint(equalToConstant: 6).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1.2).isActive = true
        
        return view
    }()
    
    var dottedLine: UIImageView = {
        let view = UIImageView()
        if let image = UIImage(named: "circleLine")?.withRenderingMode(.alwaysTemplate) {
            view.image = image
        }
        view.tintColor = lineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return view
    }()
    
    var walkingIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "walkingIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12 minute walk"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    var walkingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(parkingIcon)
        view.addSubview(parkingLabel)
        view.addSubview(parkingSubLabel)
        view.addSubview(navigateButton)
        
        parkingIcon.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        
        parkingLabel.centerYAnchor.constraint(equalTo: parkingIcon.centerYAnchor).isActive = true
        parkingLabel.leftAnchor.constraint(equalTo: parkingIcon.rightAnchor, constant: 16).isActive = true
        parkingLabel.sizeToFit()
        
        parkingSubLabel.topAnchor.constraint(equalTo: parkingLabel.bottomAnchor).isActive = true
        parkingSubLabel.leftAnchor.constraint(equalTo: parkingLabel.leftAnchor).isActive = true
        parkingSubLabel.sizeToFit()
        
        navigateButton.topAnchor.constraint(equalTo: parkingSubLabel.bottomAnchor).isActive = true
        navigateButton.leftAnchor.constraint(equalTo: parkingLabel.leftAnchor).isActive = true
        navigateButton.sizeToFit()
        
        view.addSubview(destinationIcon)
        view.addSubview(destinationLabel)
        view.addSubview(destinationSubLabel)
        
        destinationIcon.anchor(top: navigateButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 76, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 14, height: 14)
        destinationIcon.centerXAnchor.constraint(equalTo: parkingIcon.centerXAnchor).isActive = true
        
        destinationLabel.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor).isActive = true
        destinationLabel.leftAnchor.constraint(equalTo: destinationIcon.rightAnchor, constant: 16).isActive = true
        destinationLabel.sizeToFit()
        
        destinationSubLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor).isActive = true
        destinationSubLabel.leftAnchor.constraint(equalTo: destinationLabel.leftAnchor).isActive = true
        destinationSubLabel.sizeToFit()
        
        view.addSubview(dottedLine)
        dottedLine.centerYAnchor.constraint(equalTo: navigateButton.bottomAnchor, constant: -20).isActive = true
        dottedLine.heightAnchor.constraint(equalToConstant: 80).isActive = true
        dottedLine.centerXAnchor.constraint(equalTo: parkingIcon.centerXAnchor, constant: 1).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        view.addSubview(walkingView)
        view.addSubview(walkingIcon)
        view.addSubview(walkingLabel)
        
        walkingIcon.anchor(top: nil, left: walkingLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
        walkingIcon.centerYAnchor.constraint(equalTo: walkingLabel.centerYAnchor).isActive = true
        
        walkingLabel.leftAnchor.constraint(equalTo: dottedLine.leftAnchor).isActive = true
        walkingLabel.centerYAnchor.constraint(equalTo: navigateButton.bottomAnchor, constant: 38).isActive = true
        walkingLabel.sizeToFit()
    
        walkingView.anchor(top: walkingLabel.topAnchor, left: view.leftAnchor, bottom: walkingLabel.bottomAnchor, right: walkingIcon.rightAnchor, paddingTop: -8, paddingLeft: 0, paddingBottom: -8, paddingRight: -12, width: 0, height: 0)
        
    }

}
