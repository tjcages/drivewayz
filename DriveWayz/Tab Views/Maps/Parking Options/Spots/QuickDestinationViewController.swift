//
//  QuickDestinationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/31/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class QuickDestinationViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    var darkContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.roundCorners(corners: [.topLeft, .bottomLeft], radius: 3)
        
        return view
    }()
    
    var walkingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "walkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        
        return button
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 min"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        
        return label
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1080 14th St."
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var destinationSecondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Boulder, CO."
        label.textColor = Theme.BLACK.withAlphaComponent(0.8)
        label.font = Fonts.SSPExtraLightH6
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.alpha = 0
        
        setupViews()
        setupData()
    }
    
    var destinationWidth: CGFloat = 140
    var destinationSecondaryWidth: CGFloat = 140
    
    func setupData() {
        if let text = destinationLabel.text {
            self.destinationWidth = text.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH4)
            let destination = self.destinationWidth
            if let text = destinationSecondaryLabel.text {
                self.destinationSecondaryWidth = text.width(withConstrainedHeight: 20, font: Fonts.SSPExtraLightH5)
                let destinationSecondary = self.destinationSecondaryWidth
                if let text = distanceLabel.text {
                    let distanceWidth = text.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5)
                    self.darkWidthAnchor.constant = distanceWidth + 12
                    self.darkContainer.frame = CGRect(x: 0, y: 0, width: self.darkWidthAnchor.constant, height: 45)
                    self.darkContainer.roundCorners(corners: [.topLeft, .bottomLeft], radius: 3)
                    if destination > destinationSecondary && destination <= 140 {
                        self.containerWidthAnchor.constant = destination + 48 + distanceWidth
                    } else if destinationSecondary > destination && destinationSecondary <= 140 {
                        self.containerWidthAnchor.constant = destinationSecondary + 48 + distanceWidth
                    } else {
                        self.containerWidthAnchor.constant = 160
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    var containerWidthAnchor: NSLayoutConstraint!
    var darkWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerWidthAnchor = container.heightAnchor.constraint(equalToConstant: 200)
            containerWidthAnchor.isActive = true
        
        container.addSubview(darkContainer)
        darkContainer.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        darkContainer.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        darkContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        darkWidthAnchor = darkContainer.widthAnchor.constraint(equalToConstant: 50)
            darkWidthAnchor.isActive = true
        
        darkContainer.addSubview(walkingIcon)
        walkingIcon.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
        walkingIcon.topAnchor.constraint(equalTo: darkContainer.topAnchor, constant: 2).isActive = true
        walkingIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        walkingIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        darkContainer.addSubview(distanceLabel)
        distanceLabel.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
        distanceLabel.widthAnchor.constraint(equalTo: darkContainer.widthAnchor, constant: -8).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: walkingIcon.bottomAnchor, constant: -4).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: darkContainer.bottomAnchor, constant: -4).isActive = true
        
        container.addSubview(destinationLabel)
        destinationLabel.leftAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: 8).isActive = true
        destinationLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -4).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 4).isActive = true
        destinationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(destinationSecondaryLabel)
        destinationSecondaryLabel.leftAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: 8).isActive = true
        destinationSecondaryLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -4).isActive = true
        destinationSecondaryLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4).isActive = true
        destinationSecondaryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

}