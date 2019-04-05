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
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
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
    
    var viewTriangle: TriangleView = {
        let triangle = TriangleView()
        triangle.backgroundColor = UIColor.clear
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.color = Theme.BLACK
        
        return triangle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.alpha = 0
        
        setupViews()
        setupData()
    }
    
    func setupData() {
        if let text = distanceLabel.text {
            let distanceWidth = text.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5) + 16
            self.containerWidthAnchor.constant = distanceWidth
            self.view.layoutIfNeeded()
        }
    }
    
    var containerWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerWidthAnchor = container.widthAnchor.constraint(equalToConstant: 200)
            containerWidthAnchor.isActive = true
        
        self.view.addSubview(viewTriangle)
        viewTriangle.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        viewTriangle.bottomAnchor.constraint(equalTo: container.topAnchor).isActive = true
        viewTriangle.widthAnchor.constraint(equalToConstant: 20).isActive = true
        viewTriangle.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        container.addSubview(walkingIcon)
        walkingIcon.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        walkingIcon.topAnchor.constraint(equalTo: container.topAnchor, constant: 2).isActive = true
        walkingIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        walkingIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        container.addSubview(distanceLabel)
        distanceLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        distanceLabel.widthAnchor.constraint(equalTo: container.widthAnchor, constant: -8).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: walkingIcon.bottomAnchor, constant: -4).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4).isActive = true
        
    }

}
