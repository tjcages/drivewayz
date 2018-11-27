//
//  ContactDrivewayzViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ContactDrivewayzViewController: UIViewController {
    
    var delegate: handleHelpViews?

    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

    @objc func backButtonPressed(sender: UIButton) {
        self.delegate?.bringBackMain()
    }
    
}
